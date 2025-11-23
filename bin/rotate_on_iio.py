#! /usr/bin/python

import subprocess
from pathlib import Path

hypr_monitors = Path.home() / ".config/hypr/monitors.conf"
hypr_inputs = Path.home() / ".config/hypr/inputs.conf"
fontconfig_file = Path.home() / ".config/fontconfig/conf.d/10-rotate.conf"


def read_config() -> str:
    with open(hypr_monitors) as f:
        return f.read()


def write_config(monitor_config: str, input_config: str, fontconfig: str):
    with open(hypr_monitors, "w") as f:
        f.write(monitor_config)
    with open(hypr_inputs, "w") as f:
        f.write(input_config)
   # with open(fontconfig_file, "w") as f:
   #     f.write(fontconfig)


# 0 -> normal (no transforms)
# 1 -> 90 degrees
# 2 -> 180 degrees
# 3 -> 270 degrees
# 4 -> flipped
# 5 -> flipped + 90 degrees
# 6 -> flipped + 180 degrees
# 7 -> flipped + 270 degrees

hyprland_transform = {
    "normal": "0",  # 0,
    "right-up": "3",  # 270,
    "left-up": "1",  # 90,
    "bottom-up": "2",  # 180,
}

sub_pixel = {
    "normal": "rgb",  # 0,
    "right-up": "vbgr",  # 270,
    "left-up": "vrgb",  # 90,
    "bottom-up": "bgr",  # 180,
}

def is_rotation_locked() -> bool:
    try:
        with open(Path.home() / ".config/rotation_lock") as f:
            content = f.read()
            if "true" in content:
                return True
    except FileNotFoundError:
        return False
    return False

def on_changed(orientation: str):
    has_input_transform = False
    def modify_line(line: str) -> str:
        if line.startswith("monitor"):
            if "Sharp Corporation 0x1526" not in line:
                return line
            args = line.split(",")
            if args[-2].strip() == "transform":
                args[-1] = hyprland_transform[orientation]
            else:
                args += ["transform", hyprland_transform[orientation]]
            return ",".join(args)
        return line

    if is_rotation_locked():
        print("locked")
        return
    assert orientation in hyprland_transform.keys()
    config = read_config()
    lines = config.splitlines()
    monitor_config = "\n".join([modify_line(line) for line in lines])
    print(monitor_config)
    input_config = f"""
input {{
    touchdevice {{
        transform = {hyprland_transform[orientation]}
        output = eDP-1
    }}
    tablet {{
        transform = {hyprland_transform[orientation]}
        output = eDP-1
    }}
}}
"""
    fontconfig = f"""<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
    <description>Disable sub-pixel rendering</description>
    <match target="pattern">
        <edit name="rgba" mode="assign">
            <const>{sub_pixel[orientation]}</const>
        </edit>
    </match>
</fontconfig>
"""
    write_config(monitor_config, input_config, fontconfig)
    # subprocess.Popen(["fc-cache"])


def main():
    p = subprocess.Popen(["monitor-sensor"], stdout=subprocess.PIPE, text=True)

    if p.stdout is None:
        print("[ERROR]: cannot run monitor-sensor")
        return
    while True:
        line = p.stdout.readline()
        if "Accelerometer orientation changed" in line:
            orientation = line.split()[-1]
            print(orientation)
            on_changed(orientation)
    pass


if __name__ == "__main__":
    main()
