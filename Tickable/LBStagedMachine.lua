---@section LBSTATEMACHINEBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@class LBStage
---@field lbstage_onInit fun(self:LBStage, machine:LBStagedMachine)
---@field lbstage_onTick fun(self:LBStage, machine:LBStagedMachine)
---@field lbstage_onDraw fun(self:LBStage, machine:LBStagedMachine)
---@field lbstage_onDestroy fun(self:LBStage, machine:LBStagedMachine)


---@section LBStagedMachine 1 LBSTAGEDMACHINECLASS
---Basic state machine
---Each state is a function that returns the name of the state to transition into, or nil to stay in the current state
---Can make life easier for handling basic mechanics like landing gear, or radar that goes between sweep and track modes, etc.
---Can also be using in onDraw to handle e.g. different menus/screens in a fairly straight forward way
---@class LBStagedMachine
---@field current string name of the current state to run
---@field currentStage LBStage
---@field stageTicks number
---@field ticks number
LifeBoatAPI.LBStagedMachine = {
    ---@param cls LBStagedMachine
    ---@return LBStagedMachine
    new = function (cls, initDelay)
        return LifeBoatAPI.lb_copy(cls, {
            current=0,
            ticks=0,
            stageTicks=0,
            currentStage={
                lbstage_onTick = function(self, machine)
                    if machine.stageTicks > (initDelay or 0) then
                        machine:lbstagedmachine_nextState()
                    end
                end
            }
        })
    end;

    ---@section lbstagedmachine_nextState
    ---@param self LBStagedMachine
    lbstagedmachine_nextState = function(self, i)
        self.current = i or (self.current % #self) + 1
        
        self.stageTicks = 0
        self.currentStage = self[self.current]
        if self.currentStage.lbstage_onInit then
            self.currentStage:lbstage_onInit(self)
        end
        self:lbstagedmachine_onTick()
    end;
    ---@endsection

    ---@section lbstagedmachine_onTick
    ---Call during the onTick function for this state machine to function
    ---@param self LBStagedMachine
    lbstagedmachine_onTick = function (self)
        self.ticks = self.ticks + 1
        self.stageTicks = self.stageTicks + 1
        if self.currentStage.lbstage_onTick then
            self.currentStage:lbstage_onTick(self)
        end
    end;
    ---@endsection

    ---@section lbstagedmachine_onDraw
    ---Call during the onTick function for this state machine to function
    ---@param self LBStagedMachine
    lbstagedmachine_onDraw = function (self)
        if self.currentStage.lbstage_onDraw then
            self.currentStage:lbstage_onDraw(self)
        end
    end;
    ---@endsection
}
---@endsection LBSTAGEDMACHINECLASS