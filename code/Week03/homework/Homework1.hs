{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeApplications  #-}
{-# LANGUAGE TypeFamilies      #-}

module Homework1 where

import           Plutus.V2.Ledger.Api (BuiltinData, POSIXTime, PubKeyHash,
                                       ScriptContext (scriptContextTxInfo), Validator,
                                       mkValidatorScript, TxInfo (txInfoValidRange), from, to)
import           PlutusTx             (compile, unstableMakeIsData)
import           Plutus.V2.Ledger.Contexts (txSignedBy)
import           PlutusTx.Prelude     (Bool (..), traceIfFalse, ($), (&&), (||), not)
import           Plutus.V1.Ledger.Interval (contains, after, before)
import           Utilities            (wrap)

---------------------------------------------------------------------------------------------------
----------------------------------- ON-CHAIN / VALIDATOR ------------------------------------------

data VestingDatum = VestingDatum
    { beneficiary1 :: PubKeyHash
    , beneficiary2 :: PubKeyHash
    , deadline     :: POSIXTime
    }

unstableMakeIsData ''VestingDatum

{-# INLINABLE mkVestingValidator #-}
-- This should validate if either beneficiary1 has signed the transaction and the current slot is before or at the deadline
-- or if beneficiary2 has signed the transaction and the deadline has passed.
mkVestingValidator :: VestingDatum -> () -> ScriptContext -> Bool
mkVestingValidator dat () ctx = (traceIfFalse "benef" signedbyben2 && traceIfFalse "deadline" deadline2 )|| 
                                (traceIfFalse "benef" signedbyben1 &&  traceIfFalse "deadline" deadlinegood)
    where 
        info :: TxInfo
        info = scriptContextTxInfo ctx

        signedbyben1 = txSignedBy info $ beneficiary1 dat
        signedbyben2 = txSignedBy info $ beneficiary2 dat

        deadlinegood = contains (to $ deadline dat ) $ txInfoValidRange info
        deadline2 = before (deadline dat) $ txInfoValidRange info

{-# INLINABLE  mkWrappedVestingValidator #-}
mkWrappedVestingValidator :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mkWrappedVestingValidator = wrap mkVestingValidator

validator :: Validator
validator = mkValidatorScript $$(compile [|| mkWrappedVestingValidator ||])
