// =====================================================
// ThronesWiki - Main Application JavaScript
// =====================================================

document.addEventListener('DOMContentLoaded', function() {
    // Initialize all components
    initializeNavigation();
    initializeSearch();
    initializeAnimations();
    initializeSmoothScroll();
});

// =====================================================
// Navigation
// =====================================================
function initializeNavigation() {
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const navLinks = document.querySelector('.nav-links');
    const navAuth = document.querySelector('.nav-auth');
    const navbar = document.querySelector('.navbar');

    // Mobile menu toggle
    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', function() {
            navLinks.classList.toggle('mobile-active');
            navAuth.classList.toggle('mobile-active');
            this.textContent = navLinks.classList.contains('mobile-active') ? '✕' : '☰';
        });
    }

    // Navbar background on scroll
    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // Active link highlighting
    const sections = document.querySelectorAll('section[id]');
    const navItems = document.querySelectorAll('.nav-links a');

    window.addEventListener('scroll', function() {
        let current = '';
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop - 100;
            const sectionHeight = section.offsetHeight;
            
            if (window.scrollY >= sectionTop && window.scrollY < sectionTop + sectionHeight) {
                current = section.getAttribute('id');
            }
        });

        navItems.forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('href').includes(current)) {
                item.classList.add('active');
            }
        });
    });
}

// =====================================================
// Search Functionality
// =====================================================
function initializeSearch() {
    const searchInput = document.querySelector('.search-input');
    const searchBtn = document.querySelector('.search-btn');

    if (searchInput && searchBtn) {
        // Search on button click
        searchBtn.addEventListener('click', performSearch);

        // Search on Enter key
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch();
            }
        });

        // Search suggestions (placeholder for backend integration)
        searchInput.addEventListener('input', debounce(function() {
            const query = this.value.trim();
            if (query.length >= 2) {
                // fetchSearchSuggestions(query);
                console.log('Search suggestions for:', query);
            }
        }, 300));
    }
}

function performSearch() {
    const searchInput = document.querySelector('.search-input');
    const query = searchInput.value.trim();

    if (query) {
        // In production, this would redirect to search results page
        // window.location.href = `/search?q=${encodeURIComponent(query)}`;
        console.log('Searching for:', query);
        alert(`"${query}" için arama yapılıyor...\n\n(Bu özellik backend entegrasyonu ile çalışacaktır)`);
    }
}

// Debounce function for search suggestions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func.apply(this, args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// =====================================================
// Animations
// =====================================================
function initializeAnimations() {
    // Intersection Observer for scroll animations
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Observe elements for animation
    const animatedElements = document.querySelectorAll(
        '.featured-card, .character-card, .house-card, .article-item, .stat-item'
    );

    animatedElements.forEach(el => {
        el.classList.add('animate-ready');
        observer.observe(el);
    });

    // Counter animation for stats
    animateCounters();
}

function animateCounters() {
    const counters = document.querySelectorAll('.stat-number');
    
    const counterObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const counter = entry.target;
                const target = parseInt(counter.textContent.replace(/,/g, ''));
                animateNumber(counter, 0, target, 2000);
                counterObserver.unobserve(counter);
            }
        });
    }, { threshold: 0.5 });

    counters.forEach(counter => counterObserver.observe(counter));
}

function animateNumber(element, start, end, duration) {
    const startTime = performance.now();
    
    function update(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        // Easing function
        const easeOutQuart = 1 - Math.pow(1 - progress, 4);
        const current = Math.floor(start + (end - start) * easeOutQuart);
        
        element.textContent = current.toLocaleString('tr-TR');
        
        if (progress < 1) {
            requestAnimationFrame(update);
        }
    }
    
    requestAnimationFrame(update);
}

// =====================================================
// Smooth Scroll
// =====================================================
function initializeSmoothScroll() {
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            
            if (href !== '#') {
                e.preventDefault();
                
                const target = document.querySelector(href);
                if (target) {
                    const navbarHeight = document.querySelector('.navbar').offsetHeight;
                    const targetPosition = target.offsetTop - navbarHeight - 20;
                    
                    window.scrollTo({
                        top: targetPosition,
                        behavior: 'smooth'
                    });

                    // Close mobile menu if open
                    const navLinks = document.querySelector('.nav-links');
                    if (navLinks.classList.contains('mobile-active')) {
                        navLinks.classList.remove('mobile-active');
                        document.querySelector('.nav-auth').classList.remove('mobile-active');
                        document.getElementById('mobileMenuBtn').textContent = '☰';
                    }
                }
            }
        });
    });
}

// =====================================================
// Character and House Card Interactions
// =====================================================
document.addEventListener('click', function(e) {
    // Character card click
    if (e.target.closest('.character-card')) {
        const card = e.target.closest('.character-card');
        const characterName = card.querySelector('.character-name').textContent;
        console.log('Character clicked:', characterName);
        // window.location.href = `/characters/${characterName}`;
    }

    // House card click
    if (e.target.closest('.house-card')) {
        const card = e.target.closest('.house-card');
        const houseName = card.querySelector('.house-name').textContent;
        console.log('House clicked:', houseName);
        // window.location.href = `/houses/${houseName}`;
    }

    // Location item click
    if (e.target.closest('.location-item')) {
        const item = e.target.closest('.location-item');
        const locationName = item.querySelector('h4').textContent;
        console.log('Location clicked:', locationName);
        // window.location.href = `/locations/${locationName}`;
    }
});

// =====================================================
// CSS Animation Classes
// =====================================================
const style = document.createElement('style');
style.textContent = `
    .animate-ready {
        opacity: 0;
        transform: translateY(30px);
        transition: opacity 0.6s ease, transform 0.6s ease;
    }
    
    .animate-in {
        opacity: 1;
        transform: translateY(0);
    }
    
    .navbar.scrolled {
        background: rgba(10, 10, 15, 0.98);
        box-shadow: 0 2px 20px rgba(0, 0, 0, 0.5);
    }
    
    /* Mobile menu styles */
    @media (max-width: 768px) {
        .nav-links.mobile-active,
        .nav-auth.mobile-active {
            display: flex !important;
            flex-direction: column;
            position: absolute;
            top: 70px;
            left: 0;
            right: 0;
            background: rgba(10, 10, 15, 0.98);
            padding: 1rem;
            gap: 0.5rem;
            border-bottom: 1px solid rgba(201, 162, 39, 0.2);
        }
        
        .nav-auth.mobile-active {
            top: auto;
            border-top: 1px solid rgba(201, 162, 39, 0.1);
            flex-direction: row;
            justify-content: center;
        }
    }
`;
document.head.appendChild(style);

// =====================================================
// Utility Functions
// =====================================================
function formatDate(dateString) {
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('tr-TR', options);
}

function truncateText(text, maxLength) {
    if (text.length <= maxLength) return text;
    return text.slice(0, maxLength).trim() + '...';
}

// Log initialization
console.log('🐉 ThronesWiki initialized successfully!');
console.log('⚔️ Welcome to Westeros!');

