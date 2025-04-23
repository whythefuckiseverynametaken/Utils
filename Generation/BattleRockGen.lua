local rockGen = {}

--[[
Example usage
AbilityFX:SpawnGroundRocks({
    origin = Vector3.new(0, 0, 0),
    amount = 15,
    radius = 30,
    duration = 2,
    assetFolder = ReplicatedStorage.RockChunks,
    pathType = "circular"
})

used for rock generation when using abilities
]]

function rockGen:SpawnGroundRocks(config: table)
	local origin = config.origin or Vector3.zero
	local amount = config.amount or 10
	local radius = config.radius or 20
	local duration = config.duration or 2
	local rocks = config.assetFolder:GetChildren()
	local pathType = config.pathType or "random"

	for i = 1, amount do
		local rock = rocks[math.random(1, #rocks)]:Clone()
		local angle = math.rad((360 / amount) * i)
		local offset

		if pathType == "circular" then
			offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * math.random(radius / 2, radius)
		elseif pathType == "linear" then
			offset = Vector3.new(i * 3, 0, 0)
		else
			offset = Vector3.new(
				math.random(-radius, radius),
				0,
				math.random(-radius, radius)
			)
		end

		local spawnPos = origin + offset
		rock.Position = spawnPos
		rock.Anchored = false
		rock.Parent = workspace

		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0, math.random(30, 50), 0)
		bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 1e5
		bodyVelocity.Parent = rock

		game.Debris:AddItem(rock, duration)
	end
end

return rockGen