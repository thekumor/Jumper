-- ================================================
-- 
--	Project: Jumper
--	File: gamemode/cl_init.lua
--
--	Desc: Entry point for client.
--	Authors: The Kumor
-- 
-- ================================================

include("shared.lua")

local width, height = ScrW(), ScrH()
local screenCenter = Vector(width / 2, height / 2)

--
--	Assuming work resolution is 2560x1440
--
local function ConvertX(num)
	return num * width / 2560
end
local function ConvertY(num)
	return num * height / 1440
end

local function RecreateFonts()
	local crosshairFont = surface.CreateFont("CrosshairFont", {
		font = "Lato",
		size = ConvertY(28),
		antialias = true,
	})

	local hudFont = surface.CreateFont("HUDFont", {
		font = "Lato",
		size = ConvertX(36),
		antialias = true
	})
end
RecreateFonts()

hook.Add("Think", "Jumper.DetectResolutionChange", function()
	if ScrW() ~= width then
		width = ScrW()
		screenCenter.x = width / 2
		RecreateFonts()
	end
	if ScrH() ~= height then
		height = ScrH()
		screenCenter.y = height / 2
		RecreateFonts()
	end
end)

local colors = {
	white = Color(255, 255, 255),
	black = Color(0, 0, 0),
	
	transparent = {
		black = Color(0, 0, 0, 150)
	}
}
function GM:HUDPaint()
	-- Crosshair
	draw.DrawText(":", "CrosshairFont", screenCenter.x - ConvertX(1), screenCenter.y - ConvertY(14), colors.white, TEXT_ALIGN_CENTER)

	-- Coins: x/10
	--draw.RoundedBox(ConvertY(5), ConvertX(-6), ConvertY(-6), ConvertX(400), ConvertY(150), colors.transparent.black)
	draw.SimpleTextOutlined("Coins: " .. "0" .. "/" .. "10", "HUDFont", ConvertX(100), ConvertY(50), colors.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ConvertY(2), colors.black)

	-- Time (m:ss)
	local time = self.Round.SecondsLeft
	local seconds = time % 60
	local minutes = math.floor(time / 60)

	local secondsDisplay = tostring(seconds)
	local minutesDisplay = tostring(minutes)

	if minutes < 10 then minutesDisplay = "0" .. minutesDisplay end
	if seconds < 10 then secondsDisplay = "0" .. secondsDisplay end

	draw.SimpleTextOutlined(minutesDisplay .. ":" .. secondsDisplay, "HUDFont", screenCenter.x, ConvertY(50), colors.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ConvertY(2), colors.black)
end

local disabledHud = {
	"CHudCrosshair", "CHudHealth", "CHudBattery"
}
function GM:HUDShouldDraw(element)
	for i = 1, #disabledHud do
		if element == disabledHud[i] then
			return false
		end
	end

	return true
end

function GM:PreDrawHalos()
	halo.Add(ents.FindByClass("ent_coin"), colors.white)
end