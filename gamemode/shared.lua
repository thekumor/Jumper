-- ================================================
-- 
--	Project: Jumper
-- 
--	File: gamemode/shared.lua
--	Desc: Checks if map is supported and defines
--		  basic information about gamemode.
-- 
--	Modified: 2026/02/28 9:18 AM
--	Authors: The Kumor
-- 
-- ================================================

GM.Name = "Jumper"
GM.Author = "The Kumor"
GM.Website = "thekumor.com"
GM.Email = "contact@thekumor.com"

GM.ApprovedMaps = {
	"gm_flatgrass"
}
GM.BreakGame = true

function GM:Initialize()
	self.BaseClass:Initialize()

	for i = 1, #self.ApprovedMaps do
		if game.GetMap() == self.ApprovedMaps[i] then
			self.BreakGame = false
			break
		end
	end

	if self.BreakGame then
		print("[Jumper] Fatal error: this map isn't supported!")
	end
end