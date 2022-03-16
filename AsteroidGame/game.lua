local composer = require( "composer" )
local scene = composer.newScene() --this allows me to use scene composer and hence shift scenes. This is done on each file.

require "Class.30logglobal"
local player = require "Class.player"
local asteroid = require "Class.asteroid"
local bullet = require 'Class.bullet'
local score = require 'Class.score'
local asteroids = {}
local bullets = {}
local cooldown = 20
local highscore = 0
local loop -- this needs to be global as else the function does not work
local midX = display.contentCenterX
local midY = display.contentCenterY
local width = display.contentWidth
local height = display.contentHeight
local playerWidth = 30
local playerHeight = 30

local keys = {} --this table is for the boolean value I will use to make sure the player moves smoothly
keys['left'] = false
keys['right'] = false
keys['up'] = false
keys['space'] = false

--[[ The lines above are just declaring the variables I will be using. The top 2 lines are so that the corona uses the code
in this file as a scene. All the require functions are so that the code can refer to the objects that would be produced in the
class files when it is called. I made an array called 'asteroids' so that all of them can be stored. Cooldown is going to be reduced
by 1 each frame and I found that 1/3 second delay before each bullet is shot hence 20 was used. The highscore is set at 0 at
first since the player hasn't played the game at the start.
 ]]



        local function asteroidSpawn()
          local angle = math.random(0,2*math.pi)
          local radius = math.random(10,25)
          local x = midX + math.cos(angle)*1000
          local y = midY + math.sin(angle)*1000
          table.insert(asteroids,asteroid:new(x,y,radius))
        end

        --@param random x value and y value and a radius value being sent to the class file for the asteroid

        local function gameStart()
          if #asteroids < 10 then
            asteroidSpawn()
          end
        end

        --[[ The two functions above work hand in hand. asteroidSpawn is above gameStart due to scope. gameStart is called every
        0.3 seconds by the variable loop using delay. gameStart then checks whether the number of asteroids in the table is less
          than 10. If it is, it calls the function asteroidSpwan, above it. asteroidSpawn is the function for the creation of the
          asteroids. I used x and y values as the x and y coordinate parameter for the asteroids. It has math.sin and math.cos and
          angle at the top of the function, angle because I wanted them to be created in different places on the screen. To visualise
          the creation of asteroids, I made the reference point for the x and y values at the centre of the screen. The addition of
          cos and sin caused them to be created at an angle and most of them should have different angles (there could be repeating).
          The multiplication of 1000 was just a failsafe for the asteroids not being created on the screen but techincally out of it.
          I had made a loop boundary so every asteroid would take no time in coming into the scene even if it technically had an x
          value of something much larger than the display.contentWidth. Since each asteroid is unique, I inserted them into a table
          asteroids which I declared earlier. The asteroid is made in the class file hence it is 'a:new'
        ]]

        local function playerMovement(event)
          local down = event.phase=="down";
          if(event.phase=="down") then
            if(event.keyName == "left") then
              keys['left'] = true
            elseif(event.keyName == "right") then
              keys['right'] = true
            elseif(event.keyName == "up") then
              keys['up'] = true
            elseif(event.keyName == 'space') then
              keys['space'] = true
            end

          else
            if(event.keyName == "left") then
              keys['left'] = false
            elseif(event.keyName == "right") then
              keys['right'] = false
            elseif(event.keyName == "up") then
              keys['up'] = false
            elseif(event.keyName == 'space') then
              keys['space'] = false
            end

          end
        end

        --[[
        @param the key pressed even was passed into the function above. 
        It checks if the button is pressed down and if it is, it is set to true else to false.
        This will be used later to determine movement.
        ]]

        --[[This function corresponds to the ]]

        local function collision(self,event)
          if (event.phase == 'began') then
            if event.other.name == 'bullet' and self.name == 'asteroid' then
              if self.isAlive == true then
                self.isAlive = false
                event.other.isAlive = false
                dispScore:update()
              end
            end
          end
        end

        --[[ @param the object to which is attached (self) and the collision event is being sent in as parameters.

            This function is called by the collision event listener. So if the event begins, the function checks whether it is between
            a bullet and an asteroid. These names were declared in the class files. If they are i.e bullet hits asteroid, I set the alive
            variable of the asteroid involved to false along with the bullet's alive variable as well.
             This is useful in the later function. The score is then updated by the score object file being called and the function update in
            that file being run.

        ]]
        local function gameLoop(event)
          cooldown = cooldown - 1
          if dispPlayer.player.isAlive == false then
            composer.gotoScene('end')
            return
          end

          --@param enterframe is the event where it runs every frame

          --if player.player.alive == true then --check if the player is alive
            if(keys['right']) then
            dispPlayer:rotation('right')
            end
            if(keys['left']) then
            dispPlayer:rotation('left')
            end
            if(keys['up']) then
            dispPlayer:move('up')
            end
            if(keys['space']) then
              if cooldown <= 0 then
                local angle = ((dispPlayer.rotateAngle*math.pi)/180)
                local bullet = bullet:new(dispPlayer.player.x,dispPlayer.player.y,10,2,500*math.sin(angle),-500*math.cos(angle),angle)
                bullet.isBullet = true --this just allows the collision detection to be better
                table.insert(bullets,bullet)
                cooldown = 20
              end
            end

            for i = #bullets,1,-1 do
              if bullets[i].bullet.isAlive == true then --checks if the bullet is alive
                bullets[i]:boundary() --checks if the bullet has left the game screen
              else
               display.remove(bullets[i].bullet)
                table.remove(bullets,i)
              end
            end

            for i = #asteroids,1,-1 do
              if asteroids[i].asteroid.isAlive == true then
              asteroids[i]:movement()
              asteroids[i].asteroid.collision = collision
              asteroids[i].asteroid:addEventListener('collision',asteroids[i].asteroid)
              else
              display.remove(asteroids[i].asteroid)
              table.remove(asteroids,i)
              end
            end
            
            for i = #asteroids,1,-1 do
                if (math.abs(asteroids[i].asteroid.y - dispPlayer.player.y)) <= asteroids[i].radius + 15 and (math.abs(asteroids[i].asteroid.x - dispPlayer.player.x) <= asteroids[i].radius + 15) then
                  dispPlayer.player.isAlive = false
                end
            -- print(asteroids[i].asteroid.alive)
            end
          end
        --end
  
        --[[ If the player is alive, it checks every frame whether the the buttons for shooting and movement are pressed i.e 
            being set as true in the earlier function.

            @param If a key is pressed the key name is sent to the class file for the player so that the action can be
            executed.

        ]]
      

      --[[This function is run every frame of the game since it adheres to the enterFrame event. Cooldown is reduced by 1 each frame.
      This means that since the game runs at 60 frames per second, it takes about .333 seconds to go to zero. When it goes to zero,
      the player can shoot the bullet, as said earlier. Putting this under this function helps since cooldown is reduced each frame
      it helps achieve the delay I require. Each frame, so that there is no delay, it is checked whether the player is dead.
      the player is dead, then everything to do with asteroid collisions would not run and the scene would change to the end scene.
      For the collsions, i iterate the bullets array to check if each bullet is 'alive' or not and if it isn't then the bullet is
      removed from the array along with it being not displayed. I do the same with the asteroids. They are in different for loops
      as they would have different number of objects in their respective arrays. These two are soley for the bullet asteroid collision.

      Since there is a way to make collisions local, I decided to do so. In line 131, it calls the movement function in the class file
      moves each asteroid. This is only executed after checking if the asteroid is alive or not since there is no point if it isn't.
      The two lines after call the local collision function which works. Since I want collisions to work for all the alive asteroids,
      it makes sense. I need this to be under gameloop since it needs to be checked each frame else it may miss some asteroids.

      Before the collisions are checked between player and asterodi, I checked if the asteroids that could be 'dead' are removed from the array and are destroyed.
      The 'dead' is determined if they collided with a bullet from the player. I do this using a for loop so that all the asteroids are
      checked each frame. For both for loops i iterate it backwards as corona skips in iteration if one of the objects is removed, which
      in this it does occur. I then added a for loop so that each asteroid is checked for collisions. Else, if player is alive, instead of using collisions,
       since I didn't want to add physics to the player, I checked difference in both x and y value to determine whether they are close enough.
       math.mod helps in doing that since if the number is negative, it
      is turned positive. This helps in situations where the y coordinate of the player is far greater than that of the asteroid and hence
      the difference is negative. This does not mean they are close so getting the absolute value helps in that regard. Since each asteroid
      has a different radius, corona checks if the difference in x and y parameters, both, is less than the radius of each asteroid and the
      width of the player object. This is because they would be touching if it is and that should kill the player. For the player to be removed
      and the scene to change, the alive variable must be made false and hence it is.
      ]]

        -- Code here runs when the scene is still off screen (but is about to come on screen)




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()


