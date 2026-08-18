<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>400 | CodeVault</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
  <div class="bg-grid"></div>
  <div class="bg-glow bg-glow-1"></div>
  <div class="bg-glow bg-glow-2"></div>

  <main class="app-main auth-main">
    <div class="glass-card auth-card fade-in error-card">
      <h1 class="error-code">400</h1>
      <h2 class="error-title">We couldn't process your request.</h2>
      <p class="error-desc">Please check your input and try again.</p>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-full-width">Return to Saved Code</a>
    </div>
  </main>
  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
