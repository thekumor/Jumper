-- ================================================
-- 
--	Project: Jumper
--	File: gamemode/init.lua
--
--	Desc: Entry point for server.
--	Authors: The Kumor
-- 
-- ================================================

include("shared.lua")
include("sv_resource.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_round.lua")

function GM:PlayerInitialSpawn(ply)
	self.BaseClass:PlayerInitialSpawn(ply)
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
	
	mapTrampoline = trampoline

	if not trampoline:GetPhysicsObject():IsValid() then return end

	local mins = trampoline:OBBMins()
	local maxs = trampoline:OBBMaxs()

	-- Then, spawn coins
	for i = 1, mapData.CoinAmount do
		local coin = ents.Create("ent_coin")
		if not coin:IsValid() then continue end

		coin:SetPos(trampoline:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), 200 * i))
		coin:Spawn()
	end

	-- Make night
	-- TODO: make this shared??
	local skyPaint = ents.Create("env_skypaint")
	skyPaint:Spawn()
	skyPaint:SetDrawStars(true)
	skyPaint:SetTopColor(Vector(0.0, 0.0, 0.0))
	skyPaint:SetBottomColor(Vector(0.0, 0.0, 0.0))
end

function GM:GetFallDamage(ply, speed)
	return 0
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	return false
end