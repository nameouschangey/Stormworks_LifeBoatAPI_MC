---@section LBVECBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBVec 1 LBVECCLASS
---@class LBVec
---@field x number for viewspace coordinates: (0 => leftmost, 1=>rightmost) x position to convert
---@field y number for viewspace coordinates: (0 => topmost, 1=> bottommost) y position to convert
---@field z number only used in 3D calculations
LifeBoatAPI.LBVec = {
    ---@param cls LBVec
    ---@param x number x component
    ---@param y number y component
    ---@param z number z component; conventially represents the altitude
    ---@overload fun(cls:LBVec, x:number, y:number):LBVec creates a vector2 (z-component is 0)
    ---@overload fun(cls:LBVec):LBVec creates a new zero-initialized vector3
    ---@return LBVec
    new = function(cls,x,y,z)
        return LifeBoatAPI.lb_copy(cls, {x=x or 0,y=y or 0,z=z or 0})
    end;

    ---@section newFromAzimuthElevation
    --- from: https://www.mathworks.com/help/phased/ug/spherical-coordinates.html
    --- x=Rcos(el)cos(az)
    --- y=Rcos(el)sin(az)
    --- z=Rsin(el)
    ---@param azimuth number azimuth angle, 0 north -> 2pi north
    ---@param elevation number elevation +/- pi/2 radians from horizon
    ---@param distance number
    ---@return LBVec
    newFromAzimuthElevation = function(cls, azimuth, elevation, distance)
        return cls:new(
            distance * math.cos(elevation) * math.sin(azimuth),
            distance * math.cos(elevation) * math.cos(azimuth),
            distance * math.sin(elevation))
    end;
    ---@endsection

    ---@section lbvec_add
    ---Adds the two vectors together
    ---@param self LBVec
    ---@param rhs LBVec
    ---@return LBVec result
    lbvec_add = function(self,rhs)
        return self:new(self.x+rhs.x,self.y+rhs.y,self.z+rhs.z)
    end;
    ---@endsection

    ---@section lbvec_sub
    ---Subtracts the given vector from this one
    ---@param self LBVec
    ---@param rhs LBVec
    ---@return LBVec result
    lbvec_sub = function (self,rhs)
        return self:new(self.x-rhs.x, self.y-rhs.y, self.z-rhs.z)
    end;
    ---@endsection

    ---@section lbvec_lerp
    ---Lerp (linear interpolation) between the this vector and the given vector
    ---@param self LBVec
    ---@param rhs LBVec
    ---@param t number 0->1 expected
    ---@return LBVec result
    lbvec_lerp = function (self,rhs, t)
        oneMinusT = 1 - t
        return self:new(oneMinusT*self.x + t*rhs.x,
                        oneMinusT*self.y + t*rhs.y,
                        oneMinusT*self.z + t*rhs.z)
    end;
    ---@endsection

    ---@section lbvec_multiply
    ---Multiplies the components of each vector together
    ---@param self LBVec
    ---@param rhs LBVec
    ---@return LBVec result
    lbvec_multiply = function (self,rhs)
        return self:new(self.x*rhs.x, self.y*rhs.y, self.z*rhs.z)
    end;
    ---@endsection

    ---@section lbvec_scale
    ---Scales each component of this vector by the given quantity
    ---If you take a normalized LBVec3 as a direction, and scale it by a distance; you'll have a position
    ---@param self LBVec
    ---@param scalar number factor to scale by
    ---@return LBVec result
    lbvec_scale = function (self,scalar)
        return self:new(self.x*scalar, self.y*scalar, self.z*scalar)
    end;
    ---@endsection

    ---@section lbvec_sum
    ---Sums the individual components of this vector
    ---@param self LBVec
    ---@return number sum of the component parts
    lbvec_sum = function (self)
        return self.x + self.y + self.z
    end;
    ---@endsection

    ---@section lbvec_dot
    ---Calculates the Dot Product of the vectors
    ---@param self LBVec
    ---@param rhs LBVec
    ---@return number
    lbvec_dot = function (self,rhs)
        return self:lbvec_multiply(rhs):lbvec_sum()
    end;
    ---@endsection

    ---@section lbvec_length
    ---Gets the length (magnitude) of this vector
    ---i.e. gets the distance from this point; to the origin
    ---@param self LBVec
    ---@return number length
    lbvec_length = function (self)
        return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
    end;
    ---@endsection

    ---@section lbvec_distance
    ---Gets the distance between two points represented as Vecs
    ---@param self LBVec
    ---@param rhs LBVec
    ---@return number distance
    lbvec_distance = function(self,rhs)
        return self:lbvec_sub(rhs):lbvec_length()
    end;
    ---@endsection

    ---@section lbvec_normalize
    ---Normalizes the vector so the magnitude is 1
    ---Ideal for directions; as they can then be multipled by a scalar distance to get a position
    ---@param self LBVec
    ---@return LBVec result
    lbvec_normalize = function(self)
        return self:lbvec_scale(1/self:lbvec_length())
    end;
    ---@endsection

    ---@section lbvec_cross
    --- Cross product of two 3d vectors
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "lhs", index finger is "rhs"
    ---@param self LBVec
    ---@param rhs LBVec
    ---@return LBVec
    lbvec_cross = function(self, rhs)
        return self:new(self.y*rhs.z - self.z*rhs.y,
                        self.z*rhs.x - self.x*rhs.z,
                        self.x*rhs.y - self.y*rhs.x)
    end;
    ---@endsection

    ---@section lbvec_reflect
    --- Reflects this vector about the given normal
    --- Normal is expected to be in the same direction as this vector, and will return the reflection circularly about that vector
    ---@param self LBVec
    ---@param normal LBVec
    ---@return LBVec
    lbvec_reflect = function(self, normal)
        -- r=d−2(d⋅n)n where r is the reflection, d is the vector, v is the normal to reflect over
        -- normally expects rays to be like light, coming into the mirror and bouncing off. We negate the parts to make this work in our favour
        normal = normal:lbvec_normalize() -- ensure the vectors are the right direction
        self = self:lbvec_scale(-1)
        return self:lbvec_sub(normal:lbvec_scale(2 * self:lbvec_dot(normal)))
    end;
    ---@endsection

    ---@section lbvec_anglebetween
    ---Calculates the shortest angle between two vectors
    ---Note, angle is NOT signed
    ---@param self LBVec
    ---@param rhs LBVec
    ---@return number
    lbvec_anglebetween = function(self, rhs)
        return math.acos(self:lbvec_dot(rhs) / (self:lbvec_length() * rhs:lbvec_length()))
    end;
    ---@endsection

    ---@section lbvec_azimuthElevation
    ---Converts the vector into spatial coordinates as an azimuth, elevation, distance triplet
    ---Formula from mathworks: https://www.mathworks.com/help/phased/ug/spherical-coordinates.html
    ---R=sqrt(x2+y2+z2)
    ---az=tan−1(y/x)
    ---el=tan−1(z/sqrt(x2+y2))
    ---@param self LBVec
    ---@return number,number,number components azimuth (North is 0), elevation (Horizon is 0), distance
    lbvec_azimuthElevation= function(self)
        normalized = self:lbvec_normalize()
        return  math.atan(normalized.x, normalized.y),
                math.atan(normalized.z, math.sqrt(normalized.x*normalized.x + normalized.y*normalized.y)),
                self:lbvec_length()
    end;
    ---@endsection

    ---@section lbvec_rotate2D
    ---Rotates the clockwise around the origin
    ---@param self LBVec
    ---@param radians number radians to rotate this vector by, clockwise about the origin
    ---@return LBVec rotated vector rotated about the origin by the given radians
    lbvec_rotate2D = function (self, radians)
        return self:new(self.x * math.cos(radians) - self.y * math.sin(radians),
                        self.x * math.sin(radians) + self.y * math.cos(radians),
                        self.z)
    end;
    ---@endsection

    ---@section lbvec_rotateAround2D
    ---Rotates clockwise around the given point, by the given number of radians
    ---@param self LBVec
    ---@param radians number radians to rotate, clockwise around
    ---@param point LBVec point to rotate around
    ---@return LBVec rotated
    lbvec_rotateAround2D = function(self, radians, point)
        return self:lbvec_sub(point):lbvec_rotate2D(radians):lbvec_add(point)
    end;
    ---@endsection

    ---@section lbvec_cross2D
    --- Cross product of two 2D vectors
    --- Returned result is the magnitude of a vector on the "z" plane (which doesn't exist for these vectors)
    --- As such, returns a scalar; even though this should technically be a vector3
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "this", index finger is "rhs"
    ---@param self LBVec
    ---@param rhs LBVec
    ---@return number 2D cross product, as a scalar (Note cross product is poorly defined for Vec2 - but has some uses)
    lbvec_cross2D = function(self, rhs)
        return self.x*rhs.y - self.y*rhs.x
    end;
    ---@endsection

    ---@section lbvec_angle2D
    --- Calculates the angle between this vector and the vertical (0,1)
    --- If this is a position vector; the line is between this vector (x,y) to the origin (0,0)
    ---@param self LBVec
    ---@return number radians the positive clockwise angle between this vector and the vertical (0,1)
    lbvec_angle2D = function(self)
        local angle = math.atan(self.x, self.y) -- intentionally using atan the "wrong" way around so that (0,1) is 0*; and +degrees is clockwise, which is easier for most people to conceptualize
        return angle >= 0 and angle or math.pi * 2 + angle
    end;
    ---@endsection

    ---@section lbvec_angleAround2D
    ---Gets the clockwise angle from vertical (0,1), of this point around the given point
    ---@param self LBVec
    ---@return number radians
    lbvec_angleAround2D = function(self, point)
        return self:lbvec_sub(point):lbvec_angle2D()
    end;
    ---@endsection
}
---@endsection LBVECCLASS