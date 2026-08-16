<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard | CodeVault</title>
  
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
  <main class="app-main dashboard-main">
    <div class="dashboard-header fade-in">
      <h1 class="welcome-title">Welcome back, <span><c:out value="${not empty sessionScope.username ? sessionScope.username : 'Developer'}" /></span></h1>
      <p class="stat-date desktop-only" style="color: var(--text-secondary); font-size: 0.95rem; font-weight: 500;">
        Logged in securely
      </p>
    </div>
    
    <!-- Stats Cards Grid -->
    <div class="stats-grid fade-in delay-1">
      <div class="glass-card stat-card">
        <span class="stat-label">Total Snippets</span>
        <span class="stat-value"><c:out value="${not empty totalSnippets ? totalSnippets : 0}" /></span>
      </div>
      
      <div class="glass-card stat-card">
        <span class="stat-label">Languages Used</span>
        <div class="language-list">
          <c:choose>
            <c:when test="${not empty languages}">
              <c:forEach var="lang" items="${languages}">
                <span class="language-chip"><c:out value="${lang}" /></span>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <span style="color: var(--text-secondary); font-size: 0.9rem;">No languages yet</span>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      
      <div class="glass-card stat-card">
        <span class="stat-label">Last Updated</span>
        <span class="stat-value" style="font-size: 1.2rem;"><c:out value="${lastUpdated}" /></span>
      </div>
    </div>

    <!-- Search & Add Controls -->
    <div class="dashboard-controls fade-in delay-2">
      <div class="search-form">
        <div class="search-input-wrapper">
          <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <input type="text" id="searchInput" placeholder="Search snippets by title, language, description..." class="form-control search-input" autocomplete="off" />
        </div>
      </div>
      
      <a href="${pageContext.request.contextPath}/addSnippet" class="btn btn-primary btn-add-snippet">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 6px;">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        Add Snippet
      </a>
    </div>

    <div id="searchStatus" style="margin-bottom: 18px; color: var(--text-secondary); font-size: 0.9rem;"></div>

    <!-- Snippet Display -->
    <c:choose>
      <c:when test="${not empty snippets}">
        <div class="snippet-grid fade-in delay-3">
          <c:forEach var="snippet" items="${snippets}">
            <div class="glass-card snippet-card"
                 data-title="<c:out value='${snippet.title}' />"
                 data-description="<c:out value='${snippet.description}' />"
                 data-language="<c:out value='${snippet.language}' />">
              <div>
                <div class="snippet-header">
                  <a href="${pageContext.request.contextPath}/editSnippet?id=${snippet.id}" class="snippet-title"><c:out value="${snippet.title}" /></a>
                  
                  <c:set var="langClass" value="lang-other" />
                  <c:set var="highlightLang" value="plaintext"/>
                  <c:choose>
                    <c:when test="${snippet.language == 'Java'}">
                      <c:set var="langClass" value="lang-java"/>
                      <c:set var="highlightLang" value="java"/>
                    </c:when>
                    <c:when test="${snippet.language == 'Python'}">
                      <c:set var="langClass" value="lang-python"/>
                      <c:set var="highlightLang" value="python"/>
                    </c:when>
                    <c:when test="${snippet.language == 'JavaScript' || snippet.language == 'JS'}">
                      <c:set var="langClass" value="lang-javascript"/>
                      <c:set var="highlightLang" value="javascript"/>
                    </c:when>
                    <c:when test="${snippet.language == 'MySQL' || snippet.language == 'SQL'}">
                      <c:set var="langClass" value="lang-mysql"/>
                      <c:set var="highlightLang" value="sql"/>
                    </c:when>
                    <c:when test="${snippet.language == 'JSP' || snippet.language == 'HTML'}">
                      <c:set var="langClass" value="lang-jsp"/>
                      <c:set var="highlightLang" value="xml"/>
                    </c:when>
                  </c:choose>
                  
                  <span class="lang-badge ${langClass}"><c:out value="${snippet.language}" /></span>
                </div>
                
                <p class="snippet-description"><c:out value="${snippet.description}" /></p>

                <div class="code-preview">
                  <button class="copy-btn" title="Copy Code" type="button" aria-label="Copy Code">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <rect x="9" y="9" width="13" height="13" rx="2"></rect>
                      <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                    </svg>
                  </button>
                  <div class="copy-tooltip">Copied!</div>

                  <textarea class="full-code" style="display:none;"><c:out value="${snippet.code}" /></textarea>
                  <pre><code class="language-${highlightLang}"><c:out value="${snippet.previewCode}" /></code></pre>
                  <div class="preview-fade"></div>
                </div>

                <a class="view-code-btn" href="${pageContext.request.contextPath}/editSnippet?id=${snippet.id}">
                  View / Edit Code &rarr;
                </a>
              </div>
              
              <div class="snippet-footer">
                <span class="snippet-date">Added: <c:out value="${snippet.createdAt}" /></span>
                
                <div class="snippet-actions">
                  <a href="${pageContext.request.contextPath}/editSnippet?id=${snippet.id}" class="btn-action" title="Edit Snippet" aria-label="Edit Snippet">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                      <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                  </a>
                  
                  <form action="${pageContext.request.contextPath}/deleteSnippet" method="post" onsubmit="return confirm('Are you sure you want to delete this snippet?');" style="display:inline;">
                    <input type="hidden" name="csrf_token" value="<c:out value='${csrf_token}' />" />
                    <input type="hidden" name="id" value="<c:out value='${snippet.id}' />" />
                    <button type="submit" class="btn-action btn-action-delete" title="Delete Snippet" aria-label="Delete Snippet">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="3 6 5 6 21 6"></polyline>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                        <line x1="10" y1="11" x2="10" y2="17"></line>
                        <line x1="14" y1="11" x2="14" y2="17"></line>
                      </svg>
                    </button>
                  </form>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <!-- Empty State -->
        <div class="glass-card empty-card fade-in delay-3">
          <svg class="empty-icon" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
            <polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline>
            <line x1="12" y1="22.08" x2="12" y2="12"></line>
          </svg>
          <h3 class="empty-title">No Snippets Found</h3>
          <p class="empty-description">
            <c:choose>
              <c:when test="${not empty param.query}">
                Your search query "<c:out value="${param.query}" />" did not match any stored snippets.
              </c:when>
              <c:otherwise>
                Your code library is currently empty. Get started by creating your first programming snippet!
              </c:otherwise>
            </c:choose>
          </p>
          <a href="${pageContext.request.contextPath}/addSnippet" class="btn btn-primary">Create Snippet</a>
        </div>
      </c:otherwise>
    </c:choose>
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
