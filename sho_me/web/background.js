
chrome.app.runtime.onLaunched.addListener(function(launchData) {
  chrome.app.window.create('sho_me.html', {
    'id': '_mainWindow', 'bounds': {'width': 800, 'height': 600 }
  });
});
