Brush = {}
Brush.__index = Brush

function Brush.new()
    local instance = setmetatable({}, Brush)

    return instance
end

function Brush:doBrushLines(newGroundItemIds, size, centerPos, dir)
    -- creates lines e.q. 1x4 sqm, 1x3 sqm or 4x1 sqm, 3x1 sqm
    -- direction depends of the parameter dir

    --[[local pom = {}
    pom.x = centerPos.x
    pom.y = centerPos.y
    pom.z = centerPos.z
    ]]--
    if (size == 3) then
        if (dir == 0) then
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x, y = centerPos.y-1, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[1], 1, centerPos)
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x, y = centerPos.y+1, z = centerPos.z})
        else
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x-1, y = centerPos.y, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[1], 1, centerPos)
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x+1, y = centerPos.y, z = centerPos.z})
        end

    elseif (size == 4) then
        if (dir == 0) then
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x, y = centerPos.y-2, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x, y = centerPos.y-1, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[1], 1, centerPos)
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x, y = centerPos.y+1, z = centerPos.z})
        else
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x-2, y = centerPos.y, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x-1, y = centerPos.y, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[1], 1, centerPos)
            doCreateItemMock(newGroundItemIds[1], 1, {x = centerPos.x+1, y = centerPos.y, z = centerPos.z})
        end

    elseif (size == 5) then
        if (dir == 0) then
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, {x = centerPos.x, y = centerPos.y-2, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, {x = centerPos.x, y = centerPos.y-1, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, centerPos)
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, {x = centerPos.x, y = centerPos.y+1, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, {x = centerPos.x, y = centerPos.y+2, z = centerPos.z})
        else
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, {x = centerPos.x-2, y = centerPos.y, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, {x = centerPos.x-1, y = centerPos.y, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, centerPos)
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, {x = centerPos.x+1, y = centerPos.y, z = centerPos.z})
            doCreateItemMock(newGroundItemIds[math.random(1,#newGroundItemIds)], 1, {x = centerPos.x+2, y = centerPos.y, z = centerPos.z})
        end
    end
end

function Brush:doBrushSquares(newGroundItemIds, size, centerPos, goodGroundItemIds)
    local pom = {}
    pom.x = centerPos.x
    pom.y = centerPos.y
    pom.z = centerPos.z
	if (size == 2 or size == 3) then
        pom.x = centerPos.x - 1
        pom.y = centerPos.y - 1
    elseif (size == 4) then
        pom.x = (centerPos.x - 1 - math.random(0,1))
        pom.y = (centerPos.y - 1 - math.random(0,1))
    elseif (size == 5) then
        pom.x = centerPos.x - 2
        pom.y = centerPos.y - 2
    elseif (size == 6) then
        pom.x = (centerPos.x - 2 - math.random(0,1))
        pom.y = (centerPos.y - 2 - math.random(0,1))
    elseif (size == 7) then
        pom.x = centerPos.x - 3
        pom.y = centerPos.y - 3

        --else size - 1 bo pom = centerPos
    end

    for i = 1, size do
        for j = 1, size do
			if (type(goodGroundItemIds) == "table" and not isEmpty(goodGroundItemIds)) then
				local item = getThingFromPosMock({x = pom.x, y = pom.y, z = pom.z, stackpos = 0})

				if (item and inArray({1060,1061,1062,1064}, item.itemid)) then
					print("GROUND MAPPER FOUND A WALL...")
				end

				if item and inArray(goodGroundItemIds, item.itemid) then
					doCreateItemMock(
						newGroundItemIds[1],
						1,
						{x = pom.x, y = pom.y, z = pom.z, stackpos = 0},
						true
					)
				end
			else
				doCreateItemMock(
					newGroundItemIds[1],
					1,
					{x = pom.x, y = pom.y, z = pom.z, stackpos = 0},
					true
				)
			end

            pom.x = pom.x + 1
        end
        pom.x = pom.x - size -- to start new row beginning from the first element
        pom.y = pom.y + 1
    end
end

function Brush:doCarpetBrush(
	markersTab,
	badGroundItemId,
	brushShapes,
	brushTab
) -- originally it had be executed before the autoborder (stackpos issue), but currently it is workarounded/fixed in core files
    local startTime = os.clock()
    for i = 1, #markersTab do
        local los = math.random(0, #brushShapes)
        local pom = {}

        local heightEven = (brushShapes[los].height % 2)
        local widthEven = (brushShapes[los].width % 2)

        local height = brushShapes[los].height
        local width = brushShapes[los].width

        pom.x = markersTab[i][1].x
        pom.y = markersTab[i][1].y
        pom.z = markersTab[i][1].z

        -- sets the pom
        if (heightEven == 0) then -- even room height
            pom.y = (pom.y - (height / 2) + 1) -- + math.random(0,1)
        elseif (heightEven == 1) then
            pom.y = (pom.y - (height / 2) + 0.5)
        end

        if (widthEven == 0) then -- even room width
            pom.x = (pom.x - (width / 2) + 1) -- + math.random(0,1)
        elseif (widthEven == 1) then
            pom.x = (pom.x - (width / 2) + 0.5)
        end

        for i2 = 1, height do
            for j2 = 1, width do
                local itemId = getThingFromPosMock(
					{x = pom.x, y = pom.y, z = pom.z, stackpos = 0}
                ).itemid
                if (itemId ~= badGroundItemId) then
                    for id = 1, 13 do
                        if (brushShapes[los].shape[i2][j2] == id) then
                            doCreateItemMock(
								brushTab[id][1],
								1,
								{x = pom.x, y = pom.y, z = pom.z},
								true
                            )
                        end
                    end
                end
                pom.x = pom.x + 1
            end
            pom.x = pom.x - width
            pom.y = pom.y + 1
        end
    end
    print("Brush created, execution time: " .. os.clock() - startTime)
end
