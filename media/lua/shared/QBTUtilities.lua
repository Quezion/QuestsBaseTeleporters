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

-- NOTE: seems to cause crash on game initialization
-- math.randomseed(os.time())

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

-- function util.randomString(length)
--    if length > 0 then
--       return string.random(length - 1) .. charset:sub(math.random(1, #charset), 1)
--    else
--       return ""
--    end
-- end

return util