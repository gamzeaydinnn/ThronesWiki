const modelSelect = document.getElementById("modelSelect");
const promptInput = document.getElementById("prompt");
const runBtn = document.getElementById("runBtn");
const output = document.getElementById("output");

runBtn.addEventListener("click", () => {
  const model = modelSelect.value;
  const prompt = promptInput.value;

  if (!model) {
    output.textContent = "⚠️ Önce bir model seç.";
    return;
  }

  if (!prompt) {
    output.textContent = "⚠️ Bir prompt yaz.";
    return;
  }

  output.textContent =
    "Seçilen model: " + model + "\n" +
    "Prompt: " + prompt + "\n\n" +
    "(Şu an sadece arayüz çalışıyor. API bağlanınca cevap burada olacak.)";
});
