-----------------------------------------------------------------------------------------
-- Kiss Game
-- 31/07/2014
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
local composer = require "composer"

_W = display.contentWidth;
_H = display.contentHeight;
_vW = display.viewableContentWidth;
_vH = display.viewableContentHeight;
_X = (_W - _vW)/2;
_Y = (_H - _vH)/2;

_R = _vW/_W * _vH/_H

_G["selectedChar"] = "girl"
-- load menu screen
composer.gotoScene( "gameplay" )