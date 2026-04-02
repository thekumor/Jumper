-- ================================================================
--
--	Project: Jumper
--
--	Module: Gamemode
--	Component: Pickup
--	File: init.lua
--
--	Purpose:
--	Animates pickup (makes it spin).
--
--	Author(s): The Kumor
--
-- ================================================================

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Think()
	self:SetAngles(Angle(0, CurTime() * 100, 0))
end