
local _M = { debug = nil }

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
         if _M.debug then
            ngx.log(ngx.DEBUG, "match pattern:", pattern)
         end
         matched = i
         local status = view(unpack(match))
         status = status or ngx.HTTP_OK
         ngx.exit(status)
      end
   end

   if not matched then
      if _M.debug then
         ngx.log(ngx.DEBUG, "uri not matched:", ngx.var.uri)
      end
      ngx.exit(ngx.HTTP_NOT_FOUND)
   end
end

function _M.application(urls, env)
   local app = Application:new{urls = urls}
   return app
end

return _M

