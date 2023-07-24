require("utils")

Dota1x2Error = Dota1x2Error or class({})

function Dota1x2Error:constructor(message)
    self.message = message
end

function Dota1x2Error:GetMessage()
    return self.message
end

Unimplemented = Unimplemented or class({}, {}, Dota1x2Error)

function Unimplemented:constructor(class_name, method_name)
    Dota1x2Error.constructor(
        self,
        "Abstract class '" .. class_name .. "' has no implementation for method '" .. method_name .. "'"
    )
end

assert(Dota1x2Error("message"):GetMessage() ~= nil)
assert(Unimplemented("a", "b"):GetMessage() ~= nil)

function IsDota1x2Error(err)
    return instanceof(err, Dota1x2Error)
end
