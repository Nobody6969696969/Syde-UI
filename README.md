# Syde UI – Roblox Lua Executor UI Library

> A lightweight, feature‑rich UI library for **Roblox Lua executors** (not Roblox Studio GUIs). Build polished menus, tabs, forms, and controls with a single `loadstring`.

---

## ✨ Features

- Window + multi‑tab layout
- Sections, labels & paragraphs
- Buttons (click / hold), toggles (with optional keybind config)
- Text inputs (number‑only, max length, large text)
- Dropdowns (single & multi‑select)
- Keybinds
- Color pickers (linkable palettes)
- Image display (by Roblox decal ID)
- Sliders (grouped, typed ranges & increments)
- Modal dialogs & notifications
- Ratings with webhook
- Config save/load (folder + file)
- Social buttons (Discord/GitHub), auto‑join invite

> Designed to run within exploits like Synapse X, Script‑Ware, Fluxus, etc., where `game:HttpGet` is supported.

---

## 🚀 Quick Start

```lua
-- 1) Load library (HTTP must be enabled in your executor)
local syde = loadstring(game:HttpGet("https://raw.githubusercontent.com/essencejs/syde/refs/heads/main/source", true))()

-- 2) Boot with your app branding & options
syde:Load({
    Logo  = '7488932274', -- Roblox decal id (optional)
    Name  = 'My Syde App',
    Status = 'Stable',
    Accent = Color3.fromRGB(251, 144, 255),
    HitBox = Color3.fromRGB(251, 144, 255),
    AutoLoad = false, -- set true to auto load saved config on next run
    Socials = {
        { Name = 'Discord', Style = 'Discord', Size = "Large", CopyToClip = true },
        { Name = 'GitHub',  Style = 'GitHub',  Size = "Small", CopyToClip = true  }
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = 'MySydeApp',
        FileName = 'config'    -- stored as /workspace/MySydeApp/config.json (executor‑specific)
    },
    AutoJoinDiscord = {       -- optional auto‑join
        Enabled = false,
        Invite = "CZRZBwPz",  -- your invite code
        RememberJoins = false
    }
})

-- 3) Create a window & tabs
local Window = syde:Init({ Title = 'My App', SubText = 'Powered by Syde' })
local Home    = Window:InitTab('Home')
local Inputs  = Window:InitTab('Inputs')
local Visuals = Window:InitTab('Visuals')
```

---

## 🧱 Core Primitives

### `syde:Load(opts)`
Bootstraps the library and global options.

| Field | Type | Notes |
|---|---|---|
| `Logo` | string | Roblox image id |
| `Name`, `Status` | string | App branding |
| `Accent`, `HitBox` | `Color3` | Theme & click hitbox color |
| `AutoLoad` | boolean | Auto load saved config on start |
| `Socials` | table[] | Prebuilt social buttons |
| `ConfigurationSaving` | table | Simple config persistence |
| `AutoJoinDiscord` | table | Invite auto‑join helper |

### `local Window = syde:Init({ Title, SubText })`
Creates a window instance.

### `local Tab = Window:InitTab(title)`
Adds a tab and returns a **Tab API** for adding elements.

### `Tab:Section(title, [imageId])`
Visually groups controls; optional image banner.

---

## 🧭 Navigation & Copy

### Labels & Paragraphs

```lua
Tab:Label("Left aligned text", "Left")
Tab:Label("Centered text", "Center")
Tab:Label("Right aligned text", "Right")

Tab:Paragraph({
  Title = "Welcome",
  Content = "Brief description of what this tab does."
})
```

### Images

```lua
Tab:Img({ Image = '7488932274' }) -- Accepts Roblox decal IDs
```

---

## 🔘 Buttons & Toggles

### Button

```lua
Tab:Button({
  Title = "Simple Button",
  CallBack = function()
    print("clicked")
    syde:Notify({ Title="Ok", Content="Clicked!", Duration=2 })
  end,
})

Tab:Button({
  Title = "Hold to Confirm",
  Description = "Hold 2s to run",
  Type = "Hold",
  HoldTime = 2,
  CallBack = function()
    -- critical action
  end,
})
```

### Toggle (with optional keybind config)

