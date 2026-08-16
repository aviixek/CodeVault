/**
 * CodeVault — Client Side Interactions
 */
document.addEventListener('DOMContentLoaded', () => {
    // 1. Theme Management (Local Storage + System Preference)
    const themeToggleBtn = document.getElementById('theme-toggle');
    const savedTheme = localStorage.getItem('theme');
    const prefersLight = window.matchMedia('(prefers-color-scheme: light)').matches;

    if (savedTheme === 'light' || (!savedTheme && prefersLight)) {
        document.documentElement.classList.add('light-theme');
        document.body.classList.add('light-theme');
    }

    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', () => {
            document.documentElement.classList.toggle('light-theme');
            document.body.classList.toggle('light-theme');
            const isLight = document.documentElement.classList.contains('light-theme');
            localStorage.setItem('theme', isLight ? 'light' : 'dark');
        });
    }

    // 2. Mobile Menu Toggle
    const mobileMenuToggle = document.getElementById('mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');

    if (mobileMenuToggle && navMenu) {
        mobileMenuToggle.addEventListener('click', () => {
            mobileMenuToggle.classList.toggle('active');
            navMenu.classList.toggle('active');
        });

        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                mobileMenuToggle.classList.remove('active');
                navMenu.classList.remove('active');
            });
        });
    }

    // 3. Mouse spotlight tracking on glass cards
    document.querySelectorAll('.glass-card, .feature-card, .snippet-card, .auth-card, .editor-card').forEach(card => {
        card.addEventListener('mousemove', e => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            card.style.setProperty('--mouse-x', `${x}px`);
            card.style.setProperty('--mouse-y', `${y}px`);
        });
    });

    // 4. Scroll Animation Observer
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

    // 5. Password Visibility Toggle (for Auth pages)
    const passwordToggle = document.getElementById('passwordToggle');
    const passwordInput = document.getElementById('password');
    if (passwordToggle && passwordInput) {
        passwordToggle.addEventListener('click', () => {
            const isPassword = passwordInput.getAttribute('type') === 'password';
            passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
        });
    }

    // 6. Copy Code Button logic (for Dashboard snippet cards)
    document.querySelectorAll('.copy-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const parent = btn.closest('.code-preview');
            if (parent) {
                const textarea = parent.querySelector('.full-code');
                const tooltip = parent.querySelector('.copy-tooltip');
                if (textarea) {
                    navigator.clipboard.writeText(textarea.value).then(() => {
                        if (tooltip) {
                            tooltip.classList.add('show');
                            setTimeout(() => {
                                tooltip.classList.remove('show');
                            }, 2000);
                        }
                    });
                }
            }
        });
    });

    // 7. Instant Search Filter (on Dashboard)
    const searchInput = document.getElementById('searchInput');
    const snippetCards = document.querySelectorAll('.snippet-card');
    const searchStatus = document.getElementById('searchStatus');

    if (searchInput && snippetCards.length > 0) {
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase().trim();
            let visibleCount = 0;

            snippetCards.forEach(card => {
                const title = (card.getAttribute('data-title') || '').toLowerCase();
                const description = (card.getAttribute('data-description') || '').toLowerCase();
                const language = (card.getAttribute('data-language') || '').toLowerCase();

                if (title.includes(query) || description.includes(query) || language.includes(query)) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            if (searchStatus) {
                if (query.length > 0) {
                    searchStatus.textContent = `Showing ${visibleCount} matching snippet${visibleCount === 1 ? '' : 's'}`;
                } else {
                    searchStatus.textContent = '';
                }
            }
        });
    }
});
