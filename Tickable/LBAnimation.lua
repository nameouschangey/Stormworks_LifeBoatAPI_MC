---@section LBANIMATIONBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBAnimation 1 LBANIMATIONCLASS
---Table format for each of the animation steps
---@class LBAnimationStep
---@field length number length of the step in ticks
---@field callback fun(t:number, ticks:number) callback to run

---An animation that runs per tick, for handling simple state based things such as simple UI animations, landing gear stages, etc.
---@class LBAnimation
---@field steps LBAnimationStep[]
---@field index number index of the current playing animation step
---@field currentStep LBAnimationStep currently playing animation step
---@field lastStep LBAnimationStep last animation step to have played
LifeBoatAPI.LBAnimation = {

    ---@param self LBAnimation
    ---@param startPlayingStraightAway boolean (optional) if True, will begin the animation immediately. Otherwise only starts when playFromStart is called
    ---@param steps LBAnimationStep[] (optional) list of steps to initialize with, otherwise use lbanimation_addStep
    ---@return LBAnimation
    new = function (self, startPlayingStraightAway, steps)
        return LifeBoatAPI.lb_copy(self, {
            steps = steps or {},
            index = startPlayingStraightAway and 1 or 0
        })
    end;

    ---@section lbanimation_playFromStart
    ---Begin playing this animation from the start (restarts if currently playing)
    ---@param self LBAnimation
    lbanimation_playFromStart = function (self)
        self.lastStep = nil
        self.index = 1
    end;
    ---@endsection

    ---@section lbanimation_stop
    ---Stop playing the current animation#
    ---Once called, can only be restarted using playFromStart
    ---@param self LBAnimation
    lbanimation_stop = function (self)
        self.index = 0
    end;
    ---@endsection

    ---@section lbanimation_onTick
    ---Call during the onTick function for this animation to play
    ---@param self LBAnimation
    lbanimation_onTick = function (self)
        self.lastStep = self.currentStep
        self.currentStep = self.steps[self.index]
        if self.currentStep then
            self.currentStep.ticks = self.lastStep == self.currentStep and self.currentStep.ticks + 1 or 0 -- reset ticks to 0 if we've changed step
            self.currentStep.callback(self.currentStep.ticks / self.currentStep.length, self.currentStep.ticks)
            self.index = self.index + (self.currentStep.ticks > self.currentStep.length) and 1 or 0
        end
    end;
    ---@endsection

    ---@section lbanimation_addStep
    ---Add a step to this animation
    ---@param self LBAnimation
    ---@param length number number of ticks this will play for
    ---@param callback fun(t:number, ticks:number) animation function that takes a parameter t between 0->1, and a parameter ticks for the raw tick count
    lbanimation_addStep = function (self, length, callback)
        self.steps[#self.steps + 1] = {
            length = length,
            callback = callback
        }
    end;
    ---@endsection
}
---@endsection LBANIMATIONCLASS