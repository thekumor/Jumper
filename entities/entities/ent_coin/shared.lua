-- ================================================================
--
--	Project: Jumper
--
--	Module: Entities
--	Component: Coin
--	File: shared.lua
--
--	Purpose:
--	Defines how coin looks like both for client and server.
--
--	Author(s): The Kumor
--
-- ================================================================

ENT.Base = "base_anim"

function ENT:Initialize()
	self:SetModel("models/props_c17/streetsign004f.mdl")
	self:SetMaterial("models/shiny")
	self:SetColor(Color(255, 255, 0))
	self:PhysicsInit(SOLID_VPHYSICS)
end