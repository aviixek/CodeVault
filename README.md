# CodeVault — Personal Code Snippet Manager

> A modern, Dockerized, and security-hardened Java web application for managing and organizing programming snippets.

Built with **Java 21**, **Jakarta Servlets (Tomcat 11)**, **JSP / JSTL 3.0**, **JDBC / HikariCP**, **MySQL 8.0**, **Maven**, and **Docker**.

---

## Architecture Overview

```
Browser (localhost:8080)
   ↓
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

---

## Security Features & Hardening

* **Password Security:** Salted **BCrypt** password hashing (Cost Factor 12) with transparent automatic upgrade for legacy accounts. Zero passwords printed in logs or console.
* **Authorization & IDOR Protection:** Snippet operations (view, edit, update, delete) enforce ownership in every database query (`WHERE id=? AND user_id=?`). Identity is strictly bound to the authenticated server session.
* **CSRF Protection:** Server-side anti-forgery tokens on all state-changing requests (`POST`), validated using constant-time comparison.
* **XSS Mitigation:** Context-aware output encoding across all templates via `<c:out value="..." escapeXml="true" />` and attribute escaping.
* **Session Hardening:** Session fixation prevention on login, 30-minute timeout, `HttpOnly`, and `SameSite=Lax` cookie flags.
* **Security Headers:** `Content-Security-Policy`, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, and `Permissions-Policy`.
* **Container Hardening:** Multi-stage build running under an unprivileged user (`UID 1001`), `no-new-privileges:true`, and zero host exposure of MySQL port 3306.
* **Connection Pooling:** High-performance `HikariCP` pool with try-with-resources resource management.

---

## Quickstart (Localhost via Docker)

### 1. Prerequisites
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) (v24+ or newer)
* [Docker Compose](https://docs.docker.com/compose/) (v2.20+ or newer)

### 2. Configure Environment
Copy the example environment file:
```bash
cp .env.example .env
```
*(Optionally adjust passwords in `.env` if desired; default development passwords work out-of-the-box).*

### 3. Launch Application
```bash
docker compose up --build -d
```

### 4. Access CodeVault
Open your browser and navigate to:
```
http://localhost:8080
```

### 5. Verify Health Status
```bash
curl http://localhost:8080/health
```
Expected output:
```json
{"status":"UP","database":"HEALTHY"}
```

---

## Local Development (Without Docker)

If developing locally with Eclipse, IntelliJ, or CLI:

1. Ensure **MySQL 8.0** is running locally and execute `src/main/resources/db/init.sql`.
2. Set environment variables in your terminal or IDE run configuration:
   ```bash
   export DB_HOST=localhost
   export DB_PORT=3306
   export DB_NAME=codevault
   export DB_USER=codevault_user
   export DB_PASSWORD=your_db_password
   ```
3. Build and package the WAR:
   ```bash
   mvn clean package
   ```
4. Deploy `target/codevault.war` to Apache Tomcat 11.

---

## Database Backup & Restore Procedures

### Database Backup
To take a complete SQL backup of the CodeVault database from the running Docker container:

```bash
docker exec codevault-db mysqldump -u root -pchange_me_strong_root_password codevault > backup_codevault.sql
```

### Database Restore
To restore data from an existing backup file into the Docker container:

```bash
docker exec -i codevault-db mysql -u root -pchange_me_strong_root_password codevault < backup_codevault.sql
```

---

## Running Automated Tests

Run the full JUnit 5 security and unit test suite:
```bash
mvn test
```

Test coverage includes:
* BCrypt hashing, salt uniqueness, and legacy password upgrade
* Strict input validation (username regex, email RFC format, password boundaries)
* Malformed ID and SQL injection payload rejection
* CSRF token generation and uniqueness
* Snippet preview truncation and models

---

## Project Structure

```
CodeVault/
├── pom.xml                               # Maven project descriptor (Java 21, Tomcat 11)
├── Dockerfile                            # Multi-stage container definition (non-root)
├── docker-compose.yml                    # Compose orchestrator (app + db)
├── .dockerignore                         # Docker build context exclusions
├── .gitignore                            # Git repository ignore rules
├── .env.example                          # Environment configuration template
├── README.md                             # Project documentation
├── SECURITY_AUDIT.md                     # Comprehensive security audit matrix
├── SECURITY_TEST_PLAN.md                 # 23-step security test verification plan
├── SECURITY_REPORT.md                    # Final security & hardening report
│
├── src/
│   ├── main/
│   │   ├── java/com/codevault/
│   │   │   ├── dao/                      # Data Access Objects (UserDAO, SnippetDAO)
│   │   │   ├── filter/                   # Security Filters (Auth, CSRF, Headers)
│   │   │   ├── model/                    # Data models (User, Snippet)
│   │   │   ├── servlet/                  # Jakarta HTTP Servlets & Health endpoint
│   │   │   └── util/                     # DBConnection (HikariCP) & InputValidator
│   │   │
│   │   ├── resources/
│   │   │   └── db/
│   │   │       └── init.sql              # Database initialization & least-privilege user
│   │   │
│   │   └── webapp/
│   │       ├── index.jsp                 # Landing page
│   │       ├── login.jsp                 # Authentication page
│   │       ├── register.jsp              # Registration page
│   │       ├── assets/                   # Shared CSS, JS, CodeMirror 5 assets
│   │       └── WEB-INF/
│   │           ├── web.xml               # Deployment descriptor & error mappings
│   │           └── views/                # Protected JSPs (dashboard, add, edit, errors)
│   │
│   └── test/
│       └── java/com/codevault/           # JUnit 5 security & unit tests
│
└── target/                               # Maven build output (codevault.war)
```
