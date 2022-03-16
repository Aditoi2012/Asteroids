local player = class()
player.__name = "player"
-- local physics = require "physics"
-- physics.start()
-- physics.setGravity(0,0)
function player:__init(x,y,w,h) -- @param this takes in the parameters that are sent from game and then creates the sprite
  self.player = display.newImage('player.png',x,y)
  self.player:setFillColor(1,0,0)
  --physics.addBody(self.player,"dynamic")
  self.rotateAngle = 0
  self.player:rotate(self.rotateAngle)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  --self.player.name = 'player'
  self.player.isAlive = true
end

--[[ This initializing creates and displays the player as a shape. I set all the parameters as variables in case I want to change them
in the game scene file. I added the alive variable to the player object so that I can make the game more robust overall. The alive
variable helps with the game file which is explained there. Since the player is 'alive' at the start, it is true. It is changed to
false if the player dies. The rotateAngle is 90 because I wanted the player to originally start at 90 degrees. This changes in the
following function.
]]


function player:rotation(key)
	if key == 'right' then
		self.rotateAngle = self.rotateAngle + 3
	elseif key == 'left' then
		self.rotateAngle = self.rotateAngle - 3
	end
	self.player.rotation = self.rotateAngle
	--print(self.rotateAngle)
end

--@param the key string is sent via the game file. This then dtermines the angle of the sprite
--@return although it is not specifically returned, the player rotation occurs

--[[ This is the function that is called from game.lua when a key is pressed. The function checks what key was pressed and then changes
   the rotation accordingly. The key that is pressed is passed as a parameter in the game scene. So, if it's right, the angle changes by
   7.5 degrees to the right and to the left if left is pressed. After the angle has been reassigned regarding whether the right or left
   keys are pressed, after the if statement, I change the rotation of the object to the new angle. This makes the object face in the right
   direction.
   ]]

function player:move(key)
	if key == 'up' then
		self.player.y = self.player.y - (2.5 *math.sin((self.rotateAngle*math.pi)/180 + math.pi/2))
		self.player.x = self.player.x - (2.5*math.cos((self.rotateAngle*math.pi)/180 + math.pi/2))
	end
	if self.player.x <= 0 - self.w then
		self.player.x = display.contentWidth
	elseif self.player.x >= display.contentWidth + self.w then
		self.player.x = 0
	elseif self.player.y <=	 -40 - self.w then
		self.player.y = display.contentHeight + 40 + self.w
	elseif self.player.y >= display.contentHeight + 40 + self.w then
		self.player.y = -40 - self.w
	end
end
return player

--@return returns the entire class file of the object so that it can be used and manipulated for the game file

--[[ For the player's movement to make sense, I wanted the player to move at the angle that the rotation was at. For this trigonomtery
wouldbe required. For the player to move at an angle, the magnitude by what they move in the x and y directions must be proportional
to the angle of the object. For this to happen, I set the x value of the player to be reduced by the cos of the angle that was set
earlier and for the y value, the sin of the new rotation angle. Cos and sin for movement are specifically used. It makes more logical
sense to use cos for the x since in a triangle in a circle, we see the adjacent on the x axis and sin on the y. The x and y magnitude
of change changes as the angle changes and if the y is small then the x will be big which means it is closer to 90 degrees. This helps
the object move at an angle. From 49 to 57, it is code for the playerlooping around the screen. If the player moves out the screen,
the object is placed on the opposite side to enter the screen again. Since the boundaries in Corona are not exactly at the screenHeight
I had to add an extra constant being 50. The x axis has accurate results.
]]
