local asteroid = class()
asteroid.__name = "asteroid"
local physics = require "physics"
physics.start()
physics.setGravity(0,0)

--[[ Since I'm using collisions event to determine whether the bullets from the player has collided with the player, I needed to add
physics to each of the asteroid object. I set hte gravity to 0,0 because it's 9.8 by default.
]]

function asteroid:__init(x,y,r)
  self.asteroid = display.newCircle(x,y,r) --@param this takes in the parameters sent in by game and then creates the asteroid
  self.asteroid:setFillColor(0.502,0.502,0.502)
  self.angle = math.random(-math.pi/2 + 0.1,math.pi/2 + 0.1)
  physics.addBody(self.asteroid, 'dynamic')
  self.x = x
  self.y = y
  self.radius = r
  self.asteroid.name = 'asteroid'
  self.asteroid.isAlive = true
end

--[[ This is where the asteroid is created. I wanted each asteroid to have a different angle hence as the initializer is called, each
asteroid has a different angle. It specifically has 0.1 added so that there is less of a chance of an asteroid moving in a straight line.
There is still a chance with 0 but that is too minor. I had to set what type of physics and like bullets, I made it dynamic. I use
the alive variable to determine whether the asteroid should be removed or not in game.lua. The name is important for the collisions.
]]

function asteroid:movement()
  --print(self.asteroid.x)
  self.asteroid.x = self.asteroid.x + math.cos(self.angle)
  self.asteroid.y = self.asteroid.y + math.sin(self.angle)
  if self.asteroid.x < -self.radius then
    self.asteroid.x = display.contentWidth
  end
  if self.asteroid.y < -self.radius - 50 then
    self.asteroid.y = display.contentHeight + 50
  end
  if self.asteroid.x > display.contentWidth + self.radius then
    self.asteroid.x = 0
  end
  if self.asteroid.y > display.contentHeight + self.radius + 50 then
    self.asteroid.y = -50
  end
end

return asteroid

--@return this returns the object template and is created each time it is called by the asteroid generator

--[[ This function above is called for each time a new asteroid is created. The reason why it is a completely different function is 
because I need to be checked for the looping process. To make it move, I used x and y values to determine their trajectory using the 
same trignometry as does player with the x and y value being dependent on the angle set to it. From 32 to 42, it is code for the asteroids
looping around the screen. If the asteroid moves out the screen, the object is placed on the opposite side to enter the screen again.
Since the boundaries in Corona are not exactly at the screenHeight I had to add an extra constant being 50.  
The self.radius is implemented so that the whole asteroid is out of the screen and not just a part of it.The self.radius addition to both the
x and y parameters ensure the entire object is out of the screen.
]]