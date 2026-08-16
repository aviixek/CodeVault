<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>400 Bad Request | CodeVault</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
  <div class="bg-grid"></div>
  <div class="bg-glow bg-glow-1"></div>
  <div class="bg-glow bg-glow-2"></div>

  <main class="app-main auth-main">
    <div class="glass-card auth-card fade-in" style="text-align: center;">
      <h1 style="font-size: 4rem; font-weight: 800; color: var(--accent-blue); margin-bottom: 8px;">400</h1>
      <h2 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 12px;">Bad Request</h2>
      <p style="color: var(--text-secondary); font-size: 0.95rem; margin-bottom: 28px;">The request could not be understood or was missing required parameters.</p>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary" style="width: 100%;">Return to Safety</a>
    </div>
  </main>
  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
