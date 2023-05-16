-- Serverside "SBaseteleporter" luaObject, represents each constructed teleporter object

if isClient() then return end

require "Map/SGlobalObject"
-- local qbt = require "QBTUtilities"

local SBaseteleporter = SGlobalObject:derive("SBaseteleporter")

function SBaseteleporter:new(luaSystem, globalObject)
   return SGlobalObject.new(self, luaSystem, globalObject)
end

function SBaseteleporter:initNew()
   self.on = false
   print "SBaseteleporter:initNew() called"
end

--called from loadIsoObject function when making new globalObject & luaObject, triggered by: Events.OnObjectAdded, MapObjects.OnLoadWithSprite
function SBaseteleporter:stateFromIsoObject(isoObject)
   self:initNew()
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
end

function SBaseteleporter:toModData(modData)
   modData.on = self.on
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