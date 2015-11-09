-- HelperClass

-- Created by: Mr Coxall
-- Created on: Nov 2014
-- Created for: ICS2O
-- This is a collection of classes and a scene management system, 
-- to help in the aid of coding.


-- Button Class

-- This class simplifies the process of checking if a sprite button is pressed or not
-- Then you can ask the button if it is being touched or was ended.
-- Works best with vector sprite buttons, since it enlarges them when they are touched
--
-- Parameters to pass in:
--  1. Untouched button image name
--  2. A vector2 that is the location of the button

Button = class()

function Button:init(buttonImage, buttonPosition, buttonScaleSize)
    -- accepts the button image, location and scale to draw it
    
    self.buttonImage = buttonImage
    self.buttonLocation = buttonPosition
    self.buttonScaleSize = buttonScaleSize or 1.0
    
    self.buttonImageSize = vec2(spriteSize(self.buttonImage))
    -- resize the button to new size (or scale by 1.0 if no scale given!)
    if not(self.buttonScaleSize == 1.0) then
        self.buttonImage = resizeImage(self.buttonImage,(self.buttonScaleSize*self.buttonImageSize.x),(self.buttonScaleSize*self.buttonImageSize.y)) 
        -- now rest button image size
        self.buttonImageSize = vec2(spriteSize(self.buttonImage))  
    end
    self.buttonTouchScale = 1.15
    --self.buttonImageSize = vec2(spriteSize(self.buttonImage))    
    self.currentButtonImage = self.buttonImage
    self.buttonTouchedImage = resizeImage(self.buttonImage, (self.buttonImageSize.x*self.buttonTouchScale), (self.buttonImageSize.y*self.buttonTouchScale))   
    self.selected = false
end

function Button:draw()
    -- Codea does not automatically call this method
 
    pushStyle()   
    pushMatrix()
    noFill()
    noSmooth()
    noStroke()
     
    sprite(self.currentButtonImage, self.buttonLocation.x, self.buttonLocation.y)
    
    popMatrix()
    popStyle()
end

function Button:touched(touch)   
    -- local varaibles
    local currentTouchPosition = vec2(touch.x, touch.y)
    
    -- reset touching variable to false
    self.selected = false
    
    if (touch.state == BEGAN) then
         if( (self.buttonLocation.x - self.buttonImageSize.x/2) < currentTouchPosition.x and
            (self.buttonLocation.x + self.buttonImageSize.x/2) > currentTouchPosition.x and
            (self.buttonLocation.y - self.buttonImageSize.y/2) < currentTouchPosition.y and
            (self.buttonLocation.y + self.buttonImageSize.y/2) > currentTouchPosition.y ) then
                
            self.currentButtonImage = self.buttonTouchedImage
            --print("Now touching! - began")
        else          
            self.currentButtonImage = self.buttonImage  
            --print("Not touching - began")
        end             
    end
    
    if (touch.state == MOVING) then
        if( (self.buttonLocation.x - self.buttonImageSize.x/2) < currentTouchPosition.x and
            (self.buttonLocation.x + self.buttonImageSize.x/2) > currentTouchPosition.x and
            (self.buttonLocation.y - self.buttonImageSize.y/2) < currentTouchPosition.y and
            (self.buttonLocation.y + self.buttonImageSize.y/2) > currentTouchPosition.y ) then
        
            self.currentButtonImage = self.buttonTouchedImage
            --print("Now touching! - moving")
        else
            self.currentButtonImage = self.buttonImage  
            --print("Not touching - moving")
        end
    end
    
    if (touch.state == ENDED) then
        if( (self.buttonLocation.x - self.buttonImageSize.x/2) < currentTouchPosition.x and
            (self.buttonLocation.x + self.buttonImageSize.x/2) > currentTouchPosition.x and
            (self.buttonLocation.y - self.buttonImageSize.y/2) < currentTouchPosition.y and
            (self.buttonLocation.y + self.buttonImageSize.y/2) > currentTouchPosition.y ) then
        
            self.selected = true
            --print("Activated button")
        end
         
        self.currentButtonImage = self.buttonImage
    end 
end

function resizeImage(img, width, height)
    -- function from
    -- http://codea.io/talk/discussion/3490/importing-pics-from-dropbox/p1
    
    local newImg = image(width,height)
    setContext(newImg)
    sprite( img, width/2, height/2, width, height )    
    setContext()
    return newImg
end


-- Dragging Object Class
-- This class simplifies the process of dragging and dropping objects
-- You can have several objects interacting, but it is not mulit-touch
--
-- Parameters to pass in:
--  1. Object image name
--  2. A vector2 that is the location of the button
--  3. Optional object id 


SpriteObject = class()

function SpriteObject:init(objectImage, objectStartPosition, objectID) 

    self.objectImage = objectImage
    self.objectStartLocation = objectStartPosition
    self.ID = objectID or math.random()
    
    self.objectCurrentLocation = self.objectStartLocation
    self.objectImageSize = vec2(spriteSize(self.objectImage))
    --self.selected = false
    self.dragOffset = vec2(0,0)
    self.draggable = true
    -- yes, the following does need to be global to the entire program
    -- this is the only way (easy way!) to move things around and no get 
    -- several object "attached" to each other
    -- this way just the top object in the stack moves
    DRAGGING_OBJECT_MOVING = nil or DRAGGING_OBJECT_MOVING    
end

function SpriteObject:draw()
    -- Codea does not automatically call this method
    
    pushStyle()   
    pushMatrix()
    noFill()
    noSmooth()
    noStroke()
     
    sprite(self.objectImage, self.objectCurrentLocation.x, self.objectCurrentLocation.y)
     
    popMatrix()
    popStyle()

