-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local TNT = require("tnt")
local scene = composer.newScene()

--------------------------------------------
local startCountDown, startGame, checkStatus
local boyImg, girlImg
local group
local life = 3
local score = 0
local current = "boy"
local gameStatus = "OK"
local lifeText = nil
local scoreText = nil

function scene:create( event )
	local sceneGroup = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect(sceneGroup, "background.jpg", _W, _H)
	background.x, background.y = _W/2, _H/2

	boyImg = display.newImageRect(sceneGroup, "boy.png", 122, 207)
	boyImg.x, boyImg.y = -_W/2, _H/2
	boyImg.id = "boy"

	girlImg = display.newImageRect(sceneGroup, "girl.png",122, 207)
	girlImg.x, girlImg.y = -_W/2, _H/2
	girlImg.id = "girl"

	boyImg:addEventListener( "touch", onTouch )
	girlImg:addEventListener( "touch", onTouch )

	lifeText = display.newEmbossedText( sceneGroup, "Life 3", 0, 0, native.systemFontBold, 40 )
	lifeText.x, lifeText.y = _W/2, _H*0.05

	scoreText = display.newEmbossedText( sceneGroup, "Score 0", 0, 0, native.systemFontBold, 40 )
	scoreText.x, scoreText.y = _W/2, _H*0.95
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	group = sceneGroup

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.

		startCountDown(sceneGroup)

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	

end

---------------------------------------------------------------------------------------------------------
-- Show the Countdown
---------------------------------------------------------------------------------------------------------
startCountDown = function(sceneGroup)
	local timerText = display.newEmbossedText( sceneGroup, "3", 0, 0, native.systemFontBold, 90 )
	timerText.x, timerText.y = _W/2, _H/2

	local function changeText()
		if(timerText.text == "3")then timerText.text = "2", TNT:newTimer(1000, changeText)
			elseif(timerText.text == "2")then timerText.text = "1", TNT:newTimer(1000, changeText) 
				elseif(timerText.text == "1")then timerText.text = "GO", TNT:newTimer(500, function() 
																								display.remove(timerText);
																								timerText = nil;
																								startGame()
																							end) 
				end

	end
	TNT:newTimer(1000, changeText)

end

---------------------------------------------------------------------------------------------------------
-- Show the Countdown
---------------------------------------------------------------------------------------------------------
startGame = function ( ... )

	newJump = function ( ... )
		local rand = math.random(0,99)

		if(rand % 2 == 1)then
			boyImg.condition = "fresh"
			current = "boy"
			TNT:newTransition(boyImg, {time = 1000, x = _W*1.2, onComplete = checkStatus})
		else
			girlImg.condition = "fresh"
			current = "girl"
			TNT:newTransition(girlImg, {time = 1000, x = _W*1.2, onComplete = checkStatus})
		end
	end

	
	newJump()
end


checkStatus = function ()
	boyImg.x, boyImg.y = -_W*0.2, math.random(_H*0.3, _H*0.7)
	girlImg.x, girlImg.y = -_W*0.2, math.random(_H*0.3, _H*0.7)

	if(boyImg.condition == "fresh" and current == "boy" and _G["selectedChar"] == "boy")then
		life = life - 1
		lifeText.text = "Life "..life
		if(life == 0)then gameOver() 
		else newJump() end
	elseif(girlImg.condition == "fresh" and current == "girl" and _G["selectedChar"] == "girl")then
		life = life - 1
		lifeText.text = "Life "..life
		if(life == 0)then gameOver() 
		else newJump() end
	elseif(gameStatus == "OK")then
		newJump()
	end
end

onTouch = function ( event )
	if(event.phase == "ended") then
		event.target.condition = "touched"
		if ((_G["selectedChar"] == "girl" and event.target.id == "girl") or (_G["selectedChar"] == "boy" and event.target.id == "boy")) then
			score = score + 1
			scoreText.text = "Score "..score
		else
			lifeText.text = "Game Over"
			gameOver()
		end
	end
end

gameOver = function (  )
	TNT:cancelAllTransitions()
end
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene