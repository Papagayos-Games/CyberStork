local JSON = assert(loadfile "LuaScripts/json.lua")()

local score = {}

score["instantiate"] = function(params, entity)
    local p = JSON:decode(params)
    local self = {}
    self.scores = {}
    self.actualScore = 0
    self.maxScores = 3
    self.fileName = "Scores.txt"
    self.path = "\\Assets\\"

    if p ~= nil then

    if p.fileName ~= nil then self.fileName = p.fileName end

    if p.maxScores ~= nil then self.maxScores = p.maxScores end

    end

    local f = assert(io.popen "cd")
    local current_dir = f:read '*l'
    assert(f:close())

    local path_ = current_dir .. self.path .. self.fileName

    local file = assert(io.open(path_))

    if file == nil then
        print("No se ha podido abrir el archivo " .. self.path .. self.fileName)
        local fileCre = assert(io.open(path_, "w"))
        print("archivo creado" .. self.path .. self.fileName)
        assert(fileCre:close())
        return
    end

    local i = 0
    for line in file:lines() do
        table.insert(self.scores, tonumber(line));
        i = i + 1
        if i >= self.maxScores then break end
    end
    assert(file:close())

    for key, value in pairs(self.scores) do -- actualcode
        print("[" .. key .. "] " .. value)
    end

    self.getActualScore = function(s)
        return s.actualScore
    end

    self.setActualScore = function(s, score)
        s.actualScore = score
    end

    self.getScores = function(s)
        return s.scores
    end
    
    self.addScore = function(s)
        table.insert(s.scores, tonumber(s.actualScore))
        table.sort(s.scores, function(a, b) return a > b end)
        local count = 0
        for _ in pairs(s.scores) do count = count + 1 end
        if count > s.maxScores then
            table.remove(s.scores, count)
        end

        local f = assert(io.popen "cd")
        local current_dir = f:read '*l'
        assert(f:close())
    
        local path_ = current_dir .. s.path .. s.fileName
    
        local file = assert(io.open(path_, "w"))
        if file == nil then
            print("No se ha podido abrir el archivo " .. s.path .. s.fileName)
            return
        end

        for key, value in pairs(s.getScores(s)) do -- actualcode
            file:write(value .. "\n")
        end

        assert(file:close())
    end

    return self
end

score["start"] = function(_self, lua) end

score["update"] = function(_self, lua) end

return score
