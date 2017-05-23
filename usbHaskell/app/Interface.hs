{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE
      DeriveGeneric
    , RecordWildCards
#-}

module Interface where

import Data.Aeson
import Data.ByteString (ByteString)
import Data.Vector
import Data.Word
import GHC.Generics
import qualified System.USB.Descriptors as Low
import System.USB.DeviceHandling
import System.USB.Enumeration

import Extra ()
import String

  
data Interface =
  Interface {
  number::Word8,
  altSetting::Word8,
  class'::Word8,
  subClass::Word8,
  protocol::Word8,
  strIx::(Maybe String),
  endpoints::(Vector Low.EndpointDesc),
  extra :: !ByteString
  } deriving (Show, Generic)

instance ToJSON Interface where


lowInterfaceToInterface::Device->Low.InterfaceDesc->IO Interface
lowInterfaceToInterface device Low.InterfaceDesc{..} = do
  h <- openDevice device
  s <- getString h interfaceStrIx
  return 
    Interface {
    number = interfaceNumber,
    altSetting = interfaceAltSetting,
    class' = interfaceClass,
    subClass = interfaceSubClass,
    protocol = interfaceProtocol,
    strIx = s,
    endpoints=interfaceEndpoints,
    extra = interfaceExtra
    }
