{ pkgs
, lib
, inputs
, config
, ...
}: {
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      ## Navigation (lalt - ...)
      # Space Navigation (four spaces per display): lalt - {1, 2, 3, 4}
      lalt - 1 : DISPLAY="$(yabai -m query --displays --display | jq '.index')"; yabai -m space --focus $((1+4*($DISPLAY - 1)))
      lalt - 2 : DISPLAY="$(yabai -m query --displays --display | jq '.index')"; yabai -m space --focus $((2+4*($DISPLAY - 1)))
      lalt - 3 : DISPLAY="$(yabai -m query --displays --display | jq '.index')"; yabai -m space --focus $((3+4*($DISPLAY - 1)))
      lalt - 4 : DISPLAY="$(yabai -m query --displays --display | jq '.index')"; yabai -m space --focus $((4+4*($DISPLAY - 1)))

      # Window Navigation (through display borders): lalt - {h, j, k, l}
      lalt - h : yabai -m window --focus west  || yabai -m display --focus west
      lalt - j : yabai -m window --focus south || yabai -m display --focus south
      lalt - k : yabai -m window --focus north || yabai -m display --focus north
      lalt - l : yabai -m window --focus east  || yabai -m display --focus east

      # Float / Unfloat window: lalt - space
      lalt - space : yabai -m window --toggle float; sketchybar --trigger window_focus

      # Make window zoom to fullscreen: shift + lalt - f
      shift + lalt - f : yabai -m window --toggle zoom-fullscreen; sketchybar --trigger window_focus

      # Make window zoom to parent node: lalt - f
      lalt - f : yabai -m window --toggle zoom-parent; sketchybar --trigger window_focus

      ## Window Movement (shift + lalt - ...)
      # Moving windows in spaces: shift + lalt - {h, j, k, l}
      shift + lalt - h : yabai -m window --warp west || $(yabai -m window --display west && sketchybar --trigger windows_on_spaces && yabai -m display --focus west && yabai -m window --warp last) || yabai -m window --move rel:-10:0
      shift + lalt - j : yabai -m window --warp south || $(yabai -m window --display south && sketchybar --trigger windows_on_spaces && yabai -m display --focus south) || yabai -m window --move rel:0:10
      shift + lalt - k : yabai -m window --warp north || $(yabai -m window --display north && sketchybar --trigger windows_on_spaces && yabai -m display --focus north) || yabai -m window --move rel:0:-10
      shift + lalt - l : yabai -m window --warp east || $(yabai -m window --display east && sketchybar --trigger windows_on_spaces && yabai -m display --focus east && yabai -m window --warp first) || yabai -m window --move rel:10:0

      # Toggle split orientation of the selected windows node: shift + lalt - s
      shift + lalt - s : yabai -m window --toggle split

      # Moving windows between spaces: shift + lalt - {1, 2, 3, 4, p, n } (Assumes 4 Spaces Max per Display)
      shift + lalt - 1 : DISPLAY="$(yabai -m query --displays --display | jq '.index')";\
                        yabai -m window --space $((1+4*($DISPLAY - 1)));\
                        sketchybar --trigger windows_on_spaces

      shift + lalt - 2 : DISPLAY="$(yabai -m query --displays --display | jq '.index')";\
                        yabai -m window --space $((2+4*($DISPLAY - 1)));\
                        sketchybar --trigger windows_on_spaces

      shift + lalt - 3 : DISPLAY="$(yabai -m query --displays --display | jq '.index')";\
                        yabai -m window --space $((3+4*($DISPLAY - 1)));\
                        sketchybar --trigger windows_on_spaces

      shift + lalt - 4 : DISPLAY="$(yabai -m query --displays --display | jq '.index')";\
                        yabai -m window --space $((4+4*($DISPLAY - 1)));\
                        sketchybar --trigger windows_on_spaces

      shift + lalt - p : yabai -m window --space prev; yabai -m space --focus prev; sketchybar --trigger windows_on_spaces
      shift + lalt - n : yabai -m window --space next; yabai -m space --focus next; sketchybar --trigger windows_on_spaces

      # Mirror Space on X and Y Axis: shift + lalt - {x, y}
      shift + lalt - x : yabai -m space --mirror x-axis
      shift + lalt - y : yabai -m space --mirror y-axis

      ## Stacks (shift + ctrl - ...)
      # Add the active window to the window or stack to the {direction}: shift + ctrl - {h, j, k, l}
      shift + ctrl - h    : yabai -m window  west --stack $(yabai -m query --windows --window | jq -r '.id'); sketchybar --trigger window_focus
      shift + ctrl - j    : yabai -m window south --stack $(yabai -m query --windows --window | jq -r '.id'); sketchybar --trigger window_focus
      shift + ctrl - k    : yabai -m window north --stack $(yabai -m query --windows --window | jq -r '.id'); sketchybar --trigger window_focus
      shift + ctrl - l    : yabai -m window  east --stack $(yabai -m query --windows --window | jq -r '.id'); sketchybar --trigger window_focus

      # Stack Navigation: shift + ctrl - {n, p}
      shift + ctrl - n : yabai -m window --focus stack.next
      shift + ctrl - p : yabai -m window --focus stack.prev

      ## Resize (ctrl + lalt - ...)
      # Resize windows: ctrl + lalt - {h, j, k, l}
      ctrl + lalt - h    : yabai -m window --resize right:-100:0 || yabai -m window --resize left:-100:0
      ctrl + lalt - j    : yabai -m window --resize bottom:0:100 || yabai -m window --resize top:0:100
      ctrl + lalt - k    : yabai -m window --resize bottom:0:-100 || yabai -m window --resize top:0:-100
      ctrl + lalt - l : yabai -m window --resize right:100:0 || yabai -m window --resize left:100:0

      # Equalize size of windows: ctrl + lalt - e
      ctrl + lalt - e : yabai -m space --balance

      # Enable / Disable gaps in current workspace: ctrl + lalt - g
      ctrl + lalt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

      # Enable / Disable window borders in current workspace: ctrl + lalt - b
      ctrl + lalt - b : yabai -m config window_border off
      shift + ctrl + lalt - b : yabai -m config window_border on

      ## Misc
      # Open new Alacritty window
      cmd - return : alacritty msg create-window
    '';
  };
}
