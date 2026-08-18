# CodeVault

CodeVault is a simple place to save and organize your code.

## Start CodeVault

1. Install Docker Desktop.
2. Download this project.
3. Open the project folder.
4. Run:

```powershell
.\start.ps1
```

5. Open:

**http://localhost:8080**

That's it.

---

## Daily Commands (Windows PowerShell)

| Action | Command | Description |
| :--- | :--- | :--- |
| **Start** | `.\start.ps1` | Starts CodeVault, builds containers, and verifies readiness. |
| **Stop** | `.\stop.ps1` | Stops CodeVault cleanly (preserves your saved data). |
| **Restart** | `.\restart.ps1` | Restarts CodeVault services and checks health. |
| **Status** | `.\status.ps1` | Displays the current running status of the application and database. |
| **Backup** | `.\backup.ps1` | Creates a timestamped `.sql` backup file in the project folder. |
| **Reset Database** | `.\reset-database.ps1` | *(Destructive)* Confirms and resets database to a fresh state. |

---

## Linux / macOS Instructions

On Linux or macOS, you can launch CodeVault using Docker Compose:

```bash
# 1. Copy template configuration (first-time only)
cp .env.example .env

# 2. Build and start containers
docker compose up --build -d

# 3. Stop containers
docker compose stop
```

Open **http://localhost:8080** in your browser.

---

## Inspecting the Database Locally

### Option A: MySQL Workbench (Recommended GUI)

You can connect directly to your local CodeVault database with MySQL Workbench:

- **Hostname / Host:** `127.0.0.1`
- **Port:** `3307`
- **Username:** `codevault_user`
- **Password:** *(the `DB_PASSWORD` configured in your `.env` file)*
- **Database / Schema:** `codevault`

> **Note:** MySQL is exposed only on `127.0.0.1:3307` (localhost only) for your security. It is never exposed publicly.

### Option B: MySQL Command Line (CLI)

From your terminal, connect interactively without exposing passwords on the command line:

```bash
mysql -h 127.0.0.1 -P 3307 -u codevault_user -p
```

Or execute queries directly inside the running Docker container:

```bash
docker compose exec -it db mysql -u codevault_user -p codevault
```

---

## Safe Database Inspection Queries

See [`database-commands.sql`](database-commands.sql) for ready-to-run queries.

### View Registered Users
```sql
USE codevault;

SELECT id, username, email, created_at
FROM users
ORDER BY id DESC;
```

### View User Activity & Audit Trail
```sql
USE codevault;

SELECT
    a.id,
    u.username,
    a.event_type,
    a.success,
    a.ip_address,
    a.created_at
FROM login_audit a
LEFT JOIN users u ON a.user_id = u.id
ORDER BY a.id DESC;
```

---

## Database Backup & Restore

### Creating a Backup
Run:
```powershell
.\backup.ps1
```
This generates a file named `backup_codevault_YYYYMMDD_HHMMSS.sql`.

### Restoring a Backup
To restore a saved backup:
```powershell
docker compose exec -T db sh -c 'mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' < backup_codevault_YYYYMMDD_HHMMSS.sql
```

---

## Security Highlights

CodeVault is hardened against common web application vulnerabilities and validated through automated and manual security testing:

- **Password Hashing:** Salted **BCrypt** (Cost Factor 12). Plaintext passwords and hashes are never exposed in logs or monitoring queries.
- **Audit Logging:** Tracks `USER_REGISTERED`, `LOGIN_SUCCESS`, `LOGIN_FAILED`, and `LOGOUT` events in `login_audit`.
- **POST-Only Logout:** Logout strictly requires HTTP POST with valid CSRF token. GET requests are rejected with HTTP 405.
- **CSRF Protection:** Synchronizer token pattern with constant-time verification for state-changing POST requests.
- **Strict IDOR & Authorization:** SQL-level ownership verification (`WHERE id=? AND user_id=?`) on every view, update, and delete operation.
- **XSS & Injection Defense:** Context-aware JSTL escaping (`<c:out>`) and 100% parameterized SQL `PreparedStatement` queries.
- **Content Security Policy (CSP):** Strict self-contained policy (`default-src 'self'; script-src 'self'; style-src 'self'; font-src 'self'; img-src 'self' data:; connect-src 'self'; frame-ancestors 'none'; form-action 'self'; base-uri 'self'`) with zero external CDNs and zero inline scripts/styles.
- **Docker Hardening:** Application runs as a dedicated non-root user (`UID 1001`), with `no-new-privileges:true`, and MySQL restricted strictly to `127.0.0.1:3307`.

---

## Developer Information

- **Java Version:** 21 (Eclipse Temurin LTS)
- **Servlet Container:** Apache Tomcat 11.0
- **Web Specifications:** Jakarta EE 10 / Jakarta Servlets 6.0 / JSP 3.1 / JSTL 3.0
- **Database:** MySQL 8.0 with HikariCP 5.1 connection pooling
- **Testing:** JUnit 5 test suite (`mvn test`) and PowerShell integration tests
