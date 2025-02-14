local ie = core.request_insecure_environment()
assert(ie ~= nil, "Please add osshell to secure.trusted_mods")

local shellmode = {}

core.register_on_mods_loaded(function()
	table.insert(core.registered_on_chat_messages, 1, function(name, msg)
		if not shellmode[name] or not msg or msg:gsub("[ \n]","") == "" then return end
		if msg == "exit" then
			shellmode[name] = nil
			core.chat_send_player(name, "-!- OS shell mode disabled")
			return true
		end
		core.chat_send_player(name, core.colorize("#999","] "..msg))
		local cmd = ie.io.popen(msg, "r")
		local out = cmd:read("*a")
		cmd:close()
		core.chat_send_player(name, tostring(out))
		return true
	end)
end)

core.register_chatcommand("osshell",{
	description = "Enable OS shell mode. YOU MUST KNOW WHAT YOU DOING",
	params = "[passkey]",
	privs = {server=true},
	func = function(name, param)
		if core.get_player_by_name(name) then
			local pk = core.settings:get("osshell.passkey")
			if not pk or pk == param then
				shellmode[name] = true
				return true, "-!- OS shell mode enabled. Type `exit` to disable"
			else
				return false, "-!- Invalid passkey!"
			end
		end
end})
