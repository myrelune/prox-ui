## Prox Overview

Prox is a lightweight, modular Roblox UI library. You start with Prox:CreateWindow("Title"), then add tabs using AddTab("TabName"). Inside tabs, you can create dynamic sections with CreateHalf() for two-column layouts or CreateFull() for full-width sections.

Inside of each section you have functions like AddToggle, AddButton, AddValueBox, and AddDropdown. These functions take a title, optional parameters like min/max or multi-select, and a callback for when the value changes.

Call SetConfig("Folder", "File") once to enable automatic saving and loading of all toggles, values, and dropdown selections. Configuration is handled behind the scenes, no extra setup needed.

### 1. Create the window
```lua
local ui = Prox:CreateWindow("My Window")
```
Creates the main UI. You pass in the window title as a string.
---

### 2. Add a tab
```lua
local tab = ui:AddTab("Main Tab")
```
Adds a new tab to the top bar. The string is the tab title.

---

### 3. Create a section  
Use either `CreateHalf()` or `CreateFull()`:
```lua
local section = tab:CreateHalf()  -- 2 columns
-- or
local section = tab:CreateFull()  -- full-width
```
Returns a section object with builder functions.

---

### 4. Add a toggle
```lua
section:AddToggle("Enable Feature", function(state)
    print("Toggle is now", state)
end)
```
- First arg: title (string)  
- Second arg: callback (runs on toggle change)  
State is saved/loaded automatically if config is set.

---

### 5. Add a button
```lua
section:AddButton("Click Me", function()
    print("Button clicked")
end)
```
- First arg: title  
- Second arg: callback

---

### 6. Add a value box
```lua
section:AddValueBox("Speed", 1, 100, function(value)
    print("Value set to", value)
end)
```
- First arg: title  
- Second & third: min and max numbers  
- Fourth: callback when a valid number is entered

---

### 7. Add a dropdown
```lua
section:AddDropdown("Mode", {"A", "B", "C"}, function(choice)
    print("Selected:", choice)
end, false)
```
- First arg: title  
- Second: table of options  
- Third: callback  
- Fourth (optional): set to `true` for multi-select

---

### 8. Set up config saving
```lua
ProxUI:SetConfig("ProxFolder", "config.json")
```
Saves all toggle states, value box numbers, and dropdown selections. Automatically loads them back in next session.




```lua
local Prox = loadstring(game:HttpGet("https://raw.githubusercontent.com/myrelune/prox-ui/refs/heads/main/prox.lua"))()

-- Set up config
Prox:SetConfig("Prox Demo", "demo_config.json")

-- Create window
local ui = Prox:CreateWindow("Demo UI")

-- === Tab 1: Basic Controls (Full Width) ===
local basicTab = ui:AddTab("Basic")

local full1 = basicTab:CreateFull()
full1:AddToggle("Enable System", function(val)
    print("System Enabled:", val)
end)

full1:AddDropdown("Theme", {"Dark", "Light", "Cyber"}, function(opt)
    print("Selected Theme:", opt)
end)

full1:AddButton("Apply Settings", function()
    print("Settings Applied")
end)

local full2 = basicTab:CreateFull()
full2:AddValueBox("Volume", 0, 100, function(val)
    print("Volume set to:", val)
end)

full2:AddDropdown("Mode", {"Easy", "Normal", "Hard"}, function(opt)
    print("Game Mode:", opt)
end)

full2:AddToggle("Show Notifications", function(val)
    print("Notifications:", val)
end)

-- === Tab 2: Layout Showcase (Half Widths) ===
local layoutTab = ui:AddTab("Layout")

-- Row 1 - One half
local h1 = layoutTab:CreateHalf()
h1:AddButton("Single Button", function()
    print("Button Clicked")
end)

-- Row 2 - Two halves
local h2a = layoutTab:CreateHalf()
local h2b = layoutTab:CreateHalf()

h2a:AddToggle("ESP Enabled", function(val)
    print("ESP:", val)
end)
h2a:AddValueBox("Range", 50, 1000, function(val)
    print("Range:", val)
end)

h2b:AddDropdown("Display Type", {"Box", "Outline", "Name"}, function(val)
    print("Display:", val)
end)

h2b:AddButton("Refresh ESP", function()
    print("ESP Refreshed")
end)

-- Row 3 - Another single half (no paired half)
local h3 = layoutTab:CreateHalf()
h3:AddToggle("Silent Aim", function(v)
    print("Silent Aim:", v)
end)

-- === Tab 3: Misc + Reset ===
local miscTab = ui:AddTab("Other")

local miscFull = miscTab:CreateFull()
miscFull:AddDropdown("Languages", {"English", "Spanish", "French", "German"}, function(v)
    print("Language:", v)
end)

miscFull:AddButton("Reset Config", function()
    Prox:ClearConfig()
    print("Config reset.")
end)

print("Prox demo loaded. Press 'U' to toggle the UI.")
```
