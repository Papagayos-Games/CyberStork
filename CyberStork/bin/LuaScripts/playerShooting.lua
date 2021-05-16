local playerShooting = {}

playerShooting["instantiate"] = function (params)
    print("Instantiate: PlayerShooting")

    --p = JSON:decode(params)
    local self = {}

    --Por defecto, 1000 iteraciones hasta que se haga el GetTicks
    ---if p.shootBulletTime ~= nil then
        --self.shootBulletTime = p.speed
    --else
        self.shootBulletTime = 100
    --end

    --Por defecto prefab bala
    --if p.object ~= nil then
        --self.object = p.object
    --else
        self.object = "bullet"
    --end

    return self
end

playerShooting["start"] = function (_self, lua)
    _self.time = 0
    print(_self.time)
    print("Start: PlayerShooting")

end

playerShooting["update"] = function (_self, lua)
    --print("Update: PlayerShooting")
    
    print(_self.time)
    --Temporal hasta que haya una gestion del tiempo por ticks
    _self.time = _self.time + 1

    if _self.time >= _self.shootBulletTime then
        print("Disparo xD")
        local bala = lua:instantiate(_self.object)
        lua:getRigidbody(bala):setPosition()
        _self.time = 0
    end 

end

return playerShooting