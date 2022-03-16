local score = class()
score.__name = 'score'

function score:__init(x,y) --take in the x and y value for the score to be placed
	self.playerScore = 0
	self.text = display.newText('Score: '..self.playerScore,x,y)
	self.x = x
	self.y = y
end

--[[I needed the score to be produced at the top of the screen of the game scene and made it an object and hence the class file. The 
score at the start, when created, had to be 0 hence the variable playerScore being 0. For the object to be created, I set a variable text
referring to the object score's text. This was producing text which said 'Score:' concatonated with the playerScore variable. The x and
y value were the parameters added before calling the function. 
]]

function score:update()
	self.playerScore = self.playerScore + 10
 	self.text.text = 'Score: '..self.playerScore
 end

--[[ Since the score would change after a bullet colldies with an asteroid, the score must be updated hence I named this function
update. This is called after a bullet collides with an asteroid. I add the playerScore by 10 after one asteroid is destroyed. 
To display this onto the scene, I changed the text of the text object for the score to the newly updated playerScore. The change
is instantaneous as it changes the moment a bullet collides with an asteroid. 
]]

return score

--@return returns the entire score template. The update function updates the score without any parameters or returning anything
--back to the code calling the function as it can directly be done here.