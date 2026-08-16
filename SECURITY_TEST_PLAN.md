# CodeVault — Comprehensive Security Test Plan (Phase 24)

This test plan defines the manual and automated security verification procedures executed against the CodeVault web application running in its hardened Docker environment.

---

## Test Execution Matrix

| # | Test Case | Target / Endpoint | Payload / Method | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| **1** | **Unauthenticated Dashboard Access** | `GET /dashboard` | Direct URL navigation without active session | Intercepted by `AuthFilter`, redirected (302) to `/login.jsp` | Redirected to `login.jsp` | ✅ **PASS** |
| **2** | **Unauthenticated Direct JSP Access** | `GET /WEB-INF/views/dashboard.jsp` | Direct URL navigation to view template | Blocked by servlet container (404/Direct access prohibited) | HTTP 404 / Blocked | ✅ **PASS** |
| **3** | **IDOR: View Another User's Snippet** | `GET /editSnippet?id=999` (Snippet owned by User B) | Authenticated as User A, request User B's snippet ID | Server returns HTTP 404 Not Found (does not disclose existence) | HTTP 404 Not Found | ✅ **PASS** |
| **4** | **IDOR: Edit Another User's Snippet** | `GET /editSnippet?id=2` (Snippet owned by User B) | Authenticated as User A, request edit page for ID 2 | Query `WHERE id=? AND user_id=?` yields null; returns 404 | HTTP 404 Not Found | ✅ **PASS** |
| **5** | **IDOR: Update Another User's Snippet** | `POST /updateSnippet` | Authenticated as User A, submit update with `id=2` | Database query fails (`rowsUpdated = 0`), returns HTTP 404 | HTTP 404 Not Found | ✅ **PASS** |
| **6** | **IDOR: Delete Another User's Snippet** | `POST /deleteSnippet` | Authenticated as User A, submit delete with `id=2` | Database query `DELETE WHERE id=? AND user_id=?` affects 0 rows, returns 404 | HTTP 404 Not Found | ✅ **PASS** |
| **7** | **Destructive Action via HTTP GET** | `GET /deleteSnippet?id=1` | Direct GET navigation | Server returns HTTP 405 Method Not Allowed; no deletion | HTTP 405 Method Not Allowed | ✅ **PASS** |
| **8** | **SQL Injection: Authentication Bypass** | `POST /LoginServlet` | `username = ' OR '1'='1' --` and `password = arbitrary` | Parameterized query treats input as literal; authentication fails | "Invalid username or password" | ✅ **PASS** |
| **9** | **SQL Injection: Numeric ID Parameter** | `GET /editSnippet?id=1' OR 1=1--` | Submitting SQL syntax in numeric parameter | `InputValidator.isValidSnippetId` rejects; returns HTTP 400 | HTTP 400 Bad Request | ✅ **PASS** |
| **10** | **Stored XSS: Script in Snippet Title** | `POST /addSnippet` | `title = <script>alert('XSS-Title')</script>` | Saved safely; rendered via `<c:out>` as encoded text `&lt;script&gt;...` | Rendered as text, no execution | ✅ **PASS** |
| **11** | **Stored XSS: Event Handler in Title Attribute** | `POST /addSnippet` | `title = " onmouseover="alert('XSS')"` | Rendered in `data-title` with XML attribute escaping | Escaped in DOM attributes | ✅ **PASS** |
| **12** | **Stored XSS: Code Textarea Payload** | `POST /addSnippet` | `code = </textarea><script>alert('XSS-Code')</script>` | Escaped inside `<textarea>` via `<c:out>`; textarea tag not broken | Rendered as raw code in CodeMirror | ✅ **PASS** |
| **13** | **Reflected XSS: Search Query Parameter** | `GET /dashboard?query=<script>alert(1)</script>` | Submitting HTML/JS payload in search param | Empty state renders `<c:out value="${param.query}" />` safely | Escaped in HTML body | ✅ **PASS** |
| **14** | **CSRF: State-Changing Action Without Token** | `POST /addSnippet` | Form submission omitting `csrf_token` parameter | `CsrfFilter` rejects with HTTP 403 Forbidden | HTTP 403 Forbidden | ✅ **PASS** |
| **15** | **CSRF: Submission with Forged / Invalid Token** | `POST /deleteSnippet` | Submitting `csrf_token = forged_token_value_xyz` | Constant-time check fails; returns HTTP 403 Forbidden | HTTP 403 Forbidden | ✅ **PASS** |
| **16** | **Session Fixation Prevention** | `POST /LoginServlet` | Inspect session ID before and after successful login | Old session invalidated; new session ID issued | Session ID changed post-login | ✅ **PASS** |
| **17** | **Complete Session Termination on Logout** | `POST /logout` | Authenticated user logs out, then hits back button | Server session invalidated; `Cache-Control: no-store` prevents history view | Redirect to login; back blocked | ✅ **PASS** |
| **18** | **Cookie Security Flags** | HTTP Response Headers | Inspect `Set-Cookie` header on login | `CODEVAULT_SESSION` has `HttpOnly` and `SameSite=Lax` | Flags present in Set-Cookie | ✅ **PASS** |
| **19** | **Security Headers Validation** | HTTP Response Headers | Inspect headers on `GET /dashboard` | `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `CSP` present | All security headers present | ✅ **PASS** |
| **20** | **Database Connection Isolation & Non-Root User** | Docker Container | Inspect running container port bindings & DB grants | Port 3306 unexposed on host; app connects as `codevault_user` | 3306 internal; non-root user | ✅ **PASS** |
| **21** | **Container Non-Root User Execution** | `docker exec codevault-app whoami` | Inspect process execution context | Runs as UID 1001 (`tomcatuser`), not root | UID 1001 (tomcatuser) | ✅ **PASS** |
| **22** | **Container Privilege & Socket Isolation** | `docker inspect codevault-app` | Inspect container privileges & mounts | `Privileged: false`, no `/var/run/docker.sock` mount | Fully unprivileged | ✅ **PASS** |
| **23** | **Automated Health Monitoring** | `GET /health` | Ping health check endpoint | Returns HTTP 200 with JSON `{"status":"UP","database":"HEALTHY"}` | HTTP 200 JSON OK | ✅ **PASS** |
