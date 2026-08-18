<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Save New Code | CodeVault</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/codemirror5/lib/codemirror.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/codemirror5/theme/dracula.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/codemirror5/addon/fold/foldgutter.css">
</head>
<body>

  <!-- Background Grids & Ambient Glows -->
  <div class="bg-grid"></div>
  <div class="bg-glow bg-glow-1"></div>
  <div class="bg-glow bg-glow-2"></div>

  <!-- Header -->
  <header class="navbar">
    <div class="navbar-container">
      <a href="${pageContext.request.contextPath}/dashboard" class="brand">
        <svg class="brand-logo" width="30" height="30" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
        <span class="brand-name">CodeVault</span>
      </a>
      
      <nav class="nav-menu">
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Saved Code</a>
        <a href="${pageContext.request.contextPath}/addSnippet" class="nav-link nav-link-active">Save New Code</a>
        
        <div class="mobile-menu-ctas">
          <form action="${pageContext.request.contextPath}/logout" method="post" class="form-full-width">
            <input type="hidden" name="csrf_token" value="<c:out value='${csrf_token}' />" />
            <button type="submit" class="btn btn-danger mobile-only btn-full-width">Sign out</button>
          </form>
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
        
        <form action="${pageContext.request.contextPath}/logout" method="post" class="form-inline">
          <input type="hidden" name="csrf_token" value="<c:out value='${csrf_token}' />" />
          <button type="submit" class="btn btn-secondary nav-btn desktop-only">Sign out</button>
        </form>
        
        <button id="mobile-menu-toggle" class="mobile-menu-toggle" aria-label="Toggle Menu">
          <span></span>
          <span></span>
          <span></span>
        </button>
      </div>
    </div>
  </header>

  <!-- Main Content -->
  <main class="app-main editor-main">
    <div class="back-btn-container fade-in">
      <a href="${pageContext.request.contextPath}/dashboard" class="back-link">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="19" y1="12" x2="5" y2="12"></line>
          <polyline points="12 19 5 12 12 5"></polyline>
        </svg>
        Back to Saved Code
      </a>
    </div>
    
    <div class="glass-card editor-card fade-in delay-1">
      <div class="editor-header">
        <h1 class="editor-title">Save New Code</h1>
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
      
      <form action="${pageContext.request.contextPath}/addSnippet" method="post" id="addSnippetForm">
        <!-- CSRF Token -->
        <input type="hidden" name="csrf_token" value="<c:out value='${csrf_token}' />" />

        <div class="form-group">
          <label class="form-label" for="title">Code Title</label>
          <input class="form-control" type="text" id="title" name="title" placeholder="e.g. QuickSort Algorithm" required maxlength="200" />
        </div>
        
        <div class="form-group">
          <label class="form-label" for="language">Language</label>
          <select class="form-control select-control" id="language" name="language" required>
            <option value="" disabled selected>Select a language</option>
            <option value="Java">Java</option>
            <option value="Python">Python</option>
            <option value="JavaScript">JavaScript</option>
            <option value="MySQL">MySQL (SQL)</option>
            <option value="HTML">HTML</option>
            <option value="CSS">CSS</option>
            <option value="JSP">JSP</option>
            <option value="C">C</option>
            <option value="C++">C++</option>
            <option value="C#">C#</option>
            <option value="PHP">PHP</option>
            <option value="Ruby">Ruby</option>
            <option value="Go">Go</option>
            <option value="Rust">Rust</option>
            <option value="TypeScript">TypeScript</option>
            <option value="Bash">Bash</option>
            <option value="Other">Other</option>
          </select>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="description">About This Code</label>
          <textarea class="form-control" id="description" name="description" placeholder="Provide a brief explanation of what this code does..." rows="3" maxlength="2000"></textarea>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="code">Code</label>
          <textarea id="code" name="code" class="form-control hidden-code-textarea" placeholder="// Write or paste your code here..."></textarea>
        </div>
        
        <button class="btn btn-primary btn-auth btn-auth-submit" type="submit" id="submitBtn">
          Save Code
        </button>
      </form>
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

  <!-- CodeMirror Assets (Local) -->
  <script src="${pageContext.request.contextPath}/assets/codemirror5/lib/codemirror.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/mode/clike/clike.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/mode/python/python.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/mode/javascript/javascript.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/mode/xml/xml.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/mode/sql/sql.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/mode/css/css.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/addon/edit/closebrackets.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/addon/edit/matchbrackets.js"></script>
  <script src="${pageContext.request.contextPath}/assets/codemirror5/addon/selection/active-line.js"></script>

  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/editor.js"></script>
</body>
</html>
