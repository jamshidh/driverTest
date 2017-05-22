{-# LANGUAGE
      LambdaCase
    , RecordWildCards
#-}

module DeviceDesc where

import Data.Word
import qualified Data.Text as Text
import qualified System.USB.Descriptors as Low
import System.USB.DeviceHandling
import System.USB.Enumeration
import System.USB.Initialization
import System.USB.IO

data DeviceDesc =
  DeviceDesc {
  usbSpecReleaseNumber :: !Low.ReleaseNumber,
  class':: !Word8,
  subClass :: !Word8,
  protocol :: !Word8,
  maxPacketSize0 :: !Word8,
  vendorId :: !Low.VendorId,	
  productId :: !Low.ProductId,	
  releaseNumber :: !Low.ReleaseNumber,
  manufacturer :: !(Maybe String),
  product :: !(Maybe String),
  serialNumber :: !(Maybe String),
  numConfigs :: !Word8
  }


getDeviceDesc::Device->IO DeviceDesc
getDeviceDesc device = do
  Low.DeviceDesc{..} <- Low.getDeviceDesc device
  h <- openDevice device
  m <- getString h deviceManufacturerStrIx
  p <- getString h deviceProductStrIx
  s <- getString h deviceSerialNumberStrIx
  return
    DeviceDesc {
    usbSpecReleaseNumber=deviceUSBSpecReleaseNumber,
    class'=deviceClass,
    subClass=deviceSubClass,
    protocol=deviceProtocol,
    maxPacketSize0=deviceMaxPacketSize0,
    vendorId=deviceVendorId,	
    productId=deviceProductId,	
    releaseNumber=deviceReleaseNumber,
    manufacturer = m,
    product = p,
    serialNumber = s,
    numConfigs = deviceNumConfigs
    }
  


getString::DeviceHandle->Maybe Low.StrIx->IO (Maybe String)
getString deviceHandle = \case
  Nothing -> return Nothing
  Just i ->
     fmap (Just . Text.unpack) $ Low.getStrDescFirstLang deviceHandle i 1000
