-- ================================================
-- 
--	Project: Jumper
-- 
--	File: entities/entities/ent_coin/shared.lua
--	Desc: Defines how coin looks like.
-- 
--	Modified: 2026/02/28 9:18 AM
--	Authors: The Kumor
-- 
-- ================================================

ENT.Base = "base_anim"
ENT.Author = "The Kumor"

function ENT:Initialize()
	self:SetModel("models/props_c17/streetsign004f.mdl")
	self:SetMaterial("models/shiny")
	self:SetColor(Color(255, 255, 0))

	if SERVER then
		self:PhysicsInit(SOLID_NONE)
	end
end