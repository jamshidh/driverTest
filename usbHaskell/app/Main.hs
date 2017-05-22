{-# LANGUAGE
      LambdaCase
    , OverloadedStrings
    , RecordWildCards
#-}

module Main where

import Bindings.Libusb
import Control.Monad
import Data.Maybe
import qualified Data.Text as Text
import Data.Traversable
import qualified Data.Vector as V
import Data.Word
import Numeric
import System.USB.Descriptors
import System.USB.DeviceHandling
import System.USB.Enumeration
import System.USB.Initialization
import System.USB.IO
import Text.Printf

main :: IO ()
main = do
  ctx <- newCtx
  devices <- getDevices ctx
  
  let controlSetup =
        ControlSetup {
          controlSetupRequestType = Standard
        , controlSetupRecipient   = ToDevice
        , controlSetupRequest     = c'LIBUSB_REQUEST_SET_CONFIGURATION
        , controlSetupValue       = 1
        , controlSetupIndex       = 0
        }

  deviceHandle <- openDevice $ devices V.! 2
  print devices
  for (V.toList devices) $ \device -> do
    displayDeviceDesc device
    --displayConfigDesc device 0

    
  print =<< getLanguages deviceHandle
  putStrLn "#########################################"
  val <- readInterrupt deviceHandle (EndpointAddress 0 In) 1000 1000
  val <- readControl deviceHandle controlSetup 1000 1000
  print val



displayConfigDesc::Device->Word8->IO ()
displayConfigDesc device configNumber = do
  configDesc@ConfigDesc{..} <- getConfigDesc device configNumber
  
  putStrLn $ "  Config " ++ show configNumber ++ " Descriptor:"
  putStrLn $ "    configValue: " ++ show configValue
  putStrLn $ "    configStrIx: " ++ show configStrIx
  putStrLn $ "    configAttribs: " ++ show configAttribs
  putStrLn $ "    configMaxPower: " ++ show configMaxPower
  putStrLn $ "    configInterfaces: " ++ show configInterfaces
  putStrLn $ "    configExtra: " ++ show configExtra
--  print configDesc


displayDeviceDesc::Device->IO ()
displayDeviceDesc device = do
  deviceHandle <- openDevice device
  DeviceDesc{..} <- getDeviceDesc device
  
  putStrLn "Device Descriptor:"
  putStrLn $ "  USBSpecReleaseNumber: " ++ show deviceUSBSpecReleaseNumber
  putStrLn $ "  Class: " ++ show deviceClass
  putStrLn $ "  SubClass: " ++ show deviceSubClass
  putStrLn $ "  Protocol: " ++ show deviceProtocol
  putStrLn $ "  MaxPacketSize0: " ++ show deviceMaxPacketSize0
  printf "  ID: %04x:%04x\n" deviceVendorId deviceProductId
  putStrLn $ "  ReleaseNumber: " ++ show deviceReleaseNumber
  
  manufacturer <- getString deviceHandle deviceManufacturerStrIx

  putStrLn $ "  Manufacturer: " ++ fromMaybe "-" manufacturer

  product <- getString deviceHandle deviceProductStrIx
  
  putStrLn $ "  Product: " ++ fromMaybe "-" product

  serialNumber <- getString deviceHandle deviceSerialNumberStrIx
  putStrLn $ "  SerialNumber: " ++ fromMaybe "-" serialNumber
  
  putStrLn $ "  NumConfigs: " ++ show deviceNumConfigs

getString::DeviceHandle->Maybe StrIx->IO (Maybe String)
getString deviceHandle = \case
  Nothing -> return Nothing
  Just i ->
     fmap (Just . Text.unpack) $ getStrDescFirstLang deviceHandle i 1000
