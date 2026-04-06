-- ================================================================
-- 
--	Project: Jumper
--
--	Module: Gamemode
--	File: shared.lua
--
--	Purpose:
--	Checks to see if map is supported for this gamemode.
--
--	Author(s): The Kumor
-- 
-- ================================================================

include("sh_round.lua")

GM.Name = "Jumper"
GM.Author = "The Kumor"
GM.Website = "thekumor.com"
GM.Email = "contact@thekumor.com"

-- Add your maps here
-- Format is ["map_name"] = {TrampolinePos = Vector(x, y, z), CoinAmount = numCoins}
GM.ApprovedMaps = {
	["gm_flatgrass"] = {
		TrampolinePos = Vector(72, 72, -12286),
		CoinAmount = 20
	},

	["gm_construct"] = {
		TrampolinePos = Vector(0, 0, 0),
		CoinAmount = 30
	}
}
function GM:GetMapData()
	return self.ApprovedMaps[game.GetMap()]
end

GM.BreakGame = true

function GM:Initialize()
	self.BaseClass:Initialize()

	-- Check if map is supported
	for k, v in pairs(self.ApprovedMaps) do
		if game.GetMap() == k then
			self.BreakGame = false
			break
		end
	end

	if self.BreakGame then
		print("[Jumper] Fatal error: this map isn't supported!")
	end
end