-- function scene:create( event ) --@param composer event

--     local sceneGroup = self.view
--     -- Code here runs when the scene is first created but has not yet appeared on screen

-- end


-- show()
function scene:show( event )

    keys['left'] = false --need to declare each time this scene is run as otherwise it carries on from the game before
    keys['right'] = false
    keys['up'] = false
    keys['space'] = false

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        dispScore = score:new(midX,50) --@param the coordinates for the score to be displayed is sent to score object file (centre of screen)
        dispPlayer = player:new(midX,midY,playerWidth,playerHeight) --@param coords for the player sprite to be spawned and its dimensions

          Runtime:addEventListener("key",playerMovement)
          Runtime:addEventListener("enterFrame", gameLoop)
          loop = timer.performWithDelay(300,gameStart,0)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end

--[[ In the show event of composer, this code is run over and over so that if scene is called back again, it can run the code. In this
case, since I need the player and score to be displayed at all times, it is created using the class file which creates the object. The
event listeners that call all the functions above are run each time the scene is on and hence the game functions. The loop is not event
listerner but acts as the delay. I added a delay of 0.3 seconds so that the asteroid production doesn't all happen at the same time but
happens so gradually and hence giving the player time to think.

]]


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        composer.setVariable('composerScore',dispScore.playerScore)
        if dispScore.playerScore >= highscore then
          highscore = dispScore.playerScore
        end
        composer.setVariable('highscore',highscore)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        
        dispPlayer.player:removeSelf()
        dispScore.text:removeSelf()
        for i = #asteroids,1,-1 do
          display.remove(asteroids[i].asteroid)
          table.remove(asteroids,i)
        end
        for i = #bullets,1,-1 do
          display.remove(bullets[i].bullet)
          table.remove(bullets,i)
        end
        Runtime:removeEventListener('enterFrame',gameLoop)
        Runtime:removeEventListener("key",playerMovement)
        timer.cancel(loop)

        --@param all these are sent into the respective functions with the required event.

    --[[In the hide event, all the things displayed must be removed if they are not meant to be in the scene after. For the score to
    be displayed on the scene after this, I put it in the will section as othertwise the score variable would not be displayed. I used
    setVariable since it helps with transferring variables from one scene to another. I did the same with highscore by using set and
    get to transfer to the end screen. Since it is the highscore value, if the player's score in that instance is higher than that of
    the highscore then highscore takes that value and if it isn't it remains the same. I display this at the endscreen.
    It obtains the score by checking the score from the class file.
    I set the variable composerScore since I did not want it to confuse with anything else. If the scene to be moved,
    it means the player is dead and hence I remove it along with the score as that is not required in the scene after. All the asteroids
    are removed (that are still alive) using the for loop since it iterates through each object in the array and removes it. I stop
    all the eventListeners so that the code is stopped from working.

    I remove the asteroids and bullets using the loop since there would many of them and they are in array. The loop removes each
    object in it systematically.

    ]]
        --timer.cancel(loop)
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
--scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
-- -----------------------------------------------------------------------------------

return scene
