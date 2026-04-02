-- ================================================================
--
--	Project: Jumper
--
--	Module: Gamemode 
--	Component: Round
--	File: sh_round.lua
--
--	Purpose:
--	Manages round state lifecycle (start/end, timer countdown,
--	player positioning) and synchronizes round data between server
--	and clients via networking.
--
--	Author(s): The Kumor
--
-- ================================================================

GM.Round = {
	SecondsLeft = 20,
	Begun = false
}

if SERVER then
	util.AddNetworkString("jmp_RoundState")

	function GM:PlayerAuthed(ply, steamID, uniqueID)
		-- Gives player round state info on join
		net.Start("jmp_RoundState")
		net.WriteBool(self.Round.Begun)
		net.WriteUInt(self.Round.SecondsLeft, 8)
		net.Send(ply)
	end

	function GM:StartRound()
		if not self.MapTrampoline then return end

		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			local mins = self.MapTrampoline:OBBMins()
			local maxs = self.MapTrampoline:OBBMaxs()

			ply:SetPos(self.MapTrampoline:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(50, 100)))
		end

		self.Round.Begun = true
		-- Tells every player that the round has started and how much time they have left
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
		-- Tells every player that the round has ended
		net.Start("jmp_RoundState")
		net.WriteBool(false)
		net.WriteUInt(0, 8)
		net.Broadcast()

		timer.Remove("CountTime")

		local bestPlayer = nil
		for _, v in ipairs(player.GetAll()) do
			if not bestPlayer or v:GetNWInt("Coins") > bestPlayer:GetNWInt("Coins") then
				bestPlayer = v
			end
		end

		PrintMessage(HUD_PRINTTALK, bestPlayer:Nick() .. " wins with " .. bestPlayer:GetNWInt("Coins") .. " coins!")
	end

	function GM:Start()
		self:SpawnTrampoline()
		self:StartRound()
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