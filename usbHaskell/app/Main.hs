{-# LANGUAGE
      LambdaCase
    , OverloadedStrings
    , RecordWildCards
#-}

module Main where

import Prelude hiding (product)

--import Bindings.Libusb
import Data.Maybe
import Data.Traversable
import qualified Data.Vector as V
import Data.Word
--import System.USB.Descriptors
--import System.USB.DeviceHandling
import System.USB.Enumeration
import System.USB.Initialization
--import System.USB.IO
import Text.Printf

import qualified Config as Config
import qualified DeviceDesc as Device

main :: IO ()
main = do
  ctx <- newCtx
  devices <- getDevices ctx

  {-
  let controlSetup =
        ControlSetup {
          controlSetupRequestType = Standard
        , controlSetupRecipient   = ToDevice
        , controlSetupRequest     = c'LIBUSB_REQUEST_SET_CONFIGURATION
        , controlSetupValue       = 1
        , controlSetupIndex       = 0
        }
  -}

  --deviceHandle <- openDevice $ devices V.! 2
  print devices
  _ <- 
    for (V.toList devices) $ \device -> do
      displayDeviceDesc device
      --displayConfigDesc device 0

    
  --print =<< getLanguages deviceHandle
  --putStrLn "#########################################"
  --val <- readInterrupt deviceHandle (EndpointAddress 0 In) 1000 1000
  --val <- readControl deviceHandle controlSetup 1000 1000
  --print val

  return ()


displayConfigDesc::Device->Word8->IO ()
displayConfigDesc device configNumber = do
  Config.Config{..} <- Config.getConfig device configNumber
  
  putStrLn $ "  Config " ++ show configNumber ++ " Descriptor:"
  putStrLn $ "    configValue: " ++ show value
  putStrLn $ "    configStrIx: " ++ show strIx
  putStrLn $ "    configAttribs: " ++ show attribs
  putStrLn $ "    configMaxPower: " ++ show maxPower
  putStrLn $ "    configInterfaces: " ++ show interfaces
  putStrLn $ "    configExtra: " ++ show extra



displayDeviceDesc::Device->IO ()
displayDeviceDesc device = do
  Device.DeviceDesc{..} <- Device.getDeviceDesc device
  
  putStrLn "Device Descriptor:"
  putStrLn $ "  USBSpecReleaseNumber: " ++ show usbSpecReleaseNumber
  putStrLn $ "  Class: " ++ show class'
  putStrLn $ "  SubClass: " ++ show subClass
  putStrLn $ "  Protocol: " ++ show protocol
  putStrLn $ "  MaxPacketSize0: " ++ show maxPacketSize0
  printf "  ID: %04x:%04x\n" vendorId productId
  putStrLn $ "  ReleaseNumber: " ++ show releaseNumber
  putStrLn $ "  Manufacturer: " ++ fromMaybe "-" manufacturer
  putStrLn $ "  Product: " ++ fromMaybe "-" product
  putStrLn $ "  SerialNumber: " ++ fromMaybe "-" serialNumber
  putStrLn $ "  NumConfigs: " ++ show numConfigs
