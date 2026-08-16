<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Snippet | CodeVault</title>
  
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  
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
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/addSnippet" class="nav-link">Add Snippet</a>
        
        <div class="mobile-menu-ctas">
          <form action="${pageContext.request.contextPath}/logout" method="post" style="width: 100%;">
            <input type="hidden" name="csrf_token" value="<c:out value='${csrf_token}' />" />
            <button type="submit" class="btn btn-danger mobile-only" style="width: 100%;">Logout</button>
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
        
        <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline;">
          <input type="hidden" name="csrf_token" value="<c:out value='${csrf_token}' />" />
          <button type="submit" class="btn btn-secondary nav-btn desktop-only">Logout</button>
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
        Back to Dashboard
      </a>
    </div>
    
    <div class="glass-card editor-card fade-in delay-1">
      <div class="editor-header">
        <h1 class="editor-title">Edit Code Snippet</h1>
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
      
      <form action="${pageContext.request.contextPath}/updateSnippet" method="post" id="editSnippetForm">
        <!-- CSRF Token -->
        <input type="hidden" name="csrf_token" value="<c:out value='${csrf_token}' />" />
        <input type="hidden" name="id" value="<c:out value='${snippet.id}' />" />

        <div class="form-group">
          <label class="form-label" for="title">Snippet Title</label>
          <input class="form-control" type="text" id="title" name="title" value="<c:out value='${snippet.title}' />" placeholder="e.g. Binary Search implementation" required maxlength="200" />
        </div>
        
        <div class="form-group">
          <label class="form-label" for="language">Programming Language</label>
          <select class="form-control select-control" id="language" name="language" required>
            <option value="Java" ${snippet.language == 'Java' ? 'selected' : ''}>Java</option>
            <option value="MySQL" ${snippet.language == 'MySQL' || snippet.language == 'SQL' ? 'selected' : ''}>MySQL (SQL)</option>
            <option value="JSP" ${snippet.language == 'JSP' ? 'selected' : ''}>JSP</option>
            <option value="HTML" ${snippet.language == 'HTML' ? 'selected' : ''}>HTML</option>
            <option value="CSS" ${snippet.language == 'CSS' ? 'selected' : ''}>CSS</option>
            <option value="Python" ${snippet.language == 'Python' ? 'selected' : ''}>Python</option>
            <option value="JavaScript" ${snippet.language == 'JavaScript' || snippet.language == 'JS' ? 'selected' : ''}>JavaScript</option>
            <option value="TypeScript" ${snippet.language == 'TypeScript' ? 'selected' : ''}>TypeScript</option>
            <option value="C" ${snippet.language == 'C' ? 'selected' : ''}>C</option>
            <option value="C++" ${snippet.language == 'C++' ? 'selected' : ''}>C++</option>
            <option value="C#" ${snippet.language == 'C#' ? 'selected' : ''}>C#</option>
            <option value="PHP" ${snippet.language == 'PHP' ? 'selected' : ''}>PHP</option>
            <option value="Ruby" ${snippet.language == 'Ruby' ? 'selected' : ''}>Ruby</option>
            <option value="Go" ${snippet.language == 'Go' ? 'selected' : ''}>Go</option>
            <option value="Rust" ${snippet.language == 'Rust' ? 'selected' : ''}>Rust</option>
            <option value="Bash" ${snippet.language == 'Bash' ? 'selected' : ''}>Bash</option>
            <option value="Other" ${snippet.language == 'Other' ? 'selected' : ''}>Other</option>
          </select>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="description">Description</label>
          <textarea class="form-control" id="description" name="description" placeholder="Provide a brief explanation of what this snippet solves..." rows="3" maxlength="2000"><c:out value="${snippet.description}" /></textarea>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="code">Code Snippet</label>
          <textarea id="code" name="code" class="form-control" style="display:none;"><c:out value="${snippet.code}" /></textarea>
        </div>
        
        <button class="btn btn-primary btn-auth" type="submit" id="submitBtn" style="margin-top: 12px;">
          Update Snippet
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

  <script>
    const codeArea = document.getElementById('code');
    const langSelect = document.getElementById('language');

    const modeMap = {
      'Java': 'text/x-java',
      'C': 'text/x-csrc',
      'C++': 'text/x-c++src',
      'C#': 'text/x-csharp',
      'Python': 'text/x-python',
      'JavaScript': 'text/javascript',
      'TypeScript': 'text/typescript',
      'MySQL': 'text/x-sql',
      'SQL': 'text/x-sql',
      'HTML': 'text/html',
      'XML': 'application/xml',
      'CSS': 'text/css',
      'JSP': 'application/x-jsp'
    };

    const initialLang = langSelect ? langSelect.value : 'Java';
    const initialMode = modeMap[initialLang] || 'text/x-java';

    const editor = CodeMirror.fromTextArea(codeArea, {
      lineNumbers: true,
      mode: initialMode,
      theme: 'dracula',
      autoCloseBrackets: true,
      matchBrackets: true,
      styleActiveLine: true,
      tabSize: 4,
      indentUnit: 4,
      lineWrapping: true
    });

    if (langSelect) {
      langSelect.addEventListener('change', () => {
        const mode = modeMap[langSelect.value] || 'text/plain';
        editor.setOption('mode', mode);
      });
    }

    const form = document.getElementById('editSnippetForm');
    if (form) {
      form.addEventListener('submit', () => {
        editor.save();
      });
    }
  </script>
</body>
</html>
