--// ESP Dinámico Npc or Die: tu equipo + NPCs según rol con destrucción automática
--// RAW / LOCAL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ======== DESTRUCCIÓN SI YA EXISTE ========
if _G.ESPTeamHighlights then
	for target, hl in pairs(_G.ESPTeamHighlights) do
		if hl then hl:Destroy() end
	end
	_G.ESPTeamHighlights = nil
	print("ESP de equipo destruido ❌")
	return
end

-- ======== VARIABLES ========
local highlights = {}
_G.ESPTeamHighlights = highlights

-- ======== FUNCIONES ========
local function aplicarHighlight(target, color, visible)
	if not target or not target:IsA("Model") then return end

	if not highlights[target] then
		local hl = Instance.new("Highlight")
		hl.Name = "ESP_Highlight"
		hl.Adornee = target
		hl.FillTransparency = 0.5
		hl.OutlineTransparency = 0
		hl.Parent = workspace
		highlights[target] = hl
	end

	local hl = highlights[target]
	hl.FillColor = color
	hl.OutlineColor = color
	hl.Enabled = visible
end

local function obtenerMiRol()
	if LocalPlayer.Team then
		local t = LocalPlayer.Team.Name:lower()
		if t == "sheriffs" then
			return "sheriff"
		elseif t == "criminals" then
			return "criminal"
		else
			return "lobby"
		end
	else
		return "lobby"
	end
end

local function obtenerRol(plr)
	if plr.Team then
		local t = plr.Team.Name:lower()
		if t == "sheriffs" then
			return "sheriff"
		else
			return "criminal"
		end
	else
		return "criminal"
	end
end

-- ======== LOOP ESP ========
local conn
conn = RunService.Heartbeat:Connect(function()
	local miRol = obtenerMiRol()
	local color = Color3.fromRGB(0, 255, 0) -- verde para tu equipo

	if miRol == "lobby" then
		for target, hl in pairs(highlights) do
			if hl then hl:Destroy() end
		end
		highlights = {}
		return
	end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local plrRol = obtenerRol(plr)
			local mismoEquipo = (plrRol == miRol)
			aplicarHighlight(plr.Character, color, mismoEquipo)
		end
	end

	if miRol == "criminal" then
		for _, npc in pairs(Workspace:GetDescendants()) do
			if npc:IsA("Model") and npc.Name:find("NPC") then
				aplicarHighlight(npc, color, true)
			end
		end
	end
end)

-- ======== LIMPIEZA ========
Players.PlayerRemoving:Connect(function(player)
	if highlights[player] then
		highlights[player]:Destroy()
		highlights[player] = nil
	end
end)
