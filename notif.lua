
    local notifications = {}
    local tweenService = game:GetService("TweenService")
    local gui = game:GetObjects('rbxassetid://14183548964')[1]
    gui.Name = "Notifier"
    local notificationContainer = gui.Notifications
    local gui2 = Instance.new("ScreenGui")
    gui2.Name = "SiriusChecker"
    gui2.Parent = game.CoreGui
    notificationContainer.Parent = gui2

    local siriusValues = {
        siriusName = "Sirius",
        releaseType = "Stable",
        siriusFolder = "Sirius",
        settingsFile = "settings.srs",
        interfaceAsset = 14183548964,
        cdn = "https://cdn.sirius.menu/SIRIUS-SCRIPT-CORE-ASSETS/",
        icons = "https://cdn.sirius.menu/SIRIUS-SCRIPT-CORE-ASSETS/Icons/",
        enableExperienceSync = false,
        rawTree = "https://raw.githubusercontent.com/SiriusSoftwareLtd/Sirius/Sirius/games/",
        neonModule = "https://raw.githubusercontent.com/shlexware/Sirius/request/library/neon.lua",
        transparencyProperties = {
            UIStroke = {'Transparency'},
            Frame = {'BackgroundTransparency'},
            TextButton = {'BackgroundTransparency', 'TextTransparency'},
            TextLabel = {'BackgroundTransparency', 'TextTransparency'},
            TextBox = {'BackgroundTransparency', 'TextTransparency'},
            ImageLabel = {'BackgroundTransparency', 'ImageTransparency'},
            ImageButton = {'BackgroundTransparency', 'ImageTransparency'},
            ScrollingFrame = {'BackgroundTransparency', 'ScrollBarImageTransparency'}
        },
        buttonPositions = {Character = UDim2.new(0.5, -155, 1, -29), Scripts = UDim2.new(0.5, -122, 1, -29), Playerlist = UDim2.new(0.5, -68, 1, -29)},
    }

    local function figureNotifications()
        local notificationsSize = 0
        for i = #notifications, 0, -1 do
            local notification = notifications[i]
            if notification then
                if notificationsSize == 0 then
                    notificationsSize = notification.Size.Y.Offset + 2
                else
                    notificationsSize += notification.Size.Y.Offset + 5
                end
                local desiredPosition = UDim2.new(0.5, 0, 0, notificationsSize)
                if notification.Position ~= desiredPosition then
                    notification:TweenPosition(desiredPosition, "Out", "Quint", 0.8, true)
                end
            end
        end
    end

    local function wipeTransparency(ins, target, checkSelf, tween, duration)
        local transparencyProperties = siriusValues.transparencyProperties
        local function applyTransparency(obj)
            local properties = transparencyProperties[obj.className]
            if properties then
                local tweenProperties = {}
                for _, property in ipairs(properties) do
                    tweenProperties[property] = target
                end
                for property, transparency in pairs(tweenProperties) do
                    if tween then
                        tweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {[property] = transparency}):Play()
                    else
                        obj[property] = transparency
                    end
                end
            end
        end
        if checkSelf then
            applyTransparency(ins)
        end
        for _, descendant in ipairs(ins:getDescendants()) do
            applyTransparency(descendant)
        end
    end

    local function queueNotification(Title, Description, Image)
        task.spawn(function()        
            local newNotification = notificationContainer.Template:Clone()
            newNotification.Parent = notificationContainer
            newNotification.Name = Title or "Unknown Title"
            newNotification.Visible = true

            newNotification.Title.Text = Title or "Unknown Title"
            newNotification.Description.Text = Description or "Unknown Description"
            newNotification.Time.Text = "now"

            newNotification.AnchorPoint = Vector2.new(0.5, 1)
            newNotification.Position = UDim2.new(0.5, 0, -1, 0)
            newNotification.Size = UDim2.new(0, 320, 0, 500)
            newNotification.Description.Size = UDim2.new(0, 241, 0, 400)
            wipeTransparency(newNotification, 1, true)

            newNotification.Description.Size = UDim2.new(0, 241, 0, newNotification.Description.TextBounds.Y)
            newNotification.Size = UDim2.new(0, 100, 0, newNotification.Description.TextBounds.Y + 50)

            table.insert(notifications, newNotification)
            figureNotifications()

            local notificationSound = Instance.new("Sound")
            notificationSound.Parent = game.Workspace
            notificationSound.SoundId = "rbxassetid://255881176"
            notificationSound.Name = "notificationSound"
            notificationSound.Volume = 0.65
            notificationSound.PlayOnRemove = true
            notificationSound:Destroy()

            if not tonumber(Image) then
                newNotification.Icon.Image = 'rbxassetid://14317577326'
            else
                newNotification.Icon.Image = 'rbxassetid://'..Image or 0
            end

            newNotification:TweenPosition(UDim2.new(0.5, 0, 0, newNotification.Size.Y.Offset + 2), "Out", "Quint", 0.9, true)
            task.wait(0.1)
            tweenService:Create(newNotification, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 320, 0, newNotification.Description.TextBounds.Y + 50)}):Play()
            task.wait(0.05)
            tweenService:Create(newNotification, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.35}):Play()
            tweenService:Create(newNotification.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0.7}):Play()
            task.wait(0.05)
            tweenService:Create(newNotification.Icon, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
            task.wait(0.04)
            tweenService:Create(newNotification.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
            task.wait(0.04)
            tweenService:Create(newNotification.Description, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.15}):Play()
            tweenService:Create(newNotification.Time, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.5}):Play()

            newNotification.Interact.MouseButton1Click:Connect(function()
                local foundNotification = table.find(notifications, newNotification)
                if foundNotification then table.remove(notifications, foundNotification) end

                tweenService:Create(newNotification, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, newNotification.Position.Y.Offset)}):Play()

                task.wait(0.4)
                newNotification:Destroy()
                figureNotifications()
                return
            end)

            local waitTime = (#newNotification.Description.Text*0.1)+2
            if waitTime <= 1 then waitTime = 2.5 elseif waitTime > 10 then waitTime = 10 end

            task.wait(waitTime)

            local foundNotification = table.find(notifications, newNotification)
            if foundNotification then table.remove(notifications, foundNotification) end

            tweenService:Create(newNotification, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, newNotification.Position.Y.Offset)}):Play()

            task.wait(1.2)
            newNotification:Destroy()
            figureNotifications()
        end)
    end


