# CodeVault — Final Security & Hardening Report

## 1. Executive Summary

**CodeVault** is a full-stack personal code snippet manager web application originally developed in Eclipse using Java, JSP, Jakarta Servlets, JDBC, and MySQL. 

A thorough security audit and modernization process was executed to transition the application from an unmanaged, vulnerable legacy state into a **modern, Maven-managed, Dockerized, and security-hardened localhost web application**. 

All 20 identified security vulnerabilities—including 6 Critical flaws—were resolved without rewriting the core framework or disrupting the existing design aesthetics and user experience.

---

## 2. Architecture Overview

### Application Layer Architecture
```
Browser (localhost:8080)
   ↓ (HTTP Requests + Session Cookies + CSRF Tokens)
Apache Tomcat 11.0 (Servlet 6.0 Container / Java 21)
   ↓
Security Filters Pipeline (SecurityHeadersFilter → CsrfFilter → AuthFilter)
   ↓
Jakarta Servlets (LoginServlet, DashboardServlet, AddSnippetServlet, etc.)
   ↓
Data Access Objects (UserDAO, SnippetDAO)
   ↓
HikariCP Connection Pool (DataSource)
   ↓ (Isolated Docker Network: db:3306)
MySQL 8.0 Database (Least-Privilege user: codevault_user)
```

