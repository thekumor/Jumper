-- ================================================
-- 
--	Project: Jumper
-- 
--	File: gamemode/init.lua
--	Desc: Entry point for server.
-- 
--	Modified: 2026/02/28 9:18 AM
--	Authors: The Kumor
-- 
-- ================================================

include("shared.lua")
include("sv_resource.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function GM:PlayerInitialSpawn(ply)
	self.BaseClass:PlayerInitialSpawn(ply)
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)

	ply:SetModel("models/player/kleiner.mdl")
	ply:SetPlayerColor(Vector(1, 0, 0))
	ply:SetupHands()
end

function GM:GetFallDamage(ply, speed)
	return 0
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	return false
end