counter = 0
wielkoscmapy = 800
zycie = 1000
najkrutsza = 9999
function miloszonStart( agent, actorKnowledge, time)
        agent:selectWeapon(Enumerations.RocketLuncher);
end
function miloszwhatTo( agent, actorKnowledge, time)
        
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
        
end;