```lua
Tab:Toggle({
  Title = "Feature X",
  Description = "Enable the thing",
  Value = false,    -- default
  Config = true,    -- allow user to bind a key to toggle this
  CallBack = function(on)
    print("Feature X:", on and "ON" or "OFF")
  end,
})
```

---

## ✍️ Inputs & Dropdowns

### TextInput

```lua
Tab:TextInput({
  Title = "Player Name",
  PlaceHolder = "Enter name...",
  CallBack = function(text) print("name:", text) end,
})

Tab:TextInput({
  Title = "Walk Speed",
  PlaceHolder = "16‑100",
  NumberOnly = true,
  ClearOnLost = false,
  CallBack = function(speedStr)
    local n = tonumber(speedStr)
    if n and n >= 16 and n <= 100 then
      local plr = game.Players.LocalPlayer
      if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = n
      end
    else
      syde:Notify({ Title="Invalid", Content="Enter 16‑100", Duration=3 })
    end
  end,
})
```

### Dropdowns

```lua
-- Single select
Tab:Dropdown({
  Title = "Game Mode",
  Options = { "Adventure", "Creative", "Survival", "Spectator" },
  PlaceHolder = "Select...",
  CallBack = function(opt) print("mode:", opt) end,
})

-- Multi select
Tab:Dropdown({
  Title = "Favorite Features",
  Options = { "Building","Combat","Exploration","Trading","Socializing","Racing" },
  PlaceHolder = "Pick some...",
  Multi = true,
  CallBack = function(opts) print("favorites:", opts) end,
})
```

---

## ⌨️ Keybinds

```lua
Tab:Keybind({
  Title = "Toggle UI",
  Key = Enum.KeyCode.RightShift,
  CallBack = function() print("UI toggled") end,
})

Tab:Keybind({
  Title = "Quick Save",
  Description = "Saves your progress",
  Key = Enum.KeyCode.F5,
  CallBack = function() print("Saved!") end,
})
```

---

## 🎨 Color Pickers

```lua
Tab:ColorPicker({
  Title = "Theme Color",
  Color = Color3.fromRGB(255, 100, 100),
  CallBack = function(c) print("theme:", c) end,
})

-- Linkable palettes (primary/secondary share updates)
Tab:ColorPicker({
  Title = "Primary",
  Description = "Links to other pickers",
  Linkable = true,
  Color = Color3.fromRGB(100, 150, 255),
  CallBack = function(c)
    local p = workspace:FindFirstChild("Part")
    if p then p.Color = c end
  end,
})

Tab:ColorPicker({
  Title = "Secondary",
  Linkable = true,
  Color = Color3.fromRGB(255, 200, 100),
  CallBack = function(c) end,
})
```

---

## 🎚️ Sliders (Grouped)

Group multiple sliders into one card using `CreateSlider`:

```lua
Tab:CreateSlider({
  Title = "Player Settings",
  Description = "Movement & camera",
  Sliders = {
    {
      Title = "Walk Speed",
      Range = {16, 100},
      Increment = 1,
      StarterValue = 16,
      CallBack = function(v)
        local plr = game.Players.LocalPlayer
        local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v end
        syde:Notify({ Title="Speed", Content="Walk speed: "..v, Duration=1 })
      end,
    },
    {
      Title = "Jump Power",
      Range = {50, 200},
      Increment = 5,
      StarterValue = 50,
      CallBack = function(v)
        local plr = game.Players.LocalPlayer
        local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v end
      end,
    },
    {
      Title = "Field of View",
      Range = {70, 120},
      Increment = 1,
      StarterValue = 70,
      CallBack = function(v) workspace.CurrentCamera.FieldOfView = v end,
    },
  }
})
```

Additional groups (e.g., Graphics/Audio) work the same way with tailored ranges and increments.

---

## 🧩 Advanced

### Modal Dialogs

```lua
Tab:Button({
  Title = "Show Modal",
  Description = "Asks for confirmation",
  CallBack = function()
    syde:Modal({
      Title = "Confirm Action",
      Content = "Proceed? This cannot be undone.",
      Options = {
        { Text = "Proceed", CallBack = function()
            syde:Notify({ Title="Done", Content="Action executed!", Duration=3 })
        end },
        { Text = "Cancel",  CallBack = function()
            syde:Notify({ Title="Cancelled", Content="No changes made", Duration=2 })
        end },
      }
    })
  end,
})
```

