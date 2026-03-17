const promptBox = document.getElementById("prompt");

document.getElementById("copy").addEventListener("click", () => {
  navigator.clipboard.writeText(promptBox.value);
});

document.getElementById("paste").addEventListener("click", async () => {
  let [tab] = await chrome.tabs.query({active: true, currentWindow: true});

  chrome.tabs.sendMessage(tab.id, {
    action: "pastePrompt",
    text: promptBox.value
  });
});
