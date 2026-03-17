chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  if (msg.action === "pastePrompt") {

    let active = document.activeElement;

    if (active && (active.tagName === "TEXTAREA" || active.tagName === "INPUT")) {
      active.value += msg.text;
    }

  }
});
