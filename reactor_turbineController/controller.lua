local G_monitors = {} -- Set on checkPeripherals()
local G_reactor = {} -- Set on checkPeripherals()
local G_turbine = {} -- Set on checkPeripherals()

local GUI_BOX = {}
local GUI_LINE = {}
local GUI_TEXT = {}

local G_turbineAllInfos = {}

local refresh = false

function main ()

	returnCheck = checkPeripherals()

	if returnCheck ~= "OK" then
		error(returnCheck .. ", make sure the connections(modem) are activated", 0) 
	end

	while true do
		G_turbineAllInfos = setTurbineAllInfos(G_turbine)

		drawGUI(G_monitors)
		resetObj()
		sleep(1)
		break
	end
	

	-- while true do
	-- 	clickEvent()
	-- end

	-- print(G_turbine.battery().capacity())

	

	-- pode ser util
	-- https://youtu.be/LHVQzpTi1w0
	
end

function checkMonitorConnected()
	local checkMonitor = peripheral.find("monitor")
	if checkMonitor == nil then
		return false
	end
	return checkMonitor
end

function checkReactorConnected()
	local checkReactor = peripheral.find("BiggerReactors_Reactor")
	if checkReactor == nil then
		return false
	end
	G_VERSION = "BIGGERv2"
	return checkReactor 
end

function checkTurbineConnected()
	local checkTurbine = peripheral.find("BiggerReactors_Turbine")
	if checkTurbine == nil then
		return false
	end
	return checkTurbine
end

function checkPeripherals()

	G_monitors = checkMonitorConnected()
	if not G_monitors then
		return "The Monitor is not being detected"		
	end

	G_reactor = checkReactorConnected()
	if not G_reactor then
		return "The Reactor is not being detected"		
	end

	G_turbine = checkTurbineConnected()
	if not G_turbine then 
		return "The Turbine is not being detected"		
	end

	return "OK"
end

function setTurbineAllInfos(objTurbine)
	local obj = {}

	obj["currentRfStoraged"] = objTurbine.battery().stored()
	obj["maxRfStorageCapacity"] = objTurbine.battery().capacity()
	obj["rfPerTick"] = objTurbine.battery().producedLastTick()
	obj["flowLastTick"] = objTurbine.fluidTank().flowLastTick()

	obj["steamAmount"] = objTurbine.fluidTank().input().amount()
	obj["steamMaxAmount"] = objTurbine.fluidTank().input().maxAmount()

	return obj
end

function drawGUI(objMonitor)
	local monitor = objMonitor

	term.redirect(monitor)
	
	monitor.setTextColor(colors.white)
	monitor.setBackgroundColor(colors.black)
	monitor.setTextScale(0.5)
	monitor.clear() -- call last to really clear the monitor

	local width, height = monitor.getSize()
	local margin = (width/100) * 2

	-- index = 1
	-- for key, value in pairs(G_turbine.fluidTank().input()) do
	-- 	monitor.setCursorPos(1, index)
	-- 	print("key: " .. key)
	-- 	index = index + 1
	-- end

	drawGUITurbine(height, width, margin, monitor, G_turbine)

	drawGUIReactor(width, height, margin, monitor, G_reactor)
	
end

