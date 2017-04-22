--dumbMy.lua
function dumbMywhatTo( agent, actorKnowledge, time)

  friends= actorKnowledge:getSeenFriends()
  if ( friends:size() > 0) then
     dir = friends:at(0):getPosition() - actorKnowledge:getPosition()
     agent:moveDirection( dir*(-1))
     if ( dir:length() > 20) then
	 dest = friends:at(0):getPosition()
         agent:moveTo( dest )
     end
  end 

  changeWeapon = 0
  if ( actorKnowledge:getAmmo( actorKnowledge:getWeaponType()) == 0) then
	weapon = actorKnowledge:getWeaponType()
	weapon = weapon + 1
        agent:selectWeapon( weapon)
	changeWeapon = 1
  end

  
  enemies = actorKnowledge:getSeenFoes()
  if ( enemies:size() > 0) then
	if ( changeWeapon == 0) then
     	  agent:shootAtPoint( enemies:at(0):getPosition())
 	end
  end
end;

function dumbMyonStart( agent, actorKnowledge, time)
end

function showVector( vector)
    io.write( "(")
    io.write( vector:value(0))
    io.write( ",")
    io.write( vector:value(1))
    io.write( ",")
    io.write( vector:value(2))
    io.write( ",")
    io.write( vector:value(3))
    io.write( ");")
end;