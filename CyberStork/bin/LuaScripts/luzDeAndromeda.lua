local JSON = assert(loadfile "LuaScripts/json.lua")()
local luzDeAndromeda = {}

luzDeAndromeda["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.life ~= nil then
        self.life = p.life
    else
        self.life = 1
    end

    return self
end

luzDeAndromeda["start"] = function (_self, lua)

    _self.pos = lua:getTransform(_self.entity):getPosition()
    _self.rb = lua:getRigidbody(_self.entity)
    _self.lastZ = lua:getTransform(lua:getEntity("defaultCamera")):getPosition().z
   
end

luzDeAndromeda["update"] = function (_self, lua)
    --Si sobrepasamos la posicion de la camara en z
    if _self.pos.z > _self.lastZ then
        lua:getCurrentScene():destroyEntity(_self.entity)
        print("luzDeAndromeda destruido XD")
    end

   
end
luzDeAndromeda["onCollisionEnter"] = function(_self, lua, otherRb)
     --si choca con el jugador aumentara la vida de este en _self.life puntos
    print("en el oncolision enter Andromeda")

    local group = lua:getRigidbody(otherRb):getGroup()
    print("cojemos el grupo al que pertenece" )
    if group == 1 then-- si colisiona con el player
        local healthComponent = lua:getLuaSelf(otherRb,"health")
        healthComponent.getLife(_self.life)
        --se destruye el el powerup
        lua:getCurrentScene():destroyEntity(_self.entity)
        print("destruido andromeda al colisionar con el player")

    end

return luzDeAndromeda