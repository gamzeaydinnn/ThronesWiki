// =====================================================
// ThronesWiki - AI Chatbot with Gemini API
// Game of Thrones Expert Bot
// =====================================================

const GEMINI_API_KEY = "AIzaSyBsUmn7E4zL9fz1hTiUS4wTAoQlz-5sqHI";
const GEMINI_API_URL =
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

// Chatbot State
const chatbotState = {
  isOpen: false,
  isTyping: false,
  conversationHistory: [],
};

// System Prompt for Game of Thrones Expert
const SYSTEM_PROMPT = `Sen ThronesWiki'nin resmi AI asistanısın. Adın "Maester AI" ve Game of Thrones/A Song of Ice and Fire evreni hakkında uzman bir bilgesin.

Görevin:
- Game of Thrones dizisi ve kitapları hakkında soruları cevaplamak
- Karakterler, haneler, lokasyonlar, olaylar ve tarih hakkında detaylı bilgi vermek
- Westeros ve Essos kıtaları hakkında bilgi sağlamak
- Fan teorilerini tartışmak
- Dizideki ve kitaplardaki farkları açıklamak

Kurallar:
1. Her zaman Türkçe cevap ver
2. Game of Thrones temasına uygun, etkileyici bir dil kullan
3. Cevaplarında emojiler kullanabilirsin (🐺 Stark, 🐉 Targaryen, 🦁 Lannister, ⚔️ savaş, 👑 taht vb.)
4. Spoiler içeren bilgiler için uyar
5. Kısa ve öz cevaplar ver, gerekirse detaya gir
6. Eğer Game of Thrones dışında bir soru sorulursa, nazikçe konuyu Game of Thrones'a yönlendir
7. Maester gibi bilge ve saygılı bir üslup kullan

Örnek karşılama: "Selamlar, genç lord/lady! Ben Maester AI, Westeros'un tüm sırlarını bilen bir bilgeyim. Size nasıl yardımcı olabilirim?"`;

// Quick Questions
const quickQuestions = [
  "Jon Snow kimdir? 🐺",
  "Ejderhalar hakkında bilgi ver 🐉",
  "Stark Hanesi'ni anlat",
  "Demir Taht'ın tarihi nedir?",
  "En güçlü savaşçı kim?",
];

// Initialize Chatbot
document.addEventListener("DOMContentLoaded", function () {
  createChatbotHTML();
  setupChatbotEventListeners();
});

// Create Chatbot HTML
function createChatbotHTML() {
  const chatbotHTML = `
        <!-- Chatbot Toggle Button -->
        <button class="chatbot-toggle" id="chatbotToggle" title="Maester AI ile Sohbet">
            <span class="chatbot-toggle-icon bot-icon">🐉</span>
            <span class="chatbot-toggle-icon close-icon">✕</span>
        </button>

        <!-- Chatbot Container -->
        <div class="chatbot-container" id="chatbotContainer">
            <!-- Header -->
            <div class="chatbot-header">
                <div class="chatbot-avatar">🐉</div>
                <div class="chatbot-info">
                    <div class="chatbot-name">Maester AI</div>
                    <div class="chatbot-status">
                        <span class="status-dot"></span>
                        <span>Çevrimiçi - Westeros'tan</span>
                    </div>
                </div>
                <button class="chatbot-close" id="chatbotClose">✕</button>
            </div>

            <!-- Messages -->
            <div class="chatbot-messages" id="chatbotMessages">
                <!-- Welcome Message -->
                <div class="welcome-message">
                    <h3>⚔️ Maester AI'a Hoş Geldiniz ⚔️</h3>
                    <p>Game of Thrones evreni hakkında her şeyi sorabileceğiniz yapay zeka asistanınız</p>
                </div>

                <!-- Bot Welcome -->
                <div class="chat-message bot">
                    <div class="message-avatar">🐉</div>
                    <div class="message-bubble">
                        Selamlar, genç lord/lady! 👑 Ben <strong>Maester AI</strong>, Citadel'de eğitim almış ve Westeros'un tüm sırlarını bilen bir bilgeyim. 
                        <br><br>
                        Size Game of Thrones evreni hakkında her konuda yardımcı olabilirim. Karakterler, haneler, ejderhalar, savaşlar... Ne sormak istersiniz? ⚔️
                    </div>
                </div>

                <!-- Quick Questions -->
                <div class="quick-questions" id="quickQuestions">
                    ${quickQuestions.map((q) => `<button class="quick-question-btn">${q}</button>`).join("")}
                </div>
            </div>

            <!-- Input -->
            <div class="chatbot-input-container">
                <div class="chatbot-input-wrapper">
                    <input 
                        type="text" 
                        class="chatbot-input" 
                        id="chatbotInput" 
                        placeholder="Sorunuzu yazın..."
                        autocomplete="off"
                    >
                    <button class="chatbot-send-btn" id="chatbotSendBtn" title="Gönder">
                        📤
                    </button>
                </div>
            </div>

            <!-- Footer -->
            <div class="chatbot-footer">
                Powered by <span>Google Gemini AI</span> ⚡
            </div>
        </div>
    `;

  document.body.insertAdjacentHTML("beforeend", chatbotHTML);
}

