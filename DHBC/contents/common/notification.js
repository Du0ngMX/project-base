// Hệ thống thông báo không chặn UI
function showNotification(message, type = 'info') {
  // Tạo element thông báo
  const notification = document.createElement('div');
  notification.className = `notification notification--${type}`;
  notification.textContent = message;
  
  // Thêm vào body
  document.body.appendChild(notification);
  
  // Animation hiển thị
  setTimeout(() => {
    notification.classList.add('notification--show');
  }, 10);
  
  // Tự động ẩn sau 3 giây
  setTimeout(() => {
    notification.classList.remove('notification--show');
    setTimeout(() => {
      document.body.removeChild(notification);
    }, 300);
  }, 3000);
}

// Export cho cả CommonJS và ES6
if (typeof module !== 'undefined' && module.exports) {
  module.exports = showNotification;
}