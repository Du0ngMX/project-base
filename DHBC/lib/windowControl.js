'use strict';

var electron = require('electron');
var app = electron.app;
var ipcMain = electron.ipcMain;
var dialog = electron.dialog;
var BrowserWindow = electron.BrowserWindow;

var winControl = {
	mainWindow: null,

	// Create and display the main window
	showMainWindow: function() {
		this.mainWindow = new BrowserWindow({
			width: 500, 
			height: 600, 
			show: false, 
			resizable: false,
			webPreferences: {
				nodeIntegration: true,
				contextIsolation: false
			}
		});
		this.mainWindow.loadURL('file://' + __dirname + '/../contents/main_window/index.html');
		this.mainWindow.setMenu(null);

		// Close all other windows when hidden
		this.mainWindow.on('closed', () => {
			console.log('main window closed.');
			this.mainWindow = null;
		});

		this.mainWindow.once('ready-to-show', () => {
			this.mainWindow.show();
		});
	},

	// Create and display album window. Specify an image to display as an argument
	showPlayWindow: function() {
		let playWindow = new BrowserWindow({
			width: 600, 
			height: 900, 
			show: true, 
			resizable: false,
			webPreferences: {
				nodeIntegration: true,
				contextIsolation: false
			}
		});
		playWindow.loadURL('file://' + __dirname + '/../contents/play_window/index.html');
		playWindow.setMenu(null);

		playWindow.on('closed', () => {
			console.log('play window closed.');
			// Hiện lại main window khi đóng play window
			if (this.mainWindow && !this.mainWindow.isDestroyed()) {
				this.mainWindow.show();
			}
			playWindow = null;
		});
	},
};

module.exports = winControl;

