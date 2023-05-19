local qbt = require "QBTUtilities"

Telepoints = {
   _regPoints = {},
};

function Telepoints.Add(id, x, y, z )
   if not id then
      error("There was no ID given", 2 );
   end
   if type(id) ~= "string" then
      error("The given ID is not a string", 2 );
   end
   Telepoints._regPoints[ id ] = {
      X = x,
      Y = y,
      Z = z or 0
   }
end

function Telepoints.Remove(id)
   if not id then
      error("There was no ID given", 2 );
   end
   if type(id) ~= "string" then
      error("The given ID is not a string", 2 );
   end
   Telepoints._regPoints[id] = nil
end

-- TODO: Telepoints.RemovePoint(id)


function Telepoints.MoveTo( playerId, id )
   print("=======================> Moving playerId '" .. tostring(playerId) .. "' to point '" .. id .. "'");
   local player = getSpecificPlayer(playerId);
   print("=======================> Moving player '" .. tostring(player) .. "' to point '" .. id .. "'");
   local lastPos = {
      X = player:getX(),
      Y = player:getY(),
      Z = player:getZ()
   }
   local newPoint = Telepoints.GetPoint( id );

   player:setX( newPoint.X );
   player:setY( newPoint.Y );
   player:setZ( newPoint.Z );
   player:setLx( newPoint.X );
   player:setLy( newPoint.Y );
   player:setLz( newPoint.Z );
end

function Telepoints.GetAvailablePoints()
   local points = {};
   for pointName, _ in pairs(Telepoints._regPoints) do
      table.insert(points, pointName);
   end
   return points;
end

function Telepoints.GetPoint( id )
   for pointName, point in pairs(Telepoints._regPoints) do
      if pointName == id then
         return point;
      end
   end
   error("There is no point with ID of '" .. id .. "'", 2 );
end

-- Builtin In-Game Points
-- Telepoints.Add("Louisville", 12697, 2347);
-- Telepoints.Add("Rosewood",8093,11658);
-- Telepoints.Add("WestPoint",11927,6886);
-- Telepoints.Add("Muldraugh", 10604, 9934);
-- Telepoints.Add("Riverside", 6538, 5309);
-- Telepoints.Add("MarchRidge", 10009, 12706);

qbt.Telepoints = Telepoints