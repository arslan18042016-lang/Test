local tool = script.Parent
local handle = tool:FindFirstChild("Handle")
if not handle then
warn("В инструменте RayGun нет Handle!")
return
end
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local DAMAGE = 30
local RANGE = 200
local COOLDOWN = 0.15 -- секунды между выстрелами
local BEAM_COLOR = Color3.fromRGB(255, 50, 50)
local BEAM_WIDTH = 0.4
local isOnCooldown = false
local function fireRay(character, rootPart)
if isOnCooldown then return end
isOnCooldown = true
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then return end
-- Направление взгляда персонажа (упрощённо через камеру, но можно и через HumanoidRootPart)
local camera = workspace.CurrentCamera
local unitRay = camera:ScreenPointToRay(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.FilterDescendantsInstances = {character} -- Не попадаем в себя
local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * RANGE, raycastParams)
if result then
-- 1. Наносим урон
local hitCharacter = result.Instance.Parent:FindFirstChildWhichIsA("Model")
if hitCharacter and hitCharacter ~= character then
local targetHumanoid = hitCharacter:FindFirstChildOfClass("Humanoid")
if targetHumanoid then
targetHumanoid:TakeDamage(DAMAGE)
end
end
-- 2. Рисуем красивый луч (Beam)
local startAttachment = Instance.new("Attachment")
startAttachment.Position = Vector3.new(0, 0, 0) -- Из центра экрана/оружия
local endAttachment = Instance.new("Attachment")
endAttachment.Position = result.Position
local beam = Instance.new("Beam")
beam.Attachment0 = startAttachment
beam.Attachment1 = endAttachment
beam.Color = ColorSequence.new(BEAM_COLOR)
beam.Width0 = BEAM_WIDTH
beam.Width1 = BEAM_WIDTH
beam.Texture = "rbxassetid://227323329" -- Стандартная текстура луча
beam.FaceCamera = true
-- Привязываем луч к камере, чтобы он шёл из центра экрана
local fakePart = Instance.new("Part")
fakePart.Anchored = true
fakePart.Transparency = 1
fakePart.Parent = workspace
startAttachment.Parent = fakePart
-- Удаляем всё через ко
