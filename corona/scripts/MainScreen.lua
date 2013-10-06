--
--   Copyright 2013 John Pormann
--

local storyboard = require( "storyboard" )
local widget = require( "widget" )

local scene = storyboard.newScene()


local function processButton( event )
	if( event.target == scene.startBtn ) then
		storyboard.gotoScene( "scripts.GameScreen", {
			params = { action="new" }
		} )
		return true
	elseif( event.target == scene.contBtn ) then
		storyboard.gotoScene( "scripts.GameScreen", {
			params = { action="cont" }
		} )
		return true
	elseif( event.target == scene.setBtn ) then
		storyboard.gotoScene( "scripts.SettingsScreen" )
		return true
	elseif( event.target == scene.aboutBtn ) then
		storyboard.gotoScene( "scripts.AboutScreen" )
		return true
	end
	return false
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-MainScreen" )

	local group = self.view

	-- simple background image
	local img = display.newImageRect( "assets/mainbg.png",
		display.contentWidth, display.contentHeight )
	img.x = display.contentWidth * 0.50
	img.y = display.contentHeight * 0.50
	img.alpha = 0.25
	group:insert( img )
	self.img = img
	
	local w0,h0 = goodButtonSize()
	local yofs = 75

	local function getButton( txt )
		local btn = widget.newButton( {
			width  = w0,
			height = h0,
			label  = txt,
			onPress = processButton
		})
		--btn:setReferencePoint( display.TopLeftReferencePoint )
		btn:setReferencePoint( display.CenterReferencePoint )
		btn.x = display.contentWidth * 0.50
		return btn
	end

	local startBtn = getButton( "New Game" )
	startBtn.y  = yofs
	group:insert( startBtn )
	self.startBtn = startBtn
	yofs = yofs + 100
	
	local contBtn = getButton( "Continue Game" )
	contBtn.y  = yofs
	group:insert( contBtn )
	self.contBtn = contBtn
	yofs = yofs + 100

	local setBtn = getButton( "Settings" )
	setBtn.y   = yofs
	group:insert( setBtn )
	self.setBtn = setBtn
	yofs = yofs + 100

	local aboutBtn = getButton( "About Us" )
	aboutBtn.y = yofs
	group:insert( aboutBtn )
	self.aboutBtn = aboutBtn
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-MainScreen" )
	
	local group = self.view

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-MainScreen" )
	
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