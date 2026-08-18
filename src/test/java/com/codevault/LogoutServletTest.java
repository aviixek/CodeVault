package com.codevault;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.codevault.dao.AuditDAO;
import com.codevault.servlet.LogoutServlet;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogoutServletTest {

    private LogoutServlet logoutServlet;
    private TestAuditDAO testAuditDAO;
    private FakeSession fakeSession;
    private FakeRequest fakeRequest;
    private FakeResponse fakeResponse;

    @BeforeEach
    public void setUp() {
        testAuditDAO = new TestAuditDAO();
        logoutServlet = new LogoutServlet(testAuditDAO);
        fakeSession = new FakeSession();
        fakeRequest = new FakeRequest(fakeSession);
        fakeResponse = new FakeResponse();
    }

    @Test
    @DisplayName("GET /logout must return HTTP 405 Method Not Allowed and NOT invalidate the session")
    public void testGetLogoutReturns405AndDoesNotInvalidateSession() throws Exception {
        fakeRequest.setMethod("GET");
        fakeSession.setAttribute("userId", 101);
        fakeSession.setAttribute("username", "testuser");

        logoutServlet.service(fakeRequest.asProxy(), fakeResponse.asProxy());

        // Verify HTTP 405 Method Not Allowed was sent
        assertEquals(HttpServletResponse.SC_METHOD_NOT_ALLOWED, fakeResponse.getErrorCode());
        assertEquals("Method Not Allowed", fakeResponse.getErrorMessage());

        // Verify session was NOT invalidated on GET
        assertFalse(fakeSession.isInvalidated(), "Session must NOT be invalidated on GET /logout");
        // Verify no LOGOUT event was recorded
        assertEquals(0, testAuditDAO.getLogoutEventCount(), "Audit log must NOT record LOGOUT on GET");
    }

    @Test
    @DisplayName("POST /logout invalidates session, records LOGOUT audit, and redirects to login")
    public void testPostLogoutInvalidatesSessionAndRedirects() throws Exception {
        fakeRequest.setMethod("POST");
        fakeRequest.setRemoteAddr("127.0.0.1");
        fakeRequest.setHeader("User-Agent", "JUnit-Test-Agent");
        fakeRequest.setContextPath("");
        fakeSession.setAttribute("userId", 42);
        fakeSession.setAttribute("username", "testuser");

        logoutServlet.service(fakeRequest.asProxy(), fakeResponse.asProxy());

        // Verify session invalidation
        assertTrue(fakeSession.isInvalidated(), "Session MUST be invalidated on POST /logout");

        // Verify redirect to login.jsp
        assertEquals("/login.jsp", fakeResponse.getRedirectLocation());

        // Verify audit log recorded LOGOUT
        assertEquals(1, testAuditDAO.getLogoutEventCount(), "Audit log MUST record LOGOUT on POST");
        assertEquals(42, testAuditDAO.getLastUserId());
        assertEquals("LOGOUT", testAuditDAO.getLastEventType());
        assertTrue(testAuditDAO.isLastSuccess());
    }

    // -------------------------------------------------------------
    // Test Stubs & Dynamic Proxies (Portable across all Java versions)
    // -------------------------------------------------------------

    private static class TestAuditDAO extends AuditDAO {
        private int logoutEventCount = 0;
        private Integer lastUserId;
        private String lastEventType;
        private boolean lastSuccess;

        @Override
        public void logEvent(Integer userId, String eventType, boolean success, String ipAddress, String userAgent) {
            if ("LOGOUT".equals(eventType)) {
                logoutEventCount++;
            }
            this.lastUserId = userId;
            this.lastEventType = eventType;
            this.lastSuccess = success;
        }

        public int getLogoutEventCount() { return logoutEventCount; }
        public Integer getLastUserId() { return lastUserId; }
        public String getLastEventType() { return lastEventType; }
        public boolean isLastSuccess() { return lastSuccess; }
    }

    private static class FakeSession implements InvocationHandler {
        private final Map<String, Object> attributes = new HashMap<>();
        private boolean invalidated = false;

        public void setAttribute(String name, Object value) { attributes.put(name, value); }
        public boolean isInvalidated() { return invalidated; }

        public HttpSession asProxy() {
            return (HttpSession) Proxy.newProxyInstance(
                    HttpSession.class.getClassLoader(),
                    new Class<?>[]{HttpSession.class},
                    this
            );
        }

        @Override
        public Object invoke(Object proxy, Method method, Object[] args) {
            String name = method.getName();
            if ("getAttribute".equals(name)) {
                return attributes.get(args[0]);
            } else if ("setAttribute".equals(name)) {
                attributes.put((String) args[0], args[1]);
                return null;
            } else if ("invalidate".equals(name)) {
                this.invalidated = true;
                attributes.clear();
                return null;
            }
            return null;
        }
    }

    private static class FakeRequest implements InvocationHandler {
        private String method = "GET";
        private String remoteAddr = "127.0.0.1";
        private String contextPath = "";
        private final Map<String, String> headers = new HashMap<>();
        private final FakeSession session;

        public FakeRequest(FakeSession session) {
            this.session = session;
        }

        public void setMethod(String method) { this.method = method; }
        public void setRemoteAddr(String remoteAddr) { this.remoteAddr = remoteAddr; }
        public void setContextPath(String contextPath) { this.contextPath = contextPath; }
        public void setHeader(String name, String value) { headers.put(name, value); }

        public HttpServletRequest asProxy() {
            return (HttpServletRequest) Proxy.newProxyInstance(
                    HttpServletRequest.class.getClassLoader(),
                    new Class<?>[]{HttpServletRequest.class},
                    this
            );
        }

        @Override
        public Object invoke(Object proxy, Method method, Object[] args) {
            String name = method.getName();
            if ("getMethod".equals(name)) {
                return this.method;
            } else if ("getSession".equals(name)) {
                return session != null ? session.asProxy() : null;
            } else if ("getRemoteAddr".equals(name)) {
                return this.remoteAddr;
            } else if ("getHeader".equals(name)) {
                return headers.get(args[0]);
            } else if ("getContextPath".equals(name)) {
                return this.contextPath;
            }
            return null;
        }
    }

    private static class FakeResponse implements InvocationHandler {
        private int errorCode = 0;
        private String errorMessage = null;
        private String redirectLocation = null;
        private final Map<String, Object> headers = new HashMap<>();

        public int getErrorCode() { return errorCode; }
        public String getErrorMessage() { return errorMessage; }
        public String getRedirectLocation() { return redirectLocation; }

        public HttpServletResponse asProxy() {
            return (HttpServletResponse) Proxy.newProxyInstance(
                    HttpServletResponse.class.getClassLoader(),
                    new Class<?>[]{HttpServletResponse.class},
                    this
            );
        }

        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws IOException {
            String name = method.getName();
            if ("sendError".equals(name)) {
                this.errorCode = (Integer) args[0];
                if (args.length > 1) {
                    this.errorMessage = (String) args[1];
                }
                return null;
            } else if ("sendRedirect".equals(name)) {
                this.redirectLocation = (String) args[0];
                return null;
            } else if ("setHeader".equals(name)) {
                headers.put((String) args[0], args[1]);
                return null;
            } else if ("setDateHeader".equals(name)) {
                headers.put((String) args[0], args[1]);
                return null;
            }
            return null;
        }
    }
}
