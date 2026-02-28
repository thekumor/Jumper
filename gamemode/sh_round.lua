-- ================================================
-- 
--	Project: Jumper
-- 
--	File: gamemode/sh_round.lua
--	Desc: Handles round for both client and server.
-- 
--	Modified: 2026/02/28 3:42 PM
--	Created: 2026/02/28 3:29 PM
--	Authors: The Kumor
-- 
-- ================================================

GM.Round = {
	SecondsLeft = 20,
	Begun = false
}

if SERVER then
	util.AddNetworkString("jmp_RoundState")

	function GM:PlayerAuthed(ply, steamID, uniqueID)
		net.Start("jmp_RoundState")
		net.WriteBool(self.Round.Begun)
		net.WriteUInt(self.Round.SecondsLeft, 8)
		net.Send(ply)
	end

	function GM:StartRound()
		if not mapTrampoline then return end

		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			local mins = mapTrampoline:OBBMins()
			local maxs = mapTrampoline:OBBMaxs()

			ply:SetPos(mapTrampoline:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(50, 100)))
		end

		self.Round.Begun = true
		net.Start("jmp_RoundState")
		net.WriteBool(true)
		net.WriteUInt(self.Round.SecondsLeft, 8)
		net.Broadcast()

		timer.Create("CountTime", 1, 0, function()
			self.Round.SecondsLeft = self.Round.SecondsLeft - 1

			if self.Round.SecondsLeft == -1 then
				self.Round.SecondsLeft = 0

				self:EndRound()
			end
		end)
	end

	function GM:EndRound()
		self.Round.Begun = false
		net.Start("jmp_RoundState")
		net.WriteBool(false)
		net.WriteUInt(0, 8)
		net.Broadcast()

		timer.Remove("CountTime")
	end
else -- CLIENT
	net.Receive("jmp_RoundState", function(len)
		local roundActive = net.ReadBool()
		local secondsLeft = net.ReadUInt(8)

		GAMEMODE.Round.Begun = roundActive
		GAMEMODE.Round.SecondsLeft = secondsLeft

		if roundActive then
			timer.Create("CountTime", 1, 0, function()
				GAMEMODE.Round.SecondsLeft = GAMEMODE.Round.SecondsLeft - 1
			end)
		else
			-- if timer.Exists("CountTime") then
			timer.Remove("CountTime")
			-- end
		end
	end)
end