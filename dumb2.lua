--dumb2.lua

function dumb2whatTo( agent, actorKnowledge, time)
   
end

function dumb2onStart( agent, actorKnowledge, time)

   io.write( "My name is: ", actorKnowledge:getName(), "\n")
   io.write( "Number of Navigation Points is: ", actorKnowledge:getNavigation():getNumberOfPoints() ,"\n")
end


