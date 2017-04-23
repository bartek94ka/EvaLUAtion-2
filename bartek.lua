counter = 0
wielkoscmapy = 800
wait1 = 0
resetmove1 = 0
minimalDistance = 10000
shortestDistanceToActiveTrigger = 1000
distanceToNearbyEnemy = 1000
targetEnemy = 0
randomMoveCount = 0
function bartekonStart( agent, actorKnowledge, time)
        agent:selectWeapon(3);
end

function bartekwhatTo( agent, actorKnowledge, time)

		selfInfo = actorKnowledge:getSelf()
		if ( actorKnowledge:isMoving()==false) then
			agent:moveTo(Vector4d(math.random(0,wielkoscmapy),math.random(0,wielkoscmapy),0,0))
			triggerNumber = -1
			nav = actorKnowledge:getNavigation()
			for i=0, nav:getNumberOfTriggers() -1, 1 do
					trig = nav:getTrigger( i)
					dist = trig:getPosition() - actorKnowledge:getPosition() 
					if( trig:isActive() and dist:length() < shortestDistanceToActiveTrigger ) then
						shortestDistanceToActiveTrigger = dist:length()
						triggerNumber = i
					end
			end
			
			if( triggerNumber > -1) then
				trig = nav:getTrigger(triggerNumber)
				agent:moveTo(trig:getPosition())
			elseif( triggerNumber == -1) then
				agent:moveTo(Vector4d(math.random(0,wielkoscmapy),math.random(0,wielkoscmapy),0,0))
			end
			
			if( shortestDistanceToActiveTrigger > - 1 and shortestDistanceToActiveTrigger > 10) then
				shortestDistanceToActiveTrigger = 1000
			end
        end
		
		detectedEnemies = actorKnowledge:getSeenFoes()
		enemiesCount = detectedEnemies:size()
		
		
		 
		io.write( "Enemy count: ", enemiesCount, "\n")
		if ( enemiesCount == 1) then 
			position = detectedEnemies:at(0):getPosition()
			distanceToNearbyEnemy = (position - actorKnowledge:getPosition()):length()
			weapon = GetWeaponForDistance(distanceToNearbyEnemy, actorKnowledge)
			
			
			if(weapon == Enumerations.RocketLuncher) then
				agent:selectWeapon(2)
				io.write( "RocketLuncher","\n")
			end
			if(weapon == Enumerations.Shotgun) then
				agent:selectWeapon(3)
				io.write( "Shotgun","\n")
			end
			if(weapon == Enumerations.Chaingun) then
				agent:selectWeapon(0)
				io.write( "Chaingun","\n")
			end
			if(weapon == Enumerations.Railgun) then
				agent:selectWeapon(1)
				io.write( "Railgun","\n")
			end
			
			
			io.write( "Wybrano: ", actorKnowledge:getWeaponType())
			agent:shootAtPoint( position )
		end
		
		
		if ( enemiesCount == 2)then
			for i=0,enemiesCount-1,1 do
				position = detectedEnemies:at(i):getPosition()
				if(distanceToNearbyEnemy > (position - actorKnowledge:getPosition()):length()) then
					distanceToNearbyEnemy = (position - actorKnowledge:getPosition()):length()
					targetEnemy = i
				end
			end
			weapon = GetWeaponForDistance(distanceToNearbyEnemy, actorKnowledge)
			io.write( "Wybrano: ")
			if(weapon == Enumerations.RocketLuncher) then
				agent:selectWeapon(2)
				io.write( "RocketLuncher","\n")
			elseif(weapon == Enumerations.Shotgun) then
				agent:selectWeapon(3)
				io.write( "Shotgun","\n")
			elseif(weapon == Enumerations.Chaingun) then
				agent:selectWeapon(0)
				io.write( "Chaingun","\n")
			elseif(weapon == Enumerations.Railgun) then
				agent:selectWeapon(1)
				io.write( "Railgun","\n")
			end
			agent:shootAtPoint( detectedEnemies:at(targetEnemy):getPosition() )
			distanceToNearbyEnemy = 500
			targetEnemy = 0
		end
		
		if (enemiesCount == 3)then
		
		end
		
end;

function GetWeaponForDistance(distance, actorKnowledge)
	io.write( "RocketLuncher: ", actorKnowledge:getAmmo(Enumerations.RocketLuncher) ,"\n")
	io.write( "Railgun: ", actorKnowledge:getAmmo(Enumerations.Railgun) ,"\n")
	io.write( "Shotgun: ", actorKnowledge:getAmmo(Enumerations.Shotgun) ,"\n")
	io.write( "Chaingun: ", actorKnowledge:getAmmo(Enumerations.Chaingun) ,"\n")
	if(distance < 50) then
		io.write( "Distance < 50","\n")
		if(actorKnowledge:getAmmo(Enumerations.Chaingun) > 0) then
			return Enumerations.Chaingun
		elseif(actorKnowledge:getAmmo(Enumerations.Shotgun) > 0) then
			return Enumerations.Shotgun
		elseif(actorKnowledge:getAmmo(Enumerations.RocketLuncher) > 0) then
			return Enumerations.RocketLuncher
		elseif(actorKnowledge:getAmmo(Enumerations.Railgun) > 0) then
			return Enumerations.Railgun
		end
	elseif(distance >= 50 and distance < 150) then
		io.write( "Distance >= 50 and < 150","\n")
		if(actorKnowledge:getAmmo(Enumerations.RocketLuncher) > 0) then
			io.write( "Railgun","\n")
			return Enumerations.RocketLuncher
		elseif(actorKnowledge:getAmmo(Enumerations.Chaingun) > 0) then
			io.write( "Chaingun","\n")
			return Enumerations.Chaingun
		elseif(actorKnowledge:getAmmo(Enumerations.Shotgun) > 0) then
			io.write( "Shotgun","\n")
			return Enumerations.Shotgun
		elseif(actorKnowledge:getAmmo(Enumerations.Railgun) > 0) then
			io.write( "RocketLuncher","\n")
			return Enumerations.Railgun
		end
	elseif(distance >= 150 and distance < 200) then
		io.write( "Distance >= 50 and < 150","\n")
		if(actorKnowledge:getAmmo(Enumerations.Chaingun) > 0) then
			return Enumerations.Chaingun
		elseif(actorKnowledge:getAmmo(Enumerations.Railgun) > 0) then
			return Enumerations.Railgun
		elseif(actorKnowledge:getAmmo(Enumerations.RocketLuncher) > 0) then
			return Enumerations.RocketLuncher
		elseif(actorKnowledge:getAmmo(Enumerations.Enumerations.Shotgun) > 0) then
			return Enumerations.Shotgun
		end
	elseif(distance >= 200) then
		return Enumerations.Chaingun
	end
	
end

function isEnemyNear(enemiz, esiz, aen) 
	isnear = 0
	for ien=0,esiz-1,1 do
		if(ien ~= aen) then
			dyst = enemiz:at(ien):getPosition() - enemiz:at(aen):getPosition()
			if(dyst:length() < 50) then
				isnear = 1
			end
		end
	end
	return isnear
end