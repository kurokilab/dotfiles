--- @sync entry
-- Smart Enter: enter the hovered directory, or open the file otherwise.
-- Official recipe from https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi

local function setup(_, opts)
	st.open_multi = opts.open_multi
end

local function entry()
	local h = cx.active.current.hovered
	if h and h.cha.is_dir then
		ya.emit("enter", {})
	else
		ya.emit("open", { hovered = not st.open_multi })
	end
end

return { entry = entry, setup = setup }
