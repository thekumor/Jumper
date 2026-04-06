-- ================================================================
--
--	Project: Jumper
--
--	Module: Gamemode
--	File: init.lua
--
--	Purpose:
--	Handles player spawning behavior and initializes core map
--	entities, including the trampoline, coin placement, and
--	environment setup. Also overrides damage-related mechanics
--	(no fall damage / no player damage).
--
--	Author(s): The Kumor
--
-- ================================================================

include("shared.lua")
include("sv_resource.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_round.lua")

local hasPlayers = false
function GM:PlayerInitialSpawn(ply)
	self.BaseClass:PlayerInitialSpawn(ply)
	ply:SetNWInt("Coins", 0)

	if not hasPlayers then
		self:Start()
		hasPlayers = true
	end
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)

	ply:SetModel("models/player/kleiner.mdl")
	ply:SetPlayerColor(Vector(1, 0, 0))
	ply:SetupHands()
end

function GM:SpawnTrampoline()
	local mapData = self.ApprovedMaps[game.GetMap()]
	if not mapData then return end

	-- First, spawn trampoline on desired position
	local trampoline = ents.Create("ent_trampoline")
	if not trampoline:IsValid() then return end

	trampoline:SetPos(mapData.TrampolinePos or Vector(0, 0, 0))
	trampoline:SetAngles(Angle(0, 0, 0))
	trampoline:Spawn()
	
	self.MapTrampoline = trampoline

	local mins = self.MapTrampoline:OBBMins()
	local maxs = self.MapTrampoline:OBBMaxs()

	-- Move players to random positions on the trampoline
	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]

		ply:SetPos(self.MapTrampoline:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(50, 100)))
	end

	if not trampoline:GetPhysicsObject():IsValid() then return end

	-- Then, spawn coins
	for i = 1, mapData.CoinAmount do
		local coin = ents.Create("ent_coin")
		if not coin:IsValid() then continue end

		coin:SetPos(trampoline:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), 50 * i))
		coin:Spawn()
	end
end

function GM:GetFallDamage(ply, speed)
	-- TODO: If players were to drop off the map, I think they should die. But we'll see.
	return 0
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	return false
end