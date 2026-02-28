-- ================================================
-- 
--	Project: Jumper
-- 
--	File: entities/entities/ent_trampoline/shared.lua
--	Desc: Defines how trampoline looks like.
-- 
--	Modified: 2026/02/28 9:18 AM
--	Authors: The Kumor
-- 
-- ================================================

ENT.Base = "base_anim"
ENT.Author = "The Kumor"

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/plastic/plastic_panel8x8.mdl")
	self:SetMaterial("models/debugwhite")
	self:SetColor(Color(100, 0, 200))

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		local physicsObject = self:GetPhysicsObject()

		if physicsObject:IsValid() then
			physicsObject:EnableMotion(false)
		end
	end
end