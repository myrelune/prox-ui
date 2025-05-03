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
ProxUI:SetConfig("Prox Demo", "demo_config.json")

-- Create window
local ui = Prox:CreateWindow("Demo")

-- Tab 1: Full Width Sections
local tab1 = ui:AddTab("Main")
local full = tab1:CreateFull()

full:AddToggle("Enable Feature", function(val)
    print("Feature Enabled:", val)
end)

full:AddButton("Print Message", function()
    print("You clicked the button.")
end)

full:AddValueBox("Speed", 1, 100, function(val)
    print("Speed set to:", val)
end)

full:AddDropdown("Color", {"Red", "Green", "Blue"}, function(val)
    print("Selected color:", val)
end)

-- Tab 2: Half Width Sections
local tab2 = ui:AddTab("Advanced")
local half1 = tab2:CreateHalf()
local half2 = tab2:CreateHalf() -- Second half triggers divider

half1:AddToggle("God Mode", function(v)
    print("God Mode:", v)
end)

half1:AddValueBox("Jump Height", 10, 300, function(v)
    print("Jump Height:", v)
end)

half2:AddDropdown("Abilities", {"Dash", "Double Jump", "Invisibility"}, function(vals)
    print("Selected Abilities:", table.concat(vals, ", "))
end, true) -- multiSelect = true

half2:AddButton("Reset Config", function()
    ProxUI:ClearConfig()
    print("Config wiped and reset.")
end)

print("Prox demo loaded. Press 'U' to toggle UI.")
```
