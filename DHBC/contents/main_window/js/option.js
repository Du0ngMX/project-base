(function () {
  'use strict';

  const { remote } = require('electron');
  const winControl = remote.require('./lib/windowControl');
  const { app } = remote.require('electron');

  // Lấy các settings từ localStorage hoặc dùng giá trị mặc định
  const DEFAULT_SETTINGS = {
    questionCount: 10,
    timePerQuestion: 15
  };

  let gameSettings = loadSettings();

  // Load settings từ localStorage
  function loadSettings() {
    const saved = localStorage.getItem('gameSettings');
    if (saved) {
      return JSON.parse(saved);
    }
    return { ...DEFAULT_SETTINGS };
  }

  // Lưu settings vào localStorage
  function saveSettings() {
    localStorage.setItem('gameSettings', JSON.stringify(gameSettings));
  }

  // Hiển thị/ẩn màn hình
  function showScreen(screenId) {
    // Ẩn tất cả màn hình
    document.getElementById('menuBox').classList.add('u--hidden');
    document.getElementById('settingsBox').classList.add('u--hidden');
    
    // Hiện màn hình được chọn
    document.getElementById(screenId).classList.remove('u--hidden');
  }

  // Cập nhật UI với settings hiện tại
  function updateSettingsUI() {
    // Set radio button
    const radioButtons = document.querySelectorAll('input[name="questionCount"]');
    radioButtons.forEach(radio => {
      if (parseInt(radio.value) === gameSettings.questionCount) {
        radio.checked = true;
      }
    });
    
    // Set time slider
    const timeSlider = document.getElementById('timePerQuestion');
    const timeValue = document.getElementById('timeValue');
    timeSlider.value = gameSettings.timePerQuestion;
    timeValue.textContent = gameSettings.timePerQuestion;
  }

  // Xử lý nút Bắt đầu
  document.querySelector('#startLnk').onclick = function () {
    let win = remote.getCurrentWindow();
    
    // Truyền settings sang cửa sổ game thông qua localStorage
    localStorage.setItem('currentGameSettings', JSON.stringify(gameSettings));
    
    winControl.showPlayWindow();
    win.hide();
  };

  // Xử lý nút Tùy chọn
  document.querySelector('#optionLnk').onclick = function () {
    updateSettingsUI();
    showScreen('settingsBox');
  };

  // Xử lý nút Thoát
  document.querySelector('#aboutLnk').onclick = function () {
    app.exit(0);
  };

  // Xử lý range slider
  document.getElementById('timePerQuestion').addEventListener('input', function(e) {
    document.getElementById('timeValue').textContent = e.target.value;
  });

  // Xử lý nút Lưu settings
  document.querySelector('#saveSettingsBtn').onclick = function () {
    // Lấy giá trị số câu hỏi
    const selectedRadio = document.querySelector('input[name="questionCount"]:checked');
    if (selectedRadio) {
      gameSettings.questionCount = parseInt(selectedRadio.value);
    }
    
    // Lấy giá trị thời gian từ slider
    const timeSlider = document.getElementById('timePerQuestion');
    gameSettings.timePerQuestion = parseInt(timeSlider.value);
    
    // Lưu settings
    saveSettings();
    
    // Quay về menu chính
    showScreen('menuBox');
  };

  // Xử lý nút Hủy
  document.querySelector('#cancelSettingsBtn').onclick = function () {
    // Quay về menu chính mà không lưu
    showScreen('menuBox');
  };

})();