// =====================================================
// ThronesWiki - Chat JavaScript
// WebSocket entegrasyonu için hazır yapı
// =====================================================

document.addEventListener('DOMContentLoaded', function() {
    // Initialize Chat
    initializeChat();
    
    // Mobile Menu
    setupMobileMenu();
    
    // Room Selection
    setupRoomSelection();
    
    // User Profile Panel
    setupUserProfilePanel();
    
    // Message Input
    setupMessageInput();
    
    // Sidebar Toggle for Mobile
    setupSidebarToggle();
});

// Chat State
const chatState = {
    currentRoom: 'genel',
    username: 'Kullanıcı', // This would come from Thymeleaf/Backend
    isConnected: false,
    socket: null
};

// Initialize Chat
function initializeChat() {
    // Check if user is logged in (for demo purposes)
    const loginModal = document.getElementById('loginModal');
    if (loginModal) {
        // User is not logged in, show modal
        // In production, this would be handled by Thymeleaf
    }
    
    // Connect to WebSocket (placeholder)
    // connectWebSocket();
    
    // Scroll to bottom of messages
    scrollToBottom();
}

// WebSocket Connection (Placeholder for Spring Boot WebSocket)
function connectWebSocket() {
    // This would be the actual WebSocket connection
    // const socket = new SockJS('/ws');
    // chatState.socket = Stomp.over(socket);
    
    // chatState.socket.connect({}, function(frame) {
    //     console.log('Connected: ' + frame);
    //     chatState.isConnected = true;
    //     
    //     // Subscribe to the current room
    //     subscribeToRoom(chatState.currentRoom);
    // }, function(error) {
    //     console.error('Connection error:', error);
    //     chatState.isConnected = false;
    // });
    
    console.log('WebSocket connection would be established here');
}

// Subscribe to a room
function subscribeToRoom(roomId) {
    // chatState.socket.subscribe(`/topic/room/${roomId}`, function(message) {
    //     const chatMessage = JSON.parse(message.body);
    //     displayMessage(chatMessage);
    // });
    
    console.log('Subscribed to room:', roomId);
}

// Room Selection
function setupRoomSelection() {
    const roomItems = document.querySelectorAll('.room-item');
    
    roomItems.forEach(room => {
        room.addEventListener('click', function() {
            // Remove active class from all rooms
            roomItems.forEach(r => r.classList.remove('active'));
            
            // Add active class to clicked room
            this.classList.add('active');
            
            // Update current room
            const roomId = this.dataset.room;
            chatState.currentRoom = roomId;
            
            // Update header
            updateRoomHeader(this);
            
            // Clear messages and load room messages
            // loadRoomMessages(roomId);
            
            // Close sidebar on mobile
            closeSidebar();
        });
    });
}

function updateRoomHeader(roomElement) {
    const roomIcon = roomElement.querySelector('.room-icon').textContent;
    const roomName = roomElement.querySelector('.room-name').textContent;
    const roomDesc = roomElement.querySelector('.room-desc').textContent;
    
    document.querySelector('.room-icon-large').textContent = roomIcon;
    document.querySelector('.current-room-name').textContent = roomName;
    document.querySelector('.current-room-desc').textContent = roomDesc;
}

// Message Input
function setupMessageInput() {
    const messageInput = document.getElementById('messageInput');
    const sendBtn = document.getElementById('sendBtn');
    
    if (!messageInput || !sendBtn) return;
    
    // Send on button click
    sendBtn.addEventListener('click', sendMessage);
    
    // Send on Enter key
    messageInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });
    
    // Typing indicator
    let typingTimeout;
    messageInput.addEventListener('input', function() {
        // Send typing indicator
        // sendTypingIndicator(true);
        
        clearTimeout(typingTimeout);
        typingTimeout = setTimeout(() => {
            // sendTypingIndicator(false);
        }, 2000);
    });
}

function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const messageText = messageInput.value.trim();
    
    if (!messageText) return;
    
    // Create message object
    const message = {
        room: chatState.currentRoom,
        author: chatState.username,
        text: messageText,
        timestamp: new Date().toISOString()
    };
    
    // Send via WebSocket (placeholder)
    // chatState.socket.send(`/app/chat/${chatState.currentRoom}`, {}, JSON.stringify(message));
    
    // For demo: display message directly
    displayMessage(message);
    
    // Clear input
    messageInput.value = '';
    messageInput.focus();
}

