---@section LBTOUCHSCREENBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@class LBTouchScreen
---@field touchX number
---@field touchY number
---@field wasPressed boolean if the screen was being touched last tick
---@field isPressed boolean if the screen is being touched this frame
---@section LBTouchScreen 1 LBTOUCHSCREENCLASS
LifeBoatAPI.LBTouchScreen = {

    ---@section lbtouchscreen_onTick
    --- If using the button functionality, it is expected that you call this at the start of onTick
    --- Handles the touchscreen state for whether things are pressed or not
    ---@param self LBTouchScreen
    ---@param compositeOffset number default composite for touches is 1,2,3,4; offset if composite has been re-routed
    ---@overload fun(self)
    lbtouchscreen_onTick = function(self, compositeOffset)
        compositeOffset = compositeOffset or 0
        self.touchX         = input.getNumber(compositeOffset + 3)
        self.touchY         = input.getNumber(compositeOffset + 4)
        self.wasPressed     = self.isPressed or false
        self.isPressed      = input.getBool(compositeOffset + 1)
    end;
    ---@endsection


   
    ---@section lbtouchscreen_newButton 1 LBTOUCHSCREEN_NEWBUTTON
    --- PLEASE BE AWARE, FANCY STYLED BUTTONS HAVE A RELATIVELY HIGH CHARACTER COST
    --- Create a new button that works with the LBTouchScreen
    --- Note, you must call LBTouchScreen.lbtouchscreen_ontick() at the start of onTick to make these buttons work
    ---@param touchScreenRef LBTouchScreen
    ---@param x number topleft x position of the button
    ---@param y number topleft y position of the button
    ---@param width number width of the button
    ---@param height number height of the button
    ---@param borderColor LBColorRGBA color for the border
    ---@param fillColor LBColorRGBA color for the fill, when not clicked
    ---@param fillPushColor LBColorRGBA color when pushed
    ---@param textColor LBColorRGBA color for the text
    ---@param textPushColor LBColorRGBA color for the text when clicked
    ---@return LBTouchScreenButtonStyledClosure button button object to check for touches
    lbtouchscreen_newButton = function (touchScreenRef, x, y, width, height,
                                                        text,
                                                        textColor,
                                                        fillColor,
                                                        borderColor,
                                                        fillPushColor,
                                                        textPushColor, _)
        ---@class LBTouchScreenButtonStyledClosure
        _ = {
            ---@section lbbutton_isClicked
            --- Checks if this button was clicked; triggers ONLY on the frame it's being clicked
            lbbutton_isClicked = function()
                return touchScreenRef.isPressed
                        and not touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, x, y, width, height)
            end;
            ---@endsection

            ---@section lbbutton_isHeld
            --- Checks if this button is being pressed (i.e. HELD down), returns true on every frame it is being held
            lbbutton_isHeld = function()
                return touchScreenRef.isPressed
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, x, y, width, height)
            end;
            ---@endsection

            ---@section lbbutton_isReleased
            --- Checks for the user lifting the mouse button, like a "on mouse up" event. Note; this is actually how most buttons work on your computer.
            lbbutton_isReleased = function()
                return not touchScreenRef.isPressed
                        and touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, x, y, width, height)
            end;
            ---@endsection

            ---@section lbbutton_draw
            --- Simple drawing function, can make life easier while prototyping things
            ---@param self LBTouchScreenButtonStyledClosure
            lbbutton_draw = function(self)
                (self:lbclosurebutton_isHeld() and fillPushColor or fillColor):lbcolorrgba_setColor()
                screen.drawRectF(x, y, width, height)

                ;(self:lbclosurebutton_isHeld() and textPushColor or textColor):lbcolorrgba_setColor()
                screen.drawTextBox(x+1, y+1, width-1, height-1, text, 0, 0)

                ;(borderColor or textColor):lbcolorrgba_setColor()
                screen.drawRect(x, y, width, height)
            end;
            ---@endsection
        }
        return _
    end;
    ---@endsection LBTOUCHSCREEN_NEWBUTTON


    
    ---@section lbtouchscreen_newButton_Minimalist 1 LBTOUCHSCREEN_NEWBUTTON_MINIMALISTIC
    --- Create a new button that works with the LBTouchScreen
    --- Note, you must call LBTouchScreen.lbtouchscreen_ontick() at the start of onTick to make these buttons work
    ---@param touchScreenRef LBTouchScreen
    ---@param x         number topleft x position of the button
    ---@param y         number topleft y position of the button
    ---@param width     number width of the button
    ---@param height    number height of the button
    ---@param text      string text to display in the button
    ---@return LBTouchScreenButton button button object to check for touches
    lbtouchscreen_newButton_Minimalist = function (touchScreenRef, x, y, width, height, text)
        ---@class LBTouchScreenButton
        ---@field x number topLeft x position of the button
        ---@field y number topLeft y position of the button
        ---@field width number width of the button rect
        ---@field height number height of the button rect
        local button = {
            x = x,
            y = y,
            width = width,
            height = height,
            text = text,

            ---@section lbbutton_isClicked
            --- Checks if this button was clicked; triggers ONLY on the frame it's being clicked
            ---@param self LBTouchScreenButton
            lbbutton_isClicked = function(self)
                return touchScreenRef.isPressed
                        and not self.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, self.x, self.y, self.width, self.height)
            end;
            ---@endsection

            ---@section lbbutton_isHeld
            --- Checks if this button is being pressed (i.e. HELD down), returns true on every frame it is being held
            ---@param self LBTouchScreenButton
            lbbutton_isHeld = function(self)
                return touchScreenRef.isPressed
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, self.x, self.y, self.width, self.height)
            end;
            ---@endsection

            ---@section lbbutton_isReleased
            --- Checks for the user lifting the mouse button, like a "on mouse up" event. Note; this is actually how most buttons work on your computer.
            ---@param self LBTouchScreenButton
            lbbutton_isReleased = function(self)
                return not touchScreenRef.isPressed
                        and touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, self.x, self.y, self.width, self.height)
            end;
            ---@endsection

            ---@section lbbutton_draw
            --- Simple drawing function, can make life easier while prototyping things
            ---@param self LBTouchScreenButton
            lbbutton_draw = function(self)
                screen.drawRect(self.x, self.y, self.width, self.height)
                screen.drawTextBox(self.x+1, self.y+1, self.width-1, self.height-1, self.text, 0, 0)
            end;
            ---@endsection
        }
        return button
    end;
    ---@endsection LBTOUCHSCREEN_NEWBUTTON_MINIMALISTIC


    ---@section lbtouchscreen_newButton_Customizable 1 LBTOUCHSCREEN_NEWBUTTON_CUSTOMIZABLE
    --- PLEASE BE AWARE, FANCY STYLED BUTTONS HAVE A RELATIVELY HIGH CHARACTER COST
    --- Create a new button that works with the LBTouchScreen
    --- Note, you must call LBTouchScreen.lbtouchscreen_ontick() at the start of onTick to make these buttons work
    ---@param touchScreenRef LBTouchScreen
    ---@param x number topleft x position of the button
    ---@param y number topleft y position of the button
    ---@param width number width of the button
    ---@param height number height of the button
    ---@param borderColor LBColorRGBA color for the border
    ---@param fillColor LBColorRGBA color for the fill, when not clicked
    ---@param fillPushColor LBColorRGBA color when pushed
    ---@param textColor LBColorRGBA color for the text
    ---@param textPushColor LBColorRGBA color for the text when clicked
    ---@return LBTouchScreenButtonStyled button button object to check for touches
    lbtouchscreen_newButton_Customizable = function (touchScreenRef, x, y, width, height,
                                                        text,
                                                        textColor,
                                                        fillColor,
                                                        borderColor,
                                                        fillPushColor,
                                                        textPushColor, _)
        ---@class LBTouchScreenButtonStyled
        ---@field x number topLeft x position of the button
        ---@field y number topLeft y position of the button
        ---@field width number width of the button rect
        ---@field height number height of the button rect
        ---@field text string text to display in the button
        ---@field borderColor LBColorRGBA height of the button rect
        ---@field fillColor LBColorRGBA height of the button rect
        ---@field fillPushColor LBColorRGBA height of the button rect
        ---@field textColor LBColorRGBA height of the button rect
        ---@field textPushColor LBColorRGBA height of the button rect
        _ = {
            x = x,
            y = y,
            width = width,
            height = height,
            text = text,
            borderColor     = borderColor or textColor,
            fillColor       = fillColor,
            fillPushColor   = fillPushColor or fillColor,
            textColor       = textColor,
            textPushColor   = textPushColor or textColor,

            ---@section lbbutton_isClicked
            --- Checks if this button was clicked; triggers ONLY on the frame it's being clicked
            ---@param self LBTouchScreenButtonStyled
            lbbutton_isClicked = function(self)
                return touchScreenRef.isPressed
                        and not touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, self.x, self.y, self.width, self.height)
            end;
            ---@endsection

            ---@section lbbutton_isHeld
            --- Checks if this button is being pressed (i.e. HELD down), returns true on every frame it is being held
            ---@param self LBTouchScreenButtonStyled
            lbbutton_isHeld = function(self)
                return touchScreenRef.isPressed
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, self.x, self.y, self.width, self.height)
            end;
            ---@endsection

            ---@section lbbutton_isReleased
            --- Checks for the user lifting the mouse button, like a "on mouse up" event. Note; this is actually how most buttons work on your computer.
            ---@param self LBTouchScreenButtonStyled
            lbbutton_isReleased = function(self)
                return not touchScreenRef.isPressed
                        and touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(touchScreenRef.touchX, touchScreenRef.touchY, self.x, self.y, self.width, self.height)
            end;
            ---@endsection

            ---@section lbbutton_draw
            --- Simple drawing function, can make life easier while prototyping things
            ---@param self LBTouchScreenButtonStyled
            lbbutton_draw = function(self)
                (self:lbstyledbutton_isHeld() and self.fillPushColor or self.fillColor):lbcolorrgba_setColor()
                screen.drawRectF(self.x, self.y, self.width, self.height);

                (self:lbstyledbutton_isHeld() and self.textPushColor or self.textColor):lbcolorrgba_setColor()
                screen.drawTextBox(self.x+1, self.y+1, self.width-1, self.height-1, self.text, 0, 0)

                self.borderColor:lbcolorrgba_setColor()
                screen.drawRect(self.x, self.y, self.width, self.height)
            end;
            ---@endsection
        }
        return _
    end;
    ---@endsection LBTOUCHSCREEN_NEWBUTTON_CUSTOMIZABLE
}
---@endsection LBTOUCHSCREENCLASS