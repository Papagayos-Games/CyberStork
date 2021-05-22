local JSON = assert(loadfile "LuaScripts/json.lua")()
local Crescendum = {}

Crescendum["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.time ~= nil then
        self.time = p.life
    else
        self.time = 0.3
    end

    return self
end

Crescendum["start"] = function (_self, lua)

    _self.pos = lua:getTransform(_self.entity):getPosition()
    _self.rb = lua:getRigidbody(_self.entity)
    _self.lastZ = lua:getTransform(lua:getEntity("defaultCamera")):getPosition().z
   
end

Crescendum["update"] = function (_self, lua)
    --Si sobrepasamos la posicion de la camara en z
    if _self.pos.z > _self.lastZ then
        lua:getCurrentScene():destroyEntity(_self.entity)
        print("Crescendum destruido XD")
    end

    --OnColision enter
    --si choca con el jugador aumentara la velocidad de disparo en self.time
end

return quiscalus