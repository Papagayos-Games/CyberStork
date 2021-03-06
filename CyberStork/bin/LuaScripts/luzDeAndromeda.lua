local JSON = assert(loadfile "LuaScripts/json.lua")()
local luzDeAndromeda = {}

luzDeAndromeda["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity
    self.life = 1
    if p ~= nil then 
        if p.life ~= nil then
            self.life = p.life
        end
    end

    return self
end

luzDeAndromeda["start"] = function (_self, lua)

    _self.pos = lua:getTransform(_self.entity):getPosition()
    _self.rb = lua:getRigidbody(_self.entity)
    _self.lastZ = lua:getTransform(lua:getEntity("defaultCamera")):getPosition().z



          --Dimensiones del la ventana
  local halfWidth = (lua:getOgreContext():getWindowWidth()/2)
  local halfHeight = (lua:getOgreContext():getWindowHeight()/2)


  local newX = math.random(-halfWidth+350, halfWidth-350)
  local newY = math.random(-halfHeight+100, halfHeight-100)


  _self.rb:setPosition(Vector3(newX, newY, _self.pos.z))

   
end

luzDeAndromeda["update"] = function (_self, lua)
    --Si sobrepasamos la posicion de la camara en z
    if _self.pos.z > _self.lastZ then
        lua:getCurrentScene():destroyEntity(_self.entity)
    end

   
end
luzDeAndromeda["onCollisionEnter"] = function(_self, lua, otherRb)
     --si choca con el jugador aumentara la vida de este en _self.life puntos

    local group = lua:getRigidbody(otherRb):getGroup()
	
    if group == 1 then-- si colisiona con el player
        print("ColisionPlayer")
        local healthComponent = lua:getLuaSelf(otherRb,"health")
        lua:playSound("Assets/Music/Player/Bonus.wav")
        healthComponent.addLife(_self.life, lua)
		--Aqui se llama al metodo que esconde un icono de vida en caso de quedar vidas--
        --se destruye el powerup
        lua:getCurrentScene():destroyEntity(_self.entity)

    end
end

return luzDeAndromeda