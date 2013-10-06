--
--   Copyright 2013 John Pormann
--
--   Licensed under the Apache License, Version 2.0 (the "License");
--   you may not use this file except in compliance with the License.
--   You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an "AS IS" BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--   See the License for the specific language governing permissions and
--   limitations under the License.
--

local storyboard = require( "storyboard" )
local widget = require( "widget" )

local gameClass = require( "scripts.TheGame" )

local scene = storyboard.newScene()

local plist = {}

local function processButton( event )
	if( event.target == scene.backBtn ) then
		storyboard.gotoScene( "scripts.MainScreen" )
		return true
	elseif( event.target == scene.pauseBtn ) then
		local game = scene.game
		if( scene.game_running == true ) then
			game:pauseGame()
			scene.game_running = false
			local btn = scene.pauseBtn
			btn:setLabel( "Resume" )
		else
			game:resumeGame()
			scene.game_running = true
			local btn = scene.pauseBtn
			btn:setLabel( "Pause" )
		end
		return true
	end
	return false
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-GameScreen" )
	
	local group = self.view

	local pauseBtn = widget.newButton( {
			width  = 75,
			height = 25,
			left = 10,
			top = 10,
			label  = "Pause",
			fontSize = 12,
			onPress = processButton
	})
	pauseBtn:setReferencePoint( display.TopLeftReferencePoint )
	group:insert( pauseBtn )
	self.pauseBtn = pauseBtn

	local backBtn = widget.newButton( {
			width  = 75,
			height = 25,
			left = display.contentWidth - 80,
			top = 10,
			label  = "Back",
			fontSize = 12,
			onPress = processButton
	})
	backBtn:setReferencePoint( display.TopLeftReferencePoint )
	group:insert( backBtn )
	self.backBtn = backBtn

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-GameScreen" )
	
	local group = self.view

	local params = event.params
	local action = "new"
	if( params ~= nil ) then
		action = params.action
	end

	if( action == "new" ) then
		-- TODO: should I nil-out the old self.game var?
		if( self.game ~= nil ) then
			group:remove( self.game )
		end
		
		local game = gameClass.new()
		group:insert( game )
		self.game = game
		game:startGame()
	else
		local game = self.game
		game:startGame()
	end
	
	self.game_running = true
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-GameScreen" )

	local group = self.view

	local game = self.game
	game:stopGame()
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

	-----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene
