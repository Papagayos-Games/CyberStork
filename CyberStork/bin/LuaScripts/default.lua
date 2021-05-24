local default = {}

default["instantiate"] = function (params, entity)
    --p = JSON:decode(params)
    local self = {}
    return self
end

default["start"] = function (_self, lua)
end

default["update"] = function (_self, lua)
end

default["onCollisionEnter"] = function(_self, lua, otherRb)
    print("CollisionEnter")
end

default["onCollisionStay"] = function(_self, lua, otherRb)
    print("CollisionStay")
end

default["onCollisionExit"] = function(_self, lua, otherRb)
    print("CollisionExit")
end

return default