{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances #-}

import Control.Monad
import Data.List
import System.IO

import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Fullscreen
import qualified XMonad.Layout.GridVariants as GV
import XMonad.Layout.IndependentScreens
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Minimize
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Run

liftTuple :: (Functor f) => (f a, b) -> f (a, b)
liftTuple (x, y) = fmap (flip (,) y) x

-- Represents an instance of a bar
type Bar = (Handle, ScreenId)

nScreens = 1

spawnXMobar :: Int -> IO Bar
spawnXMobar x = liftTuple (spawnPipe $ "xmobar -x " ++ (show x), S x)

avoidMaster :: ManageHook
avoidMaster = doF $ W.modify' $ \c -> 
    case c of
      W.Stack t [] (r:rs) -> W.Stack t [r] rs
      otherwise -> c

isFull :: X Bool
isFull = do
   d <- description . W.layout . W.workspace . W.current <$> gets windowset
   return $ isInfixOf "Full" d
  

withKeys :: XConfig l -> XConfig l
withKeys conf = conf
    `additionalKeysP`
    [ ("M-i",              whenX isFull $ windows W.focusDown)
    , ("M-o",              whenX isFull $ windows W.focusUp)
    , ("M-v",              sendMessage ToggleStruts)
    , ("M-[",              sendMessage Shrink)
    , ("M-]",              sendMessage Expand)
--  , ("M-m",              withFocused minimizeWindow)
--  , ("M-S-m",            sendMessage RestoreNextMinimizedWin)
    ]
    -- Spawning
    `additionalKeysP`
    [(k, spawnHere p)
    | (k, p) <-
      [ ("M-w", "firefox")
      , ("M-e", "thunderbird")
      , ("M-C-s", "xtrlock -b & systemctl suspend")
      , ("M-C-l", "xtrlock -b")
      , ("M-<Return>", terminal conf)
      ]]
    -- Workspace navigation
    `additionalKeys`
    [((modMask conf .|. m, k), windows $ onCurrentScreen f i)
    | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_5]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- Window navigation
    `additionalKeys`
    [((modMask conf .|. m, k), sendMessage $ a d)
    | (k, d) <- zip [xK_h, xK_j, xK_k, xK_l] [L, D, U, R]
    , (a, m) <- [(Go, 0), (Swap, shiftMask)]]

myWorkspaces :: [String]
myWorkspaces = ["1:code", "2:live", "3:reference", "4:mail", "5:extra"]

myLog :: Bar -> X ()
myLog (handle, i) = dynamicLogWithPP $ marshallPP i $ xmobarPP 
    { ppOutput = hPutStrLn handle 
    }

myManageHook :: ManageHook
myManageHook = composeAll
    [ manageDocks
    , manageSpawn
    , manageHook def
    , avoidMaster
    ]

mySplitLayout = GV.SplitGrid GV.L 1 2 (2/5) (10) (3/100)
myLayout = mySplitLayout ||| tiled ||| Full
  where
    tiled = Tall nMaster delta ratio
    nMaster = 1
    delta   = 3/100
    ratio   = 1/2

myConfig bars =
    withKeys
    def
        { modMask         = mod4Mask
        , terminal        = "terminator"
        , borderWidth     = 0
        , workspaces      = withScreens (S nScreens) myWorkspaces
        , logHook         = sequence_ $ map myLog bars
        , manageHook      = myManageHook
        , handleEventHook = docksEventHook

--        , startupHook     = spawn "xrandr --output HDMI-1 --primary --output eDP-1 --off" >> (ask >>= spawn . terminal . config)
        , startupHook     = (ask >>= spawn . terminal . config)

        , layoutHook      = windowNavigation $ avoidStruts $ minimize $ myLayout
        }

main :: IO ()
main = do
    bars <- mapM spawnXMobar [0..(nScreens - 1)]
    xmonad $ myConfig bars
