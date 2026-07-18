<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login | CodeVault</title>
  
  <!-- Plus Jakarta Sans for premium modern SaaS typography -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  
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
      position: relative;
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

    .desktop-only { display: inline-flex; }
    .mobile-only { display: none; }
    .mobile-menu-ctas { display: none; }

    /* ==========================================
       CONTAINERS & COMMON ELEMENTS
       ========================================== */
    .app-main {
      min-height: calc(100vh - 64px);
      margin-top: 64px;
      padding: 48px max(24px, 4%);
      position: relative;
      z-index: 10;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .glass-card {
      background-color: var(--bg-surface);
      border: 1px solid var(--border-neutral);
      border-radius: 16px;
      padding: 40px;
      box-shadow: 0 4px 30px var(--card-shadow);
      width: 100%;
      position: relative;
      overflow: hidden;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    .glass-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: radial-gradient(800px circle at var(--mouse-x, 0) var(--mouse-y, 0), rgba(255, 255, 255, 0.04), transparent 40%);
      z-index: 1;
      pointer-events: none;
      opacity: 0;
      transition: opacity 0.5s ease;
    }

    body.light-theme .glass-card::before {
      background: radial-gradient(800px circle at var(--mouse-x, 0) var(--mouse-y, 0), rgba(0, 0, 0, 0.015), transparent 40%);
    }

    .glass-card:hover::before {
      opacity: 1;
    }

    .glass-card:hover {
      border-color: var(--border-hover);
    }

    /* Form Fields */
    .form-group {
      margin-bottom: 24px;
      width: 100%;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .form-label {
      font-size: 0.9rem;
      font-weight: 600;
      color: var(--text-primary);
      letter-spacing: -0.01em;
    }

    .form-control {
      background: rgba(255, 255, 255, 0.02);
      border: 1px solid var(--border-neutral);
      border-radius: 8px;
      padding: 12px 16px;
      color: var(--text-primary);
      font-family: inherit;
      font-size: 0.95rem;
      transition: all 0.2s ease;
      width: 100%;
    }

    body.light-theme .form-control {
      background: rgba(0, 0, 0, 0.01);
    }

    .form-control:focus {
      outline: none;
      border-color: var(--accent-blue);
      box-shadow: 0 0 0 2px rgba(var(--accent-blue-rgb), 0.15);
      background: rgba(255, 255, 255, 0.04);
    }

    .input-wrapper {
      position: relative;
      width: 100%;
    }

    .input-icon-right {
      position: absolute;
      right: 14px;
      top: 50%;
      transform: translateY(-50%);
      background: transparent;
      border: none;
      color: var(--text-secondary);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: color 0.2s ease;
    }

    .input-icon-right:hover {
      color: var(--text-primary);
    }

    /* Alerts */
    .banner-error {
      background: rgba(239, 68, 68, 0.1);
      border: 1px solid rgba(239, 68, 68, 0.2);
      border-radius: 8px;
      color: #f87171;
      padding: 12px 16px;
      font-size: 0.9rem;
      font-weight: 500;
      width: 100%;
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .banner-success {
      background: rgba(34, 197, 94, 0.1);
      border: 1px solid rgba(34, 197, 94, 0.2);
      border-radius: 8px;
      color: #4ade80;
      padding: 12px 16px;
      font-size: 0.9rem;
      font-weight: 500;
      width: 100%;
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .fade-in {
      opacity: 0;
      transform: translateY(16px);
      animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }

    .delay-1 { transition-delay: 0.1s; }
    .delay-2 { transition-delay: 0.2s; }

    @keyframes fadeInUp {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* ==========================================
       PAGE SPECIFIC STYLES
       ========================================== */
    .auth-main {
      justify-content: center;
      align-items: center;
      padding-top: 80px;
      padding-bottom: 80px;
    }
    
    .auth-card {
      max-width: 440px;
      width: 100%;
      margin: 0 auto;
      border-radius: 20px;
      background: rgba(10, 10, 10, 0.4);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border: 1px solid var(--border-neutral);
      box-shadow: 0 8px 32px var(--card-shadow);
    }

    body.light-theme .auth-card {
      background: rgba(255, 255, 255, 0.65);
      border-color: var(--border-neutral);
    }
    
    .auth-header {
      text-align: center;
      margin-bottom: 32px;
    }
    
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: var(--text-secondary);
      text-decoration: none;
      font-size: 0.9rem;
      font-weight: 600;
      margin-bottom: 24px;
      align-self: flex-start;
      transition: color 0.2s ease, transform 0.2s ease;
    }
    
    .back-link:hover {
      color: var(--text-primary);
      transform: translateX(-3px);
    }
    
    .auth-logo {
      color: var(--text-primary);
      filter: drop-shadow(0 0 15px rgba(var(--accent-blue-rgb), 0.2));
      margin-bottom: 16px;
    }
    
    .auth-title {
      font-size: 2rem;
      font-weight: 800;
      letter-spacing: -0.03em;
      background: linear-gradient(135deg, var(--text-primary) 30%, var(--accent-blue) 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin-bottom: 6px;
    }
    
    .auth-subtitle {
      font-size: 0.95rem;
      color: var(--text-secondary);
    }
    
    .forgot-link {
      font-size: 0.85rem;
      color: var(--accent-blue);
      text-decoration: none;
      display: inline-block;
      font-weight: 500;
      transition: opacity 0.2s ease;
    }
    
    .forgot-link:hover {
      text-decoration: underline;
    }
    
    .btn-auth {
      width: 100%;
      padding: 12px 24px;
      font-size: 0.95rem;
      font-weight: 700;
      position: relative;
    }
    
    .auth-footer-text {
      margin-top: 24px;
      text-align: center;
      font-size: 0.9rem;
      color: var(--text-secondary);
    }
    
    .auth-footer-text a {
      color: var(--text-primary);
      text-decoration: none;
      font-weight: 700;
    }
    
    .auth-footer-text a:hover {
      text-decoration: underline;
    }

    /* Spinner Logic */
    .spinner {
      display: none;
      width: 18px;
      height: 18px;
      border: 2px solid currentColor;
      border-top-color: transparent;
      border-radius: 50%;
      position: absolute;
      top: calc(50% - 9px);
      left: calc(50% - 9px);
      animation: spin 0.8s linear infinite;
    }
    
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    
    .btn.loading .btn-text {
      opacity: 0;
    }
    
    .btn.loading .spinner {
      display: inline-block;
    }

    /* Footer Styling */
    .footer {
      background-color: var(--bg-surface);
      border-top: 1px solid var(--border-neutral);
      padding: 64px 24px;
      position: relative;
      z-index: 10;
      width: 100%;
      transition: background-color 0.5s ease, border-top 0.5s ease;
    }

    .footer-container {
      max-width: 1400px;
      margin: 0 auto;
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
       RESPONSIVE CONFIGS
       ========================================== */
    @media (max-width: 834px) {
      .desktop-only { display: none; }
      .mobile-only { display: inline-flex; width: 100%; }
      .mobile-menu-toggle { display: flex; }
      
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

      .app-main {
        padding: 32px 24px;
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
    <div class="floating-item" style="top: 12%; left: 6%; animation-delay: 0s;">{ }</div>
    <div class="floating-item" style="top: 25%; right: 8%; animation-delay: 2s;">&lt;/&gt;</div>
    <div class="floating-item" style="top: 60%; left: 5%; animation-delay: 4s;">( )</div>
    <div class="floating-item" style="top: 78%; right: 10%; animation-delay: 1s;">&lt; &gt;</div>
    <div class="floating-item binary" style="top: 40%; left: 88%; animation-delay: 3s;">1010</div>
    <div class="floating-item binary" style="top: 80%; left: 12%; animation-delay: 5s;">0101</div>
  </div>

  <!-- ==========================================
       GLOBAL NAVBAR (GUEST STATE)
       ========================================== -->
  <header class="navbar">
    <div class="navbar-container">
      <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
        <!-- Logo SVG -->
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
        
        <!-- Mobile Navigation CTAs -->
        <div class="mobile-menu-ctas">
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary mobile-only">Login</a>
          <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary mobile-only" style="margin-top: 8px;">Register</a>
        </div>
      </nav>
      
      <div class="nav-actions">
        <!-- Sun/Moon Theme Toggle Button -->
        <button id="theme-toggle" class="theme-toggle-btn" aria-label="Toggle Theme">
          <svg class="sun-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="4"></circle>
            <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"></path>
          </svg>
          <svg class="moon-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"></path>
          </svg>
        </button>
        
        <!-- Desktop Authentication CTAs -->
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary nav-btn desktop-only" style="border-color: var(--accent-blue);">Login</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary nav-btn desktop-only">Register</a>
        
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
       MAIN CONTENT
       ========================================== -->
  <main class="app-main auth-main">
    
    <div class="glass-card auth-card fade-in delay-1">
      <div class="auth-header">
        <svg class="auth-logo" width="48" height="48" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M20 4L32 9V19C32 26.5 27 33.5 20 36C13 33.5 8 26.5 8 19V9L20 4Z" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round" fill="rgba(255,255,255,0.02)" />
          <path d="M15 16L11 20L15 24" stroke="var(--accent-blue)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M25 16L29 20L25 24" stroke="var(--accent-green)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M18 25L22 15" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
        </svg>
        <h2 class="auth-title">Welcome Back</h2>
        <p class="auth-subtitle">Access your personal snippet vault</p>
      </div>
      
      <!-- JSTL Error Alert -->
      <c:if test="${not empty error}">
        <div class="banner-error">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="8" x2="12" y2="12"></line>
            <line x1="12" y1="16" x2="12.01" y2="16"></line>
          </svg>
          <span>${error}</span>
        </div>
      </c:if>
      

      <c:if test="${not empty message}">
        <div class="banner-success">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
            <polyline points="22 4 12 14.01 9 11.01"></polyline>
          </svg>
          <span>${message}</span>
        </div>
      </c:if>
      
      <form action="${pageContext.request.contextPath}/LoginServlet" method="post" id="loginForm">
        <div class="form-group">
          <label class="form-label" for="username">Username or Email</label>
          <input class="form-control" type="text" id="username" name="username" placeholder="test@example.com" required />
        </div>
        
        <div class="form-group" style="margin-bottom: 16px;">
          <label class="form-label" for="password">Password</label>
          <div class="input-wrapper">
            <input class="form-control" type="password" id="password" name="password" placeholder="••••••••" required />
            <button type="button" class="input-icon-right" id="passwordToggle" aria-label="Toggle Password Visibility">
              <svg id="eyeIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
            </button>
          </div>
        </div>
        
          <div style="margin-top: 10px; margin-bottom: 28px; text-align: left; width: 100%;">
          <a href="#" class="forgot-link" onclick="alert('Password reset link is UI-only for this demonstration.'); return false;">Forgot password?</a>
        </div>
        <button class="btn btn-primary btn-auth" type="submit" id="submitBtn">
          <span class="btn-text">Sign In</span>
          <span class="spinner"></span>
        </button>
      </form>
      
      <div class="auth-footer-text">
        Don't have an account? 
        <a href="${pageContext.request.contextPath}/register.jsp">Register Here</a>
      </div>
    </div>
  </main>

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
       SCRIPTS
       ========================================== -->
  <script>
    // 1. Theme Toggle
    const themeToggleBtn = document.getElementById('theme-toggle');
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

    // 2. Mobile Menu Toggle
    const mobileMenuToggle = document.getElementById('mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (mobileMenuToggle && navMenu) {
      mobileMenuToggle.addEventListener('click', () => {
        mobileMenuToggle.classList.toggle('active');
        navMenu.classList.toggle('active');
      });
    }

    // 3. Mouse spotlight tracking on glass cards
    document.querySelectorAll('.glass-card').forEach(card => {
      card.addEventListener('mousemove', e => {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        card.style.setProperty('--mouse-x', `${x}px`);
        card.style.setProperty('--mouse-y', `${y}px`);
      });
    });

    // 4. Password Visibility Toggle Logic
    const passwordInput = document.getElementById('password');
    const passwordToggle = document.getElementById('passwordToggle');
    const eyeIcon = document.getElementById('eyeIcon');
    
    passwordToggle.addEventListener('click', () => {
      const isPassword = passwordInput.getAttribute('type') === 'password';
      passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
      
      if (isPassword) {
        eyeIcon.innerHTML = `
          <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
          <line x1="1" y1="1" x2="23" y2="23"></line>
        `;
      } else {
        eyeIcon.innerHTML = `
          <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
          <circle cx="12" cy="12" r="3"></circle>
        `;
      }
    });

    // 5. Submit Form Loading State Trigger
    const loginForm = document.getElementById('loginForm');
    const submitBtn = document.getElementById('submitBtn');
    
    form.addEventListener("submit", function () {

        submitBtn.disabled = true;
        submitBtn.classList.add("loading");

        setTimeout(() => {
            submitBtn.disabled = false;
            submitBtn.classList.remove("loading");
        }, 3000);

    });

    // 6. Scroll Animation Observer
    const scrollObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
        }
      });
    }, { rootMargin: '0px', threshold: 0.1 });

    document.querySelectorAll('.fade-in').forEach(element => {
      scrollObserver.observe(element);
    });
  </script>
</body>
</html>
