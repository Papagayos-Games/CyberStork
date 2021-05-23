local JSON = assert(loadfile "LuaScripts/json.lua")()
local Crescendum = {}

Crescendum["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.spawntime ~= nil then
        self.spawntime = p.life
    else
        self.spawntime = 2
    end
    if p.time ~= nil then
        self.time = p.life
    else
        self.time = 5
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

    
    
end
Crescendum["onCollisionEnter"] = function(_self, lua, otherRb)
    --si choca con el jugador aumentara la velocidad de disparo en self.time
   print("en el oncolision enter Crescendum")

   local group = lua:getRigidbody(otherRb):getGroup()
   print("cojemos el grupo al que pertenece" )
   if group == 1 then-- si colisiona con el player
       local spawnComponent = lua:getLuaSelf(otherRb,"spawner")
       spawnComponent.changeTimeToSpawn(_self.life, _self.time)
       --se destruye el el powerup
       lua:getCurrentScene():destroyEntity(_self.entity)
       print("destruido crescendum al colisionar con el player")

   end

return Crescendum