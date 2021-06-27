import XMonad
import XMonad.Actions.CopyWindow (kill1)
import System.Exit (exitSuccess)
import XMonad.Hooks.ManageDocks
    ( avoidStruts, avoidStrutsOn, docks, manageDocks, docksEventHook ,Direction2D(D, L, R, U) )
import XMonad.Hooks.ManageHelpers ( doFullFloat, isFullscreen )
import XMonad.Util.SpawnOnce ( spawnOnce )
import XMonad.Layout.Spacing ( spacingRaw, Border(Border) )
import XMonad.Util.EZConfig (additionalKeysP)
import qualified XMonad.StackSet as W
import XMonad.Util.NamedWindows (getName)
import Control.Monad (forM_, join)
import Data.List (sortBy)
import Data.Function (on)
import Data.Monoid (Endo)   
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook, ewmh)
import XMonad.Hooks.InsertPosition
import XMonad.Layout.NoBorders
import qualified XMonad.Layout.ToggleLayouts as T (ToggleLayout (Toggle), toggleLayouts)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.MultiToggle ((??), EOT (EOT), mkToggle, single)
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.GridVariants (Grid (Grid))
import XMonad.Layout.ThreeColumns
import XMonad.Layout.SimplestFloat
import XMonad.Actions.MouseResize
import XMonad.Layout.WindowArranger (WindowArrangerMsg (..), windowArrange)

main :: IO()
main = do
  xmonad $ ewmh def
    { terminal = myTerminal
    , modMask = myModMask
    , borderWidth = myBorderWidth
    , workspaces = myWorkspaces
    , normalBorderColor = myNormColor
    , focusedBorderColor = myFocusColor
    , startupHook = myStartup
    --, manageHook = (isFullscreen --> doFullFloat) <+> manageDocks <+> insertPosition Below Newer
    , manageHook = (isFullscreen --> doFullFloat)
                <+> manageDocks
                <+> myManageHook
    , layoutHook = myLayoutHook    
    , handleEventHook = docksEventHook
    } `additionalKeysP` myKeys

myTerminal    = "alacritty" :: String
myModMask     = mod4Mask :: KeyMask
myNormColor   = "#292d3e" :: String
myFocusColor  = "#c792ea" :: String
myBorderWidth = 1 :: Dimension

myKeys :: [(String, X ())]
myKeys =
  [
    -- Kill window
    ("M-w", kill1),
    -- Restart xmonad
    ("M-C-r", spawn "xmonad --recompile && xmonad --restart"),
    -- Quit xmonad
    ("M-C-q", io exitSuccess),
     -- Menu
    ("M-m", spawn "rofi -show drun"),
    -- Window nav
    ("M-S-m", spawn "rofi -show"),
    -- Browser
    ("M-b", spawn "brave"),
    -- File explorer
    ("M-e", spawn "pcmanfm"),
    -- Terminal
    ("M-<Return>", spawn myTerminal),
    -- Scrot
    ("M-s", spawn "scrot"),
    ("M-S-s", spawn "scrot -s")
  ]
myWorkspaces =
   --    "                  ﬏                             
   ["\xf269 ", "\xe795 ", "\xfb0f ", "\xe256 ", "\xf07b ", "\xf196 "]
myStartup = do
  setWMName "LG3D"
  spawnOnce "picom -f"
  spawnOnce "polybar example"

-- myLayout = avoidStruts(tiled ||| Mirror tiled ||| Full)
--   where
--     tiled   = Tall nmaster delta ratio
--     nmaster = 1
--     ratio   = 1/2
--     delta   = 3/100 

-- myManageHook = fullscreenManageHook <+> manageDocks <+> composeAll
--     [className =? "Polybar"        --> doFloat
--     , className =? "polybar"       --> doFloat 
--     , resource =? "polybar"        --> doFloat 
--     , resource =? "Polybar"        --> doFloat 
--     , isFullscreen --> doFullFloat
--                                  ]

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True
tall = renamed [Replace "tall"]
    $ limitWindows 12
    $ mySpacing 4
    $ ResizableTall 1 (3 / 100) (1 / 2) []

monocle = renamed [Replace "monocle"] $ limitWindows 20 Full

grid = renamed [Replace "grid"]
    $ limitWindows 12
    $ mySpacing 4
    $ mkToggle (single MIRROR)
    $ Grid (16 / 10)

threeCol = renamed [Replace "threeCol"]
    $ limitWindows 7
    $ mySpacing' 4
    $ ThreeCol 1 (3 / 100) (1 / 3)

floats = renamed [Replace "floats"] $ limitWindows 20 simplestFloat

myLayoutHook = avoidStruts 
    $ smartBorders
    $ mouseResize
    $ windowArrange
    $ T.toggleLayouts floats
    $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout = 
        noBorders monocle
        ||| tall
        ||| threeCol
        ||| grid
myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
    [ className =? "Brave-browser" --> doShift (head myWorkspaces)
    , className =? "Alacritty" --> doShift (myWorkspaces !! 1)
    , className =? "Code" --> doShift (myWorkspaces !! 2)
    , className =? "code" --> doShift (myWorkspaces !! 2)
    , className =? "discord" --> doShift (myWorkspaces !! 5)
    , title =? "FLOATING" --> doFloat
    ]
