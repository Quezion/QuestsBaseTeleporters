local util = {}

util.Types = {
   baseteleporters_tileset_01_0 = "BaseTeleporter",
}

function util.getType(isoObject)
   return util.Types[isoObject:getTextureName()]
end

function util.objIsType(isoObject,modType)
   return Worldutil.Types[isoObject:getTextureName()] == modType
end

return util