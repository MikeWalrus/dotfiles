import           System.Exit

import           XMonad
import           XMonad.Actions.CopyWindow
import           XMonad.Core
import           XMonad.Hooks.DynamicIcons
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.StatusBar
import           XMonad.Hooks.StatusBar.PP
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns
import           XMonad.Layout.ToggleLayouts
import           XMonad.Prompt.ConfirmPrompt
import           XMonad.StackSet
import           XMonad.Util.ClickableWorkspaces
import           XMonad.Util.EZConfig
import           XMonad.Util.Loggers
import           XMonad.Util.NamedWindows
import           XMonad.Util.SpawnOnce
import           XMonad.Util.Ungrab

main = xmonad
    . ewmhFullscreen
    . ewmh
    . dynamicEasySBs barSpawner
    $ myConfig

myStartupHook = do
    spawnOnce "trayer --edge bottom --align right --SetDockType true --SetPartialStrut true \
            \--expand true --width 4 --transparent true --tint 0x5f5f5f --height 20 --monitor primary"

    spawnOnce "picom -b --experimental-backend"
    spawnOnce "xss-lock --transfer-sleep-lock --\
        \ i3lock -c 00000000 --nofork"
    spawnOnce "dunst"
    spawnOnce "redshift"
    spawn     "set_wallpaper.sh"

refresh_i3status = "&& killall -SIGUSR1 i3status"

myConfig = def
    { modMask = mod4Mask
    , layoutHook = smartBorders myLayout
    , terminal = "alacritty"
    , startupHook = myStartupHook
    , focusedBorderColor = "#C792EA"
    , normalBorderColor = "#000000"
    }
    `additionalKeysP`
     [
     ("M-f", sendMessage (Toggle "Full")),
     ("M-S-e", confirmPrompt def "exit" $ io exitSuccess),
     ("M-S-q", kill1),
     ("M-b"  , spawn "brave --force-device-scale-factor=1.4"),
     ("M-g"  , spawn "goldendict"),
     ("M-u"  , spawn "systemctl suspend"),
     ("M-S-l", spawn "loginctl lock-session"),
     ("M-S-s", spawn "import png:- | tee ~/screen.png | xclip -selection clipboard -t image/png"),
     ("M-S-o", spawn "~/scripts/ocr_screen.sh"),
     ("M-S-h", spawn "dunstctl history-pop"),
     ("M-n"  , spawn "dunstctl close-all"),
     ("M-S-n", spawn "~/scripts/dunst-toggle"),
     ("M-c"  , spawn "find-cursor"),
     ("M-x"  , spawn "emacsclient -nc"),
     ("M-d"  , spawn  "dmenu_run -i -nf '#BBBBBB' -nb '#292D3E' -sb '#7193DD' -sf '#FFFFFF' -fn 'monospace-10' -p 'open:'"),
     ("<XF86AudioRaiseVolume>", spawn $ "pactl set-sink-volume @DEFAULT_SINK@ +10%" ++ refresh_i3status),
     ("<XF86AudioLowerVolume>", spawn $ "pactl set-sink-volume @DEFAULT_SINK@ -10%" ++ refresh_i3status),
     ("<XF86AudioMute>", spawn $ "pactl set-sink-mute @DEFAULT_SINK@ toggle" ++ refresh_i3status),
     ("<XF86MonBrightnessUp>", spawn "brightnessctl set 3000+"),
     ("<XF86MonBrightnessDown>", spawn "brightnessctl set 3000-")
     ]

myLayout = toggleLayouts (noBorders Full) (tiled ||| Mirror tiled ||| threeCol ||| tabbed shrinkText myTabTheme)
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 3/5    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Bottom" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = nothing
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logConst ""]
    }
  where
    nothing id = ""

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""


barSpawner :: ScreenId -> IO StatusBarConfig
barSpawner (S 0) = pure $ statusBarProp cmd (clickablePP =<< dynamicIconsPP myIconsConfig myXmobarPP)
    where
        cmd = "i3status -c ~/.config/i3status/config-xmobar | xmobar -x 0"
barSpawner (S _) = mempty

myFont = "xft:JetBrains Mono-6:style=regular"

myTabTheme = def { fontName            = myFont
                 }

myIcons :: Query [String]
myIcons = composeAll
  [ className =? "Alacritty" --> appIcon "\xf489 "
  , className =? "Emacs" --> appIcon "\xf6f3 "
  , className =? "Brave-browser" --> appIcon "\xf6e6 "
  , className =? "Zathura" --> appIcon "\xf725 "
  , className =? "code-oss" --> appIcon "\xf121 "
  , className =? "Gvim" --> appIcon "\xe62b "
  , className =? "Org.gnome.Nautilus" --> appIcon "\xf07c "
  , className =? "TelegramDesktop" --> appIcon "\xfa00 "
  , className =? "Sxiv" --> appIcon "\xf1c5 "
  , className =? "GoldenDict" --> appIcon "\xf15d "
  , className =? "Anki" --> appIcon "\xfb38 "
  , className =? "icalingua" --> appIcon "\xf1d6 "
  , className =? "Xournalpp" --> appIcon "\xf8ea "
  , className =? "Drawing" --> appIcon "\xe22b "
  , className =? "Gedit" --> appIcon "\xf044 "
  , className =? "mpv" --> appIcon "\xf72f "
  ]

myIconsConfig = def{
     iconConfigIcons = myIcons, iconConfigFmt = iconsFmtAppend concat
    }
