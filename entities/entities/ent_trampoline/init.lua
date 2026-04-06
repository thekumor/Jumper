-- ================================================================
--
--	Project: Jumper
--
--	Module: Entities
--	Component: Trampoline
--	File: init.lua
--
--	Purpose:
--	Bounces players off once they collide with trampoline, but
--	with a little delay.
--
--	Author(s): The Kumor
--
-- ================================================================

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local JMP_BOUNCE_DELAY = 0.2
local JMP_BOUNCE_POWER = 200

function ENT:PhysicsCollide(data, physObj)
	local ent = data.HitEntity

	if ent:IsValid() and ent:IsPlayer() then
		timer.Simple(JMP_BOUNCE_DELAY, function()
			if ent:GetVelocity().z > 0 then return end
			
			ent.TrampolinePower = (ent.TrampolinePower or 0) + JMP_BOUNCE_POWER

			ent:SetVelocity(Vector(0, 0, ent:GetVelocity().z + ent.TrampolinePower))
			ent:EmitSound("jumper/boing.wav")
		end)
	end
end