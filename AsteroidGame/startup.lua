local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local button
local buttonText
local title
local username
local askUsername

--I declare all the variables at the start. I place a value or object later into the code.

local function changeScenes(event) --@param takes in the event
    --composer.gotoScene('game',{effect = 'slideLeft'})
    if string.len(username.text) < 4 or string.len(username.text) > 15 then 
        native.showAlert('Error','Character Limit incorrect')
    elseif username.text:sub(1,1) == ' ' then 
        native.showAlert('Error','First character is a space!')
    else composer.gotoScene('game',{effect = 'slideLeft'})
         composer.setVariable('playerUsername', username.text)
    end
end

--[[This function is called by the button event listener. It asks the player to add a name to the ship they would be using
i.e a username. Since I wanted it to be a proper username, I had the limit of 15 characters, so that players don't put in
random long names and the minimum of 4 since otherwise it is not a username. So, to keep it on the same scene and pop an error
I made sure if the character length of the user input is less than 4 or greater than 15 (with len), an error pops up. If not,
i.e everything is fine, then it shifts the screen. This is only run when the button is pressed, i.e player wanting to play. If
the requirement is met then I set the username as a variable 'playerUsername' so that it can be accessed at the end scene. I
obtain the text entered in the field by username.text.
]]


-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    title = display.newText('Asteroids',display.contentCenterX,50,native.systemFont,40)
    title:setFillColor(0.502,0.502,0.502)
    sceneGroup:insert(title)

    button = display.newRect(display.contentCenterX,display.contentHeight*.9,display.contentWidth*.7,display.contentHeight*0.15)
    button:setFillColor(0,1,0)
    sceneGroup:insert(button)

    buttonText = display.newText('Lets Go!',display.contentCenterX,display.contentHeight*.9)
    sceneGroup:insert(buttonText)

    askUsername = display.newText('Enter Username (between 4 - 15 please):',display.contentCenterX,display.contentHeight*0.45,native.systemFont,15)
    sceneGroup:insert(askUsername)

    username = native.newTextField(display.contentCenterX,display.contentHeight*.55, display.contentWidth*0.9,30)
    username.inputType = 'default'
    sceneGroup:insert(username)

end

--[[I created a title in the centre on top while naming the object text title. I made the button at the bottom of the screen and since
I wanted some text on it, I made the same x and y coordinates for the text field which says 'let's go.' To make sure the player knows
that the condition i have set, I made it display using text being displayed. For the player input, I use the newTextField. I inserted
all of them in a scene group so that they move when the scene shifts. This does not occur if they are not put in a scenegroup.
]]


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        button:addEventListener('tap',changeScenes)
    end
end


-- hide()




-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
------------------------------------------

return scene
