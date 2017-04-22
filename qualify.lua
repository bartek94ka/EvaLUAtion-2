counter = 0
wielkoscmapy = 800
zycie = 1000
najkrutsza = 9999
function qualifyonStart( agent, actorKnowledge, time)
        agent:selectWeapon(Enumerations.RocketLuncher);
end
function qualifywhatTo( agent, actorKnowledge, time)
        
        if ( actorKnowledge:isMoving()==false) then
                agent:moveTo(Vector4d(math.random(0,wielkoscmapy),math.random(0,wielkoscmapy),0,0))
                nav = actorKnowledge:getNavigation()
                for i=0, nav:getNumberOfTriggers() -1, 1 do
                        trig = nav:getTrigger( i)
                        dist = trig:getPosition() - actorKnowledge:getPosition()
                        if(dist:length()<100 and trig:isActive())then
                                agent:moveTo(trig:getPosition())
                        end
                end
        end
        
        if(actorKnowledge:getHealth()<zycie/2)then
                nav = actorKnowledge:getNavigation()
                for i=0, nav:getNumberOfTriggers() -1, 1 do
                        trig = nav:getTrigger( i)
                        if(trig:getType() == Trigger.Health and trig:isActive())then
                                agent:moveTo(trig:getPosition())
                        end
                        if(trig:getType() == Trigger.Armour and trig:isActive())then
                                agent:moveTo(trig:getPosition())
                        end
                end
        end
        
        if (actorKnowledge:getAmmo(Enumerations.RocketLuncher) ~= 0) then
                agent:selectWeapon(Enumerations.RocketLuncher);
        elseif (actorKnowledge:getAmmo(Enumerations.Railgun) ~= 0) then
                agent:selectWeapon(Enumerations.Railgun);
        elseif (actorKnowledge:getAmmo(Enumerations.Shotgun) ~= 0) then
                agent:selectWeapon(Enumerations.Shotgun);
        elseif (actorKnowledge:getAmmo(Enumerations.Chaingun) ~= 0) then
                agent:selectWeapon(Enumerations.Chaingun);
        end
        
        if(actorKnowledge:getAmmo(Enumerations.RocketLuncher)==0 and actorKnowledge:getAmmo(Enumerations.Railgun) == 0 and actorKnowledge:getAmmo(Enumerations.Shotgun) == 0 and actorKnowledge:getAmmo(Enumerations.Chaingun) == 0)then
                nav = actorKnowledge:getNavigation()
                for i=0, nav:getNumberOfTriggers() -1, 1 do
                        trig = nav:getTrigger( i)
                        dist = trig:getPosition() - actorKnowledge:getPosition()
                        if(dist:length()<najkrutsza and trig:isActive())then
                                najkrutsza = i
                        end
                end
                if ( najkrutsza < 9999 ) then
                    agent:moveTo(nav:getTrigger(najkrutsza):getPosition())
                end
        end
        
        enemies = actorKnowledge:getSeenFoes()
        if ( enemies:size() > 0) then
                dir = enemies:at(0):getPosition() - actorKnowledge:getPosition()
                if (enemies:at(0):getHealth() > actorKnowledge:getHealth() and actorKnowledge:getHealth() < zycie/2 ) then
                agent:moveDirection( dir*(-1))
                        if ( dir:length() < 200) then
                                dest = Vector4d( agent:randomDouble()*wielkoscmapy, agent:randomDouble()*wielkoscmapy, 0,0)
                                agent:moveTo( dest )
                        end
                end
                if(enemies:at(0):getHealth() <= actorKnowledge:getHealth()-(zycie/4)) then
                        agent:moveDirection( dir)               
                        if ( dir:length() < 120) then
                                dest = Vector4d( agent:randomDouble()*wielkoscmapy, agent:randomDouble()*wielkoscmapy, 0,0)
                                agent:moveTo( dest )
                        end
                end
                agent:shootAtPoint( enemies:at(0):getPosition())
        end     
        
end;