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
	SecondsLeft = 10,
	PhaseID = 1,

	Phases = {
		[1] = {
			Name = "Waiting",
			Seconds = 30
		},
		[2] = {
			Name = "Playing",
			Seconds = 60
		},
		[3] = {
			Name = "Ended",
			Seconds = 100
		}
	}
}

if SERVER then
	util.AddNetworkString("jmp_RoundState")

	function GM:PlayerAuthed(ply, steamID, uniqueID)
		-- Gives player round state info on join
		net.Start("jmp_RoundState")
		net.WriteUInt(self.Round.SecondsLeft, 8)
		net.WriteUInt(self.Round.PhaseID, 8)
		net.Send(ply)
	end

	function GM:StartRound()
		local plys = player.GetAll()

		-- Tells every player that the round has started and how much time they have left
		net.Start("jmp_RoundState")
		net.WriteUInt(self.Round.SecondsLeft, 8)
		net.WriteUInt(self.Round.PhaseID, 8)
		net.Broadcast()

		timer.Create("CountTime", 1, 0, function()
			self.Round.SecondsLeft = self.Round.SecondsLeft - 1

				if GAMEMODE.Round.SecondsLeft == -1 then
					GAMEMODE.Round.PhaseID = GAMEMODE.Round.PhaseID + 1
					GAMEMODE.Round.SecondsLeft = GAMEMODE.Round.Phases[GAMEMODE.Round.PhaseID] and GAMEMODE.Round.Phases[GAMEMODE.Round.PhaseID].Seconds or 0

					hook.Run("NewRoundPhase", self.Round.PhaseID)
				end
		end)
	end

	function GM:EndRound()
		-- Tells every player that the round has ended
		net.Start("jmp_RoundState")
		net.WriteUInt(0, 8)
		net.WriteUInt(self.Round.PhaseID, 8)
		net.Broadcast()

		--timer.Remove("CountTime")

		local bestPlayer = nil
		for _, v in ipairs(player.GetAll()) do
			if not bestPlayer or v:GetNWInt("Coins") > bestPlayer:GetNWInt("Coins") then
				bestPlayer = v
			end
		end

		PrintMessage(HUD_PRINTTALK, bestPlayer:Nick() .. " wins with " .. bestPlayer:GetNWInt("Coins") .. " coins!")

		timer.Simple(10, function()
			game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
		end)
	end

	function GM:Start()
		self:StartRound()

		hook.Add("NewRoundPhase", "Jumper.ControlFlow", function(phaseID)
			if phaseID == 2 then
				GAMEMODE:SpawnTrampoline()
			elseif phaseID == 3 then
				GAMEMODE:EndRound()
			end
		end)
	end
else -- CLIENT
	net.Receive("jmp_RoundState", function(len)
		local secondsLeft = net.ReadUInt(8)
		local phase = net.ReadUInt(8)

		GAMEMODE.Round.SecondsLeft = secondsLeft
		GAMEMODE.Round.PhaseID = phase

		if not timer.Exists("CountTime") then
			timer.Create("CountTime", 1, 0, function()
				GAMEMODE.Round.SecondsLeft = GAMEMODE.Round.SecondsLeft - 1

				if GAMEMODE.Round.SecondsLeft == -1 then
					GAMEMODE.Round.PhaseID = GAMEMODE.Round.PhaseID + 1
					GAMEMODE.Round.SecondsLeft = GAMEMODE.Round.Phases[GAMEMODE.Round.PhaseID] and GAMEMODE.Round.Phases[GAMEMODE.Round.PhaseID].Seconds or 0
				end
			end)
		end
	end)
end