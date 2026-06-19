--- @since 25.5.31
-- Glow previewer: render Markdown files in yazi's preview pane with `glow`.
-- Official recipe from https://github.com/yazi-rs/plugins/tree/main/glow.yazi

local M = {}

function M:peek(job)
	local child = Command("glow")
		:arg({ "-s", "dark", "-w", tostring(job.area.w), tostring(job.file.url) })
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if not child then
		return ya.preview_widget(
			job,
			ui.Text("Failed to start `glow`, please make sure it's installed"):area(job.area):wrap(ui.Wrap.YES)
		)
	end

	local limit = job.area.h
	local i, lines = 0, ""
	repeat
		local next, event = child:read_line()
		if event == 1 then
			return ya.preview_widget(job, ui.Text(tostring(next)):area(job.area):wrap(ui.Wrap.YES))
		elseif event ~= 0 then
			break
		end

		i = i + 1
		if i > job.skip then
			lines = lines .. next
		end
	until i >= job.skip + limit

	child:start_kill()
	if job.skip > 0 and i < job.skip + limit then
		ya.emit("peek", { math.max(0, i - limit), only_if = job.file.url, upper_bound = true })
	else
		lines = lines:gsub("\t", string.rep(" ", rt.preview.tab_size))
		ya.preview_widget(job, ui.Text.parse(lines):area(job.area))
	end
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = math.floor(job.units * job.area.h / 10)
		ya.emit("peek", {
			math.max(0, cx.active.preview.skip + step),
			only_if = job.file.url,
		})
	end
end

return M
