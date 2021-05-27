local JSON = assert(loadfile "LuaScripts/json.lua")()
local Crescendum = {}

Crescendum["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.life ~= nil then
        self.life = p.life
    else
        self.life = 2
    end
    if p.time ~= nil then
        self.time = p.time
    else
        self.time = 5
    end

    return self
end

Crescendum["start"] = function (_self, lua)

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

Crescendum["update"] = function (_self, lua)
    --Si sobrepasamos la posicion de la camara en z
    if _self.pos.z > _self.lastZ then
        lua:getCurrentScene():destroyEntity(_self.entity)
    end

    
    
end
Crescendum["onCollisionEnter"] = function(_self, lua, otherRb)
    --si choca con el jugador aumentara la velocidad de disparo en self.time

   local group = lua:getRigidbody(otherRb):getGroup()
   
   if group == 1 then-- si colisiona con el player
       local spawnComponent = lua:getLuaSelf(otherRb,"spawner")
       lua:playSound("Assets/Music/Player/Bonus.wav")
       spawnComponent.changeTimeToSpawn(_self.life, _self.time)
       --se destruye el el powerup
       lua:getCurrentScene():destroyEntity(_self.entity)
   end

   end

return Crescendum