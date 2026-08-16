# CodeVault — Security Audit Report (Phase 0 Audit & Remediation)

## Executive Summary

An initial security audit of the Eclipse-based CodeVault codebase was performed before modernization. The audit identified **20 distinct security findings**, including **6 CRITICAL** vulnerabilities that allowed unauthorized access, credential disclosure, plaintext password storage, and data compromise.

All findings were systematically addressed during the modernization and containerization phases.

---

## Detailed Audit Findings & Remediation Matrix

### 1. Hard-Coded Database Credentials (SEC-01)
* **Severity:** 🔴 CRITICAL
* **Affected File:** `src/main/java/com/codevault/util/DBConnection.java`
* **Affected Code:**
  ```java
  private static final String USERNAME = "root";
  private static final String PASSWORD = "ABhi12@@";
  ```
* **Explanation:** Root MySQL database credentials were hardcoded directly in Java source code and tracked in version control.
* **Recommended Fix:** Extract all database connection properties to environment variables (`DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`), create `.env.example`, and rotate exposed passwords.
* **Status:** ✅ FIXED (HikariCP pool now reads from environment variables; `.env.example` created; `.env` gitignored).

---

### 2. Plaintext Password Storage (SEC-02)
* **Severity:** 🔴 CRITICAL
* **Affected File:** `src/main/java/com/codevault/dao/UserDAO.java`
* **Affected Code:**
  ```java
  String sql = "INSERT INTO users(username,email,password) VALUES(?,?,?)";
  ...
  ps.setString(3, user.getPassword());
  ```
* **Explanation:** Passwords were inserted directly into MySQL without any cryptographic hashing. A database compromise immediately yields all plaintext passwords.
* **Recommended Fix:** Implement salted, adaptive one-way hashing with **BCrypt** (cost factor 12). Implement a seamless transparent upgrade path for legacy passwords.
* **Status:** ✅ FIXED (BCrypt cost 12 implemented in `UserDAO.registerUser()` and `validateUser()` with automatic legacy upgrade).

---

### 3. Sensitive Credentials Printed to Logs / Stdout (SEC-03)
* **Severity:** 🔴 CRITICAL
* **Affected Files:**
  - `src/main/java/com/codevault/servlet/LoginServlet.java`
  - `src/main/java/com/codevault/servlet/RegisterServlet.java`
* **Affected Code:**
  ```java
  System.out.println("Password = " + password);
  ```
* **Explanation:** Plaintext passwords entered by users during login and registration were printed directly to standard output / console logs.
* **Recommended Fix:** Remove all `System.out.println` statements dumping passwords. Use standard `java.util.logging` with sanitized non-sensitive parameters.
* **Status:** ✅ FIXED (All credential printing removed; safe logging added).

---

### 4. Admin Method Dumping All Passwords to Console (SEC-04)
* **Severity:** 🔴 CRITICAL
* **Affected File:** `src/main/java/com/codevault/dao/UserDAO.java`
* **Affected Code:**
  ```java
  public void displayAllUsers() { ... System.out.println("Password : " + rs.getString("password")); }
  ```
* **Explanation:** Unprotected debug method queried and printed all user records including passwords to stdout.
* **Recommended Fix:** Remove the debug method entirely from production codebase.
* **Status:** ✅ FIXED (Removed).

---

### 5. Broken Access Control / IDOR on Snippet Management (SEC-05)
* **Severity:** 🔴 CRITICAL
* **Affected Files:**
  - `src/main/java/com/codevault/dao/SnippetDAO.java`
  - `src/main/java/com/codevault/servlet/EditSnippetServlet.java`
  - `src/main/java/com/codevault/servlet/UpdateSnippetServlet.java`
  - `src/main/java/com/codevault/servlet/DeleteSnippetServlet.java`
* **Affected Code:**
  ```sql
  DELETE FROM snippets WHERE id=?
  SELECT * FROM snippets WHERE id=?
  UPDATE snippets SET title=?, language=?, description=?, code=? WHERE id=?
  ```
* **Explanation:** None of the snippet modification, view, or deletion queries verified that the snippet belonged to the authenticated user. Any logged-in user could edit, view, or delete another user's snippets simply by guessing or modifying the numeric `id` parameter.
* **Recommended Fix:** Enforce ownership checks at both the servlet session level and the database query level:
  `WHERE id = ? AND user_id = ?`. Return 404 (or 403) on unauthorized attempts.
* **Status:** ✅ FIXED (All queries in `SnippetDAO` require `user_id`; servlets obtain `userId` strictly from session).

---

