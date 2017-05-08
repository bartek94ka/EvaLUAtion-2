wielkoscmapy = 800
shortestDistanceToActiveTrigger = 10000
distanceToNearbyEnemy = 10000
targetEnemy = 0
selectWeaponed = 1
actionCount = 0
friendsCount = 0
enemiesCount = 0
isClearShoot = 0
selectedWeapon = 0
triggerNumber = -1
position = Vector4d(math.random(0,wielkoscmapy),math.random(0,wielkoscmapy),0,0)

function AgentBartek1onStart( agent, actorKnowledge, time)
    agent:selectWeapon(actorKnowledge:Railgun());
end

function AgentBartek1whatTo( agent, actorKnowledge, time)

	if (actorKnowledge:isMoving()==false) then
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
		
		if( shortestDistanceToActiveTrigger > - 1 and shortestDistanceToActiveTrigger > 20) then
			shortestDistanceToActiveTrigger = 10000
		end
	end
	
	detectedEnemies = actorKnowledge:getSeenFoes()
	enemiesCount = detectedEnemies:size()
	actionCount = actionCount + 1
	if(actionCount % 2 == 1) then
		actionCount = 1
		if ( enemiesCount == 1) then 
			position = detectedEnemies:at(0):getPosition()
			distanceToNearbyEnemy = (position - actorKnowledge:getPosition()):length()
			selectedWeapon = GetWeaponForDistance(distanceToNearbyEnemy, actorKnowledge)
			if(selectedWeapon ~= nil and selectedWeapon ~= -1) then
				agent:selectWeapon(selectedWeapon)
			elseif(selectWeapon == -1) then
				agent:printMessage("SelectedWeapon doesnt changed")
			end
			distanceToNearbyEnemy = 10000
		elseif ( enemiesCount >  1)then
			position = detectedEnemies:at(0):getPosition()
			distanceToNearbyEnemy = (position - actorKnowledge:getPosition()):length()
			for i=0,enemiesCount-1,1 do
				position = detectedEnemies:at(i):getPosition()
				if(distanceToNearbyEnemy > (position - actorKnowledge:getPosition()):length()) then
					distanceToNearbyEnemy = (position - actorKnowledge:getPosition()):length()
					targetEnemy = i
				end
			end
			selectedWeapon = GetWeaponForDistance(distanceToNearbyEnemy, actorKnowledge)
			if(selectWeapon ~= nil) then
				agent:selectWeapon(selectedWeapon)
			end
			position = detectedEnemies:at(targetEnemy):getPosition()
			distanceToNearbyEnemy = 10000
		end
	elseif(actionCount % 2 == 0 and enemiesCount > 0) then
		actionCount = 0
		detectedFriends = actorKnowledge:getSeenFriends()
		friendsCount = detectedFriends:size()
		enemyPosition = position
		isClearShoot = HasAgentClearWayToShoot(agent, detectedFriends, friendsCount, actorKnowledge:getPosition(), enemyPosition)
		
		if(isClearShoot == 1) then
			dir = enemyPosition - actorKnowledge:getPosition()
			agent:rotate( dir)
			if(actorKnowledge:getAmmo(actorKnowledge:getWeaponType()) > 0) then
				agent:shootAtPoint( position )
			end
			targetEnemy = 0
		end
	end
end

function HasAgentClearWayToShoot(agent, detectedFriends, friendsCount, agentPosition, enemyPosition)
	if(friendsCount == 0) then
		return 1
	elseif(friendsCount > 0) then
		for i=0,friendsCount-1,1 do
			friendPosition = detectedFriends:at(i):getPosition()
			degree = GetAngleBetweenPositions(agentPosition, friendPosition, enemyPosition)
			if(degree ~= nil) then
				if(degree <= 30) then
					return 0
				end
			end
		end
	end
	return 1
end

function GetAngleBetweenPositions(agentPosition, friendPosition, enemyPosition)
	vectorA_X = agentPosition:value(0) - friendPosition:value(0)
	vectorA_Y = agentPosition:value(1) - friendPosition:value(1)
	vectorB_X = agentPosition:value(0) - enemyPosition:value(0)
	vectorB_Y = agentPosition:value(1) - enemyPosition:value(1)
	AoB = vectorA_X * vectorB_X + vectorA_Y * vectorB_Y
	sqrtA = math.sqrt((vectorA_X * vectorA_X) + (vectorA_Y * vectorA_Y))
	sqrtB = math.sqrt((vectorB_X * vectorB_X) + (vectorB_Y * vectorB_Y))
	cosAlfa = AoB / (sqrtA * sqrtB)
	degree = GetAbsDegreeOfCosAlfa(cosAlfa)
	return degree
end

function GetAbsDegreeOfCosAlfa(cosAlfa)
	absCosAlfa = math.abs(cosAlfa)
	if(absCosAlfa >= 0.95) then
		return 0
	elseif(absCosAlfa >= 0.86 and absCosAlfa < 0.95) then
		return 30
	elseif(absCosAlfa >= 0.7 and absCosAlfa < 0.86) then
		return 45
	elseif(absCosAlfa >= 0.5 and absCosAlfa < 0.7) then
		return 60
	elseif(absCosAlfa < 0.5) then
		return 90
	end
end

function GetNextWeapon(actorKnowledge)
	if ( actorKnowledge:getAmmo( actorKnowledge:getWeaponType() ) == 0 ) then
		weapon = actorKnowledge:getWeaponType()
		weapon = ( weapon + 1 ) % 4
		return weapon
	end
end

function GetWeaponForDistance(distance, actorKnowledge)
	if(distance < 50) then
		if(actorKnowledge:getAmmo(actorKnowledge:Chaingun()) > 0) then
			return actorKnowledge:Chaingun()
		elseif(actorKnowledge:getAmmo(actorKnowledge:Shotgun()) > 0) then
			return actorKnowledge:Shotgun()
		elseif(actorKnowledge:getAmmo(actorKnowledge:Railgun()) > 0) then
			return actorKnowledge:Railgun()
		end
	elseif(distance >= 50 and distance < 150) then
		if(actorKnowledge:getAmmo(actorKnowledge:Shotgun()) > 0) then
			return actorKnowledge:Shotgun()
		elseif(actorKnowledge:getAmmo(actorKnowledge:Chaingun()) > 0) then
			return actorKnowledge:Chaingun()
		elseif(actorKnowledge:getAmmo(actorKnowledge:RocketLauncher()) > 0) then
			return actorKnowledge:RocketLauncher()
		elseif(actorKnowledge:getAmmo(actorKnowledge:Railgun()) > 0) then
			return actorKnowledge:Railgun()
		end
	elseif(distance >= 150) then
		if(actorKnowledge:getAmmo(actorKnowledge:Chaingun()) > 0) then
			return actorKnowledge:Chaingun()
		elseif(actorKnowledge:getAmmo(actorKnowledge:Railgun()) > 0) then
			return actorKnowledge:Railgun()
		elseif(actorKnowledge:getAmmo(actorKnowledge:RocketLauncher()) > 0) then
			return actorKnowledge:RocketLauncher()
		elseif(actorKnowledge:getAmmo(actorKnowledge:Shotgun()) > 0) then
			return actorKnowledge:Shotgun()
		end
	end
	return -1
end