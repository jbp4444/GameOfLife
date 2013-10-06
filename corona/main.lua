--
--   Copyright 2013 John Pormann
--

local storyboard = require( "storyboard" )
require( "scripts.UtilityFuncs" )

screenW = display.contentWidth
screenH = display.contentHeight
screenHW = screenW *.5
screenHH = screenH *.5

debug_level = 0

settings = {
	fontSize = 20,
	init_pct = 33,
	speed = 2,
	sim_delay = 400,  -- tied to 'speed' above
	box_size = 10,
	black_white = false,
	colormap = 1
}

display.setStatusBar( display.HiddenStatusBar )

-- load splash screen
storyboard.gotoScene( "scripts.SplashScreen" )
