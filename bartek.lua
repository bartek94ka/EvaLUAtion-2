counter = 0
wielkoscmapy = 800
wait1 = 0
resetmove1 = 0
minimalDistance = 10000
randomMoveCount = 0
function bartekonStart( agent, actorKnowledge, time)
        agent:selectWeapon(Enumerations.Chaingun);
end

function bartekwhatTo( agent, actorKnowledge, time)

		if ( actorKnowledge:isMoving()==false) then
				agent:moveTo(Vector4d(math.random(0,wielkoscmapy),math.random(0,wielkoscmapy),0,0))
				minimalDistanceToTrigger = -1
				nav = actorKnowledge:getNavigation()
                for i=0, nav:getNumberOfTriggers() -1, 1 do
                        trig = nav:getTrigger( i)
                        dist = trig:getPosition() - actorKnowledge:getPosition() 
						if( dist:length() < minimalDistance and trig:isActive()) then
							minimalDistance = dist:length()
							minimalDistanceToTrigger = i
						end
                end
				if(minimalDistanceToTrigger > -1 and minimalDistance < 150)then
					trig = nav:getTrigger(minimalDistanceToTrigger)
                    agent:moveTo(trig:getPosition())
                end
				if(minimalDistance < 5) then
					minimalDistance = 10000
					randomMoveCount = 0
				end
        end
end;

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