---@section LBSTATEMACHINEBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBStateMachine 1 LBSTATEMACHINECLASS
---Basic state machine
---Each state is a function that returns the name of the state to transition into, or nil to stay in the current state
---Can make life easier for handling basic mechanics like landing gear, or radar that goes between sweep and track modes, etc.
---Can also be using in onDraw to handle e.g. different menus/screens in a fairly straight forward way
---@class LBStateMachine
---@field states table
---@field currentState string name of the current state to run
---@field ticks number number of ticks that have been spent in the current state
LifeBoatAPI.LBStateMachine = {
    ---@param self LBStateMachine
    ---@param defaultStateCallback fun(ticks:number, statemachine:LBStateMachine):string default state function
    ---@return LBStateMachine
    new = function (self, defaultStateCallback)
        return LifeBoatAPI.lb_copy(self, {
            states = {
                [0] = defaultStateCallback
            },
            ticks = 0,
            currentState = 0
        })
    end;

    ---@section lbstatemachine_onTick
    ---Call during the onTick function for this state machine to function
    ---@param self LBStateMachine
    lbstatemachine_onTick = function (self)
        self._currentStateFunc = self.states[self.currentState]
        if self._currentStateFunc then
            self._nextState = self._currentStateFunc(self.ticks, self) or self.currentState -- nil preserves the current state
            self.ticks = self._nextState == self.currentState and self.ticks + 1 or 0 -- reset ticks when the stateName changes
        else
            self.currentState = 0
        end
    end;
    ---@endsection

    ---@section lbstatemachine_setState
    ---Recommended to just do myStatemachine.states["MyStateName"] = function() ... end,
    ---But let this act as active code documentation
    ---@param self LBStateMachine
    ---@param stateName string name of the state
    ---@param callback fun(ticks:number, statemachine:LBStateMachine):string state callback that will be run while in the given state. Returns the name of the next state to move into or nil
    lbstatemachine_addState = function (self, stateName, callback)
        self.states[stateName] = callback
    end;
    ---@endsection
}
---@endsection LBSTATEMACHINECLASS