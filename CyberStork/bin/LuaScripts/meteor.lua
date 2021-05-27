local JSON = assert(loadfile "LuaScripts/json.lua")()
local meteor = {}

meteor["instantiate"] = function(params, entity)
  p = JSON:decode(params)
  local self = {}
  self.entity = entity
  self.speed = 1000
  self.damage = 1
  self.score = 10
  self.scrRange = 5
  
  --Velocidad de los meteoritos
  --TO DO: pasar mejor un rango y que asi todos los meteoritos
  --no tengan la misma velocidad
  if p ~= nil then
    if p.speed ~= nil then
      self.speed = p.speed
    end

    if p.damage ~= nil then
      self.damage = p.damage
    end

    if p.score ~= nil then
      self.score = p.score
    end

    if p.scrRange ~= nil then
      self.scrRange = p.scrRange
    end
  end
  return self
end

meteor["start"] = function(_self, lua)
  local z = lua:getTransform(_self.entity):getPosition().z

  _self.pos = lua:getTransform(_self.entity):getPosition()

  --Dimensiones del la ventana
  local halfWidth = (lua:getOgreContext():getWindowWidth()/2)
  local halfHeight = (lua:getOgreContext():getWindowHeight()/2)

  --TO DO: no hacerlo en base al tamano de la ventana y tener en cuenta que es una camara
  --en perspectiva
  local v3 = Vector3(math.random(-halfWidth, halfWidth), math.random(-halfHeight, halfHeight), z)
  
  _self.rb = lua:getRigidbody(_self.entity)
  _self.rb:setPosition(v3)
  
  --Cogemos la posicion del player, calculamos nuestra direccion y normalizamos el vector
  local v2 = lua:getTransform(lua:getEntity("Player")):getPosition()
  local resta = Vector3(v2.x - v3.x, v2.y - v3.y, v2.z - v3.z)
  resta:normalize()

  --Setteamos velocidad lineal correspondiente
  _self.rb:setLinearVelocity(Vector3(resta.x * _self.speed, resta.y * _self.speed, resta.z * _self.speed))

end

meteor["update"] = function(_self, lua)
  --TO DO: gestion de colisiones con otros objetos y la destruccion cuando supere la z de la camara principal
     --Si sobrepasamos la posicion de la camara en z
     if _self.pos.z > _self.lastZ then
      lua:getCurrentScene():destroyEntity(_self.entity)
	end
end

meteor["onCollisionEnter"] = function(_self, lua, otherRb)

  --TO DO :sumar puntos

  local group = lua:getRigidbody(otherRb):getGroup()
  
  if group == 1 then-- si colisiona con el player
    --cogemos el health del player
      local healthComponent = lua:getLuaSelf(otherRb,"health")
      --le añadimos el daño
      if healthComponent.receiveDamage(_self.damage, lua) == true then
        lua:changeScene("gameOver")
        lua:getLuaSelf(lua:getEntity("gameManager"), "score").registerScore()
      end 
	  local luz = lua:instantiate("luzDeAndromeda")
	  lua:getTransform(luz):setPosition(_self.pos)
	  luz:start()
      --se destruye el meteorito
      lua:playSound("Assets/Music/Enemigos/MeteoritoDestroy.wav")
      lua:getCurrentScene():destroyEntity(_self.entity)
		
  elseif group == 4 then -- si colisiona con las balas del jugador
      --destruimos la bala 
      lua:getCurrentScene():destroyEntity(otherRb)
	  --destruimos el meteoro
	  local luz = lua:instantiate("luzDeAndromeda")
	  lua:getTransform(luz):setPosition(_self.pos)
	  luz:start()

      lua:playSound("Assets/Music/Enemigos/MeteoritoDestroy.wav")
      lua:getCurrentScene():destroyEntity(_self.entity)

      local sc = lua:getLuaSelf(lua:getEntity("gameManager"), "score")
      sc.addScore( _self.score + math.random(0, _self.scrRange))
      lua:getLuaSelf(lua:getEntity("ScorePanel"), "showScore").updateScoreText(sc.getActualScore())
  end
end

return meteor
