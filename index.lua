local web = require("web")

local function index() 
   ngx.say("this is index.") 
end

local function about()
   ngx.say("this is about.") 
end

local function page(page,count,name)
   ngx.say(string.format("page %s, count %s, name %s",
                         page,count,name))
end

local function blog(arg)
   ngx.say("this is blog " .. arg) 
end

local urls = {
   '^/$', index,
   '^/about$', about,
   '^/page/([0-9]+)/count/([0-9]+)/name/(.*)$', page,
   '^/blog/(.*)$', blog,
}

local app = web.application(urls, nil)
app:run()