### Docker Infrastructure Architecture
```
[ Host Machine (Windows 11) ]
  └── Port 8080 (Forwarded to Container)
        │
┌───────▼────────────────────────────────────────────────────────┐
│ Docker Internal Network (codevault-network)                    │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Container: codevault-app                                 │  │
│  │ Base: Tomcat 11 / Temurin JDK 21 (Noble)                 │  │
│  │ User: UID 1001 (tomcatuser - non-root)                   │  │
│  │ Privileges: unprivileged (no-new-privileges:true)        │  │
│  │ App: ROOT.war                                            │  │
│  │ Healthcheck: GET /health (interval: 15s)                 │  │
│  └──────────────────────────┬───────────────────────────────┘  │
│                             │ TCP 3306 (Internal Only)         │
│  ┌──────────────────────────▼───────────────────────────────┐  │
│  │ Container: codevault-db                                  │  │
│  │ Base: MySQL 8.0                                          │  │
│  │ User: codevault_user (SELECT, INSERT, UPDATE, DELETE)    │  │
│  │ Port 3306: UNEXPOSED to host machine                     │  │
│  │ Volume: codevault_db_data (Persistent)                   │  │
│  │ Healthcheck: mysqladmin ping                             │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

---

## 3. Key Security Improvements

### 3.1 Authentication & Password Security
* **BCrypt Hashing:** Migrated from plaintext password storage to salted BCrypt hashing (cost factor 12) via `at.favre.lib:bcrypt`.
* **Zero Credential Logging:** Removed all `System.out.println` statements that printed passwords or credentials to logs.
* **Transparent Legacy Upgrade:** Implemented automatic on-login password hash upgrading for legacy accounts.

### 3.2 Authorization & IDOR Protection
* **Ownership Verification in SQL:** Enforced ownership checks in all data queries:
  ```sql
  DELETE FROM snippets WHERE id = ? AND user_id = ?
  SELECT * FROM snippets WHERE id = ? AND user_id = ?
  UPDATE snippets SET title=?, language=?, description=?, code=? WHERE id = ? AND user_id = ?
  ```
* **Trusted Identity:** User identity (`userId`) is strictly obtained from the server-side HTTP session, never accepted from user-controlled request parameters.
* **Enumeration Resistance:** Unauthorized access to another user's snippet returns HTTP 404 Not Found rather than 403, preventing attackers from confirming snippet existence.

### 3.3 Session Hardening & CSRF Protection
* **Session Fixation Prevention:** The unauthenticated session is explicitly invalidated on successful login via `oldSession.invalidate()`, and a fresh session is allocated.
* **Server-Side CSRF Validation:** `CsrfFilter` generates cryptographically random tokens and validates all state-changing POST requests (`/LoginServlet`, `/RegisterServlet`, `/addSnippet`, `/updateSnippet`, `/deleteSnippet`, `/logout`) using constant-time comparison (`MessageDigest.isEqual`).
* **Session Timeout & Cookie Flags:** Configured 30-minute session timeout, `HttpOnly`, and `SameSite=Lax` cookie flags in `web.xml`.

### 3.4 Cross-Site Scripting (XSS) & Input Validation
* **Context-Aware Output Encoding:** All dynamic values (snippet titles, descriptions, code, search parameters, flash messages) are safely rendered using JSTL `<c:out value="..." escapeXml="true" />` and escaped in HTML attributes and textareas.
* **Server-Side Validation:** `InputValidator` enforces strict whitelist validation on usernames (`^[a-zA-Z0-9_]{3,30}$`), RFC 5322 compliant emails, minimum password lengths (8+ chars), numeric ID boundaries, and language whitelisting.

### 3.5 Network & Docker Hardening
* **Non-Root Execution:** The Tomcat runtime executes under a dedicated unprivileged user (`tomcatuser`, UID 1001).
* **Least-Privilege Database User:** The application connects exclusively as `codevault_user`, restricted to CRUD permissions on `codevault.*`.
* **Zero Host Exposure of Database:** MySQL port 3306 is not bound to the host, remaining accessible only over the internal Docker bridge network.
* **Multi-Stage Build:** Build tools, compilers, and source files are discarded; only the compiled WAR is transferred to the minimal runtime image.

---

## 4. Security Findings Matrix (Before & After)

| Vulnerability | Before Modernization | Implemented Fix | After Modernization |
|---|---|---|---|
| **Hard-coded Credentials** | Cleartext root password in `DBConnection.java` | Extracted to environment variables & `.env` | No credentials in source code |
| **Plaintext Passwords** | Passwords stored & validated in plaintext | BCrypt (Cost 12) salted hashing + auto-migration | Passwords hashed securely |
| **Password Logging** | `System.out.println("Password = " + password)` | Removed all credential dumps, safe logging | Zero credentials in stdout/logs |
| **Snippet IDOR / BOLA** | Any user could edit/delete snippets by changing ID | Ownership enforced at servlet and SQL query level | 100% IDOR protected |
| **Missing Authentication** | Servlets executed without session verification | Centralized `AuthFilter` on all protected endpoints | Unauthenticated traffic redirected |
| **CSRF Vulnerability** | No anti-forgery token verification on forms | `CsrfFilter` with constant-time token comparison | All POST requests protected |
| **Cross-Site Scripting (XSS)** | Unescaped EL expressions (`${snippet.title}`) | Context-aware `<c:out escapeXml="true"/>` | Stored & reflected XSS prevented |
| **Delete via GET** | `GET /deleteSnippet?id=123` deleted records | Switched to `POST /deleteSnippet` with CSRF check | GET returns 405 Method Not Allowed |
| **Session Fixation** | Session ID retained across login transition | `session.invalidate()` and re-creation on login | Session fixation prevented |
| **Broken Logout** | Link just redirected to `login.jsp` | Dedicated `LogoutServlet` calling `session.invalidate()` | Complete session destruction |
| **Security Headers** | Zero security headers present | `SecurityHeadersFilter` adds CSP, X-Frame-Options, etc. | Strict security headers sent |
| **Database Privileges** | Application connected as MySQL `root` | Created `codevault_user` with CRUD-only grants | Least privilege enforced |
| **Connection Leaks** | Raw JDBC connections unclosed on errors | `HikariCP` connection pool + try-with-resources | Automatic pool management & leak check |
| **Error Disclosure** | Full stack traces shown to users on errors | Custom branded 400, 401, 403, 404, 500 error pages | Safe user-friendly error views |
| **Container Root User** | Docker default (root UID 0) | Dedicated `tomcatuser` (UID 1001) | Non-root container runtime |
| **Direct JSP Access** | JSPs accessible in root directory | Moved view templates to `/WEB-INF/views/` | Direct JSP navigation blocked |

---

## 5. Security Scanning & Verification Results

### 5.1 Automated Security Testing (JUnit 5 Suite)
* **Tests Executed:** 15 automated test cases.
* **Results:** 15 Passed, 0 Failed, 0 Errors.
* **Coverage:** BCrypt hashing, salt uniqueness, legacy password identification, username regex, email format validation, snippet ID bounds and SQL injection payload rejection, CSRF token generation, model preview code formatting.

### 5.2 Container Image Inspection
* **User Verification:** Verified running process user is `UID 1001` (`tomcatuser`).
* **Privilege Escalation:** `no-new-privileges:true` active.
* **Docker Socket:** No `/var/run/docker.sock` volume mounts.
* **Secrets in Image:** Verified `.dockerignore` excludes `.env` and source control secrets.

---

## 6. Remaining Risks & Ongoing Recommendations

While the application has been hardened against common OWASP Top 10 vulnerabilities, the following items are documented for production environments:

1. **HTTPS / TLS Termination:** In a production deployment outside of localhost, a reverse proxy (such as Nginx, Caddy, or an AWS ALB) must terminate HTTPS to enforce encrypted data in transit and enable the `Secure` cookie flag and `Strict-Transport-Security` (HSTS) headers.
2. **CSP Inline Style Exception:** The current `style-src` directive includes `'unsafe-inline'` to accommodate dynamic theme transitions. While JavaScript execution is strictly isolated (`script-src 'self'`), migrating all remaining dynamic styles to CSS classes will allow removing `'unsafe-inline'`.
3. **Rate Limiting / Account Lockout:** For high-exposure public deployments, rate-limiting on `/LoginServlet` and `/RegisterServlet` (e.g. via Redis or reverse proxy) should be implemented to mitigate brute-force password guessing and registration spam.
4. **Periodic Dependency Updates:** Maven dependencies (`HikariCP`, `mysql-connector-j`, `bcrypt`) should be periodically scanned and bumped using tools like Dependabot or OWASP Dependency-Check.
