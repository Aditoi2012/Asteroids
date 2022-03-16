local bullet = class()
bullet.__name = "bullet"
local physics = require "physics"
physics.start()
physics.setGravity(0,0)

--[[ The first two lines are to specify that the file is a template i.e a class file for an object. Next 3 lines are to make each object
when the class file is called to have physics. Hence, 'require physics' and physics.start(). Gravity is, by deafult, set to 9.8. I did
not want any forces acting on the bullets hence I made them set at 0 for both x and y.
]]

function bullet:__init(x,y,w,h,xVelocity,yVelocity,angle)
	self.bullet = display.newRect(x,y,w,h) -- @param this takes in the parameters that are sent in by the creation of the bullet in game
	physics.addBody(self.bullet,'dynamic') 
	self.angle = (angle*180/math.pi)
	self.xVelocity = xVelocity
	self.yVelocity = yVelocity
	self.x = x
	self.bullet:setLinearVelocity(xVelocity,yVelocity)
	self.bullet:rotate(self.angle + 90)
	self.bullet.name = 'bullet'
	self.bullet.isAlive = true
end

function bullet:boundary() 
	if self.bullet.x < 0 or self.bullet.x > display.contentWidth then
		self.bullet.alive = false
	elseif self.bullet.y< -display.contentHeight-50 or self.bullet.y>display.contentHeight+50 then
		self.bullet.alive = false
	end
end

--This takes in no parameters. It checks if the bullet is in the screen. If it is not, the alive variable is set to false and
--would be deleted.

return bullet
--@return this returns the bullet when the 'new' function is initialized in game


--[[This is the initialising function which is called when 'new:' is used for a variable to store the object. It is called once and
not after that. When this function is called, it is assigned to something for it to be reffered to and used in the main file (game.lua)
For the creation of the bullet, I set it to bullet so that it can easily be accessed when need be. 'bullet' is set to a rectangle with
the required parameters that are sent to the function when it is called. Since all of the parameters are not set to anything, i.e
cannot be accessed in the game file, i set all of them to their names. For example self.yVelocity = yVelocity. For the angle, since it
is sent as radians, I had to turn it back into degrees. setLinearVelocity is so that the bullet moves when the space bar is pressed.
(this file is run when the space bar is pressed). xVelocity and yVelocity is already sent in as a parameter that is determined by the
angle of the player's orientation. Since I want the bullet to move like a bullet, the rotation of the player's object should be the
same for the bullets hence line 22 where the object is rotated at the player's orientation. Since I used collisions for the bullets
and the asteroids, I added the name variable so that the function can determine the collisions. All of this is done in initialising
since it is only called once. I do not want any of this to change for when the spacebar is pressed.
]]
