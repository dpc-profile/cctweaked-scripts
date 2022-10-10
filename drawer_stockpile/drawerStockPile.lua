local objDrawer = peripheral.find("storagedrawers:standard_drawers_1") -- Work only with the drawer 1x1
local objMonitor = peripheral.find("monitor") -- can be use with only one monitor 
local fileName = "lastSignal.txt"
local sideOutput = "top"

local maxStackInDrawer = 32
local maxStack = 64 -- Place the max amount of itens per stack
local upgradeMultiplier = 1 -- how much the upgrade increase. If not have, leave at 1
local slot = 2 -- For drawer 1x1, aways will be 2

local minPercent = 0.30
local maxPercent = 0.90

local redstoneSignal = true

function main()
	shell.run("clear")

	returnMaxCapacityDrawer =  maxCapacityDrawer(objDrawer, upgradeMultiplier, maxStack)

	local currentCount = objDrawer.getItemDetail(slot).count

	local quantMin = returnMaxCapacityDrawer * minPercent
	local quantMax = returnMaxCapacityDrawer * maxPercent

	if objMonitor ~= nil then
		drawMonitor(objMonitor, currentCount, returnMaxCapacityDrawer)
	end

	local savedSignal = toBool(loadLastSignal(fileName))
	print("Value get from file: " .. tostring(savedSignal))

	local returnSetRedstoneSignal = setRedstoneSignal(quantMin, quantMax, currentCount)	

	if returnSetRedstoneSignal ~= nil then 
		redstoneSignal = returnSetRedstoneSignal
		print("Signal change to: " .. tostring(redstoneSignal))
	end

	if savedSignal ~= redstoneSignal then
		saveLastSignal(fileName, redstoneSignal)
	end

	redstone.setOutput(sideOutput, redstoneSignal)
end

-- ==========================================================================
-- =============================== FUNCTIONS ================================
-- ==========================================================================

function maxCapacityDrawer(obj, multiplier, stack)
	local maxCount = maxStackInDrawer * stack
	maxCount = maxCount * multiplier
	return maxCount
end

function setRedstoneSignal(min, max, current)
	if current < min then
		return true
	end

	if current > max then
		return false
	end
end

function drawMonitor(monitor, currentItens, maxItens)
	monitor.setTextColor(colors.white)
	monitor.setBackgroundColor(colors.black)
	monitor.setTextScale(0.5)
	monitor.clear()

	monitor.setCursorPos(1,1)
	monitor.write("Itens: " .. currentItens)

	monitor.setCursorPos(1,2)
	monitor.write("Max Itens: " .. maxItens)
end

function loadLastSignal(name)
	if (fs.exists(name) == false) then
		saveLastSignal(name, redstoneSignal)
		return redstoneSignal
	else
		local file = fs.open(name,"r")
		local line = {}
		line = file.readLine()
		file.close()
		print("file readed")
		return line
	end
end

function saveLastSignal(name, content)
	local file = fs.open(name,"w")
	file.write(content)			
	file.close()
	print("file writed")
end

function toBool(param)
	if (param == "true") or (param == true) then
		return true
	end

	return false
end

-- ==========================================================================
-- ==========================================================================
while true do 
	main()
	sleep(2)
end