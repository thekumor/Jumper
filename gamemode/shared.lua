-- ================================================
-- 
--	Project: Jumper
-- 
--	File: gamemode/shared.lua
--	Desc: Checks if map is supported and defines
--		  basic information about gamemode.
-- 
--	Modified: 2026/02/28 10:07 AM
--	Authors: The Kumor
-- 
-- ================================================

include("sh_round.lua")

GM.Name = "Jumper"
GM.Author = "The Kumor"
GM.Website = "thekumor.com"
GM.Email = "contact@thekumor.com"

GM.ApprovedMaps = {
	["gm_flatgrass"] = {
		TrampolinePos = Vector(72, 72, -12286),
		CoinAmount = 20
	}
}
GM.BreakGame = true

function GM:Initialize()
	self.BaseClass:Initialize()

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