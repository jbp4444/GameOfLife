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

local Game = {}

local top_offset = 50


function Game.new( )

	local game = display.newGroup()
	 
	-- per box size (w==h)
	local color_alive = {255,0,0}
	local color_dead = {0,0,0}
	local color_grid = {44,44,44}

	-- game parameters
	local die_if_le = 1
	local die_if_ge = 4
	local grow_if_le = 3
	local grow_if_ge = 3
	
	local Xdim = math.floor( display.contentWidth / settings.box_size )
	local Ydim = math.floor( (display.contentHeight-top_offset) / settings.box_size )

	-- all the data is kept in 'grid' table	
	local grid = {}
	
	function game:touch( event )
		local x = event.x
		local y = event.y
		local r = math.floor( (y-top_offset)/settings.box_size ) + 1
		local c = math.floor( x/settings.box_size ) + 1
		local box = grid[r][c]
		box.stim = 1
		box:setFillColor( color_alive[1],color_alive[2],color_alive[3] )
		return true
	end

	-- initialize with random data
	function game:initRandom( start_pct )
		for r=1,Ydim do
			for c=1,Xdim do
				local box = grid[r][c]
				if( math.random(0,100) < start_pct ) then
					box.state = 1
				else
					box.state = 0
				end 
				if( box.state == 1 ) then
					box:setFillColor( color_alive[1],color_alive[2],color_alive[3] )
				else
					box:setFillColor( color_dead[1],color_dead[2],color_dead[3] )
				end
			end
		end
	end

	-- for max frame rate, listen for "enterFrame" events instead of "timer" events
	--function game:enterFrame( e )
	function game:timer()
		
		for r=1,Ydim do
			for c=1,Xdim do
				local box = grid[r][c]
				if( box.stim == 1 ) then
					box.new_state = 1
					box.stim = 0
				else
					local ctr = grid[r-1][c].state   + grid[r-1][c-1].state 
							+   grid[r-1][c+1].state + grid[r+1][c].state 
							+   grid[r+1][c-1].state + grid[r+1][c+1].state
							+   grid[r][c-1].state   + grid[r][c+1].state 
					
					if( (ctr <= die_if_le) or (ctr >= die_if_ge) ) then
						box.new_state = 0
					elseif( (ctr <= grow_if_le) and (ctr >= grow_if_ge) ) then
						box.new_state = 1
					else
						-- otherwise, state remains the same
						box.new_state = box.state
					end
				end
			end
		end
		
		for r=1,Ydim do
			for c=1,Xdim do
				local box = grid[r][c]
				box.state = box.new_state
				if( box.state == 1 ) then
					box:setFillColor( color_alive[1],color_alive[2],color_alive[3] )
				else
					box:setFillColor( color_dead[1],color_dead[2],color_dead[3] )
				end
			end
		end
		
		return true
	end

	function game:startGame()
		-- iteration count=0 means infinite loop
		local timer_obj = timer.performWithDelay( settings.sim_delay, game, 0 )
		self.timer_obj = timer_obj

		-- for max frame rate, listen for "enterFrame" events instead of "timer" events
		--Runtime:addEventListener( "enterFrame", game )
		
		-- start watching for touch events
		game:addEventListener( "touch", game )
	end
	
	function game:stopGame()
		-- we'll turn off the timer
		local timer_obj = self.timer_obj
		if( timer_obj ~= nil ) then
			timer.cancel( timer_obj )
			self.timer_obj = nil
		end
		
		-- and stop listening for touch events
		game:removeEventListener( "touch", game )
	end	
	
	function game:resumeGame()
		-- iteration count=0 means infinite loop
		local timer_obj = timer.performWithDelay( settings.sim_delay, game, 0 )
		self.timer_obj = timer_obj
	end
	
	function game:pauseGame()
		-- we'll turn off the timer
		local timer_obj = self.timer_obj
		timer.cancel( timer_obj )
		self.timer_obj = nil
	end	

	-- -- -- -- -- -- -- -- -- -- -- --
	 -- -- -- -- -- -- -- -- -- -- -- 
	-- -- -- -- -- -- -- -- -- -- -- --

	function game:initGame()
		-- set the initial colormap
		if( settings.colormap == 1 ) then
			color_alive = {255,0,0}
			color_dead = {0,0,0} 
		elseif( settings.colormap == 2 ) then
			color_alive = {0,0,255}
			color_dead = {0,0,0} 
		elseif( settings.colormap == 3 ) then
			color_alive = {255,255,255}
			color_dead = {0,0,0} 
		else
		end

		-- create the game board
		for r=1,Ydim do
			grid[r] = {}
			for c=1,Xdim do
				local box = display.newRect( game, 
					(c-1)*settings.box_size + 1, 
					(r-1)*settings.box_size + top_offset, 
					settings.box_size,settings.box_size )
				box:setReferencePoint( display.TopLeftReferencePoint )
				box:setFillColor( color_dead[1], color_dead[2], color_dead[3] )
				box.strokeWidth = 1
				box:setStrokeColor( color_grid[1],color_grid[2],color_grid[3] )
				box.row = r
				box.col = c
				box.stim = 0
				box.new_state = 0
				grid[r][c] = box
			end
		end
		-- "fake" the wrap-around at the edges
		grid[0] = {}
		grid[Ydim+1] = {}
		for c=1,Xdim do
			grid[0][c] = grid[Ydim][c]
			grid[Ydim+1][c] = grid[1][c]
		end
		for r=1,Ydim do
			grid[r][0] = grid[r][Xdim]
			grid[r][Xdim+1] = grid[r][1]
		end
		grid[0][0]           = grid[Ydim][Xdim]
		grid[Ydim+1][Xdim+1] = grid[1][1]
		grid[Ydim+1][0]      = grid[0][Xdim]
		grid[0][Xdim+1]      = grid[Ydim][0]
	
		-- allow for other kinds of initialization?
		game:initRandom( settings.init_pct )
	end
	
	game:initGame()
	
	return game
end

return Game
