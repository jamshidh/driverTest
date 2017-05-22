{-# LANGUAGE
      LambdaCase
    , RecordWildCards
#-}

module String where

import Data.Word
import qualified Data.Text as Text
import qualified System.USB.Descriptors as Low
import System.USB.DeviceHandling
import System.USB.Enumeration
import System.USB.Initialization
import System.USB.IO


getString::DeviceHandle->Maybe Low.StrIx->IO (Maybe String)
getString deviceHandle = \case
  Nothing -> return Nothing
  Just i ->
     fmap (Just . Text.unpack) $ Low.getStrDescFirstLang deviceHandle i 1000
