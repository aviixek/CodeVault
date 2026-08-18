<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign in | CodeVault</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

  <!-- Background Grids & Ambient Glows -->
  <div class="bg-grid"></div>
  <div class="bg-glow bg-glow-1"></div>
  <div class="bg-glow bg-glow-2"></div>

  <!-- Drifting Ambient Programming Symbols -->
  <div class="floating-elements">
    <div class="floating-item float-pos-1">{ }</div>
    <div class="floating-item float-pos-2">&lt;/&gt;</div>
    <div class="floating-item float-pos-3">( )</div>
    <div class="floating-item float-pos-4">&lt; &gt;</div>
    <div class="floating-item binary float-pos-5">1010</div>
    <div class="floating-item binary float-pos-6">0101</div>
  </div>

  <!-- Header -->
  <header class="navbar">
    <div class="navbar-container">
      <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
        <svg class="brand-logo" width="30" height="30" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
        <span class="brand-name">CodeVault</span>
      </a>
      
      <nav class="nav-menu">
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link">Home</a>
        <a href="${pageContext.request.contextPath}/index.jsp#features" class="nav-link">Features</a>
        <a href="${pageContext.request.contextPath}/index.jsp#technologies" class="nav-link">Stack</a>
        
        <div class="mobile-menu-ctas">
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary mobile-only">Sign in</a>
          <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary mobile-only mt-8">Create account</a>
        </div>
      </nav>
      
      <div class="nav-actions">
        <button id="theme-toggle" class="theme-toggle-btn" aria-label="Toggle Theme">
          <svg class="sun-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="4"></circle>
            <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"></path>
          </svg>
          <svg class="moon-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 3a6 6 0 0 0 9 9 9 0 1 1-9-9Z"></path>
          </svg>
        </button>
        
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary nav-btn desktop-only">Sign in</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary nav-btn desktop-only">Create account</a>
        
        <button id="mobile-menu-toggle" class="mobile-menu-toggle" aria-label="Toggle Menu">
          <span></span>
          <span></span>
          <span></span>
        </button>
      </div>
    </div>
  </header>

  <!-- Main Content -->
  <main class="app-main auth-main">
    <div class="glass-card auth-card fade-in delay-1">
      <div class="auth-header">
        <svg class="auth-logo" width="48" height="48" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
        <h1 class="auth-title auth-title-custom">Welcome Back</h1>
        <p class="auth-subtitle">Sign in to access your saved code</p>
      </div>
      
      <!-- Safe Error Alert with JSTL escaping -->
      <c:if test="${not empty error}">
        <div class="banner-error">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="8" x2="12" y2="12"></line>
            <line x1="12" y1="16" x2="12.01" y2="16"></line>
          </svg>
          <span><c:out value="${error}" /></span>
        </div>
      </c:if>

      <!-- Safe Success Alert with JSTL escaping -->
      <c:if test="${not empty message}">
        <div class="banner-success">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
            <polyline points="22 4 12 14.01 9 11.01"></polyline>
          </svg>
          <span><c:out value="${message}" /></span>
        </div>
      </c:if>
      
      <form action="${pageContext.request.contextPath}/LoginServlet" method="post" id="loginForm">
        <!-- CSRF Token -->
        <input type="hidden" name="csrf_token" value="<c:out value='${csrf_token}' />" />

        <div class="form-group">
          <label class="form-label" for="username">Username or Email</label>
          <input class="form-control" type="text" id="username" name="username" placeholder="Username or email address" required autocomplete="username" />
        </div>
        
        <div class="form-group mb-24">
          <label class="form-label" for="password">Password</label>
          <div class="input-wrapper">
            <input class="form-control" type="password" id="password" name="password" placeholder="••••••••" required autocomplete="current-password" />
            <button type="button" class="input-icon-right" id="passwordToggle" aria-label="Toggle Password Visibility">
              <svg id="eyeIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
            </button>
          </div>
        </div>
        
        <button class="btn btn-primary btn-auth" type="submit" id="submitBtn">
          Sign In
        </button>
      </form>
      
      <div class="auth-footer-text">
        Don't have an account? 
        <a href="${pageContext.request.contextPath}/register.jsp">Create account</a>
      </div>
    </div>
  </main>

  <!-- Footer -->
  <footer class="footer">
    <div class="footer-container">
      <div class="footer-bottom">
        <p class="copyright">&copy; 2026 CodeVault. All rights reserved.</p>
      </div>
    </div>
  </footer>

  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
