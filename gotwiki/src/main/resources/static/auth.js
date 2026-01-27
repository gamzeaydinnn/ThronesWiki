// =====================================================
// ThronesWiki - Authentication JavaScript
// =====================================================

document.addEventListener('DOMContentLoaded', function() {
    // Password Toggle Functionality
    setupPasswordToggle();
    
    // Password Strength Meter
    setupPasswordStrength();
    
    // Form Validation
    setupFormValidation();
    
    // Mobile Menu
    setupMobileMenu();
});

// Password Toggle
function setupPasswordToggle() {
    const toggleButtons = document.querySelectorAll('.password-toggle');
    
    toggleButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.previousElementSibling;
            const isPassword = input.type === 'password';
            
            input.type = isPassword ? 'text' : 'password';
            this.textContent = isPassword ? '🙈' : '👁️';
        });
    });
}

// Password Strength Meter
function setupPasswordStrength() {
    const passwordInput = document.getElementById('password');
    const strengthBar = document.getElementById('strengthBar');
    
    if (!passwordInput || !strengthBar) return;
    
    passwordInput.addEventListener('input', function() {
        const password = this.value;
        const strength = calculatePasswordStrength(password);
        
        strengthBar.className = 'strength-bar';
        
        if (password.length === 0) {
            strengthBar.style.width = '0';
        } else if (strength < 2) {
            strengthBar.classList.add('weak');
        } else if (strength < 4) {
            strengthBar.classList.add('medium');
        } else {
            strengthBar.classList.add('strong');
        }
    });
}

function calculatePasswordStrength(password) {
    let strength = 0;
    
    if (password.length >= 6) strength++;
    if (password.length >= 10) strength++;
    if (/[a-z]/.test(password)) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^a-zA-Z0-9]/.test(password)) strength++;
    
    return strength;
}

// Form Validation
function setupFormValidation() {
    const registerForm = document.getElementById('registerForm');
    
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                showError('Şifreler eşleşmiyor!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                showError('Şifre en az 6 karakter olmalıdır!');
                return false;
            }
        });
    }
    
    const loginForm = document.getElementById('loginForm');
    
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            
            if (!username || !password) {
                e.preventDefault();
                showError('Lütfen tüm alanları doldurun!');
                return false;
            }
        });
    }
}

function showError(message) {
    // Remove existing error alerts
    const existingAlert = document.querySelector('.alert-error');
    if (existingAlert) {
        existingAlert.remove();
    }
    
    // Create new error alert
    const alert = document.createElement('div');
    alert.className = 'alert alert-error';
    alert.innerHTML = `
        <span class="alert-icon">⚠️</span>
        <span>${message}</span>
    `;
    
    const form = document.querySelector('.auth-form');
    form.insertBefore(alert, form.firstChild);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        alert.style.opacity = '0';
        alert.style.transform = 'translateY(-10px)';
        setTimeout(() => alert.remove(), 300);
    }, 5000);
}

// Mobile Menu
function setupMobileMenu() {
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const navLinks = document.querySelector('.nav-links');
    const navAuth = document.querySelector('.nav-auth');
    
    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', function() {
            navLinks.classList.toggle('mobile-active');
            navAuth.classList.toggle('mobile-active');
            this.textContent = navLinks.classList.contains('mobile-active') ? '✕' : '☰';
        });
    }
}

// Real-time username availability check (placeholder for API integration)
function checkUsernameAvailability(username) {
    // This would be an AJAX call to the backend
    console.log('Checking username:', username);
    // return fetch(`/api/check-username?username=${username}`)
    //     .then(response => response.json());
}

// Real-time email validation (placeholder for API integration)
function checkEmailAvailability(email) {
    // This would be an AJAX call to the backend
    console.log('Checking email:', email);
    // return fetch(`/api/check-email?email=${email}`)
    //     .then(response => response.json());
}
