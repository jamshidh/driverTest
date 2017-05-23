{-# LANGUAGE
      DeriveGeneric
    , RecordWildCards
#-}

module DeviceDesc where

import Data.Aeson
import Data.Traversable
import Data.Word
import GHC.Generics
import qualified System.USB.Descriptors as Low
import System.USB.DeviceHandling
import System.USB.Enumeration

import Config
import String

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
  configs::[Config]
  } deriving (Generic)

instance ToJSON DeviceDesc where

getDeviceDesc::Device->IO DeviceDesc
getDeviceDesc device = do
  Low.DeviceDesc{..} <- Low.getDeviceDesc device
  h <- openDevice device
  m <- getString h deviceManufacturerStrIx
  p <- getString h deviceProductStrIx
  s <- getString h deviceSerialNumberStrIx
  c <- for [0..deviceNumConfigs-1] $ Config.getConfig device
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
    configs=c
    }
  


