(function() {
  'use strict';
  
  // Import các module cần thiết
  const { remote } = require('electron');
  const path = require('path');
  
  // Dữ liệu câu hỏi - 10 món ăn Việt Nam
  const gameData = [
    {
        id: 1,
        image: "1.jpg",
        answer: "BANH MI",
        hint: "BANHMIXYZT"
    },
    {
        id: 2,
        image: "2.jpg",
        answer: "PHO BO",
        hint: "PHOBOXYZW"
    },
    {
        id: 3,
        image: "3.jpg",
        answer: "BUN CHA",
        hint: "BUNCHAXYZ"
    },
    {
        id: 4,
        image: "4.jpg",
        answer: "COM TAM",
        hint: "COMTAMXYZ"
    },
    {
        id: 5,
        image: "5.jpg",
        answer: "CHE BA MAU",
        hint: "CHEBAMAUXY"
    },
    {
        id: 6,
        image: "6.jpg",
        answer: "CAFE SUA",
        hint: "CAFESUAXY"
    },
    {
        id: 7,
        image: "7.jpg",
        answer: "GOI CUON",
        hint: "GOICUONXY"
    },
    {
        id: 8,
        image: "8.jpg",
        answer: "NEM RAN",
        hint: "NEMRANXYZ"
    },
    {
        id: 9,
        image: "9.jpg",
        answer: "BUN BO HUE",
        hint: "BUNBOHUEXYZ"
    },
    {
        id: 10,
        image: "10.jpg",
        answer: "MI QUANG",
        hint: "MIQUANGXY"
    }
  ];

  // Load settings từ localStorage
  let gameSettings = {
    questionCount: 10,
    timePerQuestion: 15
  };
  
  try {
    const savedSettings = localStorage.getItem('currentGameSettings');
    if (savedSettings) {
      gameSettings = JSON.parse(savedSettings);
    }
  } catch (error) {
    console.error('Error loading settings:', error);
  }

  // Biến quản lý trạng thái game
  let currentQuestion = 0;      // Câu hỏi hiện tại
  let score = 0;                // Điểm số
  let timeLeft = gameSettings.timePerQuestion; // Thời gian còn lại
  let timerInterval = null;     // Interval cho đồng hồ đếm ngược
  let currentAnswer = [];       // Mảng chứa các ký tự đã chọn
  let availableLetters = [];    // Mảng chứa các ký tự gợi ý đã xáo trộn
  let maxQuestions = Math.min(gameSettings.questionCount, gameData.length); // Giới hạn số câu hỏi

  // Cache các element DOM để tránh query nhiều lần
  const elements = {
    currentQuestion: document.getElementById('currentQuestion'),
    totalQuestions: document.getElementById('totalQuestions'),
    score: document.getElementById('score'),
    timer: document.getElementById('timer'),
    questionImage: document.getElementById('questionImage'),
    answerBox: document.getElementById('answerBox'),
    lettersGrid: document.getElementById('lettersGrid'),
    submitBtn: document.getElementById('submitBtn'),
    skipBtn: document.getElementById('skipBtn'),
    clearBtn: document.getElementById('clearBtn'),
    gameOver: document.getElementById('gameOver'),
    finalScore: document.getElementById('finalScore'),
    playAgainBtn: document.getElementById('playAgainBtn'),
    backMenuBtn: document.getElementById('backMenuBtn'),
    gameContent: document.querySelector('.game-content'),
    gameStats: document.querySelector('.game-stats')
  };

  /**
   * Xáo trộn mảng bằng thuật toán Fisher-Yates
   * @param {Array} array - Mảng cần xáo trộn
   * @returns {Array} - Mảng đã được xáo trộn
   */
  function shuffleArray(array) {
    const newArray = [...array];
    for (let i = newArray.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [newArray[i], newArray[j]] = [newArray[j], newArray[i]];
    }
    return newArray;
  }

  /**
   * Khởi động bộ đếm thời gian cho câu hỏi
   * Đếm ngược từ timePerQuestion, tự động chuyển câu khi hết giờ
   */
  function startTimer() {
    timeLeft = gameSettings.timePerQuestion;
    elements.timer.textContent = timeLeft;
    
    // Clear timer cũ nếu có
    if (timerInterval) {
      clearInterval(timerInterval);
    }

    timerInterval = setInterval(() => {
      timeLeft--;
      elements.timer.textContent = timeLeft;
      
      // Đổi màu đỏ khi còn ít thời gian
      if (timeLeft <= 5) {
        elements.timer.style.color = '#e74c3c';
      } else {
        elements.timer.style.color = '#333';
      }
      
      // Hết giờ - chuyển câu tiếp theo
      if (timeLeft === 0) {
        clearInterval(timerInterval);
        nextQuestion();
      }
    }, 1000);
  }

  /**
   * Load câu hỏi mới
   * Hiển thị hình ảnh, khởi tạo các ô trả lời, xáo trộn ký tự gợi ý
   */
  function loadQuestion() {
    // Kiểm tra dữ liệu game
    if (!gameData || gameData.length === 0) {
      alert('Không thể tải dữ liệu trò chơi!');
      return;
    }
    
    // Kiểm tra đã hết câu hỏi chưa
    if (currentQuestion >= maxQuestions) {
      endGame();
      return;
    }

    const question = gameData[currentQuestion];
    
    // Clear trạng thái cũ
    elements.answerBox.classList.remove('correct-answer', 'wrong-answer');
    
    // Cập nhật số câu hỏi
    elements.currentQuestion.textContent = currentQuestion + 1;
    
    // Load hình ảnh
    elements.questionImage.src = '../../databases/item/' + question.image;
    elements.questionImage.onerror = function() {
      console.error('Không thể tải hình ảnh:', question.image);
      this.src = '../../databases/item/1.jpg'; // Hình ảnh dự phòng
    };
    
    // Xáo trộn ký tự gợi ý
    availableLetters = shuffleArray(question.hint.split(''));
    
    // Khởi tạo mảng đáp án với số ô trống bằng độ dài đáp án
    const answerLength = question.answer.replace(/\s/g, '').length;
    currentAnswer = new Array(answerLength).fill(null);
    
    // Render giao diện
    renderLetterButtons();
    updateAnswerDisplay();
    
    // Bắt đầu đếm thời gian
    startTimer();
  }

  /**
   * Render các button ký tự gợi ý
   * Tạo button cho mỗi ký tự trong availableLetters
   */
  function renderLetterButtons() {
    elements.lettersGrid.innerHTML = '';
    
    availableLetters.forEach((letter, index) => {
      const button = document.createElement('button');
      button.className = 'letter-btn';
      button.textContent = letter;
      button.dataset.index = index;
      
      // Xử lý click chọn ký tự
      button.addEventListener('click', () => selectLetter(index));
      
      elements.lettersGrid.appendChild(button);
    });
  }

  /**
   * Xử lý khi người chơi chọn một ký tự
   * @param {number} index - Vị trí của ký tự trong mảng availableLetters
   */
  function selectLetter(index) {
    const buttons = elements.lettersGrid.querySelectorAll('.letter-btn');
    const button = buttons[index];
    
    // Kiểm tra button đã được chọn chưa
    if (button.classList.contains('disabled')) return;
    
    // Tìm ô trống đầu tiên trong đáp án
    const emptyIndex = currentAnswer.findIndex(slot => slot === null);
    if (emptyIndex === -1) return; // Không còn ô trống
    
    // Thêm ký tự vào ô trống
    currentAnswer[emptyIndex] = {
      letter: availableLetters[index],
      originalIndex: index
    };
    
    // Disable button đã chọn
    button.classList.add('disabled');
    
    // Cập nhật hiển thị
    updateAnswerDisplay();
  }

  /**
   * Cập nhật hiển thị các ô đáp án
   * Hiển thị ký tự đã chọn hoặc ô trống
   */
  function updateAnswerDisplay() {
    elements.answerBox.innerHTML = '';
    
    currentAnswer.forEach((item, index) => {
      const span = document.createElement('span');
      span.className = 'answer-slot';
      
      if (item) {
        // Ô đã có ký tự
        span.textContent = item.letter;
        span.classList.add('filled');
        span.addEventListener('click', () => removeLetter(index));
      } else {
        // Ô trống
        span.textContent = '';
        span.classList.add('empty');
      }
      
      span.dataset.answerIndex = index;
      elements.answerBox.appendChild(span);
    });
  }

  /**
   * Xóa ký tự khỏi ô đáp án khi click vào ô đã điền
   * @param {number} answerIndex - Vị trí của ô cần xóa
   */
  function removeLetter(answerIndex) {
    const removed = currentAnswer[answerIndex];
    if (!removed) return;
    
    // Enable lại button ký tự
    const buttons = elements.lettersGrid.querySelectorAll('.letter-btn');
    buttons[removed.originalIndex].classList.remove('disabled');
    
    // Xóa ký tự khỏi ô
    currentAnswer[answerIndex] = null;
    
    // Cập nhật hiển thị
    updateAnswerDisplay();
  }

  /**
   * Xóa toàn bộ đáp án đã nhập
   */
  function clearAnswer() {
    const buttons = elements.lettersGrid.querySelectorAll('.letter-btn');
    
    // Enable lại tất cả các button đã chọn
    currentAnswer.forEach((item, index) => {
      if (item) {
        buttons[item.originalIndex].classList.remove('disabled');
        currentAnswer[index] = null;
      }
    });
    
    // Cập nhật hiển thị
    updateAnswerDisplay();
  }

  /**
   * Kiểm tra đáp án người chơi nhập
   * So sánh với đáp án đúng và cập nhật điểm
   */
  function checkAnswer() {
    // Kiểm tra đã điền đủ chưa
    const hasEmpty = currentAnswer.some(slot => slot === null);
    if (hasEmpty) {
      alert('Vui lòng điền đầy đủ tất cả các ô!');
      return;
    }
    
    // Ghép các ký tự thành chuỗi đáp án
    const userAnswer = currentAnswer.map(item => item ? item.letter : '').join('');
    const correctAnswer = gameData[currentQuestion].answer.replace(/\s/g, '');
    
    if (userAnswer === correctAnswer) {
      // Đáp án đúng
      score += 10;
      elements.score.textContent = score;
      elements.answerBox.classList.add('correct-answer');
      
      // Chuyển câu sau 1 giây
      setTimeout(() => {
        elements.answerBox.classList.remove('correct-answer');
        nextQuestion();
      }, 1000);
    } else {
      // Đáp án sai
      elements.answerBox.classList.add('wrong-answer');
      
      // Xóa hiệu ứng sau 0.5 giây
      setTimeout(() => {
        elements.answerBox.classList.remove('wrong-answer');
      }, 500);
    }
  }

  /**
   * Chuyển sang câu hỏi tiếp theo
   */
  function nextQuestion() {
    clearInterval(timerInterval);
    currentQuestion++;
    
    if (currentQuestion < maxQuestions) {
      loadQuestion();
    } else {
      endGame();
    }
  }

  /**
   * Kết thúc game và hiển thị điểm số
   */
  function endGame() {
    clearInterval(timerInterval);
    
    // Ẩn màn chơi, hiện màn kết thúc
    elements.gameContent.style.display = 'none';
    elements.gameStats.style.display = 'none';
    elements.gameOver.style.display = 'block';
    elements.finalScore.textContent = score;
  }

  /**
   * Reset game về trạng thái ban đầu
   */
  function resetGame() {
    currentQuestion = 0;
    score = 0;
    elements.score.textContent = score;
    
    // Hiện lại màn chơi
    elements.gameContent.style.display = 'block';
    elements.gameStats.style.display = 'flex';
    elements.gameOver.style.display = 'none';
    
    // Load câu đầu tiên
    loadQuestion();
  }

  // Gắn event listeners cho các nút
  elements.submitBtn.addEventListener('click', checkAnswer);
  elements.skipBtn.addEventListener('click', nextQuestion);
  elements.clearBtn.addEventListener('click', clearAnswer);
  elements.playAgainBtn.addEventListener('click', resetGame);
  
  // Nút quay về menu chính
  elements.backMenuBtn.addEventListener('click', () => {
    const win = remote.getCurrentWindow();
    win.close(); // Chỉ cần đóng cửa sổ game, main window sẽ tự động hiện lại
  });

  // Đợi DOM sẵn sàng trước khi bắt đầu game
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      elements.totalQuestions.textContent = maxQuestions;
      loadQuestion();
    });
  } else {
    elements.totalQuestions.textContent = maxQuestions;
    loadQuestion();
  }
})();