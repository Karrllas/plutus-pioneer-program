{-# LANGUAGE DataKinds         		#-}
{-# LANGUAGE NoImplicitPrelude 		#-}
{-# LANGUAGE TemplateHaskell 		#-}
{-# LANGUAGE ScopedTypeVariables	#-}
{-# LANGUAGE TypeApplications    	#-}
{-# LANGUAGE ImportQualifiedPost	#-}

module Onchain where

import PlutusTx qualified
import PlutusTx.Prelude
import Plutus.V2.Ledger.Api qualified as PlutusV2
import           Utilities            (wrap, writeValidatorToFile)
import           Prelude              (IO)


newtype MyCustomDatum = MyCustomDatum Integer
PlutusTx.unstableMakeIsData ''MyCustomDatum
newtype MyCustomRedeemer = MyCustomRedeemer Integer
PlutusTx.unstableMakeIsData ''MyCustomRedeemer

-- This validator always validates true
{-# INLINABLE mkValidator #-}
mkValidator :: MyCustomDatum -> MyCustomRedeemer -> PlutusV2.ScriptContext -> Bool
mkValidator _ _ _ = True

wrappedMkVal :: BuiltinData -> BuiltinData -> BuiltinData -> ()
wrappedMkVal = wrap mkValidator
{-# INLINABLE wrappedMkVal #-}

validator :: PlutusV2.Validator
validator = PlutusV2.mkValidatorScript
    $$(PlutusTx.compile [|| wrappedMkVal ||])

saveVal :: IO ()
saveVal = writeValidatorToFile "./assets/onchain.plutus" validator