-- ================================================
-- 
--	Project: Jumper
-- 
--	File: entities/entities/ent_trampoline/init.lua
--	Desc: Entry point for entity for client.
-- 
--	Modified: 2026/02/28 9:18 AM
--	Authors: The Kumor
-- 
-- ================================================

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:PhysicsCollide(data, physObj)
	local ent = data.HitEntity

	if ent:IsValid() and ent:IsPlayer() then
		ent:SetVelocity(Vector(0, 0, ent:GetVelocity().z + 1000))
		ent:EmitSound("jumper/funny_boing.wav")
	end
end