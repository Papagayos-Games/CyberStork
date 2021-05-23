local JSON = assert(loadfile "LuaScripts/json.lua")()
local meteor = {}

meteor["instantiate"] = function(params, entity)
  p = JSON:decode(params)
  local self = {}
  
  --Velocidad de los meteoritos
  --TO DO: pasar mejor un rango y que asi todos los meteoritos
  --no tengan la misma velocidad
  if p.speed ~= nil then
    self.speed = p.speed
  else
    self.speed = 1000
  end

  if p.damage ~= nil then
    self.damage = p.damage
  else
    self.damage = 1
  end

  self.entity = entity
  return self
end

meteor["start"] = function(_self, lua)
  local z = lua:getTransform(_self.entity):getPosition().z

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

end

meteor["onCollisionEnter"] = function(_self, lua, otherRb)
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
      --destruimos la bala 
      lua:getCurrentScene():destroyEntity(otherRb)
      lua:getCurrentScene():destroyEntity(_self.entity)
      print("destruida bala  y meteorito al colisionar")

  end


end

return meteor
