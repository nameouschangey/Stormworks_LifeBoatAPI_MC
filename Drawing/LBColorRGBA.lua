---@section LBMATHSBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBColorRGBA 1 LBCOLORRGBACLASS
---@class LBColorRGBA
LifeBoatAPI.LBColorRGBA = {
    ---@section lbcolorrgba_newRGBA
    --- Creates a new LBColorRGBA from simple RGBA values
    ---@param self LBColorRGBA
    ---@param r number red 0->255
    ---@param g number green 0->255
    ---@param b number blue 0->255
    ---@param a number|nil alpha 0->255
    lbcolorrgba_newRGBA = function (self, r,g,b,a)
        return LifeBoatAPI.lb_copy(self, {r, g, b, a or 255})
    end;
    ---@endsection


    ---@section lbcolorrgba_newCorrected
    --- Creates a new LBColorRGBA, correcting for the game's gamma factor
    --- Allows for colours that are closer to the expected HTML values
    ---@param self LBColorRGBA
    ---@param r number red 0->255
    ---@param g number green 0->255
    ---@param b number blue 0->255
    ---@param a number|nil alpha 0->255
    --- see explanation of Stormworks gamma here: https://steamcommunity.com/sharedfiles/filedetails/?id=2273112890
    lbcolorrgba_newGammaCorrected = function (self, r,g,b,a)
        return LifeBoatAPI.lb_copy(self,
                                    {255*(r/300)^2.4,
                                     255*(g/300)^2.4,
                                     255*(b/300)^2.4,
                                     a or 255})
    end;
    ---@endsection

    ---@section lbcolorrgba_setColor
    --- Set the screen color with the current values of this LBColorRGBA
    ---@param self LBColorRGBA
    lbcolorrgba_setColor = function (self)
        screen.setColor(self[1], self[2], self[3], self[4])
    end;
    ---@endsection

    ---@section lbcolorrgba_newGammaCorrected
    --- Creates a new LBColorRGBA, correcting for the game's gamma factor
    --- Allows for colours that are closer to the expected HTML values
    ---@param self LBColorRGBA
    ---@param r number red 0->255
    ---@param g number green 0->255
    ---@param b number blue 0->255
    ---@param a number|nil alpha 0->255
    ---@param constantCorrection number (default 0.8) constant factor, as K in the equation (K*color) ^ gamma
    ---@param gamma number (default 2.6) gamma factor, in the equation (K*color) ^ gamma
    ---@overload fun(self, r,g,b,a)
    --- see explanation of Stormworks gamma here: https://steamcommunity.com/sharedfiles/filedetails/?id=2273112890
    lbcolorrgba_newGammeCorrected_Customizable = function (self, r,g,b,a, gamma, constantCorrection)
        constantCorrection = constantCorrection or 0.85
        gamma = gamma or 2.4
        return LifeBoatAPI.lb_copy(self,
                                    {255*(constantCorrection*r/255)^gamma,
                                     255*(constantCorrection*g/255)^gamma,
                                     255*(constantCorrection*b/255)^gamma,
                                     a or 255})
    end;
    ---@endsection
}
---@endsection LBCOLORRGBACLASS