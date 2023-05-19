local qbt = require "QBTUtilities"
-- local WorldSpawns = require "World/QBTWorldSpawns"

local isClient = isClient()

local function LoadBaseTeleporter(isoObject)
   if not isClient then
      qbt.TpSystem_server:loadIsoObject(isoObject)
   else
      print "Clientside LoadBaseTeleporter invoked with isoObject"
      -- qbt.Telepoints.Add(isoObject:getName(), isoObject:getX(), isoObject:getY(), isoObject:getZ())
   end
end
MapObjects.OnLoadWithSprite("baseteleporters_tileset_01_0", LoadBaseTeleporter, 5)

-- local function LoadPowerbank(isoObject)
--    isoObject:getContainer():setAcceptItemFunction("AcceptItemFunction.ISA_Batteries")
--    if isClient then
--       local gen = isoObject:getSquare():getGenerator()
--       if gen then gen:getCell():addToProcessIsoObjectRemove(gen) end
--    else
--       qbt.TpSystem_server:loadIsoObject(isoObject)
--    end
-- end
-- MapObjects.OnLoadWithSprite("baseteleporters_tileset_01_0", LoadPowerbank, 5)

if not isClient then
    --- if a map had our objects
    local function OnNewWithSprite(isoObject)
        local spriteName = isoObject:getTextureName()
        local type = qbt.Types[spriteName]
        local square = isoObject:getSquare()

        if not square or not type then return error("QBT OnNewWithSprite "..spriteName) end

        square:getSpecialObjects():add(isoObject)
    end

    local MapObjects = MapObjects
    for sprite,type in pairs(qbt.Types) do
        MapObjects.OnNewWithSprite(sprite, OnNewWithSprite, 5)
    end
end
