local qbt = require "QBTUtilities"

local Telepoints = {
   _regPoints = {},
};

function Telepoints.Add(id, name, x, y, z )
   if not id then
      error("There was no ID given", 2 )
   end
   if type(id) ~= "string" then
      error("The given ID is not a string", 2 )
   end
   Telepoints._regPoints[ id ] = {
      X = x,
      Y = y,
      Z = z or 0,
      Name = name
   }
end

function Telepoints.Remove(id)
   if not id then
      error("There was no ID given", 2 )
   end
   if type(id) ~= "string" then
      error("The given ID is not a string", 2 )
   end
   Telepoints._regPoints[id] = nil
end

-- Wipes all points, workaround to try and keep in-sync
function Telepoints.Reset()
   Telepoints._regPoints = {}
end

function Telepoints.MoveTo(playerId, pointId)
   print("qbt.Telepoints.MoveTo() on playerId,pointId '" .. tostring(playerId) .. "," .. pointId .. "'");
   local player = getSpecificPlayer(playerId);
   local newPoint = Telepoints.GetPoint(pointId);
   print("qbt.Telepoints moving player '" .. tostring(player) .. "' to pointName '" .. newPoint.Name .. "'");
   player:setX(newPoint.X);
   player:setY(newPoint.Y);
   player:setZ(newPoint.Z);
   player:setLx(newPoint.X);
   player:setLy(newPoint.Y);
   player:setLz(newPoint.Z);
end

function Telepoints.GetAvailablePoints()
   local points = {};
   for pointId, values in pairs(Telepoints._regPoints) do
      table.insert(points, {Id = pointId, Name = values.Name})
   end
   return points;
end

function Telepoints.GetPoint( id )
   for pointId, point in pairs(Telepoints._regPoints) do
      if pointId == id then
         return point;
      end
   end
   error("There is no point with ID of '" .. id .. "'", 2 );
end

qbt.Telepoints = Telepoints