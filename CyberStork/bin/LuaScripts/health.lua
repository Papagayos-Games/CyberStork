local JSON = assert(loadfile "LuaScripts/json.lua")()
local health = {}

health["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.life ~= nil then
        self.life = p.life
    else
        self.life = 1
    end

    self.receiveDamage = function (x) self.life = self.life - x end
    return self
end

health["start"] = function (_self, lua)
end

health["update"] = function (_self, lua)

    if _self.life <= 0 then
        lua:getCurrentScene():destroyEntity(_self.entity)
    end
end

return health