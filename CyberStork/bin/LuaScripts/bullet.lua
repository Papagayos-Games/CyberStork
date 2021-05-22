local JSON = assert(loadfile "LuaScripts/json.lua")()
local bullet = {}

bullet["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    
    --En segundos el tiempo
    if p.lifetime ~= nil then
        self.lifetime = p.speed-- TO DO esto no seria p.lifetime?
    else
        self.lifetime = 3
    end
--la bala guarda el daño que hace
    if p.damage ~= nil then
        self.damage = p.damage
    else
        self.damage = 1
    end
    
    self.entity =  entity
    return self
end

bullet["start"] = function (_self, lua)
    _self.startTime = lua:getInputManager():getTicks()
end

bullet["update"] = function (_self, lua)

    if (lua:getInputManager():getTicks() - _self.startTime)/1000  >= _self.lifetime then
        lua:getCurrentScene():destroyEntity(_self.entity)
    end 
end

return bullet