// Setup Event Listeners
function setupChatbotEventListeners() {
  const toggle = document.getElementById("chatbotToggle");
  const container = document.getElementById("chatbotContainer");
  const closeBtn = document.getElementById("chatbotClose");
  const input = document.getElementById("chatbotInput");
  const sendBtn = document.getElementById("chatbotSendBtn");
  const quickBtns = document.querySelectorAll(".quick-question-btn");

  // Toggle Chatbot
  toggle.addEventListener("click", () => toggleChatbot());
  closeBtn.addEventListener("click", () => toggleChatbot(false));

  // Send Message
  sendBtn.addEventListener("click", () => sendMessage());
  input.addEventListener("keypress", (e) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });

  // Quick Questions
  quickBtns.forEach((btn) => {
    btn.addEventListener("click", () => {
      input.value = btn.textContent;
      sendMessage();
    });
  });

  // Close on outside click
  document.addEventListener("click", (e) => {
    if (
      chatbotState.isOpen &&
      !container.contains(e.target) &&
      !toggle.contains(e.target)
    ) {
      // Optional: close on outside click
      // toggleChatbot(false);
    }
  });
}

// Toggle Chatbot
function toggleChatbot(state = null) {
  const toggle = document.getElementById("chatbotToggle");
  const container = document.getElementById("chatbotContainer");

  chatbotState.isOpen = state !== null ? state : !chatbotState.isOpen;

  if (chatbotState.isOpen) {
    container.classList.add("active");
    toggle.classList.add("active");
    document.getElementById("chatbotInput").focus();
  } else {
    container.classList.remove("active");
    toggle.classList.remove("active");
  }
}

// Send Message
async function sendMessage() {
  const input = document.getElementById("chatbotInput");
  const message = input.value.trim();

  if (!message || chatbotState.isTyping) return;

  // Clear input
  input.value = "";

  // Hide quick questions after first message
  const quickQuestionsDiv = document.getElementById("quickQuestions");
  if (quickQuestionsDiv) {
    quickQuestionsDiv.style.display = "none";
  }

  // Add user message
  addMessage(message, "user");

  // Add to conversation history
  chatbotState.conversationHistory.push({
    role: "user",
    parts: [{ text: message }],
  });

  // Show typing indicator
  showTypingIndicator();

  try {
    // Call Gemini API
    const response = await callGeminiAPI(message);

    // Hide typing indicator
    hideTypingIndicator();

    // Add bot response
    addMessage(response, "bot");

    // Add to conversation history
    chatbotState.conversationHistory.push({
      role: "model",
      parts: [{ text: response }],
    });
  } catch (error) {
    console.error("Chatbot Error:", error);
    hideTypingIndicator();

    // Check if it's a quota/rate limit error
    let errorMessage = "Üzgünüm, bir hata oluştu. Lütfen tekrar deneyin. ⚠️";

    if (error.message.includes("429")) {
      errorMessage =
        "⏳ API kullanım kotası doldu. Lütfen birkaç dakika sonra tekrar deneyin. Ücretsiz planda günlük ve dakikalık limitler vardır.";
    } else if (error.message.includes("API Error")) {
      errorMessage =
        "🔌 API'ye bağlanırken bir sorun oluştu. Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.";
    }

    addMessage(errorMessage, "bot", true);
  }
}

