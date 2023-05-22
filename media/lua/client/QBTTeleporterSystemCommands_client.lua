if not isClient() then return end

local qbt = require "QBTUtilities"
local TpSystem = require "QBTTeleporterSystem_client"

local Commands = {}

-- Just register a single teleporter for now to see if this works
function Commands.registerTeleporter(args)
   print("QBTTeleporterSystem.Commands.registerTeleporter() called")
   qbt.Telepoints.Add(args.id, args.name, args.x, args.y, args.z)
end

TpSystem.Commands = Commands
