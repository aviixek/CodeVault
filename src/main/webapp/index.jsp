<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CodeVault | Personal Code Snippet Manager</title>
  <meta name="description"
    content="Store, organize, and manage your programming snippets securely in one place. Built with JSP, Servlets, JDBC, and MySQL.">

  <!-- Plus Jakarta Sans for premium modern SaaS typography -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap"
    rel="stylesheet">

  <style>
    /* ==========================================
       DESIGN SYSTEM & VARIABLES
       ========================================== */
    :root {
      /* Dark Theme Variables (Vercel-like Default) */
      --bg-base: #000000;
      --bg-surface: #0a0a0a;
      --bg-surface-hover: #121212;
      --bg-glass: rgba(0, 0, 0, 0.7);
      --border-neutral: #262626;
      --border-hover: #404040;
      --accent-blue: #3b82f6;
      --accent-blue-rgb: 59, 130, 246;
      --accent-green: #22c55e;
      --accent-green-rgb: 34, 197, 94;
      --text-primary: #ffffff;
      --text-secondary: #888888;
      --text-tertiary: #525252;

      --button-primary-bg: #ffffff;
      --button-primary-text: #000000;
      --button-secondary-bg: transparent;
      --button-secondary-text: #ffffff;
      --button-secondary-border: #262626;
      --button-secondary-hover-bg: #0a0a0a;

      --grid-color: rgba(255, 255, 255, 0.025);
      --glow-opacity: 0.12;
      --card-shadow: rgba(0, 0, 0, 0.8);
      --badge-opacity: 0.03;
    }

    .light-theme {
      /* Light Theme Variables (Apple-like clean white/parchment) */
      --bg-base: #ffffff;
      --bg-surface: #f5f5f7;
      --bg-surface-hover: #eef2f6;
      --bg-glass: rgba(255, 255, 255, 0.75);
      --border-neutral: #e2e8f0;
      --border-hover: #cbd5e1;
      --accent-blue: #0066cc;
      --accent-blue-rgb: 0, 102, 204;
      --accent-green: #15803d;
      --accent-green-rgb: 21, 128, 61;
      --text-primary: #1d1d1f;
      --text-secondary: #6e6e73;
      --text-tertiary: #b4b4b8;

      --button-primary-bg: #1d1d1f;
      --button-primary-text: #ffffff;
      --button-secondary-bg: transparent;
      --button-secondary-text: #1d1d1f;
      --button-secondary-border: #cbd5e1;
      --button-secondary-hover-bg: #f5f5f7;

      --grid-color: rgba(0, 0, 0, 0.02);
      --glow-opacity: 0.06;
      --card-shadow: rgba(0, 0, 0, 0.04);
      --badge-opacity: 0.5;

      color-scheme: light;
    }

    /* ==========================================
       RESET & BASE STYLES
       ========================================== */
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    html {
      scroll-behavior: smooth;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      background-color: var(--bg-base);
      overflow-x: hidden;
      color-scheme: dark;
      scrollbar-width: thin;
      scrollbar-color: var(--border-neutral) var(--bg-base);
      transition: background-color 0.5s ease;
    }

    body {
      font-family: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
      background-color: var(--bg-base);
      color: var(--text-primary);
      overflow-x: hidden;
      position: relative;
      width: 100%;
      min-height: 100vh;
      transition: background-color 0.5s ease, color 0.5s ease;
      line-height: 1.5;
    }

    /* Custom scrollbars */
    ::-webkit-scrollbar {
      width: 10px;
      height: 10px;
    }

    ::-webkit-scrollbar-track {
      background: var(--bg-base);
      transition: background-color 0.5s ease;
    }

    ::-webkit-scrollbar-thumb {
      background: var(--border-neutral);
      border-radius: 9999px;
      border: 3px solid var(--bg-base);
      transition: background-color 0.5s ease, border-color 0.5s ease;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: var(--border-hover);
    }

    /* ==========================================
       BACKGROUND ELEMENTS
       ========================================== */
    .bg-grid {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-image:
        linear-gradient(to right, var(--grid-color) 1px, transparent 1px),
        linear-gradient(to bottom, var(--grid-color) 1px, transparent 1px);
      background-size: 50px 50px;
      /* Full width grid, fades out only at the bottom */
      mask-image: linear-gradient(to bottom, black 50%, transparent 98%);
      -webkit-mask-image: linear-gradient(to bottom, black 50%, transparent 98%);
      pointer-events: none;
      z-index: 0;
      transition: background-image 0.5s ease;
    }

    .bg-glow {
      position: fixed;
      width: 600px;
      height: 600px;
      border-radius: 50%;
      filter: blur(140px);
      opacity: var(--glow-opacity);
      pointer-events: none;
      z-index: 0;
      transition: background 0.5s ease, opacity 0.5s ease;
    }

    .bg-glow-1 {
      top: -200px;
      left: calc(50% - 300px);
      background: radial-gradient(circle, var(--accent-blue), transparent 70%);
    }

    .bg-glow-2 {
      bottom: -200px;
      right: 10%;
      background: radial-gradient(circle, var(--accent-green), transparent 70%);
    }

    .floating-elements {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      pointer-events: none;
      z-index: 1;
      overflow: hidden;
    }

    .floating-item {
      position: absolute;
      color: var(--text-tertiary);
      font-family: 'Courier New', Courier, monospace;
      font-size: 2.2rem;
      font-weight: 700;
      opacity: 0.2;
      user-select: none;
      animation: floatDrift 16s infinite ease-in-out alternate;
      transition: color 0.5s ease;
    }

    .floating-item.binary {
      font-size: 1.4rem;
      letter-spacing: 0.1em;
    }

    @keyframes floatDrift {
      0% {
        transform: translateY(0) rotate(0deg) scale(0.9);
      }

      50% {
        transform: translateY(-30px) rotate(5deg) scale(1);
      }

      100% {
        transform: translateY(-60px) rotate(15deg) scale(0.9);
      }
    }

    /* ==========================================
       HEADER & NAVIGATION
       ========================================== */
    .navbar {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      height: 64px;
      background: var(--bg-glass);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--border-neutral);
      z-index: 100;
      transition: background 0.5s ease, border-bottom 0.5s ease;
    }

    .navbar-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 max(24px, 4%);
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
      color: var(--text-primary);
      font-weight: 700;
      font-size: 1.25rem;
      letter-spacing: -0.03em;
      transition: color 0.5s ease;
    }

    .brand-logo {
      transition: transform 0.3s ease;
      color: var(--text-primary);
    }

    .brand:hover .brand-logo {
      transform: rotate(-5deg) scale(1.05);
    }

    .nav-menu {
      display: flex;
      align-items: center;
      gap: 28px;
    }

    .nav-link {
      color: var(--text-secondary);
      text-decoration: none;
      font-size: 0.95rem;
      font-weight: 500;
      transition: color 0.2s ease;
    }

    .nav-link:hover {
      color: var(--text-primary);
    }

    .nav-actions {
      display: flex;
      align-items: center;
      gap: 14px;
    }

    /* Buttons */
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 10px 20px;
      border-radius: 9999px;
      font-size: 0.9rem;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
      cursor: pointer;
    }

    .btn-primary {
      background: var(--button-primary-bg);
      color: var(--button-primary-text);
      border: 1px solid transparent;
    }

    .btn-primary:hover {
      transform: translateY(-1.5px);
      box-shadow: 0 8px 20px rgba(var(--accent-blue-rgb), 0.2);
    }

    .btn-secondary {
      background: var(--button-secondary-bg);
      color: var(--button-secondary-text);
      border: 1px solid var(--button-secondary-border);
    }

    .btn-secondary:hover {
      background: var(--button-secondary-hover-bg);
      border-color: var(--border-hover);
      transform: translateY(-1.5px);
    }

    /* Theme Toggle */
    .theme-toggle-btn {
      background: transparent;
      border: 1px solid var(--border-neutral);
      cursor: pointer;
      padding: 8px;
      border-radius: 8px;
      color: var(--text-primary);
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s ease;
      width: 38px;
      height: 38px;
      position: relative;
    }

    .theme-toggle-btn:hover {
      border-color: var(--border-hover);
      background: var(--bg-surface-hover);
    }

    .theme-toggle-btn svg {
      width: 18px;
      height: 18px;
      position: absolute;
      transition: transform 0.5s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.3s ease;
    }

    /* Theme toggling states */
    body:not(.light-theme) .sun-icon {
      opacity: 0;
      transform: rotate(90deg) scale(0);
    }

    body:not(.light-theme) .moon-icon {
      opacity: 1;
      transform: rotate(0) scale(1);
    }

    body.light-theme .sun-icon {
      opacity: 1;
      transform: rotate(0) scale(1);
    }

    body.light-theme .moon-icon {
      opacity: 0;
      transform: rotate(-90deg) scale(0);
    }

    .mobile-menu-toggle {
      display: none;
      flex-direction: column;
      gap: 5px;
      background: transparent;
      border: none;
      cursor: pointer;
      padding: 4px;
      z-index: 101;
    }

    .mobile-menu-toggle span {
      width: 22px;
      height: 2px;
      background: var(--text-primary);
      transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
      border-radius: 2px;
    }

    .mobile-menu-toggle.active span:nth-child(1) {
      transform: translateY(7px) rotate(45deg);
    }

    .mobile-menu-toggle.active span:nth-child(2) {
      opacity: 0;
    }

    .mobile-menu-toggle.active span:nth-child(3) {
      transform: translateY(-7px) rotate(-45deg);
    }

    .desktop-only {
      display: inline-flex;
    }

    .mobile-only {
      display: none;
    }

    .mobile-menu-ctas {
      display: none;
    }

    /* ==========================================
       HERO SECTION
       ========================================== */
    .hero-section {
      position: relative;
      min-height: calc(100vh - 64px);
      margin-top: 64px;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 80px 24px;
      z-index: 10;
    }

    .hero-container {
      max-width: 800px;
      text-align: center;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .hero-logo-wrapper {
      position: relative;
      margin-bottom: 32px;
    }

    .hero-logo {
      color: var(--text-primary);
      filter: drop-shadow(0 0 25px rgba(var(--accent-blue-rgb), 0.25));
      transition: transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .hero-logo-wrapper:hover .hero-logo {
      transform: scale(1.08) rotate(3deg);
    }

    .logo-glow {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 140px;
      height: 140px;
      background: radial-gradient(circle, rgba(var(--accent-blue-rgb), 0.2) 0%, transparent 70%);
      z-index: -1;
      filter: blur(15px);
    }

    .hero-title {
      font-size: 4.8rem;
      font-weight: 800;
      line-height: 1.05;
      letter-spacing: -0.04em;
      margin-bottom: 12px;
      background: linear-gradient(135deg, var(--text-primary) 30%, var(--accent-blue) 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .hero-subtitle {
      font-size: 1.8rem;
      font-weight: 600;
      letter-spacing: -0.02em;
      color: var(--accent-blue);
      margin-bottom: 24px;
      transition: color 0.5s ease;
    }

    .hero-description {
      font-size: 1.15rem;
      font-weight: 400;
      line-height: 1.6;
      color: var(--text-secondary);
      max-width: 620px;
      margin-bottom: 44px;
      transition: color 0.5s ease;
    }

    .hero-description span {
      color: var(--text-primary);
      font-weight: 600;
      border-bottom: 1px dashed var(--border-hover);
      padding-bottom: 1px;
    }

    .hero-ctas {
      display: flex;
      gap: 16px;
    }

    .hero-btn {
      padding: 14px 36px;
      font-size: 1rem;
    }

    /* ==========================================
       FEATURES SECTION
       ========================================== */
    .features-section {
      position: relative;
      padding: 100px 24px;
      z-index: 10;
      border-top: 1px solid var(--border-neutral);
      transition: border-top 0.5s ease;
    }

    .section-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 max(24px, 4%);
    }

    .section-header {
      text-align: center;
      margin-bottom: 64px;
    }

    .section-title {
      font-size: 2.6rem;
      font-weight: 800;
      letter-spacing: -0.03em;
      color: var(--text-primary);
      margin-bottom: 12px;
      transition: color 0.5s ease;
    }

    .section-subtitle {
      font-size: 1.1rem;
      color: var(--text-secondary);
      max-width: 500px;
      margin: 0 auto;
      transition: color 0.5s ease;
    }

    .features-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 32px;
    }

    .feature-card {
      position: relative;
      background-color: var(--bg-surface);
      border: 1px solid var(--border-neutral);
      border-radius: 16px;
      padding: 36px;
      overflow: hidden;
      transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
      box-shadow: 0 4px 30px var(--card-shadow);
      display: flex;
      flex-direction: column;
      align-items: flex-start;
    }

    .feature-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: radial-gradient(800px circle at var(--mouse-x, 0) var(--mouse-y, 0), rgba(255, 255, 255, 0.05), transparent 40%);
      z-index: 1;
      pointer-events: none;
      opacity: 0;
      transition: opacity 0.5s ease;
    }

    body.light-theme .feature-card::before {
      background: radial-gradient(800px circle at var(--mouse-x, 0) var(--mouse-y, 0), rgba(0, 0, 0, 0.02), transparent 45%);
    }

    .feature-card:hover::before {
      opacity: 1;
    }

    .feature-card:hover {
      transform: translateY(-6px);
      border-color: var(--border-hover);
      box-shadow: 0 16px 40px var(--card-shadow);
    }

    .icon-wrapper {
      width: 46px;
      height: 46px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 24px;
      position: relative;
      z-index: 2;
    }

    .blue-glow {
      background: rgba(var(--accent-blue-rgb), 0.08);
      color: var(--accent-blue);
      border: 1px solid rgba(var(--accent-blue-rgb), 0.15);
    }

    .green-glow {
      background: rgba(var(--accent-green-rgb), 0.08);
      color: var(--accent-green);
      border: 1px solid rgba(var(--accent-green-rgb), 0.15);
    }

    .card-title {
      font-size: 1.35rem;
      font-weight: 700;
      letter-spacing: -0.02em;
      color: var(--text-primary);
      margin-bottom: 12px;
      position: relative;
      z-index: 2;
      transition: color 0.5s ease;
    }

    .card-description {
      font-size: 0.95rem;
      line-height: 1.55;
      color: var(--text-secondary);
      position: relative;
      z-index: 2;
      transition: color 0.5s ease;
    }

    /* ==========================================
       TECHNOLOGY SECTION
       ========================================== */
    .tech-section {
      position: relative;
      padding: 100px 24px;
      z-index: 10;
      border-top: 1px solid var(--border-neutral);
      transition: border-top 0.5s ease;
    }

    .tech-grid {
      display: grid;
      grid-template-columns: repeat(6, 1fr);
      gap: 20px;
    }

    .tech-badge {
      background-color: var(--bg-surface);
      border: 1px solid var(--border-neutral);
      border-radius: 14px;
      padding: 24px 16px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 14px;
      transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
      box-shadow: 0 4px 20px var(--card-shadow);
      cursor: default;
    }

    .tech-badge:hover {
      transform: translateY(-4px) scale(1.03);
      border-color: var(--border-hover);
      box-shadow: 0 10px 30px var(--card-shadow);
    }

    .tech-icon {
      color: var(--text-primary);
      transition: transform 0.3s ease, color 0.5s ease;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .tech-badge:hover .tech-icon {
      transform: rotate(5deg) scale(1.08);
    }

    .tech-name {
      font-size: 0.9rem;
      font-weight: 600;
      color: var(--text-secondary);
      transition: color 0.3s ease;
    }

    .tech-badge:hover .tech-name {
      color: var(--text-primary);
    }

    /* ==========================================
       FOOTER
       ========================================== */
    .footer {
      background-color: var(--bg-surface);
      border-top: 1px solid var(--border-neutral);
      padding: 64px 24px;
      position: relative;
      z-index: 10;
      transition: background-color 0.5s ease, border-top 0.5s ease;
    }

    .footer-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 max(24px, 4%);
    }

    .footer-info {
      display: flex;
      flex-direction: column;
      align-items: center;
      margin-bottom: 40px;
      text-align: center;
    }

    .footer-brand {
      display: flex;
      align-items: center;
      gap: 8px;
      font-weight: 700;
      font-size: 1.15rem;
      color: var(--text-primary);
      margin-bottom: 12px;
      transition: color 0.5s ease;
    }

    .project-tagline {
      font-size: 0.85rem;
      font-weight: 700;
      color: var(--accent-blue);
      margin-bottom: 6px;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      transition: color 0.5s ease;
    }

    .developer-credit {
      font-size: 0.95rem;
      color: var(--text-secondary);
      transition: color 0.5s ease;
    }

    .developer-credit span {
      color: var(--text-primary);
      font-weight: 600;
    }

    .footer-bottom {
      border-top: 1px solid var(--border-neutral);
      padding-top: 24px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      transition: border-top 0.5s ease;
    }

    .copyright {
      font-size: 0.85rem;
      color: var(--text-tertiary);
      transition: color 0.5s ease;
    }

    .social-links {
      display: flex;
      gap: 16px;
    }

    .social-link {
      color: var(--text-secondary);
      transition: color 0.2s ease, transform 0.2s ease;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .social-link:hover {
      color: var(--text-primary);
      transform: translateY(-2px);
    }

    /* ==========================================
       ANIMATIONS & TRANSITIONS
       ========================================== */
    .fade-in {
      opacity: 0;
      transform: translateY(20px);
      transition: opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1), transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .fade-in.visible {
      opacity: 1;
      transform: translateY(0);
    }

    .delay-1 {
      transition-delay: 0.1s;
    }

    .delay-2 {
      transition-delay: 0.2s;
    }

    .delay-3 {
      transition-delay: 0.3s;
    }

    .delay-4 {
      transition-delay: 0.4s;
    }

    /* ==========================================
       RESPONSIVE MEDIA QUERIES
       ========================================== */
    @media (max-width: 1024px) {
      .tech-grid {
        grid-template-columns: repeat(3, 1fr);
        gap: 16px;
      }
    }

    @media (max-width: 834px) {
      .desktop-only {
        display: none;
      }

      .mobile-only {
        display: inline-flex;
        width: 100%;
      }

      .mobile-menu-toggle {
        display: flex;
      }

      .nav-menu {
        position: fixed;
        top: 64px;
        left: 0;
        right: 0;
        background: var(--bg-glass);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-bottom: 1px solid var(--border-neutral);
        flex-direction: column;
        padding: 32px 24px;
        gap: 24px;
        transform: translateY(-150%);
        transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        z-index: 99;
        align-items: flex-start;
      }

      .nav-menu.active {
        transform: translateY(0);
      }

      .mobile-menu-ctas {
        display: flex;
        flex-direction: column;
        gap: 12px;
        width: 100%;
        margin-top: 16px;
        border-top: 1px solid var(--border-neutral);
        padding-top: 24px;
      }

      .features-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
      }

      .hero-title {
        font-size: 3.8rem;
      }

      .hero-subtitle {
        font-size: 1.5rem;
      }
    }

    @media (max-width: 640px) {
      .features-grid {
        grid-template-columns: 1fr;
      }

      .tech-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      .hero-title {
        font-size: 3.2rem;
      }

      .hero-subtitle {
        font-size: 1.3rem;
        margin-bottom: 16px;
      }

      .hero-description {
        font-size: 1rem;
        margin-bottom: 32px;
      }

      .hero-ctas {
        flex-direction: column;
        width: 100%;
        max-width: 300px;
        gap: 12px;
      }

      .btn {
        width: 100%;
        padding: 12px 20px;
      }

      .footer-bottom {
        flex-direction: column;
        gap: 16px;
        text-align: center;
      }
    }
  </style>
</head>

<body>

  <!-- Background high-tech grids and glowing lights -->
  <div class="bg-grid"></div>
  <div class="bg-glow bg-glow-1"></div>
  <div class="bg-glow bg-glow-2"></div>

  <!-- Drifting programming symbols to create a coding ambient -->
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
      <a href="#" class="brand">
        <!-- Logo SVG: Shield (Vault) containing terminal chevron and slash -->
        <svg class="brand-logo" width="32" height="32" viewBox="0 0 40 40" fill="none"
          xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor"
            stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round"
            stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round"
            stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
        <span class="brand-name">CodeVault</span>
      </a>

      <nav class="nav-menu">
        <a href="#features" class="nav-link">Features</a>
        <a href="#technologies" class="nav-link">Stack</a>

        <!-- Mobile Navigation CTAs -->
        <div class="mobile-menu-ctas">
          <a href="login.jsp" class="btn btn-primary mobile-only">Login</a>
          <a href="register.jsp" class="btn btn-secondary mobile-only">Register</a>
        </div>
      </nav>

      <div class="nav-actions">
        <!-- Sun/Moon Theme Toggle Button -->
        <button id="theme-toggle" class="theme-toggle-btn" aria-label="Toggle Theme">
          <svg class="sun-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="4"></circle>
            <path
              d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41">
            </path>
          </svg>
          <svg class="moon-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"></path>
          </svg>
        </button>

        <!-- Desktop Navigation CTAs -->
        <a href="login.jsp" class="btn btn-primary nav-btn desktop-only">Login</a>
        <a href="register.jsp" class="btn btn-secondary nav-btn desktop-only">Register</a>

        <!-- Mobile Menu Toggle Burger -->
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
  <section class="hero-section">
    <div class="hero-container">
      <div class="hero-logo-wrapper fade-in">
        <svg class="hero-logo" width="84" height="84" viewBox="0 0 40 40" fill="none"
          xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor"
            stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round"
            stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round"
            stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
        <div class="logo-glow"></div>
      </div>

      <h1 class="hero-title fade-in delay-1">CodeVault</h1>
      <h2 class="hero-subtitle fade-in delay-2">Personal Code Snippet Manager</h2>

      <p class="hero-description fade-in delay-3">
        Store, organize and manage your programming snippets securely in one place. <br class="desktop-only">
        Built with enterprise-ready <span>JSP</span>, <span>Servlets</span>, <span>JDBC</span>, and <span>MySQL</span>.
      </p>

      <div class="hero-ctas fade-in delay-4">
        <a href="login.jsp" class="btn btn-primary hero-btn">Login</a>
        <a href="register.jsp" class="btn btn-secondary hero-btn">Register</a>
      </div>
    </div>
  </section>

  <!-- ==========================================
       FEATURES SECTION
       ========================================== -->
  <section id="features" class="features-section">
    <div class="section-container">
      <div class="section-header fade-in">
        <h2 class="section-title">Product Features</h2>
        <p class="section-subtitle">A modern toolkit optimized for developers to secure and organize their codebase.</p>
      </div>

      <div class="features-grid">
        <!-- Feature 1: Store Snippets -->
        <div class="feature-card fade-in delay-1">
          <div class="icon-wrapper blue-glow">
            <!-- Database Icon SVG -->
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
              <path d="M3 5V19A9 3 0 0 0 21 19V5"></path>
              <path d="M3 12A9 3 0 0 0 21 12"></path>
            </svg>
          </div>
          <h3 class="card-title">Store Snippets</h3>
          <p class="card-description">Save programming snippets safely. Keep your algorithms, templates, and
            configurations cataloged securely.</p>
        </div>

        <!-- Feature 2: Manage Code -->
        <div class="feature-card fade-in delay-2">
          <div class="icon-wrapper green-glow">
            <!-- Folder Icon SVG -->
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <path
                d="M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z">
              </path>
            </svg>
          </div>
          <h3 class="card-title">Manage Code</h3>
          <p class="card-description">Edit and organize snippets anytime. Update code real-time, structure folders, and
            tag solutions.</p>
        </div>

        <!-- Feature 3: Fast Access -->
        <div class="feature-card fade-in delay-3">
          <div class="icon-wrapper blue-glow">
            <!-- Lightning Icon SVG -->
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
            </svg>
          </div>
          <h3 class="card-title">Fast Access</h3>
          <p class="card-description">Quickly retrieve your saved code. Locate snippets in milliseconds with
            index-optimized searching mechanics.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ==========================================
       TECHNOLOGY SECTION
       ========================================== -->
  <section id="technologies" class="tech-section">
    <div class="section-container">
      <div class="section-header fade-in">
        <h2 class="section-title">Built On Robust Architecture</h2>
        <p class="section-subtitle">Engineered on high-performance Java web specifications and standard systems.</p>
      </div>

      <div class="tech-grid fade-in delay-2">
        <!-- Java -->
        <div class="tech-badge">
          <div class="tech-icon">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
              stroke-linecap="round" stroke-linejoin="round">
              <path d="M6 15c0 1.5 1.5 3 3 3h4c2 0 3.5-1 3.5-3v-4H6v4Z"></path>
              <path d="M16.5 11h1c1 0 1.5.5 1.5 1.5s-.5 1.5-1.5 1.5h-1"></path>
              <path d="M9 18v2c0 .5.5 1 1 1h2c.5 0 1-.5 1-1v-2"></path>
              <path d="M10 6c0-2 2-2 2-4m-4 4c0-2 2-2 2-4m4 4c0-2 2-2 2-4" stroke="var(--accent-blue)"></path>
            </svg>
          </div>
          <span class="tech-name">Java</span>
        </div>

        <!-- JSP -->
        <div class="tech-badge">
          <div class="tech-icon">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
              stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
              <path d="M8 13l-2 2 2 2" stroke="var(--accent-green)"></path>
              <path d="M12 13l2 2-2 2" stroke="var(--accent-green)"></path>
              <line x1="11" y1="13" x2="9" y2="17" stroke="var(--accent-green)"></line>
            </svg>
          </div>
          <span class="tech-name">JSP</span>
        </div>

        <!-- Servlets -->
        <div class="tech-badge">
          <div class="tech-icon">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
              stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
              <line x1="8" y1="21" x2="16" y2="21"></line>
              <line x1="12" y1="17" x2="12" y2="21"></line>
              <circle cx="12" cy="10" r="3" stroke="var(--accent-blue)"></circle>
              <path d="M12 7v1m0 4v1" stroke="var(--accent-blue)"></path>
            </svg>
          </div>
          <span class="tech-name">Servlets</span>
        </div>

        <!-- JDBC -->
        <div class="tech-badge">
          <div class="tech-icon">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
              stroke-linecap="round" stroke-linejoin="round">
              <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
              <path d="M3 5v14a9 3 0 0 0 18 0V5"></path>
              <path d="M3 12a9 3 0 0 0 18 0"></path>
              <path d="M18 12h-4m-2 0H8" stroke="var(--accent-green)" stroke-width="2"></path>
            </svg>
          </div>
          <span class="tech-name">JDBC</span>
        </div>

        <!-- MySQL -->
        <div class="tech-badge">
          <div class="tech-icon">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
              stroke-linecap="round" stroke-linejoin="round">
              <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
              <path d="M3 5v6a9 3 0 0 0 18 0V5" stroke="var(--accent-blue)"></path>
              <path d="M3 11v6a9 3 0 0 0 18 0v-6"></path>
              <path d="M12 8v6"></path>
              <circle cx="12" cy="14" r="1.5" fill="var(--accent-blue)" stroke="none"></circle>
            </svg>
          </div>
          <span class="tech-name">MySQL</span>
        </div>

        <!-- Apache Tomcat -->
        <div class="tech-badge">
          <div class="tech-icon">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
              stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"></circle>
              <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"
                stroke="var(--accent-green)"></path>
              <path d="M2 12h20"></path>
            </svg>
          </div>
          <span class="tech-name">Tomcat</span>
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
            <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor"
              stroke-width="2.5" stroke-linejoin="round" />
            <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round"
              stroke-linejoin="round" />
            <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round"
              stroke-linejoin="round" />
            <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
          </svg>
          <span>CodeVault</span>
        </div>
      </div>

      <div class="footer-bottom">
        <p class="copyright">&copy; 2026 CodeVault. All rights reserved.</p>
        <div class="social-links">
          <!-- GitHub -->
          <a href="https://github.com/aviixek/" target="_blank" rel="noopener noreferrer" aria-label="GitHub"
            class="social-link">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <path
                d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22">
              </path>
            </svg>
          </a>
        </div>
      </div>
    </div>
  </footer>

  <!-- ==========================================
       SCRIPTS & DYNAMIC LIGHTWEIGHT EFFECTS
       ========================================== -->
  <script>
    // 1. Theme Toggle Mechanic
    const themeToggleBtn = document.getElementById('theme-toggle');

    // Check local storage or system preference
    const savedTheme = localStorage.getItem('theme');
    const prefersLight = window.matchMedia('(prefers-color-scheme: light)').matches;

    if (savedTheme === 'light' || (!savedTheme && prefersLight)) {
      document.documentElement.classList.add('light-theme');
      document.body.classList.add('light-theme');
    }

    themeToggleBtn.addEventListener('click', () => {
      document.documentElement.classList.toggle('light-theme');
      document.body.classList.toggle('light-theme');
      const isLight = document.documentElement.classList.contains('light-theme');
      localStorage.setItem('theme', isLight ? 'light' : 'dark');
    });

    // 2. Mobile Menu Toggle Mechanic
    const mobileMenuToggle = document.getElementById('mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');

    mobileMenuToggle.addEventListener('click', () => {
      mobileMenuToggle.classList.toggle('active');
      navMenu.classList.toggle('active');
    });

    // Close menu when clicking links
    document.querySelectorAll('.nav-link').forEach(link => {
      link.addEventListener('click', () => {
        mobileMenuToggle.classList.remove('active');
        navMenu.classList.remove('active');
      });
    });

    // 3. Mouse spotlight tracking on feature cards
    document.querySelectorAll('.feature-card').forEach(card => {
      card.addEventListener('mousemove', e => {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        card.style.setProperty('--mouse-x', `${x}px`);
        card.style.setProperty('--mouse-y', `${y}px`);
      });
    });

    // 4. Scroll Animation Observer (Fade-In Trigger)
    const observerOptions = {
      root: null,
      rootMargin: '0px',
      threshold: 0.1
    };

    const scrollObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
        }
      });
    }, observerOptions);

    document.querySelectorAll('.fade-in').forEach(element => {
      scrollObserver.observe(element);
    });
  </script>
</body>

</html>