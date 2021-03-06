player = {}
ranks = {"Spaceman", "Leading Spaceman", "Petty Officer", "Warrant Officer";
         "Midshipman"; "Ensign", "Sub-Lieutenant", "Lieutenant";
         "Lieutenant-Commander", "Commander", "Captain"; "Commodore",
         "Rear Admiral", "Vice Admiral", "Admiral", "Admiral of the Fleet"}
--fleetsizebyrank = {0, 0, 0, 0; 1; 2, 2, 2; 3, 3, 3; 5, 7, 7, 7, 10, 15}

function player.load()
	player.x = map.objects.homebase.x + 400
	player.y = map.objects.homebase.y
	player.dx = 0
	player.dy = 0
	player.angle = 0
	--player.acc = 20
	player.rank = 1
	player.ship = 'beginner'
	player.remove = false
end

function player.update(dt)
	local mult = love.keyboard.isDown("lshift") and 3 or 1
	local ship = ships[player.ship]
	local D = love.keyboard.isDown
	if D"up" or D"w" then
		player.autopilot = false
		player.braking = false
		local ddx = dt*math.cos(player.angle) * ship.acc * mult
		local ddy = dt*math.sin(player.angle) * ship.acc * mult
		if (ddx>0) ~= (player.dx>0) then ddx = ddx * ship.revengine end
		if (ddy>0) ~= (player.dy>0) then ddy = ddy * ship.revengine end
		player.dx = player.dx + ddx
		player.dy = player.dy + ddy
	end
	if D"right" or D"d" then
		player.autopilot = false
		player.braking = false
		player.angle = player.angle - dt * mult * ship.rot
	elseif D"left" or D"a" then
		player.autopilot = false
		player.braking = false
		player.angle = player.angle + dt * mult * ship.rot
	end
	if player.autopilot then
		if player.braking then
			player.braking = not ai.brake(player, dt)
		else
			if ai.approach(player, player.targetx, player.targety, dt) then
				player.autopilot = false
				player.braking = true
			end
		end
	elseif player.braking then
		player.braking = not ai.brake(player, dt) --stop after reaching target
	end
	player.x = player.x + player.dx * dt
	player.y = player.y + player.dy * dt
	if player.remove then
		--player died
		state.current = 'dead'
	end
end

local nextship = {beginner = 'vessel', vessel = 'fighter', fighter='bomber', bomber='speeder', speeder = 'betterspeeder', betterspeeder = 'superspeeder', superspeeder = 'beginner'}
function states.game.keypressed.tab()
	player.ship = nextship[player.ship]
end
function states.dead.keypressed.r()
	restart()
	state.current = 'game'
end

function player.draw()
end
