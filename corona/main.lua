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
