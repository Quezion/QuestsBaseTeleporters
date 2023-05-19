-- Serverside "SBaseteleporter" luaObject, represents each constructed teleporter object

if isClient() then return end

require "Map/SGlobalObject"
local qbt = require "QBTUtilities"

local SBaseteleporter = SGlobalObject:derive("SBaseteleporter")

function SBaseteleporter:new(luaSystem, globalObject)
   return SGlobalObject.new(self, luaSystem, globalObject)
end

function SBaseteleporter:initNew()
   self.on = false
   self.name = "New Teleporter"
   self.id = tostring(getRandomUUID())
end

--called from loadIsoObject function when making new globalObject & luaObject, triggered by: Events.OnObjectAdded, MapObjects.OnLoadWithSprite
function SBaseteleporter:stateFromIsoObject(isoObject)
   self:initNew()
   -- Disabled, unknown exactly how the loading system works
   -- and this custom code might be causing errors rather than fixing them
   -- if isoObject then
   --    local modData = isoObject:getModData()
   --    if modData then
   --       self:fromModData(modData)
   --    end
   -- end
   self:saveData(true)
end

--called from loadIsoObject function when luaObject exists, triggered by: Events.OnObjectAdded, MapObjects.OnLoadWithSprite
function SBaseteleporter:stateToIsoObject(isoObject)
   self:toModData(isoObject:getModData())
   isoObject:transmitModData()
   -- self:updateSprite() -- TODO: for dynamic teleporter 'animations'
end

function SBaseteleporter:fromModData(modData)
   self.on = modData.on
   self.name = modData.name
   self.id = modData.id
   --print("SBaseteleporter:fromModData " .. self.id .. ", " .. self.name)
end

function SBaseteleporter:toModData(modData)
   modData.on = self.on
   modData.name = self.name
   modData.id = self.id
   --print("SBaseteleporter:toModData " .. modData.id .. ", " .. modData.name)
end

function SBaseteleporter:saveData(transmit)
   local isoObject = self:getIsoObject()
   if not isoObject then return end
   self:toModData(isoObject:getModData())
   if transmit then
      isoObject:transmitModData()
   end
end

return SBaseteleporter