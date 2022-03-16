
local function collision(self,event)



for i = #bullets, 1, -1 do
	bullets[i].collision = collision
	bullets[i]:addEventListener('collision',bullets[i].collision)
end



