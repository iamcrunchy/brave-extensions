(async function init() {
  // Check if current tab is pinned
  const response = await chrome.runtime
    .sendMessage({ action: 'isPinned' })
    .catch(() => null);

  if (!response || !response.pinned) {
    return; // Exit if not in a pinned tab
  }

  console.log(
    'TSC Pinned Tab Helper: Pinned tab detected, link interception active.'
  );

  document.addEventListener(
    'click',
    (event) => {
      // Find closest anchor tag
      const link = event.target.closest('a[href]');
      if (!link) return;

      const href = link.href.trim();

      // Skip in-page anchors, javascript voids, or modifier key clicks
      if (
        !href ||
        href.startsWith('javascript:') ||
        href.startsWith('#') ||
        event.button !== 0 ||
        event.ctrlKey ||
        event.shiftKey ||
        event.metaKey ||
        event.altKey
      ) {
        return;
      }

      event.preventDefault();
      event.stopImmediatePropagation();

      // Request background script to open the link in a new tab
      chrome.runtime.sendMessage({
        action: 'openTab',
        url: href,
      });
    },
    true // Capture phase to intercept before page frameworks handle it
  );
})();
