{-# LANGUAGE
      RecordWildCards
#-}

module Config where

import Data.ByteString (ByteString)
import Data.Vector
import Data.Word
import qualified System.USB.Descriptors as Low
import System.USB.DeviceHandling
import System.USB.Enumeration
import System.USB.Initialization
import System.USB.IO

import String

data Config =
  Config {
  value :: !ConfigValue,
  strIx :: !(Maybe String),
  attribs :: !Low.ConfigAttribs,
  maxPower :: !Word8,
  interfaces :: !(Vector Low.Interface),
  extra :: !ByteString
  }

getConfig::Device->Word8->IO Config
getConfig device number = do
  h <- openDevice device
  Low.ConfigDesc{..} <- Low.getConfigDesc device number
  s <- getString h configStrIx
  return
    Config {
      value = configValue,
      strIx = s,
      attribs = configAttribs,
      maxPower = configMaxPower,
      interfaces = configInterfaces,
      extra = configExtra
      }

