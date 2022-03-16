local composer = require( "composer" )
local scene = composer.newScene()
require "Class.30logglobal"


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
local button
local score
local playerUsername
local buttonText
local highscore

--[[I declare all the variable I'd be using
]]

local function changeScenes(event) --@param takes in the button being pressed event and then shifts the scenes
    composer.gotoScene('game',{effect = 'slideLeft'})
end

--[[ This function is called each time the button is pressed and it moves scenes from the endscreen to the actual game so 
the players can have another go.
]]

function scene:create( event )
    local sceneGroup = self.view

    button = display.newRect(display.contentCenterX,display.contentHeight*.9,display.contentWidth*.7,display.contentHeight*0.15)
    button:setFillColor(0,1,0)
    sceneGroup:insert(button)
    button:addEventListener('tap',changeScenes)
    buttonText = display.newText('Go again!',display.contentCenterX,display.contentHeight*.9)
    sceneGroup:insert(buttonText)
    -- Code here runs when the scene is first created but has not yet appeared on screen
end
 
--[[ I created a button much like startup.lua so that the player can go back and play the game more if they'd like. I inserted the
button in sceneGroup with text since otherwise it would not move even after the scene is shifted. The text, much like startup, is 
so that the player knows what it does.
]]
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        score = display.newText('Score: '..composer.getVariable('composerScore'),display.contentCenterX,display.contentCenterY)
        playerUsername = display.newText('Well done '..composer.getVariable('playerUsername'),display.contentCenterX,display.contentHeight*0.4)
        highscore = display.newText('Your highscore is: '..composer.getVariable('highscore'),display.contentCenterX,display.contentHeight*0.2)
 
    end
end

--[[ To display the score, I used getVariable for composerScore that was set in game.lua so that it can be displayed. Same with 
playerUsername which was set in the startup and not game scene. To add some personlization I added 'well done.' Since I want them
to appear each time the scene shifts back to 'end', I had to put them under show. I also added the highscore for a reason for the 
player to play the game. It also uses get and set variable.
]]
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        score:removeSelf()
        playerUsername:removeSelf()
        highscore:removeSelf()
--[[ Since I created them in show, I would need to remove them in hide. This is so that they don't show up when the player is 
playing the game.
]]
        
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
-- -----------------------------------------------------------------------------------
 
return scene