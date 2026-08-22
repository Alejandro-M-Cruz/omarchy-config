-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Catch-all fallback for any output not matched below. Keep this first:
-- later rules win for the outputs they name.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- External AOC Q27G3XMN over DisplayPort. Anchored at 0x0 so it is always the
-- left-hand screen; vrr = 2 runs adaptive sync (48-180 Hz) for fullscreen apps only.
hl.monitor({ output = "DP-1", mode = "2560x1440@180", position = "0x0", scale = 1, vrr = 2 })

-- Built-in laptop panel. auto-right puts it to the right of the external when
-- both are up, and at 0x0 on its own when the external is unplugged.
-- scale must stay a literal number: omarchy-hyprland-monitor-clamshell reads this
-- rule to restore the panel, and cannot resolve "auto".
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "auto-right", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