### Notifications

```lua
syde:Notify({ Title="Info", Content="Short message", Duration=1 })
```

### Ratings

```lua
Tab:Rate({
  Title = "Rate This",
  WebHook = "https://your-webhook-url" -- receive star ratings
})
```

---

## 💾 Config Saving

Enable in `syde:Load`:

```lua
ConfigurationSaving = {
  Enabled = true,
  FolderName = 'MySydeApp',
  FileName = 'config'
}
```

Then use your toggles/inputs normally—state is persisted automatically (executor‑dependent path). Set `AutoLoad = true` to restore on next run.

---

## 🧱 Putting It All Together (Mini Demo)

```lua
local syde = loadstring(game:HttpGet("https://raw.githubusercontent.com/essencejs/syde/refs/heads/main/source", true))()
syde:Load({
  Name = "Demo", Status = "Stable",
  ConfigurationSaving = { Enabled = true, FolderName = "Demo", FileName = "config" }
})

local win = syde:Init({ Title = "Demo App", SubText = "All Features" })
local main = win:InitTab("Main")

main:Section("Basics", "8932620770")
main:Button({ Title="Click Me", CallBack=function() syde:Notify({Title="Yay", Content="Clicked!", Duration=2}) end })
main:Toggle({ Title="God Mode", Value=false, Config=true, CallBack=function(v) print("god:", v) end })

local inputs = win:InitTab("Inputs")
inputs:TextInput({ Title="Name", PlaceHolder="type...", CallBack=function(t) print(t) end })
inputs:Dropdown({ Title="Mode", Options={"Adventure","Creative"}, PlaceHolder="choose...", CallBack=function(opt) print(opt) end })

local vis = win:InitTab("Visuals")
vis:ColorPicker({ Title="Theme", Color=Color3.fromRGB(255, 100, 100), CallBack=function(c) end })
vis:Img({ Image='7488932274' })
```

---

## ✅ Tips & Best Practices

- **Executor HTTP**: Make sure your executor allows `HttpGet` and that you trust the source.
- **Humanoid checks**: Guard player property edits with `FindFirstChild("Humanoid")`.
- **Ranges**: Keep sliders in sane gameplay ranges to avoid anti‑cheat.
- **Hold buttons**: Use `Type="Hold"` for destructive actions.
- **Keybind UX**: Set `Config=true` only on important toggles to avoid clutter.
- **Images**: Use Roblox decal IDs for `Logo`/`Img` to avoid loading errors.
- **Security**: Never paste webhooks or secrets in public scripts.

---

## 📦 API Summary

| API | Description |
|---|---|
| `syde:Load(opts)` | Initialize library & global options |
| `syde:Init({ Title, SubText })` | Create a window |
| `Window:InitTab(title)` | Create a tab |
| `Tab:Section(title, [imageId])` | Group UI elements |
| `Tab:Button({...})` | Click / hold button |
| `Tab:Toggle({...})` | Boolean toggle (optional keybind config) |
| `Tab:TextInput({...})` | Single/large text / numeric input |
| `Tab:Dropdown({...})` | Single / multi select dropdown |
| `Tab:Keybind({...})` | Register a hotkey callback |
| `Tab:ColorPicker({...})` | Color selection (linkable) |
| `Tab:Img({ Image })` | Display an image by Roblox id |
| `Tab:Label(text, align)` | Left/Center/Right aligned text |
| `Tab:Paragraph({...})` | Title + multi‑line content |
| `Tab:CreateSlider({...})` | Grouped sliders (with range/increment) |
| `Tab:Rate({...})` | 1‑5 star rating via webhook |
| `syde:Modal({...})` | Confirmation/option modal |
| `syde:Notify({...})` | Toast notifications |

---

## 🔧 Compatibility

- Works in **Roblox Lua executors** that support `HttpGet` and drawing UI to the Roblox client.
- Not intended for **Roblox Studio** plugin GUIs.

---

## 📝 License

Use at your own risk. Respect Roblox ToS and game rules.
