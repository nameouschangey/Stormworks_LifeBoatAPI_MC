---@section LBROLLINGAVERAGEBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBRollingAverage 1 LBROLLINGAVERAGECLASS
---A rolling average across a given number of values
---Useful for filtering noisey values
---@class LBRollingAverage
---@field maxValues number number of values this rolling average holds
---@field values number[] list of values to be averaged
---@field average number current average of the values that have been added
---@field count number number of values currently being averaged
---@field sum number total of the currently tracked values
LifeBoatAPI.LBRollingAverage = {

    ---@param cls LBRollingAverage
    ---@param maxValues number number of values this rolling average holds
    ---@return LBRollingAverage
    new = function (cls, maxValues)
        return LifeBoatAPI.lb_copy(cls, {
            values = {},
            maxValues = maxValues or math.maxinteger,
            index = 1
        })
    end;

    ---@section lbrollingaverage_addValue 
    ---Add a value to the rolling average
    ---@param self LBRollingAverage
    ---@param value number value to add into the rolling average
    ---@return number average the current rolling average (also accessible via .average)
    lbrollingaverage_addValue = function (self, value)
        self.values[(self.index % self.maxValues) + 1] = value
        self.index = self.index + 1
        self.count = math.min(self.index, self.maxValues)
        self.sum = 0
        for _,v in ipairs(self.values) do
            self.sum = self.sum + v
        end
        self.average = self.sum / self.count
        return self.average
    end;
    ---@endsection
}
---@endsection LBROLLINGAVERAGECLASS
