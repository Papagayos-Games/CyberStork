local quiscalus = {}

quiscalus["instantiate"] = function (params, entity)
    --p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.speed ~= nil then
        self.speed = p.speed
    else
        self.speed = 4
    end

    if p.frontSpeed ~= nil then
        self.frontSpeed = p.frontSpeed
    else
        self.frontSpeed = 1.7
    end

    return self
end

quiscalus["start"] = function (_self, lua)

    _self.pos = lua:getTransform(_self.entity):getPosition()
    _self.rb = lua:getRigidbody(_self.entity)
    _self.lastZ = lua:getTransform(lua:getEntity("defaultCamera")):getPosition().z
    --Cojemos las dimensiones de la pantalla
    _self.halfWidth = (lua:getOgreContext():getWindowWidth()/2)
    _self.halfHeight = (lua:getOgreContext():getWindowHeight()/2)
  

    --Decidimos la direccion de movimiento, horizontal o vertical
    local aux = math.random(0,1)
    if aux == 0  then
        _self.horizontal = true

    else
        _self.horizontal = false
    end

    _self.dir = 1
end

quiscalus["update"] = function (_self, lua)
    if _self.horizontal then
        local newPos = Vector3(_self.pos.x + (_self.speed * _self.dir), _self.pos.y, _self.pos.z + _self.frontSpeed)
        --si nos salimos de la pantalla
        if newPos.x >= _self.halfWidth or newPos.x <= -(_self.halfWidth) then 
            --cambiamos de direccion
            _self.dir = _self.dir * -1
        end
        _self.rb:setPosition(newPos)
    else
        local newPos = Vector3(_self.pos.x , _self.pos.y +(_self.speed * _self.dir), _self.pos.z + _self.frontSpeed)
        --si nos salimos de la pantalla
        if newPos.y >= _self.halfHeight or newPos.y <= -(_self.halfHeight) then 
            --cambiamos de direccion
            _self.dir = _self.dir * -1
        end
        _self.rb:setPosition(newPos)

    end


    --Si sobrepasamos la posicion de la camara en z
    if _self.pos.z > _self.lastZ then
        lua:getCurrentScene():destroyEntity(_self.entity)
    end
end

quiscalus["onCollisionEnter"] = function(_self, lua, otherRb)
    --TO DO :sumar puntos

    local group = lua:getRigidbody(otherRb):getGroup()
	
    if group == 1 then-- si colisiona con el player
        local healthComponent = lua:getLuaSelf(otherRb,"health")
        if healthComponent.receiveDamage(_self.damage, lua) == true then
            lua:changeScene("mainMenu")--TO DO poner nombre de la escena game over
        end 
        --se destruye el quiscalus
        lua:playSound("Assets/Music/Enemigos/QuiscalusDestroy.wav")
        lua:getCurrentScene():destroyEntity(_self.entity)

    elseif group == 4 then-- si colisiona con las balas del jugador
        local healthComponent = lua:getLuaSelf(_self.entity,"health")
        local bulletcomponent = lua:getLuaSelf(otherRb,"bullet")
        --añadimos daño
        healthComponent.receiveDamage(bulletcomponent.damage, lua)
        --destruimos la bala 
        lua:getCurrentScene():destroyEntity(otherRb)
    end

    end

return quiscalus