-- Criar função para desenhar a box, textos e graficos da Turbine
function drawGUITurbine(height, width, margin, objMonitor, objTurbine)
	local singleText = ""
	-- Format text
	local collumnText = margin * 2
	local lineY = 0
	local sizeBarX = 0
	local sizeBarY = 0

	local objInfo = {}
	local texts = {}
	local newWidth = ((width - (margin*3)) / 3) * 2
	local newHeight = height - (height/2)
	

	objInfo['startX'] = margin + 1
	objInfo['startY'] =  margin + 1
	objInfo['endX'] = newWidth - margin
	objInfo['endY'] = newHeight - margin

	sizeBarX = objInfo.endX * 0.45
	sizeBarY = objInfo.endY * 0.45

	-- Draw Box Main
	paintutils.drawBox(objInfo.startX, objInfo.startY, objInfo.endX, objInfo.endY, colors.gray)

	-- Title 
	singleText = "TURBINE"
	-- background title
	paintutils.drawLine(objInfo.startX + margin, objInfo.startY, objInfo.startX + margin + #singleText+1 ,objInfo.startY, colors.black)
	table.insert(texts, {objInfo.startX + collumnText, objInfo.startY, singleText, colors.white})
	-- =================================================================================
	singleText = "ENERGY STORAGE"
	lineY = margin * 2
	local energySorageTextLine = lineY
	table.insert(texts,{objInfo.startX + collumnText, objInfo.startY + lineY, singleText, colors.white})
	-- =================================================================================
	-- Percent Storage
	local fillBarPercent = G_turbineAllInfos.currentRfStoraged / G_turbineAllInfos.maxRfStorageCapacity
	local fillBarRoundPercent = (round(fillBarPercent, 2))*100
	singleText = fillBarRoundPercent .. "%"
	table.insert(texts, {(objInfo.startX + collumnText) + (sizeBarX*0.35), objInfo.startY + lineY + (sizeBarY * 0.4), singleText, colors.white})
	-- =================================================================================
	local steamLevelTextLine = lineY
	local steamLevelTextCollumn = (objInfo.endX/2) + margin + 1
	singleText = "STEAM LEVEL"
	table.insert(texts,{steamLevelTextCollumn, objInfo.startY + steamLevelTextLine, singleText, colors.white})
	-- =================================================================================
	-- Percent Steam
	local steamPercent = G_turbineAllInfos.steamAmount / G_turbineAllInfos.steamMaxAmount
	local steamPercentRound = (round(steamPercent, 2))*100
	singleText = steamPercentRound .. "%"
	table.insert(texts, {steamLevelTextCollumn + (sizeBarX*0.35), objInfo.startY + steamLevelTextLine + (sizeBarY)*0.4, singleText, colors.white})
	-- =================================================================================
	lineY = objInfo.startY + (objInfo.endY/2) + margin
	singleText = "RF : " .. G_turbineAllInfos.rfPerTick .. " RF/t"
	table.insert(texts, {objInfo.startX + collumnText, lineY, singleText, colors.white})
	-- =================================================================================
	singleText = "ENERGY STORAGED : " .. G_turbineAllInfos.currentRfStoraged .. " RF"
	lineY = lineY + 1
	table.insert(texts, {objInfo.startX + collumnText, lineY, singleText, colors.white})
	-- =================================================================================
	singleText = "CONSUME RATE : " .. G_turbineAllInfos.flowLastTick .. " B/t"
	lineY = lineY + 1
	table.insert(texts, {objInfo.startX + collumnText, lineY, singleText, colors.white})
	-- =================================================================================
	-- Draw "ENERGY STORAGE" Progres bar background
	paintutils.drawFilledBox(objInfo.startX + collumnText, objInfo.startY + energySorageTextLine + 1, objInfo.startX + sizeBarX, objInfo.startY + sizeBarY, colors.lightGray)

	local fillBar = (1 - fillBarPercent)
	local color = colors.lightGray
	
	if fillBar ~= 1 then		
		fillBar = collumnText + sizeBarX - (sizeBarX * fillBar)
		color = colors.green
	else
		fillBar = collumnText
	end

	if fillBar > (sizeBarX/2) then
		fillBar = fillBar - collumnText
	end

	-- Draw "ENERGY STORAGE" Progres bar
	paintutils.drawFilledBox(objInfo.startX + collumnText, objInfo.startY + energySorageTextLine + 1, objInfo.startX + fillBar, objInfo.startY + sizeBarY, color)
	-- =================================================================================
	-- Draw "STEAM LEVEL" Progress bar background
	paintutils.drawFilledBox(steamLevelTextCollumn, objInfo.startY + steamLevelTextLine + 1, objInfo.endX - (margin * 2), objInfo.startY + sizeBarY, colors.lightGray)

	color = colors.green
	fillBar = (sizeBarX * steamPercent)

	if fillBar <= (margin*1.9) then
		color = colors.lightGray
	else
		fillBar = fillBar - (margin*2)
	end

	-- Draw "STEAM LEVEL" Progres bar
	paintutils.drawFilledBox(steamLevelTextCollumn, objInfo.startY + steamLevelTextLine + 1, steamLevelTextCollumn + fillBar,objInfo.startY + sizeBarY, color)

	-- Draw Text
	for index, value in pairs(texts) do
		objMonitor.setCursorPos(value[1], value[2])
		objMonitor.setTextColor(value[4])
		objMonitor.setBackgroundColor(colors.black)
		objMonitor.write(value[3])
	end	
end

-- Criar função para desenhar a box, textos e graficos do Reactor
function drawGUIReactor(width, height, margin, objMonitor, G_turbine)
	local singleText = ""
	-- Format text
	local collumnText = margin * 2
	local line = 0
	local sizeBarX = 0
	local sizeBarY = 0

	local objInfo = {}
	local texts = {}

	objInfo['startX'] = margin + 1
	objInfo['startY'] = height - (height/2) + margin
	objInfo['endX'] = (((width - (margin*3)) / 3) * 2) - margin
	objInfo['endY'] = height - margin

	sizeBarX = objInfo.endX * 0.45
	sizeBarY = objInfo.endY * 0.45

	-- Draw Box Main
	paintutils.drawBox(objInfo.startX, objInfo.startY, objInfo.endX, objInfo.endY, colors.gray)
	-- =================================================================================
	-- Title 
	singleText = "REACTOR"
	-- background title
	paintutils.drawLine(objInfo.startX + margin, objInfo.startY, objInfo.startX + margin + #singleText+1 ,objInfo.startY, colors.black)
	table.insert(texts, {objInfo.startX + collumnText, objInfo.startY, singleText, colors.white})
	-- =================================================================================
	singleText = "WATER LEVEL"
	line = margin * 2
	table.insert(texts,{objInfo.startX + collumnText, objInfo.startY + line, singleText, colors.white})

	-- Draw Text
	for index, value in pairs(texts) do
		objMonitor.setCursorPos(value[1], value[2])
		objMonitor.setTextColor(value[4])
		objMonitor.setBackgroundColor(colors.black)
		objMonitor.write(value[3])
	end	

end

-- Criar função para desenhar a box, textos e botoẽs dos Controls
function drawGUIControls()

end


function writeTxt(filename, contend)
	file = io.open(filename..".txt","w")
	file:write(contend)
    file:flush()
    file:close()
end

function clickEvent()
	local touchEvent={os.pullEvent("monitor_touch")}
	print("X:" .. touchEvent[3])
	print("Y:" .. touchEvent[4])
	-- checkxy(myEvent[3], myEvent[4])
end

function round(val, decimal)
	-- rounds a number to the nearest decimal places
	if (decimal) then
	  return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
	else
	  return math.floor(val+0.5)
	end
end

function resetObj()
	G_turbineAllInfos = {}
end

main()