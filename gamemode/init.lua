include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function GM:PlayerInitialSpawn(ply)
    self.BaseClass:PlayerInitialSpawn(ply)
end

function GM:PlayerSpawn(ply)
    self.BaseClass:PlayerSpawn(ply)

    ply:SetModel("models/player/kleiner.mdl")
    ply:SetPlayerColor(Vector(1, 0, 0))
    ply:SetupHands()
end