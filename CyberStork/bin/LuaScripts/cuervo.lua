local JSON = assert(loadfile "LuaScripts/json.lua")()
local cuervo = {}

cuervo["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.speed ~= nil then
        self.speed = p.speed
    else
        self.speed = 2
    end

    if p.frontSpeed ~= nil then
        self.frontSpeed = p.frontSpeed
    else
        self.frontSpeed = 1.2
    end

    --el cuervo guarda el daño que hace
    if p.damage ~= nil then
        self.damage = p.damage
    else
        self.damage = 1
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

cuervo["onCollisionEnter"] = function(_self, lua, otherRb)
    print("en el oncolision enter cuervo")

    --TO DO :sumar puntos

    local group = lua:getRigidbody(otherRb):getGroup()
    print("cojemos el grupo al que pertenece" )
    if group == 1 then-- si colisiona con el player
        local healthComponent = lua:getLuaSelf(otherRb,"health")
        if healthComponent.receiveDamage(_self.damage) then
            lua:changeScene("mainMenu")--TO DO poner nombre de la escena game over
        end 
        --se destruye el cuervo
        lua:getCurrentScene():destroyEntity(_self.entity)
        print("destruido cuervo al colisionar con el player")

    elseif group == 4 then-- si colisiona con las balas del jugador
        local healthComponent = lua:getLuaSelf(_self.entity,"health")
        local bulletcomponent = lua:getLuaSelf(otherRb,"bullet")
        --añadimos daño
        healthComponent.receiveDamage(bulletcomponent.damage, lua)
        --destruimos la bala 
        lua:getCurrentScene():destroyEntity(otherRb)
        print("destruida bala al colisionar")

    end


end


return cuervo