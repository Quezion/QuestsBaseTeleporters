local qbt = require "QBTUtilities"
local TpSystem = require "QBTTeleporterSystem_client"

local Commands = {}

function Commands.registerTeleporter(args)
   qbt.Telepoints.Add(args.id, args.name, args.x, args.y, args.z)
end

TpSystem.Commands = Commands
