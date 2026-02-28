-- ================================================
-- 
--	Project: Jumper
-- 
--	File: entities/entities/ent_coin/init.lua
--	Desc: Entry point for entity for server.
-- 
--	Modified: 2026/02/28 9:18 AM
--	Authors: The Kumor
-- 
-- ================================================

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

ENT.Ticking = 0
function ENT:Think()
	self.Ticking = self.Ticking < 360 and self.Ticking + 10 or 0
	self:SetAngles(Angle(0, self.Ticking, 0))
end