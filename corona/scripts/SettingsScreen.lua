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

local function stepperListener( event )
	local tgt = event.target
	
	if( event.phase == "increment" ) then
		settings.box_size = settings.box_size + 1
    elseif( event.phase == "decrement" ) then
		settings.box_size = settings.box_size - 1
    end
	scene.boxszTxt.text = settings.box_size

	return true
end

local function slider1Listener( event )
    local slider = event.target
    local value = event.value

	settings.init_pct = value
	
	scene.initpctTxt.text = value

	return true	
end

local function speed2word( val )
	local txt = "Medium"
	if( val > 500 ) then
		txt = "Slow"
	elseif( val < 200 ) then
		txt = "Fast"
	end
	return txt
end

local function slider2Listener( event )
    local slider = event.target
    local value = event.value

	settings.sim_delay = 6*value + 100
	
	scene.speedTxt.text = speed2word(settings.sim_delay)
	
	return true	
end

local function segmentListener( event )
    local target = event.target
	local num = target.segmentNumber

	-- hard-code the slow/med/fast mapping to delay-time
	settings.colormap = num

	return true
end

local function switchListener( event )
    local switch = event.target
	settings.black_white = switch.isOn
end


local function processButton( event )
	if( event.target == scene.backBtn ) then
		storyboard.gotoScene( "scripts.MainScreen" )
		return true
	end
	return false
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-SettingsScreen" )
	
	local group = self.view
	
	local yofs = 25
	
	-- stepper for box-size for grid
	local boxszExpl = display.newText( "Box Size for Grid:", 20,20,
		native.systemFont, 20 )
	boxszExpl:setReferencePoint( display.TopRightReferencePoint )
	boxszExpl.x = display.contentWidth * 0.50 + 75
	boxszExpl.y = yofs
	group:insert( boxszExpl )
	self.boxszExpl = boxszExpl
	yofs = yofs + 25
	
	local boxszTxt = display.newText( settings.box_size, 20,20,
		native.systemFont, 20 )
	boxszTxt:setReferencePoint( display.TopRightReferencePoint )
	boxszTxt.x = display.contentWidth * 0.50
	boxszTxt.y = yofs
	group:insert( boxszTxt )
	self.boxszTxt = boxszTxt
	
	local boxszWgt = widget.newStepper({
		left = display.contentWidth*0.50 + 20,
		top  = yofs,
		width = 40,
		height = 20,
		initialValue = settings.box_size,
		minimumValue = 5,
		maximumValue = 50,
		onPress = stepperListener
	})
	group:insert( boxszWgt )
	self.boxszWgt = boxszWgt

	yofs = yofs + 50
	
	-- slider for initial percent of cells that are alive
	local initpctExpl = display.newText( "Init Pct of 'Alive' Cells:", 20,20,
		native.systemFont, 20 )
	initpctExpl:setReferencePoint( display.TopRightReferencePoint )
	initpctExpl.x = display.contentWidth * 0.50 + 75
	initpctExpl.y = yofs
	group:insert( initpctExpl )
	self.initpctExpl = initpctExpl
	yofs = yofs + 25
	
	local initpctTxt = display.newText( settings.init_pct, 20,20,
		native.systemFont, 20 )
	initpctTxt:setReferencePoint( display.TopRightReferencePoint )
	initpctTxt.x = display.contentWidth * 0.50
	initpctTxt.y = yofs
	group:insert( initpctTxt )
	self.initpctTxt = initpctTxt
	
	local initpctWgt = widget.newSlider({
		left = display.contentWidth*0.50 + 20,
		top  = yofs,
		width = 80,
		height = 20,
		value = settings.init_pct,
		orientation = "horizontal",
		listener = slider1Listener
	})
	group:insert( initpctWgt )
	self.initpctWgt = initpctWgt

	yofs = yofs + 50
	
	-- 1-of-N selector for speed
	local speedExpl = display.newText( "Simulation Speed:", 20,20,
		native.systemFont, 20 )
	speedExpl:setReferencePoint( display.TopRightReferencePoint )
	speedExpl.x = display.contentWidth * 0.50 + 75
	speedExpl.y = yofs
	group:insert( speedExpl )
	self.speedExpl = speedExpl
	yofs = yofs + 25

	local speedTxt = display.newText( speed2word(settings.sim_delay), 20,20,
		native.systemFont, 20 )
	speedTxt:setReferencePoint( display.TopRightReferencePoint )
	speedTxt.x = display.contentWidth * 0.50
	speedTxt.y = yofs
	group:insert( speedTxt )
	self.speedTxt = speedTxt

	local speedWgt = widget.newSlider({
		left = display.contentWidth*0.50 + 20,
		top  = yofs,
		width = 80,
		height = 20,
		value = (settings.sim_delay-100)/600,
		orientation = "horizontal",
		listener = slider2Listener
	})	
	group:insert( speedWgt )
	self.speedWgt = speedWgt
	
	yofs = yofs + 50

	-- slider for initial percent of cells that are alive
	local colorExpl = display.newText( "Black & White:", 20,20,
		native.systemFont, 20 )
	colorExpl:setReferencePoint( display.TopRightReferencePoint )
	colorExpl.x = display.contentWidth * 0.50 + 75
	colorExpl.y = yofs
	group:insert( colorExpl )
	self.colorExpl = colorExpl
	yofs = yofs + 25
	
	local colorWgt = widget.newSegmentedControl({
		left = display.contentWidth*0.50 - 150,
		top  = yofs,
		--width = 300,      -- auto-calculate the right width
		height = 20,
		segmentWidth = 100,
		segments = { "Red", "Blue", "B/W" },
		defaultSegment = settings.colormap,
		--value = settings.init_pct,
		orientation = "horizontal",
		onPress = segmentListener
	})
	if(1==0) then
	local colorWgt = widget.newSwitch({
		left = display.contentWidth*0.50 + 20,
		top  = yofs,
		width = 40,
		height = 20,
		style = "onOff",
		initialSwitchState = false,
		onPress = switchListener
	})
	end
	group:insert( colorWgt )
	self.colorWgt = colorWgt


	local backBtn = widget.newButton( {
			width  = 100,
			height = 50,
			left = display.contentWidth - 110,
			top = display.contentHeight - 60,
			label  = "Back",
			onPress = processButton
	})
	group:insert( backBtn )
	self.backBtn = backBtn
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-SettingsScreen" )
	
	local group = self.view

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-SettingsScreen" )

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
