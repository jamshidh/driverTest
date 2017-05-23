{-# LANGUAGE
      DeriveGeneric
    , RecordWildCards
#-}

module Config where

import Data.Aeson
import Data.ByteString (ByteString)
import Data.Traversable
import Data.Vector
import Data.Word
import GHC.Generics
import qualified System.USB.Descriptors as Low
import System.USB.DeviceHandling
import System.USB.Enumeration

import Extra ()
import Interface
import String

{-
data DeviceStatus =
  DeviceStatus {
  remoteWakeup::Bool,
  selfPowered::Bool
  } deriving (Generic)
-}

data Config =
  Config {
  value :: Word8,
  strIx::(Maybe String),
  attribs::Low.DeviceStatus,
  maxPower::Word8,
  interfaces::[[Interface]],
  extra::ByteString
  } deriving (Generic)

instance ToJSON Config where

getConfig::Device->Word8->IO Config
getConfig device number = do
  h <- openDevice device
  Low.ConfigDesc{..} <- Low.getConfigDesc device number
  s <- getString h configStrIx
  i <- 
    for (toList configInterfaces) $ \i ->
      for (toList i) $
        lowInterfaceToInterface device
  return
    Config {
      value = configValue,
      strIx = s,
      attribs = configAttribs,
      maxPower = configMaxPower,
      interfaces = i,
      extra = configExtra
      }

