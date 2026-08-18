<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CodeVault | Save and Organize Your Code</title>
  <meta name="description" content="A simple, secure place to save and organize your code snippets. Built with Java, JSP, and MySQL.">

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
    <div class="floating-item float-pos-hero-2">&lt;/&gt;</div>
    <div class="floating-item float-pos-hero-3">( )</div>
    <div class="floating-item float-pos-4">&lt; &gt;</div>
    <div class="floating-item binary float-pos-hero-5">1010</div>
    <div class="floating-item binary float-pos-hero-6">0101</div>
  </div>

  <!-- ==========================================
       NAVIGATION BAR
       ========================================== -->
  <header class="navbar">
    <div class="navbar-container">
      <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
        <svg class="brand-logo" width="32" height="32" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
        <span class="brand-name">CodeVault</span>
      </a>

      <nav class="nav-menu">
        <a href="#features" class="nav-link">Features</a>
        <a href="#technologies" class="nav-link">Stack</a>

        <div class="mobile-menu-ctas">
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary mobile-only">Sign in</a>
          <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary mobile-only mt-8">Create account</a>
        </div>
      </nav>

      <div class="nav-actions">
        <!-- Theme Toggle -->
        <button id="theme-toggle" class="theme-toggle-btn" aria-label="Toggle Theme">
          <svg class="sun-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="4"></circle>
            <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"></path>
          </svg>
          <svg class="moon-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 3a6 6 0 0 0 9 9 9 0 1 1-9-9Z"></path>
          </svg>
        </button>

        <!-- Desktop Navigation CTAs -->
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary nav-btn desktop-only">Sign in</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary nav-btn desktop-only">Create account</a>

        <!-- Mobile Burger -->
        <button id="mobile-menu-toggle" class="mobile-menu-toggle" aria-label="Toggle Menu">
          <span></span>
          <span></span>
          <span></span>
        </button>
      </div>
    </div>
  </header>

  <!-- ==========================================
       HERO SECTION
       ========================================== -->
  <section class="hero-section hero-container">
    <div class="hero-content-wrapper">
      <div class="hero-logo-box fade-in">
        <svg class="hero-logo" width="84" height="84" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
      </div>

      <h1 class="fade-in delay-1 hero-headline">CodeVault</h1>

      <h2 class="fade-in delay-2 hero-subhead">A Simple Place to Save and Organize Your Code</h2>

      <p class="fade-in delay-3 hero-description">
        Save, organize, and access your code safely from anywhere.<br class="desktop-only">
        Built with <strong class="hero-bold-text">Java 21</strong>, <strong class="hero-bold-text">Jakarta Servlets</strong>, <strong class="hero-bold-text">JSP</strong>, and <strong class="hero-bold-text">MySQL</strong>.
      </p>

      <div class="fade-in delay-4 hero-cta-group">
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary hero-btn">Sign in</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary hero-btn">Create account</a>
      </div>
    </div>
  </section>

  <!-- ==========================================
       FEATURES SECTION
       ========================================== -->
  <section id="features" class="section-bordered">
    <div class="section-inner-container">
      <div class="section-header-center fade-in">
        <h2 class="section-main-title">Features</h2>
        <p class="section-subtitle-center">Everything you need to keep your code organized, searchable, and secure.</p>
      </div>

      <div class="features-grid-layout">
        <!-- Feature 1: Save Code -->
        <div class="glass-card feature-card fade-in delay-1">
          <div class="feature-icon-blue">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
              <path d="M3 5V19A9 3 0 0 0 21 19V5"></path>
              <path d="M3 12A9 3 0 0 0 21 12"></path>
            </svg>
          </div>
          <h3 class="feature-heading">Save Code</h3>
          <p class="feature-body">Save programming code safely. Keep your algorithms, templates, and helpful snippets organized in one place.</p>
        </div>

        <!-- Feature 2: Manage Code -->
        <div class="glass-card feature-card fade-in delay-2">
          <div class="feature-icon-green">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"></path>
            </svg>
          </div>
          <h3 class="feature-heading">Manage Code</h3>
          <p class="feature-body">View, edit, and update your saved code anytime with built-in syntax highlighting for popular languages.</p>
        </div>

        <!-- Feature 3: Fast Search -->
        <div class="glass-card feature-card fade-in delay-3">
          <div class="feature-icon-blue">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
            </svg>
          </div>
          <h3 class="feature-heading">Fast Search</h3>
          <p class="feature-body">Quickly find your saved code by searching titles, descriptions, or programming languages in real time.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ==========================================
       TECHNOLOGY STACK
       ========================================== -->
  <section id="technologies" class="section-bordered">
    <div class="section-inner-container">
      <div class="section-header-center fade-in">
        <h2 class="section-main-title">Built With Modern Standards</h2>
        <p class="section-subtitle-center">Engineered with secure, reliable, and containerized components.</p>
      </div>

      <div class="tech-grid-layout fade-in delay-2">
        <div class="glass-card tech-item-card">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <path d="M6 15c0 1.5 1.5 3 3 3h4c2 0 3.5-1 3.5-3v-4H6v4Z"></path>
            <path d="M16.5 11h1c1 0 1.5.5 1.5 1.5s-.5 1.5-1.5 1.5h-1"></path>
            <path d="M9 18v2c0 .5.5 1 1 1h2c.5 0 1-.5 1-1v-2"></path>
            <path d="M10 6c0-2 2-2 2-4m-4 4c0-2 2-2 2-4m4 4c0-2 2-2 2-4" stroke="var(--accent-blue)"></path>
          </svg>
          <span class="tech-item-name">Java 21</span>
        </div>

        <div class="glass-card tech-item-card">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <path d="M8 13l-2 2 2 2" stroke="var(--accent-green)"></path>
            <path d="M12 13l2 2-2 2" stroke="var(--accent-green)"></path>
          </svg>
          <span class="tech-item-name">JSP / JSTL 3</span>
        </div>

        <div class="glass-card tech-item-card">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
            <line x1="8" y1="21" x2="16" y2="21"></line>
            <line x1="12" y1="17" x2="12" y2="21"></line>
            <circle cx="12" cy="10" r="3" stroke="var(--accent-blue)"></circle>
          </svg>
          <span class="tech-item-name">Jakarta Servlets</span>
        </div>

        <div class="glass-card tech-item-card">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
            <path d="M3 5v14a9 3 0 0 0 18 0V5"></path>
            <path d="M3 12a9 3 0 0 0 18 0"></path>
            <path d="M18 12h-4m-2 0H8" stroke="var(--accent-green)" stroke-width="2"></path>
          </svg>
          <span class="tech-item-name">HikariCP / JDBC</span>
        </div>

        <div class="glass-card tech-item-card">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
            <path d="M3 5v6a9 3 0 0 0 18 0V5" stroke="var(--accent-blue)"></path>
            <path d="M3 11v6a9 3 0 0 0 18 0v-6"></path>
            <circle cx="12" cy="14" r="1.5" fill="var(--accent-blue)" stroke="none"></circle>
          </svg>
          <span class="tech-item-name">MySQL 8</span>
        </div>

        <div class="glass-card tech-item-card">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" stroke="var(--accent-green)"></path>
            <path d="M2 12h20"></path>
          </svg>
          <span class="tech-item-name">Tomcat 11</span>
        </div>
      </div>
    </div>
  </section>

  <!-- ==========================================
       FOOTER
       ========================================== -->
  <footer class="footer">
    <div class="footer-container">
      <div class="footer-info fade-in">
        <div class="footer-brand">
          <svg width="24" height="24" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round" />
            <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
            <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
            <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
          </svg>
          <span>CodeVault</span>
        </div>
      </div>

      <div class="footer-bottom">
        <p class="copyright">&copy; 2026 CodeVault. All rights reserved.</p>
      </div>
    </div>
  </footer>

  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>