-- ================================================================
--
--	Project: Jumper
--
--	Module: Entities
--	Component: Pickup
--	File: shared.lua
--
--	Purpose:
--	Defines how pickup looks like both for client and server.
--
--	Author(s): The Kumor
--
-- ================================================================

ENT.Base = "base_anim"

function ENT:Initialize()
	self:SetModel("models/props_junk/PopCan01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
end