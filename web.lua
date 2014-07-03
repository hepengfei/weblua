
local _M = {}

local Application = {}

function Application:new(obj)
   obj = obj or {}
   setmetatable(obj, self)
   self.__index = self
   return obj
end

function Application:run()
   local matched = nil

   for i = 1, #self.urls, 2 do
      local pattern = self.urls[i]
      local view = self.urls[i+1]
      -- regex mather in compile mode
      local match = ngx.re.match(ngx.var.uri, pattern, "")
      if match then
         matched = i
         view(unpack(match))
         break
      end
   end

   if not matched then
      ngx.exit(ngx.HTTP_NOT_FOUND)
   end
end

function _M.application(urls, env)
   local app = Application:new{urls = urls}
   return app
end

return _M

