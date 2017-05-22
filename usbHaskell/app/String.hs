{-# LANGUAGE
      LambdaCase
    , RecordWildCards
#-}

module String where

import qualified Data.Text as Text
import qualified System.USB.Descriptors as Low
import System.USB.DeviceHandling


getString::DeviceHandle->Maybe Low.StrIx->IO (Maybe String)
getString deviceHandle = \case
  Nothing -> return Nothing
  Just i ->
     fmap (Just . Text.unpack) $ Low.getStrDescFirstLang deviceHandle i 1000
