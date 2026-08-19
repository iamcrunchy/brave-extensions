chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'isPinned') {
    if (sender.tab && sender.tab.id) {
      chrome.tabs.get(sender.tab.id, (tab) => {
        sendResponse({ pinned: Boolean(tab && tab.pinned) });
      });
      return true; // Keep message channel open for async response
    }
    sendResponse({ pinned: false });
  }

  if (message.action === 'openTab' && message.url) {
    chrome.tabs.create({
      url: message.url,
      active: true, // Set to false if you do not want the new tab to gain immediate focus
    });
  }
});
