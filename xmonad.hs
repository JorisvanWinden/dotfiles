import System.IO

import XMonad
import XMonad.Actions.NoBorders
import XMonad.Actions.SpawnOn
import XMonad.Actions.WindowNavigation
import XMonad.Layout.Fullscreen
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Minimize
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Run

type Bar = (Handle, ScreenId)

modMask' :: KeyMask
modMask' = mod4Mask

liftTuple :: (Functor f) => (f a, b) -> f (a, b)
liftTuple (x, y) = fmap (flip (,) y) x

barFromId :: ScreenId -> IO Bar
barFromId x = liftTuple (spawnPipe $ "xmobar -x " ++ (show x), x)

avoidMaster :: W.StackSet i l a s sd -> W.StackSet i l a s sd
avoidMaster = W.modify' $ \c -> case c of
    W.Stack t [] (r:rs) -> W.Stack t [r] rs
    otherwise -> c

spawnInitialPrograms :: X ()
spawnInitialPrograms = do
   spawnOn "1_1:test" "terminator"
   spawnOn "0_1:test" "google-chrome-stable"
   spawnOn "0_3:mail" "thunderbird"

withKeys :: XConfig l -> XConfig l
withKeys conf = conf
    `additionalKeysP`
    [ ("M-<Return>",       spawn $ terminal conf) 
    , ("M-w",              spawn "google-chrome-stable")
    , ("M-e",              spawn "thunderbird")
    , ("M-C-s",            spawn "systemctl suspend")
    , ("M-v",              sendMessage ToggleStruts)
    , ("M-[",              sendMessage Shrink)
    , ("M-]",              sendMessage Expand)
    , ("M-b",              withFocused toggleBorder)
    , ("M-m",              withFocused minimizeWindow)
    , ("M-S-m",            sendMessage RestoreNextMinimizedWin)
    , ("M-i",              spawnInitialPrograms)
    ]
    `additionalKeys`
    [((modMask' .|. m, k), windows $ onCurrentScreen f i)
    | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_5]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myWorkspaces :: [String]
myWorkspaces = ["1:test", "2:doc", "3:mail", "4", "5"]

myLog :: Bar -> X ()
myLog (handle, i) = dynamicLogWithPP $ marshallPP i $ xmobarPP 
    { ppOutput = hPutStrLn handle }

myManageHook :: ManageHook
myManageHook = composeAll
    [ manageDocks
    , manageSpawn
    , fullscreenManageHook
    , className =? "Mail" --> doShift "0_3:mail"
    , manageHook def
    , doF avoidMaster
    ]

myLayout = tiled ||| Full
  where
    tiled = Tall nMaster delta ratio
    nMaster = 1
    delta   = 3/100
    ratio   = 1/2

myConfig nScreens bars =
    withWindowNavigation (xK_k, xK_h, xK_j, xK_l)
    $ withKeys
    def
        { modMask         = modMask'
        , terminal        = "terminator"
        , borderWidth     = 0
        , workspaces      = withScreens nScreens myWorkspaces
        , logHook         = sequence_ $ map myLog bars
        , manageHook      = myManageHook
        , handleEventHook = fullscreenEventHook
        , layoutHook      = fullscreenFull $ avoidStruts $ minimize $ myLayout
        }

main :: IO ()
main = do
    bar1 <- liftTuple (spawnPipe "xmobar -x 0", 0)
    bar2 <- liftTuple (spawnPipe "xmobar -x 1", 1)
    myConfig 2 [bar1, bar2] >>= xmonad
