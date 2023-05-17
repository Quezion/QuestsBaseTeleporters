local qbt = require "QBTUtilities"

Telepoints = {
   _regPoints = {},
   _returnPoint = {}
};

local transporter = {

}

function Telepoints.AddPoint( id, x, y, z )
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

-- TODO: Telepoints.RemovePoint(id)


function Telepoints.MoveTo( player, id )
   print("=======================> Moving player '" .. tostring(player) .. "' to point '" .. id .. "'");
   -- commented out, don't think this is necessary now that we're
   -- correctly passing the player object from the teleporter callbacks
   player = getSpecificPlayer(player);
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
   Telepoints._returnPoint.Last = lastPos;
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

function Telepoints.CanReturn()
   if not Telepoints._returnPoint.Last then
      return false;
   else
      return true;
   end
end

function Telepoints.Return( player )
   player = player.player;
   local returnPoint = Telepoints._returnPoint.Last;
   player:setX( returnPoint.X );
   player:setY( returnPoint.Y );
   player:setZ( returnPoint.Z );
   player:setLx( returnPoint.X );
   player:setLy( returnPoint.Y );
   player:setLz( returnPoint.Z );
   Telepoints._returnPoint.Last = nil;
end

Telepoints.AddPoint("Louisville", 12697, 2347);
Telepoints.AddPoint("Rosewood",8093,11658);
Telepoints.AddPoint("WestPoint",11927,6886);

Telepoints.AddPoint("Muldraugh", 10604, 9934);

Telepoints.AddPoint("Riverside", 6538, 5309);

Telepoints.AddPoint("MarchRidge", 10009, 12706);

qbt.Telepoints = Telepoints