end

function SpriteObject:touched(touch)
    -- Codea does not automatically call this method
    
    -- local varaibles
    local currentTouchPosition = vec2(touch.x, touch.y)
    
    if (touch.state == BEGAN and self.draggable == true) then
        if( (self.objectCurrentLocation.x - self.objectImageSize.x/2) < currentTouchPosition.x and
            (self.objectCurrentLocation.x + self.objectImageSize.x/2) > currentTouchPosition.x and
            (self.objectCurrentLocation.y - self.objectImageSize.y/2) < currentTouchPosition.y and
            (self.objectCurrentLocation.y + self.objectImageSize.y/2) > currentTouchPosition.y ) then
            -- if the touch has began, we need to find delta from touch to center of object
            -- since will need it to reposition the object for draw
            -- subtracting 2 vec2s here
            self.dragOffset = self.objectCurrentLocation - currentTouchPosition
            DRAGGING_OBJECT_MOVING = self.ID
        end        
    end
    
    if (touch.state == MOVING and self.draggable == true) then
        if( (self.objectCurrentLocation.x - self.objectImageSize.x/2) < currentTouchPosition.x and
            (self.objectCurrentLocation.x + self.objectImageSize.x/2) > currentTouchPosition.x and
            (self.objectCurrentLocation.y - self.objectImageSize.y/2) < currentTouchPosition.y and
            (self.objectCurrentLocation.y + self.objectImageSize.y/2) > currentTouchPosition.y ) then
                -- only let it move if self.draggable == true
            if (self.draggable == true) then
                -- add the offset back in for its new position
                if (self.ID == DRAGGING_OBJECT_MOVING) then
                    self.objectCurrentLocation = currentTouchPosition + self.dragOffset
                end
            end
        end      
    end
    
    if (touch.state == ENDED and self.draggable == true) then
        DRAGGING_OBJECT_MOVING = nil   
    end
end

function SpriteObject:isTouching(otherSpriteObject)
    -- this method checks if one dragging object is touching another dragging object
    
    local isItTouching = false
    
    if( (self.objectCurrentLocation.x + self.objectImageSize.x/2) > (otherSpriteObject.objectCurrentLocation.x - otherSpriteObject.objectImageSize.x/2) and
        (self.objectCurrentLocation.x - self.objectImageSize.x/2) < (otherSpriteObject.objectCurrentLocation.x + otherSpriteObject.objectImageSize.x/2) and
        (self.objectCurrentLocation.y - self.objectImageSize.y/2) < (otherSpriteObject.objectCurrentLocation.y + otherSpriteObject.objectImageSize.y/2) and
        (self.objectCurrentLocation.y + self.objectImageSize.y/2) > (otherSpriteObject.objectCurrentLocation.y - otherSpriteObject.objectImageSize.y/2) ) then
        -- if true, then not touching
        isItTouching = true
    end        
    
    return isItTouching
end


-- SceneManager
--
-- This file lets you easily manage different scenes
--     Original code from Brainfox, off the Codea forums

Scene = {}
local scenes = {}
local sceneNames = {}
local currentScene = nil

setmetatable(Scene,{__call = function(_,name,cls)
   if (not currentScene) then
       currentScene = 1
   end
   table.insert(scenes,cls)
   sceneNames[name] = #scenes
   Scene_Select = nil
end})

--Change scene
Scene.Change = function(name)
  currentScene = sceneNames[name]
    scenes[currentScene]:init()
   if (Scene_Select) then
       Scene_Select = currentScene
   end
    
   collectgarbage()
end

Scene.Draw = function()
   pushStyle()
   pushMatrix()
   scenes[currentScene]:draw()
   popMatrix()
   popStyle()
end

Scene.Touched = function(t)
   if (scenes[currentScene].touched) then
       scenes[currentScene]:touched(t)
   end
end

Scene.Keyboard = function()
   if (scenes[currentScene].keyboard) then
       scenes[currentScene]:keyboard(key)
   end
end

Scene.OrientationChanged = function()
   if (scenes[currentScene].orientationChanged) then
       scenes[currentScene]:orientationChanged()
   end
end


-- Simulates the use of Game Center, so you can actually write the calls in Codea and still test on the iPad

if (DEBUG_GAMECENTER == true) then
        
    function GameCenterClass()
        -- the new instance
        local self = {          
        }

        function self.enabled()
            -- simulates that Game Center is logged in
            
            return true
        end
        
        function self.showLeaderboards(leaderboardID)
            -- Show leaderboards
            
            if (leaderboardID == nil) then
                alert("Game Center leaderboard screen will pop up.", "Game Center Simulation")
            else
                alert("Game Center leaderboard with ID " .. leaderboardID .. " will pop up.", "Game Center Simulation")
            end
        end
        
        function self.showAchievements()
            -- Show achievements
            
            alert("Game Center achievement screen will pop up.", "Game Center Simulation") 
        end
        
        function self.submitScore(score, leaderboardID)
            -- simulates submitting a score to Game Center
            
            if (leaderboardID == nil) then
                alert("Default Leaderboard updated with score " .. score, "Game Center Simulation")
            else
                alert("Leaderboard with ID " .. leaderboardID .. " updated with score " .. score, "Game Center Simulation")
            end 
        end

        function self.submitAchievement(achievementID, percent)
            -- simulates submitting an achievement to Game Center
        
            alert("Achievement with ID " .. achievementID .. " updated to " .. percent .. "%", "Game Center Simulation")
        end

        -- return the instance
        return self
    end
   
    -- create a global instance and call it "gamecenter"
    -- the exact name you need to impliment when you make the changes in Xcode
    -- but now you can do it locally :)
    gamecenter = GameCenterClass()    
end