<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CodeVault | Personal Code Snippet Manager</title>
  <meta name="description" content="Store, organize, and manage your programming snippets securely in one place. Built with JSP, Servlets, JDBC, and MySQL.">

  <!-- Plus Jakarta Sans font -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

  <!-- Background Grids & Ambient Glows -->
  <div class="bg-grid"></div>
  <div class="bg-glow bg-glow-1"></div>
  <div class="bg-glow bg-glow-2"></div>

  <!-- Drifting Ambient Programming Symbols -->
  <div class="floating-elements">
    <div class="floating-item" style="top: 15%; left: 8%; animation-delay: 0s;">{ }</div>
    <div class="floating-item" style="top: 28%; right: 10%; animation-delay: 2s;">&lt;/&gt;</div>
    <div class="floating-item" style="top: 62%; left: 6%; animation-delay: 4s;">( )</div>
    <div class="floating-item" style="top: 75%; right: 12%; animation-delay: 1s;">&lt; &gt;</div>
    <div class="floating-item binary" style="top: 42%; left: 85%; animation-delay: 3s;">1010</div>
    <div class="floating-item binary" style="top: 82%; left: 15%; animation-delay: 5s;">0101</div>
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
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary mobile-only">Login</a>
          <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary mobile-only" style="margin-top: 8px;">Register</a>
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
            <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"></path>
          </svg>
        </button>

        <!-- Desktop Navigation CTAs -->
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary nav-btn desktop-only">Login</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary nav-btn desktop-only">Register</a>

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
  <section class="hero-section" style="min-height: calc(100vh - 64px); margin-top: 64px; display: flex; align-items: center; justify-content: center; padding: 80px 24px; position: relative; z-index: 10;">
    <div style="max-width: 800px; text-align: center; display: flex; flex-direction: column; align-items: center;">
      <div style="position: relative; margin-bottom: 32px;" class="fade-in">
        <svg class="hero-logo" width="84" height="84" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
      </div>

      <h1 class="fade-in delay-1" style="font-size: 4.5rem; font-weight: 800; line-height: 1.05; letter-spacing: -0.04em; margin-bottom: 12px; background: linear-gradient(135deg, var(--text-primary) 30%, var(--accent-blue) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">CodeVault</h1>
      <h2 class="fade-in delay-2" style="font-size: 1.8rem; font-weight: 600; letter-spacing: -0.02em; color: var(--accent-blue); margin-bottom: 24px;">Personal Code Snippet Manager</h2>

      <p class="fade-in delay-3" style="font-size: 1.15rem; font-weight: 400; line-height: 1.6; color: var(--text-secondary); max-width: 620px; margin-bottom: 44px;">
        Store, organize, and manage your programming snippets securely in one place.<br class="desktop-only">
        Built with enterprise-ready <strong style="color: var(--text-primary);">Jakarta Servlets</strong>, <strong style="color: var(--text-primary);">JSP</strong>, <strong style="color: var(--text-primary);">JDBC</strong>, and <strong style="color: var(--text-primary);">MySQL</strong>.
      </p>

      <div class="fade-in delay-4" style="display: flex; gap: 16px;">
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary" style="padding: 14px 36px; font-size: 1rem;">Login</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary" style="padding: 14px 36px; font-size: 1rem;">Register</a>
      </div>
    </div>
  </section>

  <!-- ==========================================
       FEATURES SECTION
       ========================================== -->
  <section id="features" style="position: relative; padding: 100px 24px; z-index: 10; border-top: 1px solid var(--border-neutral);">
    <div style="max-width: 1400px; margin: 0 auto; padding: 0 max(24px, 4%);">
      <div style="text-align: center; margin-bottom: 64px;" class="fade-in">
        <h2 style="font-size: 2.6rem; font-weight: 800; letter-spacing: -0.03em; margin-bottom: 12px;">Product Features</h2>
        <p style="font-size: 1.1rem; color: var(--text-secondary); max-width: 500px; margin: 0 auto;">A modern toolkit optimized for developers to secure and organize their codebase.</p>
      </div>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 32px;">
        <!-- Feature 1: Store Snippets -->
        <div class="glass-card feature-card fade-in delay-1">
          <div style="width: 46px; height: 46px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 24px; background: rgba(var(--accent-blue-rgb), 0.08); color: var(--accent-blue); border: 1px solid rgba(var(--accent-blue-rgb), 0.15);">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
              <path d="M3 5V19A9 3 0 0 0 21 19V5"></path>
              <path d="M3 12A9 3 0 0 0 21 12"></path>
            </svg>
          </div>
          <h3 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 12px;">Store Snippets</h3>
          <p style="font-size: 0.95rem; line-height: 1.55; color: var(--text-secondary);">Save programming snippets safely. Keep your algorithms, templates, and configurations cataloged securely.</p>
        </div>

        <!-- Feature 2: Manage Code -->
        <div class="glass-card feature-card fade-in delay-2">
          <div style="width: 46px; height: 46px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 24px; background: rgba(var(--accent-green-rgb), 0.08); color: var(--accent-green); border: 1px solid rgba(var(--accent-green-rgb), 0.15);">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"></path>
            </svg>
          </div>
          <h3 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 12px;">Manage Code</h3>
          <p style="font-size: 0.95rem; line-height: 1.55; color: var(--text-secondary);">Edit and organize snippets anytime. Update code real-time, structure folders, and tag solutions.</p>
        </div>

        <!-- Feature 3: Fast Access -->
        <div class="glass-card feature-card fade-in delay-3">
          <div style="width: 46px; height: 46px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 24px; background: rgba(var(--accent-blue-rgb), 0.08); color: var(--accent-blue); border: 1px solid rgba(var(--accent-blue-rgb), 0.15);">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
            </svg>
          </div>
          <h3 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 12px;">Fast Access</h3>
          <p style="font-size: 0.95rem; line-height: 1.55; color: var(--text-secondary);">Quickly retrieve your saved code. Locate snippets in milliseconds with index-optimized searching mechanics.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ==========================================
       TECHNOLOGY STACK
       ========================================== -->
  <section id="technologies" style="position: relative; padding: 100px 24px; z-index: 10; border-top: 1px solid var(--border-neutral);">
    <div style="max-width: 1400px; margin: 0 auto; padding: 0 max(24px, 4%);">
      <div style="text-align: center; margin-bottom: 64px;" class="fade-in">
        <h2 style="font-size: 2.6rem; font-weight: 800; letter-spacing: -0.03em; margin-bottom: 12px;">Built On Robust Architecture</h2>
        <p style="font-size: 1.1rem; color: var(--text-secondary); max-width: 500px; margin: 0 auto;">Engineered on high-performance Java web specifications and standard systems.</p>
      </div>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 20px;" class="fade-in delay-2">
        <div class="glass-card" style="padding: 24px 16px; display: flex; flex-direction: column; align-items: center; gap: 14px;">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <path d="M6 15c0 1.5 1.5 3 3 3h4c2 0 3.5-1 3.5-3v-4H6v4Z"></path>
            <path d="M16.5 11h1c1 0 1.5.5 1.5 1.5s-.5 1.5-1.5 1.5h-1"></path>
            <path d="M9 18v2c0 .5.5 1 1 1h2c.5 0 1-.5 1-1v-2"></path>
            <path d="M10 6c0-2 2-2 2-4m-4 4c0-2 2-2 2-4m4 4c0-2 2-2 2-4" stroke="var(--accent-blue)"></path>
          </svg>
          <span style="font-size: 0.9rem; font-weight: 600;">Java 21</span>
        </div>

        <div class="glass-card" style="padding: 24px 16px; display: flex; flex-direction: column; align-items: center; gap: 14px;">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <path d="M8 13l-2 2 2 2" stroke="var(--accent-green)"></path>
            <path d="M12 13l2 2-2 2" stroke="var(--accent-green)"></path>
          </svg>
          <span style="font-size: 0.9rem; font-weight: 600;">JSP / JSTL 3</span>
        </div>

        <div class="glass-card" style="padding: 24px 16px; display: flex; flex-direction: column; align-items: center; gap: 14px;">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
            <line x1="8" y1="21" x2="16" y2="21"></line>
            <line x1="12" y1="17" x2="12" y2="21"></line>
            <circle cx="12" cy="10" r="3" stroke="var(--accent-blue)"></circle>
          </svg>
          <span style="font-size: 0.9rem; font-weight: 600;">Jakarta Servlets</span>
        </div>

        <div class="glass-card" style="padding: 24px 16px; display: flex; flex-direction: column; align-items: center; gap: 14px;">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
            <path d="M3 5v14a9 3 0 0 0 18 0V5"></path>
            <path d="M3 12a9 3 0 0 0 18 0"></path>
            <path d="M18 12h-4m-2 0H8" stroke="var(--accent-green)" stroke-width="2"></path>
          </svg>
          <span style="font-size: 0.9rem; font-weight: 600;">HikariCP / JDBC</span>
        </div>

        <div class="glass-card" style="padding: 24px 16px; display: flex; flex-direction: column; align-items: center; gap: 14px;">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
            <path d="M3 5v6a9 3 0 0 0 18 0V5" stroke="var(--accent-blue)"></path>
            <path d="M3 11v6a9 3 0 0 0 18 0v-6"></path>
            <circle cx="12" cy="14" r="1.5" fill="var(--accent-blue)" stroke="none"></circle>
          </svg>
          <span style="font-size: 0.9rem; font-weight: 600;">MySQL 8</span>
        </div>

        <div class="glass-card" style="padding: 24px 16px; display: flex; flex-direction: column; align-items: center; gap: 14px;">
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" stroke="var(--accent-green)"></path>
            <path d="M2 12h20"></path>
          </svg>
          <span style="font-size: 0.9rem; font-weight: 600;">Tomcat 11</span>
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
        <div class="social-links">
          <a href="https://github.com/aviixek/" target="_blank" rel="noopener noreferrer" aria-label="GitHub" class="social-link">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"></path>
            </svg>
          </a>
        </div>
      </div>
    </div>
  </footer>

  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>