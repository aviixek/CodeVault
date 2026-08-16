# CodeVault Security Test Plan & Verification Matrix

| # | Test Scenario | Target / Method | Payload / Action | Expected Result | Observed Result | Status |
|---|---|---|---|---|---|---|
| **1** | **BCrypt Password Hashing** | `UserDAO.registerUser` | Register user with password | Stored password in DB begins with `$2a$12$` and is 60 chars | Salted BCrypt hash stored | ✅ **PASS** |
| **2** | **Legacy Password Auto-Migration** | `UserDAO.validateUser` | Login with pre-existing plaintext password | User successfully authenticated; password column upgraded to BCrypt | Upgraded on first login | ✅ **PASS** |
| **3** | **Zero Password Logging** | Console / Application Logs | Register & login operations | No password strings appear in stdout, stderr, or loggers | No credentials logged | ✅ **PASS** |
| **4** | **IDOR: Cross-User Snippet Read** | `GET /editSnippet?id=1` | User B requests User A's snippet ID | DAO returns null; Servlet responds with HTTP 404 Not Found | HTTP 404 Not Found | ✅ **PASS** |
| **5** | **IDOR: Cross-User Snippet Update** | `POST /updateSnippet` | User B submits update targeting User A's snippet ID | Query `WHERE id=? AND user_id=?` affects 0 rows; HTTP 404 | Update rejected (0 rows) | ✅ **PASS** |
| **6** | **IDOR: Cross-User Snippet Delete** | `POST /deleteSnippet` | User B submits delete targeting User A's snippet ID | Query `WHERE id=? AND user_id=?` affects 0 rows; HTTP 404 | Delete rejected (0 rows) | ✅ **PASS** |
| **7** | **Delete via GET Method Rejection** | `GET /deleteSnippet?id=1` | Direct HTTP GET request | Servlet returns HTTP 405 Method Not Allowed; record preserved | HTTP 405 Method Not Allowed | ✅ **PASS** |
| **8** | **SQL Injection: Login Form** | `POST /LoginServlet` | `username = ' OR 1=1 --` | Parameterized query treats input as literal; login fails | Authentication failed | ✅ **PASS** |
| **9** | **SQL Injection: Snippet Search** | `GET /dashboard?query=...` | `query = ' UNION SELECT null, password, null...` | Parameterized query treats input as literal; no data leaked | Safe search results | ✅ **PASS** |
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
| **20** | **Health Check Response Privacy** | `GET /health` | Ping health check endpoint | Returns HTTP 200 `{"status":"UP"}` without internal URLs/traces | Minimal JSON status | ✅ **PASS** |
| **21** | **Audit Trail: USER_REGISTERED** | `login_audit` in MySQL | User registration flow | `login_audit` records user_id, timestamp, IP, success flag | Verified in MySQL | ✅ **PASS** |
| **22** | **Audit Trail: LOGIN_SUCCESS** | `login_audit` in MySQL | User login flow | `login_audit` records user_id, timestamp, IP, success=1 | Verified in MySQL | ✅ **PASS** |
| **23** | **Audit Trail: LOGIN_FAILED** | `login_audit` in MySQL | Invalid password / unknown user | `login_audit` records success=0, user_id (if existing) or NULL | Verified in MySQL | ✅ **PASS** |
| **24** | **Audit Trail: LOGOUT** | `login_audit` in MySQL | User logout flow | `login_audit` records user_id, timestamp, IP, success=1 | Verified in MySQL | ✅ **PASS** |
| **25** | **MySQL Workbench & Host Access (3307)** | Host CLI / Workbench | Connect to `127.0.0.1:3307` | Connected as `codevault_user`; port not exposed to 0.0.0.0 | Localhost 3307 only | ✅ **PASS** |
| **26** | **Container Non-Root User Execution** | `docker exec codevault-app whoami` | Inspect process execution context | Runs as UID 1001 (`tomcatuser`), not root | UID 1001 (tomcatuser) | ✅ **PASS** |
| **27** | **Container Privilege & Socket Isolation** | `docker inspect codevault-app` | Inspect container privileges & mounts | `Privileged: false`, no `/var/run/docker.sock` mount | Fully unprivileged | ✅ **PASS** |
| **28** | **Automated Unit & Integration Suites** | `mvn test` & `integration_test.ps1` | Execute full test suites | 15/15 unit tests and 15/15 integration tests pass | All 30 tests pass | ✅ **PASS** |
