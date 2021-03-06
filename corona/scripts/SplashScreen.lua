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

local scene = storyboard.newScene()


-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-SplashScreen" )

	local group = self.view

	local img = display.newImageRect( "assets/splash.png", 
		display.contentWidth, display.contentHeight )
	img.x = display.contentWidth * 0.50
	img.y = display.contentHeight * -0.50
	group:insert( img )
	self.img = img
	
end

function scene:cancelTween( obj )
	if( obj.tween ~= nil ) then
		transition.cancel( obj.tween )
		obj.tween = nil
	end
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-SplashScreen" )

	local group = self.view

	local img = self.img
	
	self:cancelTween( img )

	img.tween = transition.to( img, {time=600, y=display.contentHeight*0.50,
		transition=easing.outExpo,
		onComplete = function() 
			scene:cancelTween(img)
		end
	})

	timer.performWithDelay( 1000, function(e)
		storyboard.gotoScene( "scripts.MainScreen" )
	end )

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-SplashScreen" )

	local group = self.view

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