function displayMessage(message) {
    const messagesContainer = document.getElementById('chatMessages');
    const typingIndicator = document.getElementById('typingIndicator');
    
    const messageElement = document.createElement('div');
    messageElement.className = 'message';
    
    const time = new Date(message.timestamp || Date.now());
    const timeStr = time.toLocaleTimeString('tr-TR', { hour: '2-digit', minute: '2-digit' });
    
    messageElement.innerHTML = `
        <div class="message-avatar">
            <span>👤</span>
        </div>
        <div class="message-content">
            <div class="message-header">
                <span class="message-author">${escapeHtml(message.author || chatState.username)}</span>
                <span class="message-time">${timeStr}</span>
            </div>
            <p class="message-text">${escapeHtml(message.text)}</p>
        </div>
    `;
    
    // Insert before typing indicator
    if (typingIndicator) {
        messagesContainer.insertBefore(messageElement, typingIndicator);
    } else {
        messagesContainer.appendChild(messageElement);
    }
    
    scrollToBottom();
}

function scrollToBottom() {
    const messagesContainer = document.getElementById('chatMessages');
    if (messagesContainer) {
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// User Profile Panel
function setupUserProfilePanel() {
    const toggleUserListBtn = document.getElementById('toggleUserList');
    const profilePanel = document.getElementById('userProfilePanel');
    const closeProfileBtn = document.getElementById('closeProfile');
    
    if (toggleUserListBtn && profilePanel) {
        toggleUserListBtn.addEventListener('click', function() {
            profilePanel.classList.toggle('active');
        });
    }
    
    if (closeProfileBtn && profilePanel) {
        closeProfileBtn.addEventListener('click', function() {
            profilePanel.classList.remove('active');
        });
    }
    
    // Click on user in list to show profile
    const userItems = document.querySelectorAll('.user-item');
    userItems.forEach(user => {
        user.addEventListener('click', function() {
            const userName = this.querySelector('.user-name').textContent;
            const userAvatar = this.querySelector('.user-avatar-small').textContent;
            
            // Update profile panel
            if (profilePanel) {
                profilePanel.querySelector('.profile-avatar-large').textContent = userAvatar;
                profilePanel.querySelector('.profile-name').textContent = userName;
                profilePanel.classList.add('active');
            }
        });
    });
}

// Sidebar Toggle for Mobile
function setupSidebarToggle() {
    // Add toggle button for mobile
    const chatHeader = document.querySelector('.chat-header');
    
    if (window.innerWidth <= 768 && chatHeader) {
        const toggleSidebarBtn = document.createElement('button');
        toggleSidebarBtn.className = 'chat-action-btn sidebar-toggle';
        toggleSidebarBtn.innerHTML = '☰';
        toggleSidebarBtn.title = 'Odalar';
        
        chatHeader.querySelector('.chat-actions').prepend(toggleSidebarBtn);
        
        toggleSidebarBtn.addEventListener('click', function() {
            const sidebar = document.querySelector('.chat-sidebar');
            sidebar.classList.toggle('active');
        });
    }
}

function closeSidebar() {
    if (window.innerWidth <= 768) {
        const sidebar = document.querySelector('.chat-sidebar');
        sidebar.classList.remove('active');
    }
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

// Typing Indicator Functions
function showTypingIndicator(username) {
    const typingIndicator = document.getElementById('typingIndicator');
    if (typingIndicator) {
        typingIndicator.style.display = 'flex';
        typingIndicator.querySelector('.message-avatar span').textContent = '👤';
        scrollToBottom();
    }
}

function hideTypingIndicator() {
    const typingIndicator = document.getElementById('typingIndicator');
    if (typingIndicator) {
        typingIndicator.style.display = 'none';
    }
}

// Emoji Picker (Placeholder)
function setupEmojiPicker() {
    const emojiBtn = document.querySelector('.input-action-btn[title="Emoji"]');
    
    if (emojiBtn) {
        emojiBtn.addEventListener('click', function() {
            // Toggle emoji picker
            console.log('Emoji picker would open here');
        });
    }
}

// Notification Sound
function playNotificationSound() {
    // const audio = new Audio('/sounds/notification.mp3');
    // audio.play();
}

// Format timestamp
function formatTimestamp(timestamp) {
    const date = new Date(timestamp);
    const now = new Date();
    
    if (date.toDateString() === now.toDateString()) {
        return date.toLocaleTimeString('tr-TR', { hour: '2-digit', minute: '2-digit' });
    } else {
        return date.toLocaleDateString('tr-TR', { day: 'numeric', month: 'short' }) + 
               ' ' + date.toLocaleTimeString('tr-TR', { hour: '2-digit', minute: '2-digit' });
    }
}
