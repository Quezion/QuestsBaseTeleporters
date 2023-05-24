local util = {}
local random = math.random

util.Types = {
   baseteleporters_tileset_01_0 = "BaseTeleporter",
}

function util.getType(isoObject)
   return util.Types[isoObject:getTextureName()]
end

function util.objIsType(isoObject,modType)
   return Worldutil.Types[isoObject:getTextureName()] == modType
end

-- NOTE: trying to run math.randomseed() seems to cause a Lua crash
--       we assume the generator is already seeded by PZ code somewhere else
local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

function util.randomString(length)
   local res = ""
   local i = 0
   while i < length do
      res = res .. string.char(math.random(97, 122))
      i = i + 1
   end
   return res
end

return util