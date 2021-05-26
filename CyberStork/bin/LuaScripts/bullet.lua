local JSON = assert(loadfile "LuaScripts/json.lua")()
local bullet = {}

bullet["instantiate"] = function(params, entity)
    p = JSON:decode(params)
    local self = {}

    -- En segundos el tiempo
    if p.lifetime ~= nil then
        self.lifetime = p.lifetime
    else
        self.lifetime = 3
    end
--la bala guarda el daño que hace
    if p.damage ~= nil then
        self.damage = p.damage
    else
        self.damage = 1
    end
    
    self.entity =  entity
    return self
end

bullet["start"] = function(_self, lua)
    _self.startTime = lua:getInputManager():getTicks()
end

bullet["update"] = function(_self, lua)

    if (lua:getInputManager():getTicks() - _self.startTime) / 1000 >=
        _self.lifetime then
        lua:getCurrentScene():destroyEntity(_self.entity)
    end
end

bullet["onCollisionEnter"] = function(_self, lua, otherRb)
    --si choca con el jugador aumentara la vida de este en _self.life puntos

   local group = lua:getRigidbody(otherRb):getGroup()
   
   if group == 16 or group == 4 then-- si colisiona con otra bala
       --se destruye el la bala
       lua:getCurrentScene():destroyEntity(_self.entity)
   elseif group == 1 then-- si colisiona con el player
        local healthComponent = lua:getLuaSelf(otherRb,"health")
        if healthComponent.receiveDamage(_self.damage, lua)== true then
        lua:changeScene("gameOver")
        end
        
        --se destruye la bala
        lua:getCurrentScene():destroyEntity(_self.entity)
    elseif group == 2 then
        print("he colisionado con un enemigo")
    end

   end

return bullet

