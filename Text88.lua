--------------------------------------------------
-- TOGGLE
--------------------------------------------------
if getgenv().ESP_TEAM then
	getgenv().ESP_TEAM = false

	-- borrar ESP existentes
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Highlight") and v.Name == "ESP_TEAM" then
			v:Destroy()
		end
	end

	return
end

getgenv().ESP_TEAM = true

--------------------------------------------------
-- SERVICIOS
--------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- BUSCAR MODELO REAL
--------------------------------------------------
local function getRealModel(player)

	for _,model in pairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model.Name == player.Name then

			if model:FindFirstChildWhichIsA("AudioEmitter", true)
			or model:FindFirstChild("GunSource", true) then
				return model
			end

		end
	end

end

--------------------------------------------------
-- APLICAR ESP
--------------------------------------------------
local function aplicarESP(player)

	if player == LocalPlayer then return end

	task.spawn(function()

		while player.Parent and getgenv().ESP_TEAM do

			if LocalPlayer.Team and player.Team then

				local myTeam = LocalPlayer.Team.Name
				local team = player.Team.Name

				if myTeam == "Criminals" or myTeam == "Sheriffs" then

					if team == myTeam then

						local model = getRealModel(player)

						if model then

							local h = model:FindFirstChild("ESP_TEAM")

							if not h then
								h = Instance.new("Highlight")
								h.Name = "ESP_TEAM"
								h.FillColor = Color3.fromRGB(0,255,0)
								h.OutlineColor = Color3.fromRGB(0,255,0)
								h.FillTransparency = 0.5
								h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
								h.Adornee = model
								h.Parent = model
							end

						end

					end

				end

			end

			task.wait(1)

		end

	end)

end

--------------------------------------------------
-- INICIAR
--------------------------------------------------
for _,player in pairs(Players:GetPlayers()) do
	aplicarESP(player)
end

Players.PlayerAdded:Connect(function(player)
	if getgenv().ESP_TEAM then
		aplicarESP(player)
	end
end)
