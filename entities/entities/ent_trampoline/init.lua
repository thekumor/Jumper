-- ================================================
-- 
--	Project: Jumper
-- 
--	File: entities/entities/ent_trampoline/init.lua
--	Desc: Entry point for entity for client.
-- 
--	Modified: 2026/02/28 10:36 AM
--	Authors: The Kumor
-- 
-- ================================================

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:PhysicsCollide(data, physObj)
	local ent = data.HitEntity

	if ent:IsValid() and ent:IsPlayer() then
		timer.Simple(0.5, function()
			if (ent:GetVelocity().z > 0) then return end
			ent:SetVelocity(Vector(0, 0, ent:GetVelocity().z + 400))
			ent:EmitSound("jumper/boing.wav")
		end)
	end
end