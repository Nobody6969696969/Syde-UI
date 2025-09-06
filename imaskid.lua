-- syde_notify.lua
-- Minimal Syde‑style notification system.

local TweenService = game:GetService("TweenService")

-- Load the Syde notification asset.  This asset contains the template frames used for notifications.
local Library = game:GetObjects("rbxassetid://123800669522471")[1]
Library.Enabled = true
Library.Parent = game.CoreGui

-- Store active notifications so they can stack neatly
local notifications = {}
local notificationSpacing = 10
local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- Update positions of notifications so they slide up the screen
local function updatePositions()
    local screenHeight = workspace.CurrentCamera.ViewportSize.Y - 200
    local currentY = screenHeight
    for i = #notifications, 1, -1 do
        local notif = notifications[i]
        local targetPos = UDim2.new(0, 250, 0, currentY - notif.Size.Y.Offset + 60)
        TweenService:Create(notif, tweenInfo, {Position = targetPos}):Play()
        currentY = currentY - (notif.Size.Y.Offset + notificationSpacing)
    end
end

local function Notify(data)
    -- Spawn a new thread so notifications don’t block each other
    task.spawn(function()
        local notifData = {
            Title    = data.Title or "",
            Content  = data.Content or "",
            Duration = data.Duration or 5,
        }

        -- Clone the default template and set its text
        local notif = Library.Notification.Default:Clone()
        notif.Visible = true
        notif.Parent = Library.Notification
        notif.Title.Text   = notifData.Title
        notif.Content.Text = notifData.Content
        -- Resize to fit the content
        notif.Content.Size = UDim2.new(0, 200, 0, notif.Content.TextBounds.Y)
        notif.Size         = UDim2.new(1, 0, 0, notif.Content.TextBounds.Y + 50)

        -- Insert into the list and reposition others
        table.insert(notifications, notif)
        updatePositions()

        -- Initial visual state
        notif.UIScale.Scale           = 0.9
        notif.close.ImageTransparency = 0.95
        notif.BackgroundTransparency  = 0.75
        notif.Title.TextTransparency  = 0.5
        notif.Content.TextTransparency= 0.78
        notif.Position                = UDim2.new(0, 600, 0, 637)

        -- Function to remove and animate a notification away
        local function closeNotification()
            if notif and notif.Parent then
                local idx = table.find(notifications, notif)
                if idx then table.remove(notifications, idx) end

                TweenService:Create(notif.UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = 0.9}):Play()
                TweenService:Create(notif.close,   TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.95}):Play()
                TweenService:Create(notif,         TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.75}):Play()
                TweenService:Create(notif.Title,   TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.5}):Play()
                TweenService:Create(notif.Content, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.78}):Play()

                task.wait(0.15)
                TweenService:Create(
                    notif,
                    TweenInfo.new(0.95, Enum.EasingStyle.Exponential),
                    {Position = UDim2.new(0, notif.Position.X.Offset + 400, 0, notif.Position.Y.Offset)}
                ):Play()

                task.wait(0.4)
                notif:Destroy()
                updatePositions()
            end
        end

        -- Animate entry
        task.wait(0.45)
        TweenService:Create(notif.UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = 1}):Play()
        TweenService:Create(notif.close,   TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.75}):Play()
        TweenService:Create(notif,         TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
        TweenService:Create(notif.Title,   TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
        TweenService:Create(notif.Content, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

        -- Hover effects on the close button
        notif.close.MouseEnter:Connect(function()
            TweenService:Create(notif.close, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.25}):Play()
        end)
        notif.close.MouseLeave:Connect(function()
            TweenService:Create(notif.close, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.75}):Play()
        end)
        notif.close.MouseButton1Click:Connect(closeNotification)

        -- Auto‑close after the specified duration
        task.delay(notifData.Duration, closeNotification)
    end)
end

return {
    Notify = Notify
}
