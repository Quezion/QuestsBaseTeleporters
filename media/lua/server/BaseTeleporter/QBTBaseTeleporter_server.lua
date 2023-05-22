-- Serverside "SBaseteleporter" luaObject, represents each constructed teleporter object

if isClient() then return end

require "Map/SGlobalObject"
local qbt = require "QBTUtilities"

local SBaseteleporter = SGlobalObject:derive("SBaseteleporter")

function SBaseteleporter:new(luaSystem, globalObject)
   return SGlobalObject.new(self, luaSystem, globalObject)
end

function SBaseteleporter:initNew(x,y,z)
   self.on = true
   self.name = "New Teleporter"
   self.id = tostring(getRandomUUID())
   self.x = x
   self.y = y
   self.z = z
end

--called from loadIsoObject function when making new globalObject & luaObject, triggered by: Events.OnObjectAdded, MapObjects.OnLoadWithSprite
function SBaseteleporter:stateFromIsoObject(isoObject)
   self:initNew(isoObject:getX(), isoObject:getY(), isoObject:getZ())
   self:noise("stateFromIsoObject invoked")
   self:saveData(true)
end

--called from loadIsoObject function when luaObject exists, triggered by: Events.OnObjectAdded, MapObjects.OnLoadWithSprite
function SBaseteleporter:stateToIsoObject(isoObject)
   self:toModData(isoObject:getModData())
   isoObject:transmitModData()
   -- self:updateSprite() -- TODO: for dynamic teleporter 'animations'
end

function SBaseteleporter:fromModData(modData)
   self.id = modData.id
   self.name = modData.name
   self.on = modData.on
   self.x = modData.x
   self.y = modData.y
   self.z = modData.z
end

function SBaseteleporter:toModData(modData)
   modData.id = self.id
   modData.name = self.name
   modData.on = self.on
   modData.x = self.x
   modData.y = self.y
   modData.z = self.z
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