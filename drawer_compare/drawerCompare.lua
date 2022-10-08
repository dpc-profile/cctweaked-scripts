-- ========================================================
-- Send a redstone pulse if the drawer is empyt, or
-- reach a certain quantity of itens, or
-- the time reach 20(each loop is 2 second)
-- ========================================================

local next = next -- for speed increase???

local slot = 2 -- For drawer 1x1, aways will be 2
local maxItens = 64*10
local timer = 0
local maxTimer = 20

local sideOutput = "right"

function main()
    shell.run("clear")
    local objDrawer = peripheral.find("storagedrawers:standard_drawers_1") -- Work only with the drawer 1x1

    if objDrawer == nil then
        print("No drawer found")
        return
    end

    -- check if the drawer is empty
    if next(objDrawer.list()) == nil then
        redstonePulse(sideOutput)
        return
    end

    local currentCount = objDrawer.getItemDetail(slot).count

    -- If the quant of itens on drawer is greater than maxItens
    if currentCount > maxItens then
        redstonePulse(sideOutput)
        return
    end
    
    if timer > maxTimer then
        redstonePulse(sideOutput)
        return
    end

    timer = timer + 1
	print("Wait drawer filled up. Timer: " .. timer)
end

function redstonePulse(param)
    redstone.setOutput(param, true)
    sleep(1)
    redstone.setOutput(param, false)
	timer = 0
end

-- ============================================================
while true do
    main()
    sleep(2)
end