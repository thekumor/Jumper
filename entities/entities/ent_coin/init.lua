-- ================================================================
--
--	Project: Jumper
--
--	Module: Entities
--	Component: Coin
--	File: init.lua
--
--	Purpose:
--	Animates coin (makes it spin). Makes it pickable.
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

function ENT:PhysicsCollide(colData, collider)
	if self.Touched then return end

	local ent = colData.HitEntity
	if ent and ent:IsPlayer() then
		self:EmitSound("items/smallmedkit1.wav")

		ent:SetNWInt("Coins", ent:GetNWInt("Coins", 0) + 1)
		
		-- NOTE: This is redundant, but I need it on leaderboard and I don't
		-- want to create my own.
		ent:SetFrags(ent:Frags() + 1)

		self.Touched = true

		self:Remove()
	end
end