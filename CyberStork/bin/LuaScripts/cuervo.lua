local JSON = assert(loadfile "LuaScripts/json.lua")()
local cuervo = {}

cuervo["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.speed ~= nil then
        self.speed = p.speed
    else
        self.speed = 3
    end

    if p.frontSpeed ~= nil then
        self.frontSpeed = p.frontSpeed
    else
        self.frontSpeed = 1.2
    end

    return self
end

cuervo["start"] = function (_self, lua)
    _self.target = lua:getTransform(lua:getEntity("Player")):getPosition()
    _self.pos = lua:getTransform(_self.entity):getPosition()
    _self.rb = lua:getRigidbody(_self.entity)
    _self.lastZ = lua:getTransform(lua:getEntity("defaultCamera")):getPosition().z
end

cuervo["update"] = function (_self, lua)

    local dir = Vector3(_self.target.x - _self.pos.x, _self.target.y - _self.pos.y, 0 )
    local mag = dir:normalize()
    local newPos = Vector3(_self.pos.x, _self.pos.y, _self.pos.z + _self.frontSpeed)
    
    --Desplazamos si la magnitud es mayor que la velocidad
    if mag > _self.speed then 
        newPos.x =_self.pos.x + dir.x * _self.speed
        newPos.y = _self.pos.y + dir.y * _self.speed
    end
    _self.rb:setPosition(newPos)

    --Si sobrepasamos la posicion de la camara en z
    if _self.pos.z > _self.lastZ then
        lua:getCurrentScene():destroyEntity(_self.entity)
        print("Cuervo destruido XD")
    end
end

return cuervo