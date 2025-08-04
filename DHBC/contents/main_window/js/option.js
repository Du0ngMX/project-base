(function () {
  'use strict';

  const { remote } = require('electron');
  const winControl = remote.require('./lib/windowControl');
  const { app } = remote.require('electron');

  // const elements = {
  //   startLnk: document.querySelector('#startLnk'),
  //   optionLnk: document.querySelector('#optionLnk'),
  //   aboutLnk: document.querySelector('#aboutLnk')
  // };

  // elements.startLnk.addEventListener('click', startGame);
  // elements.optionLnk.addEventListener('click', optionGame);
  // elements.aboutLnk.addEventListener('click', aboutGame);

  document.querySelector('#startLnk').onclick = function () {
    let win = remote.getCurrentWindow();
    winControl.showPlayWindow();
    win.hide(); // Ẩn cửa sổ main khi mở cửa sổ game
  };

  document.querySelector('#optionLnk').onclick = function () {
    // console.log('optionLnk');
  };

  document.querySelector('#aboutLnk').onclick = function () {
    app.exit(0);
  };

  // function buttonSetting() {
  //   // set style and action to buttons.
  //   document.querySelector('#startLnk').onclick = async function () {
  //   };
  //   document.querySelector('#optionLnk').onclick = async function () {
  //   };
  //   document.querySelector('#aboutLnk').onclick = function () {
  //   };
  // }
})();