// Call Gemini API
async function callGeminiAPI(userMessage) {
  // Build conversation with system instruction
  const contents = [];

  // Add system prompt as first user message
  contents.push({
    role: "user",
    parts: [{ text: SYSTEM_PROMPT }],
  });

  contents.push({
    role: "model",
    parts: [
      {
        text: "Anladım, Game of Thrones uzmanı Maester AI olarak Türkçe hizmet vereceğim. 🐉",
      },
    ],
  });

  // Add conversation history
  for (const msg of chatbotState.conversationHistory) {
    contents.push(msg);
  }

  const requestBody = {
    contents: contents,
    generationConfig: {
      temperature: 1.0,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 1024,
    },
  };

  console.log("Sending request to Gemini API...");

  const response = await fetch(`${GEMINI_API_URL}?key=${GEMINI_API_KEY}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(requestBody),
  });

  console.log("Response status:", response.status);

  if (!response.ok) {
    const errorData = await response.text();
    console.error("API Error Response:", errorData);
    throw new Error(`API Error: ${response.status} - ${errorData}`);
  }

  const data = await response.json();
  console.log("API Response:", data);

  if (data.candidates && data.candidates[0] && data.candidates[0].content) {
    return data.candidates[0].content.parts[0].text;
  } else if (data.error) {
    throw new Error(`API Error: ${data.error.message}`);
  } else {
    throw new Error("Invalid API response");
  }
}

// Add Message to Chat
function addMessage(text, sender, isError = false) {
  const messagesContainer = document.getElementById("chatbotMessages");
  const messageDiv = document.createElement("div");
  messageDiv.className = `chat-message ${sender}`;

  const avatar = sender === "bot" ? "🐉" : "👤";

  // Format text with basic markdown
  const formattedText = formatMessage(text);

  messageDiv.innerHTML = `
        <div class="message-avatar">${avatar}</div>
        <div class="message-bubble ${isError ? "error-message" : ""}">${formattedText}</div>
    `;

  messagesContainer.appendChild(messageDiv);
  scrollToBottom();
}

// Format message with basic styling
function formatMessage(text) {
  // Bold text
  text = text.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>");
  // Italic text
  text = text.replace(/\*(.*?)\*/g, "<em>$1</em>");
  // Code
  text = text.replace(/`(.*?)`/g, "<code>$1</code>");
  // Line breaks
  text = text.replace(/\n/g, "<br>");

  return text;
}

// Show Typing Indicator
function showTypingIndicator() {
  chatbotState.isTyping = true;
  const messagesContainer = document.getElementById("chatbotMessages");

  const typingDiv = document.createElement("div");
  typingDiv.className = "chat-message bot";
  typingDiv.id = "typingIndicator";
  typingDiv.innerHTML = `
        <div class="message-avatar">🐉</div>
        <div class="typing-indicator">
            <span></span>
            <span></span>
            <span></span>
        </div>
    `;

  messagesContainer.appendChild(typingDiv);
  scrollToBottom();

  // Disable send button
  document.getElementById("chatbotSendBtn").disabled = true;
}

// Hide Typing Indicator
function hideTypingIndicator() {
  chatbotState.isTyping = false;
  const typingIndicator = document.getElementById("typingIndicator");
  if (typingIndicator) {
    typingIndicator.remove();
  }

  // Enable send button
  document.getElementById("chatbotSendBtn").disabled = false;
}

// Scroll to Bottom
function scrollToBottom() {
  const messagesContainer = document.getElementById("chatbotMessages");
  messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

// Clear Chat History
function clearChatHistory() {
  chatbotState.conversationHistory = [];
  const messagesContainer = document.getElementById("chatbotMessages");

  // Keep only welcome message
  messagesContainer.innerHTML = `
        <div class="welcome-message">
            <h3>⚔️ Maester AI'a Hoş Geldiniz ⚔️</h3>
            <p>Game of Thrones evreni hakkında her şeyi sorabileceğiniz yapay zeka asistanınız</p>
        </div>
        <div class="chat-message bot">
            <div class="message-avatar">🐉</div>
            <div class="message-bubble">
                Sohbet temizlendi. Yeni bir sohbete başlayabiliriz! 🏰 Size nasıl yardımcı olabilirim?
            </div>
        </div>
        <div class="quick-questions" id="quickQuestions">
            ${quickQuestions.map((q) => `<button class="quick-question-btn">${q}</button>`).join("")}
        </div>
    `;

  // Re-setup quick questions
  document.querySelectorAll(".quick-question-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.getElementById("chatbotInput").value = btn.textContent;
      sendMessage();
    });
  });
}

// Export for potential external use
window.ThronesWikiChatbot = {
  toggle: toggleChatbot,
  clearHistory: clearChatHistory,
};
