(function () {
  'use strict';

  const { remote, ipcRenderer } = require('electron');
  const winControl = remote.require('./lib/windowControl');
  const { app } = remote.require('electron');

  // Lấy các settings từ localStorage hoặc dùng giá trị mặc định
  const DEFAULT_SETTINGS = {
    questionCount: 10,
    timePerQuestion: 15
  };

  let gameSettings = loadSettings();
  let currentPlayerName = '';

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

  // Load leaderboard từ localStorage
  function loadLeaderboard() {
    const saved = localStorage.getItem('leaderboard');
    if (saved) {
      return JSON.parse(saved);
    }
    return [];
  }

  // Lưu leaderboard vào localStorage
  function saveLeaderboard(leaderboard) {
    localStorage.setItem('leaderboard', JSON.stringify(leaderboard));
  }

  // Thêm điểm mới vào leaderboard
  function addScoreToLeaderboard(name, score) {
    const leaderboard = loadLeaderboard();
    const newEntry = {
      name: name,
      score: score,
      date: new Date().toLocaleString('vi-VN')
    };
    
    leaderboard.push(newEntry);
    
    // Sắp xếp theo điểm cao nhất
    leaderboard.sort((a, b) => b.score - a.score);
    
    // Giữ lại top 10
    if (leaderboard.length > 10) {
      leaderboard.length = 10;
    }
    
    saveLeaderboard(leaderboard);
  }

  // Hiển thị/ẩn màn hình
  function showScreen(screenId) {
    // Ẩn tất cả màn hình
    document.getElementById('menuBox').classList.add('u--hidden');
    document.getElementById('settingsBox').classList.add('u--hidden');
    document.getElementById('nameBox').classList.add('u--hidden');
    document.getElementById('leaderboardBox').classList.add('u--hidden');
    
    // Hiện màn hình được chọn
    document.getElementById(screenId).classList.remove('u--hidden');
  }

  // Hiển thị bảng xếp hạng
  function displayLeaderboard() {
    const leaderboard = loadLeaderboard();
    const listElement = document.getElementById('leaderboardList');
    
    listElement.innerHTML = '';
    
    if (leaderboard.length === 0) {
      listElement.innerHTML = '<p class="no-scores">Chưa có điểm nào được ghi nhận</p>';
      return;
    }
    
    leaderboard.forEach((entry, index) => {
      const row = document.createElement('div');
      row.className = 'leaderboard-row';
      if (index < 3) {
        row.classList.add('top-' + (index + 1));
      }
      
      row.innerHTML = `
        <span class="rank">${index + 1}</span>
        <span class="name">${entry.name}</span>
        <span class="score">${entry.score}</span>
        <span class="date">${entry.date}</span>
      `;
      
      listElement.appendChild(row);
    });
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
    // Hiển thị màn hình nhập tên
    showScreen('nameBox');
    document.getElementById('playerName').focus();
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

  // Xử lý nút Bảng xếp hạng
  document.querySelector('#leaderboardLnk').onclick = function () {
    displayLeaderboard();
    showScreen('leaderboardBox');
  };

  // Xử lý nút Quay lại từ bảng xếp hạng
  document.querySelector('#backFromLeaderboardBtn').onclick = function () {
    showScreen('menuBox');
  };

  // Xử lý nút Chơi (sau khi nhập tên)
  document.querySelector('#playGameBtn').onclick = function () {
    const nameInput = document.getElementById('playerName');
    const name = nameInput.value.trim();
    
    if (name.length === 0) {
      showNotification('Vui lòng nhập tên của bạn!', 'warning');
      nameInput.focus();
      return;
    }
    
    currentPlayerName = name;
    
    // Lưu thông tin để truyền sang game
    localStorage.setItem('currentPlayerName', currentPlayerName);
    localStorage.setItem('currentGameSettings', JSON.stringify(gameSettings));
    
    // Mở cửa sổ game
    let win = remote.getCurrentWindow();
    winControl.showPlayWindow();
    win.hide();
  };

  // Xử lý nút Hủy từ màn hình nhập tên
  document.querySelector('#cancelNameBtn').onclick = function () {
    document.getElementById('playerName').value = '';
    showScreen('menuBox');
  };

  // Xử lý phím Enter khi nhập tên
  document.getElementById('playerName').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
      document.querySelector('#playGameBtn').click();
    }
  });

  // Lắng nghe message từ game window để quay về menu chính
  ipcRenderer.on('show-main-menu', () => {
    showScreen('menuBox');
  });

})();