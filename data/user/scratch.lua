-- data/user/scratch.lua


(local pp = function()
  print("...")
end
pp())
print(">>>>>>>>>>>")

local s = ''
 for k,v in pairs(system) do
   s = s .. 'K:' .. tostring(k) .. 'V:' .. type(v)
end



local s = '123'

3*1230
print("...")
for k,v in pairs(renderer) do
  print(k,v)
end
renderer.show_debug(false)
renderer.show_debug(true)


-- status-bar:notify
core.log_quiet(tostring({1,2,3}))
core.log("X")

table: 0x55720225a6e0


display(command.get_all_valid())
type('')
function display(object)
  if type(object) == 'string' then return object end

  return tostring(object)
end