### 6. Missing Authentication Checks on Multiple Servlets (SEC-06)
* **Severity:** 🔴 CRITICAL
* **Affected Files:** `AddSnippetServlet.java`, `EditSnippetServlet.java`, `UpdateSnippetServlet.java`, `DeleteSnippetServlet.java`
* **Affected Code:** Missing session checks before processing requests.
* **Explanation:** Unauthenticated requests to `/editSnippet`, `/deleteSnippet`, `/updateSnippet`, or `/addSnippet` could execute or trigger NullPointerExceptions.
* **Recommended Fix:** Introduce a centralized `AuthFilter` intercepting all protected URL patterns and redirecting unauthenticated traffic to `login.jsp`.
* **Status:** ✅ FIXED (`AuthFilter` deployed on all protected endpoints; non-caching headers added).

---

### 7. Missing CSRF Protection on State-Changing Actions (SEC-07)
* **Severity:** 🟠 HIGH
* **Affected Files:** All POST forms and state-changing servlets.
* **Explanation:** State-changing endpoints accepted POST requests without verifying an anti-forgery token. Malicious websites could forge requests on behalf of authenticated users.
* **Recommended Fix:** Implement `CsrfFilter` generating cryptographically random tokens stored in session and verified on all POST requests using constant-time comparison.
* **Status:** ✅ FIXED (`CsrfFilter` validates all POST requests with `MessageDigest.isEqual`).

---

### 8. Cross-Site Scripting (XSS) via Unencoded JSP Outputs (SEC-08)
* **Severity:** 🟠 HIGH
* **Affected Files:** `dashboard.jsp`, `addSnippet.jsp`, `editSnippet.jsp`, `login.jsp`, `register.jsp`
* **Affected Code:** `${snippet.title}`, `${snippet.code}`, `${snippet.description}`, `${error}`, `${sessionScope.username}`, `data-title="${snippet.title}"`
* **Explanation:** User-controlled inputs stored in the database were rendered raw into HTML contexts, HTML attributes (`data-*`), and `<textarea>` elements without contextual encoding, permitting Stored and Reflected XSS.
* **Recommended Fix:** Use context-aware JSTL `<c:out value="..." escapeXml="true" />` and attribute escaping on all dynamic values.
* **Status:** ✅ FIXED (Context-aware output encoding applied across all JSP files).

---

### 9. Snippet Deletion via HTTP GET (SEC-09)
* **Severity:** 🟠 HIGH
* **Affected File:** `src/main/java/com/codevault/servlet/DeleteSnippetServlet.java`
* **Affected Code:** `protected void doGet(...) { dao.deleteSnippet(id); }`
* **Explanation:** Destructive delete operations could be triggered via GET URLs (e.g. `GET /deleteSnippet?id=123`), making it vulnerable to accidental clicks, web crawler pre-fetching, and image-tag CSRF.
* **Recommended Fix:** Disallow GET requests on `/deleteSnippet` (return 405 Method Not Allowed) and require POST with CSRF token and session authentication.
* **Status:** ✅ FIXED (`doGet` returns 405; `doPost` enforces auth + CSRF + ownership).

---

### 10. Session Fixation (SEC-10)
* **Severity:** 🟠 HIGH
* **Affected File:** `src/main/java/com/codevault/servlet/LoginServlet.java`
* **Affected Code:** `HttpSession session = request.getSession();` without session invalidation upon privilege elevation.
* **Explanation:** Session IDs were retained across login transitions, allowing session fixation attacks.
* **Recommended Fix:** Invalidate the existing session upon successful credential verification and allocate a new session.
* **Status:** ✅ FIXED (`oldSession.invalidate()` followed by `request.getSession(true)`).

---

### 11. Incomplete Session Termination / Fake Logout (SEC-11)
* **Severity:** 🟠 HIGH
* **Affected Files:** `dashboard.jsp`, `addSnippet.jsp`, `editSnippet.jsp`
* **Affected Code:** `<a href="login.jsp">Logout</a>`
* **Explanation:** "Logout" links merely redirected to `login.jsp` without invalidating the HTTP session on the server.
* **Recommended Fix:** Implement `LogoutServlet` (`/logout`) that invokes `session.invalidate()` and clears cookies.
* **Status:** ✅ FIXED (`LogoutServlet` created; JSPs updated to POST `/logout`).

---

### 12. Missing Security Headers & Loose CSP (SEC-12)
* **Severity:** 🟡 MEDIUM
* **Affected File:** HTTP Responses
* **Explanation:** Missing headers (`X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`, `Content-Security-Policy`).
* **Recommended Fix:** Implement `SecurityHeadersFilter` adding strict headers to all servlet responses.
* **Status:** ✅ FIXED (`SecurityHeadersFilter` active on `/*`).

