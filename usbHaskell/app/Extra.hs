{-# OPTIONS_GHC -fno-warn-orphans #-}

module Extra where

import Data.Aeson
import Data.ByteString (ByteString)
import qualified System.USB.Descriptors as Low

instance ToJSON ByteString where
  toJSON b = toJSON $ show b
  
instance ToJSON Low.DeviceStatus where
instance ToJSON Low.EndpointAddress where
instance ToJSON Low.EndpointDesc where
instance ToJSON Low.MaxPacketSize where
instance ToJSON Low.Synchronization where
instance ToJSON Low.TransactionOpportunities where
instance ToJSON Low.TransferDirection where
instance ToJSON Low.TransferType where
instance ToJSON Low.Usage where

