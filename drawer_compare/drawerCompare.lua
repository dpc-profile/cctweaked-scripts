-- ========================================================
-- Send a redstone pulse if the drawer is empyt, or
-- is full of items, or
-- the time reach 20(each loop is 2 second).
-- ========================================================
-- NOTE:  if you want to change the max amount of items 
-- allowed, you can change the variable 'maxItems' for the 
-- quantity you want.
-- ========================================================

local next = next -- is more optimal???

local slot = 2 -- For drawer 1x1, aways will be 2
local maxItems = 0
local timer = 0
local maxTimer = 20

local sideOutput = "right"

function main()    	
	
    local objDrawer = peripheral.find("storagedrawers:standard_drawers_1") -- Work only with the drawer 1x1

    if objDrawer == nil then
        print("No drawer found")
        return
    end

    -- check if the drawer is empty
    if next(objDrawer.list()) == nil then
        redstonePulse(sideOutput)
	timer = 0
        return
    end
	
    if maxItems == 0 then
    	maxItems = objDrawer.getItemDetail(slot).maxCount * 10
    end
	
    local currentCount = objDrawer.getItemDetail(slot).count
    	
    if currentCount >= maxItems then
        redstonePulse(sideOutput)
	timer = 0
        return
    end
    
    if timer > maxTimer then
        redstonePulse(sideOutput)
	timer = 0
        return
    end

    timer = timer + 1
    print("Wait drawer filled up. Timer: " .. timer)
end

-- ==========================================================================
-- =============================== FUNCTIONS ================================
-- ==========================================================================
function redstonePulse(param)
    redstone.setOutput(param, true)
    sleep(1)
    redstone.setOutput(param, false)
end
-- ==========================================================================
-- ==========================================================================

while true do
    shell.run("clear")
    main()
    sleep(2)
end