---

### 13. Unhandled NumberFormatException on Malformed IDs (SEC-13)
* **Severity:** 🟡 MEDIUM
* **Affected Files:** `EditSnippetServlet.java`, `DeleteSnippetServlet.java`, `UpdateSnippetServlet.java`
* **Affected Code:** `Integer.parseInt(request.getParameter("id"))`
* **Explanation:** Passing non-numeric or overflow IDs caused unhandled 500 exceptions and stack trace disclosure.
* **Recommended Fix:** Introduce `InputValidator.isValidSnippetId()` and `parseSnippetId()` returning 400 Bad Request on invalid input.
* **Status:** ✅ FIXED (`InputValidator` integrated).

---

### 14. JDBC Resource Leaking (SEC-14)
* **Severity:** 🟡 MEDIUM
* **Affected Files:** `UserDAO.java`, `SnippetDAO.java`
* **Affected Code:** `con.close()` placed inside `try` block before catch; statements and result sets unclosed.
* **Explanation:** Exceptions during query execution bypassed `con.close()`, causing connection leaks and pool exhaustion.
* **Recommended Fix:** Refactor all database operations to Java try-with-resources.
* **Status:** ✅ FIXED (Try-with-resources applied across all DAOs).

---

### 15. Server Stack Trace & Exception Disclosure (SEC-15)
* **Severity:** 🟡 MEDIUM
* **Affected Files:** DAOs, Servlets, and default Tomcat error handling.
* **Explanation:** Uncaught exceptions rendered default Tomcat error pages containing full stack traces, internal package paths, and Tomcat version info.
* **Recommended Fix:** Add custom, branded error pages for 400, 401, 403, 404, 500 in `web.xml`.
* **Status:** ✅ FIXED (Custom error pages in `WEB-INF/views/error/` mapped in `web.xml`).

---

### 16. Missing Session Expiration & Insecure Cookie Flags (SEC-16)
* **Severity:** 🟡 MEDIUM
* **Affected File:** `src/main/webapp/WEB-INF/web.xml`
* **Explanation:** No session timeout configured (sessions persisted indefinitely). Session cookies lacked `HttpOnly` and `SameSite` flags.
* **Recommended Fix:** Configure 30-minute session timeout, `CODEVAULT_SESSION` cookie name, `http-only: true`, `SameSite: Lax` in `web.xml`.
* **Status:** ✅ FIXED (Configured in `web.xml`).

---

### 17. Application Running as MySQL Administrative `root` (SEC-17)
* **Severity:** 🟡 MEDIUM
* **Affected Files:** Database connection & Docker compose.
* **Explanation:** Application connected as `root`, granting full server privileges.
* **Recommended Fix:** Provision dedicated `codevault_user` with only `SELECT, INSERT, UPDATE, DELETE` on `codevault.*`.
* **Status:** ✅ FIXED (`init.sql` and `docker-compose.yml` configure least-privilege `codevault_user`).

---

### 18. Absence of Connection Pooling (SEC-18)
* **Severity:** 🟡 MEDIUM
* **Affected File:** `src/main/java/com/codevault/util/DBConnection.java`
* **Explanation:** Every request established a new TCP connection via `DriverManager.getConnection()`.
* **Recommended Fix:** Implement `HikariCP` connection pool with health validation and leak detection.
* **Status:** ✅ FIXED (HikariCP 5.1.0 pool implemented).

---

### 19. Test Source Files with Hardcoded Credentials in Main Tree (SEC-19)
* **Severity:** 🟢 LOW
* **Affected Files:** `DAOTest.java`, `DisplayTest.java`, `ModelTest.java`, `TestConnection.java`
* **Explanation:** Test classes containing dummy/real credentials lived in `src/main/java`.
* **Recommended Fix:** Relocate tests to `src/test/java` and convert to standard JUnit 5 unit tests.
* **Status:** ✅ FIXED (Converted to clean JUnit 5 test suite in `src/test/java`).

---

### 20. Direct Unprotected JSP File Access (SEC-20)
* **Severity:** 🟢 LOW
* **Affected Files:** `dashboard.jsp`, `addSnippet.jsp`, `editSnippet.jsp`
* **Explanation:** JSPs in the web application root could be requested directly without routing through the corresponding servlet controller.
* **Recommended Fix:** Move all view JSPs into `/WEB-INF/views/` so they are only accessible via servlet dispatchers.
* **Status:** ✅ FIXED (Moved to `/WEB-INF/views/`).
