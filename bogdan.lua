counter = 0
wielkoscmapy = 800
wait3 = 0
resetmove3 = 0
function bogdanonStart( agent, actorKnowledge, time)
        agent:selectWeapon(Enumerations.Chaingun);
end

function bogdanwhatTo( agent, actorKnowledge, time)
        mindist = 9999
		mindisttrig = -1
		if(actorKnowledge:getAmmo(Enumerations.RocketLuncher) == 0 and actorKnowledge:getAmmo(Enumerations.Railgun) == 0 and actorKnowledge:getAmmo(Enumerations.Shotgun) == 0 and actorKnowledge:getAmmo(Enumerations.Chaingun) == 0) then
			hasNoAmmo = 1
		else
			hasNoAmmo = 0
		end
		
        if ( actorKnowledge:isMoving()==false or resetmove3 == 1) then
				resetmove3 = 0
                agent:moveTo(Vector4d(math.random(0,wielkoscmapy),math.random(0,wielkoscmapy),0,0))
                nav = actorKnowledge:getNavigation()
                for i=0, nav:getNumberOfTriggers() -1, 1 do
                        trig = nav:getTrigger( i)
                        dist = trig:getPosition() - actorKnowledge:getPosition()
						weightedDist = dist:length()
						if(hasNoAmmo) then
							weightedDist = weightedDist/3
						end
						if( weightedDist < mindist and trig:isActive()) then
							mindist = weightedDist
							mindisttrig = i
						end
						if((trig:getType() == Trigger.Health or trig:getType() == Trigger.Armour) and actorKnowledge:getHealth() < 200) then
							if( dist:length()/2 < mindist and trig:isActive()) then
								mindist = dist:length()/2
								mindisttrig = i
							end
						end
                end
				if(mindisttrig > -1 and mindist < 150)then
					trig = nav:getTrigger(mindisttrig)
                    agent:moveTo(trig:getPosition())
                end
        end

        if (actorKnowledge:getAmmo(Enumerations.Shotgun) ~= 0) then
                agent:selectWeapon(Enumerations.Shotgun)
				wait3 = 0
		elseif (actorKnowledge:getAmmo(Enumerations.Railgun) ~= 0) then
                agent:selectWeapon(Enumerations.Railgun)
				wait3 = 0
        elseif (actorKnowledge:getAmmo(Enumerations.Chaingun) ~= 0) then
                agent:selectWeapon(Enumerations.Chaingun)
		elseif (actorKnowledge:getAmmo(Enumerations.RocketLuncher) ~= 0) then
                agent:selectWeapon(Enumerations.RocketLuncher)
				wait3 = 0
        end

		frendz = actorKnowledge:getSeenFriends()
		fsize = frendz:size()
		  
		enemis = actorKnowledge:getSeenFoes()
		esize = enemis:size()
  
		if ( enemis:size() > 0) then
			if(wait3 == 0) then
				for en=0,esize-1,1 do
					if(enemis:at(en):getHealth() > 0) then
						vectorToEn = (enemis:at(en):getPosition() - actorKnowledge:getPosition()):normalize()
						dystToEn = (enemis:at(en):getPosition() - actorKnowledge:getPosition()):length()
						isok = 1
						dontshoot = 0
						if ( frendz:size() > 0) then
							for fr=0,fsize-1,1 do
								vectorToFr = (frendz:at(fr):getPosition() - actorKnowledge:getPosition()):normalize()
								diff = vectorToFr:dot(vectorToEn)
								if(diff > 0.87) then
									isok = 0
									break
								end
								if(fr == fsize) then
									break
								end
							end
						end
						if(dystToEn > 200 and ( actorKnowledge:getWeaponType() == Enumerations.Shotgun or actorKnowledge:getWeaponType() == Enumerations.Chaingun)) then
							dontshoot = 1
							
							if (actorKnowledge:getAmmo(Enumerations.Railgun) ~= 0) then
								agent:selectWeapon(Enumerations.Railgun)
							elseif (actorKnowledge:getAmmo(Enumerations.RocketLuncher) ~= 0) then
								agent:selectWeapon(Enumerations.RocketLuncher)
							end
						end
						if(dystToEn < 70 and actorKnowledge:getWeaponType() == Enumerations.RocketLuncher) then
							dontshoot = 1
							if (actorKnowledge:getAmmo(Enumerations.Railgun) ~= 0) then
								agent:selectWeapon(Enumerations.Railgun)
							elseif (actorKnowledge:getAmmo(Enumerations.Shotgun) ~= 0) then
								agent:selectWeapon(Enumerations.Shotgun)
							elseif (actorKnowledge:getAmmo(Enumerations.Chaingun) ~= 0) then
								agent:selectWeapon(Enumerations.Chaingun)
							end
						end

						if (isok == 1) then
							if(isEnemyNear(enemis, esize, en) == 1 and actorKnowledge:getAmmo(Enumerations.RocketLuncher) ~= 0) then
								agent:selectWeapon(Enumerations.RocketLuncher)
							end
							
							posEn = enemis:at(en):getPosition()
							
							if(actorKnowledge:getWeaponType() == Enumerations.Chaingun) then
								endir = enemis:at(en):getDirection():normalize() * 4
								posEn = posEn + endir
								wait3 = 2
							else
								wait3 = 0
							end
							
							if(hasNoAmmo == 0 and dystToEn > 100 and actorKnowledge:getAmmo(actorKnowledge:getWeaponType()) > 0) then
								if(enemis:at(en):getWeaponType() == Enumerations.Railgun or enemis:at(en):getWeaponType() == Enumerations.Chaingun) then
									vec = Vector4d( -vectorToEn:value(1), vectorToEn:value(0), 0, 0):normalize() * 10
									vec2 = actorKnowledge:getPosition() + vec
									agent:moveTo( vec2 )
									if( actorKnowledge:isMoving() == false) then
										vec = Vector4d( vectorToEn:value(1), -vectorToEn:value(0), 0, 0):normalize() * 10
										vec2 = actorKnowledge:getPosition() + vec
										agent:moveTo( vec2 )
									end
								elseif	(enemis:at(en):getHealth() < actorKnowledge:getHealth()) then
									agent:moveTo( posEn )
								end
							else
								resetmove3 = 1
							end
							
							if(dontshoot == 0) then
								agent:shootAtPoint( posEn )
							else
								resetmove3 = 1
							end
							
						else
							me = vectorToEn
							mypos = actorKnowledge:getPosition()
							frend = frendz:at(0):getPosition()
							vec = Vector4d( -vectorToEn:value(1), vectorToEn:value(0), 0, 0):normalize() * 10
							vec2 = frend + vec
							agent:moveTo( vec2)
							
						end

						break;
					end	
				end	
			end
			wait3 = wait3 - 1
		else
			wait3 = 0
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