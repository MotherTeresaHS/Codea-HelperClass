-- Helper Class Main Tab

-- Created by: Mr Coxall
-- Created on: Nov 2013
-- Created for: ICS2O
-- This program displays an image and let the user move it with their finger

-- Updated on: Oct 2015
-- Updated so you can enter a number to size a button object.1 is 100% normal size. 2.00 would be 200% the size. 0.50 would be 1/2 the size

-- Updated on: Nov 2015
-- Updated so you can "simulate" real Game Center functionality on the iPad
-- Normally you would have to add the Game Center code after you export to Xcode
-- since there is no way to call Game Center in Codea.
-- Now set DEBUG_GAMECENTER = true and alerts will pop up to tell you what is happening.
-- Just before exporting to Xcode, change it to DEBUG_GAMECENTER = false,
-- uncomment the one line of code in Xcode that starts up Game Center and you are good to go.


-- Global variables to the entire project

-- this turns on Game Center simulation from the Helper Class
-- this is so you can call Game Center code within Codea 
-- and just set this boolean to "false" before you export to Xcode
DEBUG_GAMECENTER = true

-- variables local to entire file
local beetle
local planet
local aButton

-- Use this function to perform your initial setup
function setup()
    -- setup display and drawing functions
    supportedOrientations(LANDSCAPE_ANY)    
    displayMode(FULLSCREEN)
    noFill()
    noSmooth()
    noStroke()
    pushStyle()
    
    --sprite("Cargo Bot:Clear Button")
    beetle = SpriteObject("SpaceCute:Beetle Ship", vec2(WIDTH/2, HEIGHT/2 +200))
    planet = SpriteObject("SpaceCute:Planet", vec2(WIDTH/2, HEIGHT/2 - 100))
    aButton = Button("Cargo Bot:Clear Button", vec2(150, 730))
end

-- This function gets called once every frame
function touched(touch)
    
    -- local varaibles
    beetle:touched(touch)
    planet:touched(touch)
    aButton:touched(touch)
    
    if (beetle:isTouching(planet) == true) then
        print("touching")
    else
        print("not touching")
    end
    
    if (aButton.selected == true) then
        -- always check to ensure Game Center is logged in
        -- before doing a command, or the player will
        -- get anoying warnings!
        if (gamecenter.enabled() == true) then
            gamecenter.submitAchievement("grp.FinishedGame", 100)
        end
    end    
end

-- This function gets called once every frame
function draw()
    
    -- local varaibles
    
    -- This sets a dark background color 
    background(0, 0, 0, 255)
    beetle:draw()
    planet:draw()
    aButton:draw()
end