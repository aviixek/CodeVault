# CodeVault — Personal Code Snippet Manager

> A modern, Dockerized, and security-hardened Java web application for managing and organizing programming snippets.

Built with **Java 21 LTS**, **Apache Tomcat 11 (Jakarta Servlet 6.0)**, **JSP / JSTL 3.0**, **JDBC / HikariCP**, **MySQL 8.0**, **Maven**, and **Docker Compose**.

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
Data Access Objects (UserDAO, SnippetDAO, AuditDAO)
   ↓
HikariCP Connection Pool (DataSource)
   ↓ (Internal Bridge Network: db:3306)
MySQL 8.0 Database
   ↑ (Host Port Mapping: 127.0.0.1:3307 — Localhost Only)
MySQL Workbench & Host CLI
```

---

## Security Features & Hardening

* **Authentication & Audit Logging:** Comprehensive security event tracking in `login_audit` (`USER_REGISTERED`, `LOGIN_SUCCESS`, `LOGIN_FAILED`, `LOGOUT`). Zero passwords, hashes, or tokens stored in audit logs.
* **Password Security:** Salted **BCrypt** password hashing (Cost Factor 12) with transparent automatic upgrade for legacy accounts. Zero passwords printed in logs or console.
* **Authorization & IDOR Protection:** Snippet operations (view, edit, update, delete) enforce ownership in every database query (`WHERE id=? AND user_id=?`). Identity is strictly bound to the authenticated server session.
* **CSRF Protection:** Server-side anti-forgery tokens on all state-changing requests (`POST`), validated using constant-time comparison (`MessageDigest.isEqual`).
* **XSS Mitigation:** Context-aware output encoding across all templates via `<c:out value="..." escapeXml="true" />` and attribute escaping.
* **Session Hardening:** Session fixation prevention on login, 30-minute timeout, `HttpOnly`, and `SameSite=Lax` cookie flags.
* **Security Headers:** `Content-Security-Policy`, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, and `Permissions-Policy`.
* **Container Hardening:** Multi-stage build running under an unprivileged user (`UID 1001`), `no-new-privileges:true`, and strictly localhost-bound database port (`127.0.0.1:3307`).
* **Connection Pooling:** High-performance `HikariCP` pool with fail-fast credential validation and try-with-resources resource management.

---

## Quickstart (First-Time Setup)

### 1. Prerequisites
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) (v24+ or newer)
* [Docker Compose](https://docs.docker.com/compose/) (v2.20+ or newer)

### 2. Configure Environment
Create your `.env` configuration file from the template:

**Windows PowerShell:**
```powershell
Copy-Item .env.example .env
```

**Linux / macOS:**
```bash
cp .env.example .env
```

Open `.env` and configure your secure local passwords:
```ini
DB_HOST=db
DB_PORT=3306
DB_NAME=codevault
DB_USER=codevault_user
DB_PASSWORD=your_strong_app_password_here
MYSQL_ROOT_PASSWORD=your_strong_root_password_here
```

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
{"status":"UP"}
```

---

## Connecting with MySQL Workbench & Host CLI

MySQL is securely mapped to **`127.0.0.1:3307`** on your host (not exposed publicly or bound to `0.0.0.0`).

### MySQL Workbench Configuration
In MySQL Workbench, click **+** to add a new connection:
* **Connection Name:** `CodeVault Local`
* **Hostname:** `127.0.0.1`
* **Port:** `3307`
* **Username:** `codevault_user`
* **Password:** *(enter the value from `DB_PASSWORD` in your `.env` file)*
* **Default Schema:** `codevault`

### Host CLI Connection (PowerShell / Terminal)
If you have the `mysql` client installed on your host machine:
```powershell
mysql -h 127.0.0.1 -P 3307 -u codevault_user -p
```

### Docker CLI Connection (Direct Container Access)
You can also connect directly inside the running container without installing local MySQL tools:
```bash
docker exec -it codevault-db mysql -u codevault_user -p codevault
```

---

## Monitoring & Audit SQL Queries

Connect to MySQL and run these queries to inspect data securely:

### View Login & Registration Activity (Audit Trail)
```sql
SELECT id, user_id, event_type, success, ip_address, created_at
FROM login_audit
ORDER BY created_at DESC;
```

### View Activity with Username (Joined Query)
```sql
SELECT a.id, a.user_id, u.username, a.event_type, a.success, a.ip_address, a.created_at
FROM login_audit a
LEFT JOIN users u ON a.user_id = u.id
ORDER BY a.created_at DESC;
```

### View Registered Users Safely (Without Password Hashes)
```sql
SELECT id, username, email, created_at
FROM users
ORDER BY id ASC;
```

### View Snippets
```sql
SELECT id, title, language, user_id, created_at
FROM snippets
ORDER BY created_at DESC;
```

---

## Database Backup & Restore Procedures

### Database Backup
To create a complete SQL backup of the CodeVault database:
```bash
docker exec codevault-db mysqldump -u root -p<MYSQL_ROOT_PASSWORD> codevault > backup_codevault.sql
```

### Database Restore
To restore data into the container:
```bash
docker exec -i codevault-db mysql -u root -p<MYSQL_ROOT_PASSWORD> codevault < backup_codevault.sql
```

---

## Existing Database Migration Procedure

If you have an existing database from an earlier version and need to add `login_audit` without losing any existing users or snippets:

```bash
docker exec -i codevault-db mysql -u root -p<MYSQL_ROOT_PASSWORD> codevault < src/main/resources/db/migration.sql
```

*(Do **NOT** run `docker compose down -v` as that deletes database volumes).*

---

## Essential Management Commands Reference

| Action | Command |
|---|---|
| **1. Start CodeVault** | `docker compose up --build -d` |
| **2. Open Website** | Navigate to `http://localhost:8080` in your browser |
| **3. Connect with MySQL CLI** | `mysql -h 127.0.0.1 -P 3307 -u codevault_user -p` |
| **4. Connect with MySQL Workbench** | Host: `127.0.0.1`, Port: `3307`, User: `codevault_user`, Database: `codevault` |
| **5. View Registered Users Safely** | `docker exec -i codevault-db mysql -u codevault_user -p<DB_PASSWORD> codevault -e "SELECT id, username, email, created_at FROM users;"` |
| **6. View Snippets** | `docker exec -i codevault-db mysql -u codevault_user -p<DB_PASSWORD> codevault -e "SELECT id, title, language, user_id, created_at FROM snippets;"` |
| **7. View Login & Activity Audit** | `docker exec -i codevault-db mysql -u codevault_user -p<DB_PASSWORD> codevault -e "SELECT a.id, u.username, a.event_type, a.success, a.created_at FROM login_audit a LEFT JOIN users u ON a.user_id = u.id ORDER BY a.id DESC;"` |
| **8. Back Up Database** | `docker exec codevault-db mysqldump -u root -p<ROOT_PASSWORD> codevault > backup_codevault.sql` |
| **9. Stop Application** | `docker compose stop` |
| **10. Restart Application** | `docker compose restart` |

---

## Running Automated Tests

Run the full JUnit 5 unit and security test suite:
```bash
mvn test
```

Run the end-to-end integration and security test suite:
```powershell
powershell -ExecutionPolicy Bypass -File "src/test/resources/integration_test.ps1"
```
