<div align="center">

# 🚀 CodeVault
### Personal Code Snippet Manager

A modern web application for developers to securely save, organize, search, and manage code snippets with syntax highlighting and an elegant user interface.

---

![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge)
![JSP](https://img.shields.io/badge/JSP-Servlet-blue?style=for-the-badge)
![Tomcat](https://img.shields.io/badge/Apache-Tomcat%2011-F8DC75?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-Database-00758F?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

</div>

---

# 📖 About

**CodeVault** is a dynamic Java web application that helps developers store, organize, edit, and search their programming snippets in one place.

Instead of saving code in random text files or notes, CodeVault provides a clean dashboard where snippets can be categorized, searched instantly, copied with one click, and managed efficiently.

Built using **JSP, Servlets, JDBC, MySQL, and Apache Tomcat**, the project demonstrates core Java Enterprise development concepts with a modern user interface.

---

# ✨ Features

### 🔐 Authentication

- User Registration
- Secure Login
- Session Management
- Logout

---

### 📝 Snippet Management

- Add Snippets
- Edit Snippets
- Delete Snippets
- View Snippets

---

### 💻 Code Editor

- CodeMirror Editor
- Syntax Highlighting
- Multiple Programming Languages
- Automatic Formatting Support

---

### 🎨 User Interface

- Modern Dashboard
- Dark Mode
- Light Mode
- Responsive Design
- Glassmorphism Cards
- Beautiful Animations

---

### 🔍 Search

- Live Search
- Instant Filtering
- Language Search
- Description Search

---

### 📋 Productivity

- One Click Copy
- Dashboard Statistics
- Language Badges
- Clean Code Preview

---

# 🛠️ Tech Stack

## Backend

- Java
- JSP
- Servlets
- JDBC

## Frontend

- HTML5
- CSS3
- JavaScript

## Database

- MySQL

## Server

- Apache Tomcat 11

## Libraries

- Highlight.js
- CodeMirror 5

---

# 📂 Project Structure

```text
CodeVault
│
├── src/
│   ├── controller/
│   ├── dao/
│   ├── model/
│   ├── util/
│   └── ...
│
├── WebContent/
│   ├── css/
│   ├── js/
│   ├── images/
│   ├── dashboard.jsp
│   ├── login.jsp
│   ├── register.jsp
│   ├── addSnippet.jsp
│   ├── editSnippet.jsp
│   ├── profile.jsp
│   └── WEB-INF/
│       └── web.xml
│
├── build/
│
└── README.md
```
---

# 📸 Screenshots

## Dashboard

```
<img width="1912" height="911" alt="image" src="https://github.com/user-attachments/assets/a800659b-d9d5-46e9-a47d-3fee9fa8117d" />

```

---

## Add Snippet

```
<img width="1917" height="906" alt="image" src="https://github.com/user-attachments/assets/138ac96c-bd69-4533-873e-d287cbe63a46" />

```

---

## Login

```
<img width="1917" height="912" alt="image" src="https://github.com/user-attachments/assets/47dc1d04-ce7e-4f5b-a2a1-c2551fe0d79a" />

```

---

## Dark Mode

```
<img width="1917" height="913" alt="image" src="https://github.com/user-attachments/assets/a310530b-6ae2-42ad-b1ae-f58a16847f6e" />

```

---

# 🚀 Installation Guide

## Prerequisites

- Java JDK 17 (or the version used by your project)
- Eclipse IDE for Enterprise Java Developers
- Apache Tomcat 11
- MySQL Server
- Git

---

## Clone Repository

```bash
git clone https://github.com/aviixek/CodeVault.git
```

---

## Import into Eclipse

1. Open Eclipse.
2. Go to:

```
File
    ↓
Import
    ↓
Existing Projects into Workspace
```

3. Select the cloned project.
4. Finish the import.

---

## Configure Tomcat

1. Open

```
Servers
```

2. Add

```
Apache Tomcat 11
```

3. Select the installed Tomcat directory.

4. Add the CodeVault project to the server.

---

## Configure MySQL

Create a database:

```sql
CREATE DATABASE codevault;
```

Create the snippets table:

```sql
CREATE TABLE snippets(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    language VARCHAR(50),
    code TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT
);
```

If your project includes additional tables (such as `users`), create/import those as well.

Update your JDBC connection details inside the project.

Example:

```java
String url = "jdbc:mysql://localhost:3306/codevault";
String username = "root";
String password = "your_password";
```

---

## Run Project

Right-click the project

```
Run As
        ↓
Run on Server
```

Open

```
http://localhost:8080/CodeVault
```

---

# 🎯 Current Features

- ✅ User Authentication
- ✅ Dashboard
- ✅ CRUD Operations
- ✅ Live Search
- ✅ Copy Code
- ✅ Syntax Highlighting
- ✅ Code Editor
- ✅ Dashboard Statistics
- ✅ Responsive Layout
- ✅ Dark / Light Theme

---

# 🚧 Future Improvements

- ⭐ Favorite Snippets
- 🏷️ Tags
- 📂 Collections
- 📤 Export Snippets
- 📥 Import Snippets
- 🔗 Share Snippets
- 👤 User Profile
- 📊 Usage Analytics
- ☁️ Cloud Backup
- 📱 Progressive Web App (PWA)

---

# 🏗️ Architecture

```
User

   │

   ▼

JSP Pages

   │

   ▼

Servlet Controller

   │

   ▼

DAO Layer

   │

   ▼

JDBC

   │

   ▼

MySQL Database
```

---

# 💡 Why CodeVault?

Developers often store useful code snippets in multiple places, making them difficult to organize and retrieve later.

CodeVault solves this by providing:

- Organized storage
- Fast searching
- Syntax highlighting
- Easy editing
- One-click copying
- Secure user accounts

---

# 🌐 Live Demo

🚧 Coming Soon

This project currently runs on Apache Tomcat locally. A public deployment will be added in a future update.

---

# 🤝 Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.

```bash
git checkout -b feature/new-feature
```

3. Commit changes.

```bash
git commit -m "Added new feature"
```

4. Push your branch.

```bash
git push origin feature/new-feature
```

5. Open a Pull Request.

---

# 📄 License

This project is licensed under the MIT License.

---

# 👨‍💻 Developer

**Abhishek Kushwaha**

GitHub:
https://github.com/aviixek

---

<div align="center">

⭐ If you like this project, consider giving it a star!

</div>
