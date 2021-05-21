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
    if _self.horizontal == true then
        local newPos = Vector3(_self.pos.x +(_self.speed * dir), _self.pos.y, _self.pos.z + _self.frontSpeed)
        --si nos salimos de la pantalla
        if newPos.x >= _self.halfWidth or newPos.x <= -(_self.halfWidth) then 
            --cambiamos de direccion
            _self.dir = _self.dir * -1
        end
        _self.rb:setPosition(newPos)
    else
        local newPos = Vector3(_self.pos.x , _self.pos.y +(_self.speed * dir), _self.pos.z + _self.frontSpeed)
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
        print("Cuervo destruido XD")
    end
end

return quiscalus