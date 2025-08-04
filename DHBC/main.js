'use strict';

var winControl = require('./lib/windowControl');
var {app, BrowserWindow} = require('electron');

app.on('window-all-closed', function() {
	if (process.platform != 'darwin')
		app.quit();
});

app.on('ready', function() {
	winControl.showMainWindow();
});