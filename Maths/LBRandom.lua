require("LifeBoatAPI.Utils.LBCopy")

---@section LBRandom 1 LBRANDOMCLASS
---@class LBRandom
LifeBoatAPI.LBRandom = {
    new = function(cls, seed)
        return LifeBoatAPI.lb_copy(cls, {
            seed = seed or 1
        })
    end;

    ---@section lbrandom_next
    ---@param self LBRandom
    lbrandom_next = function(self)
        self.seed = ((self.seed * 1103515245) + 12345) % 65564
        return (self.seed+1)/65565
    end;
    ---@endsection

    ---@section lbrandom_choice
    ---@param self LBRandom
    lbrandom_choice = function(self, tbl)
        local rnd = self:lbrandom_next()
        return math.ceil(rnd * #tbl)
    end;
    ---@endsection
}
---@endsection LBRANDOMCLASS