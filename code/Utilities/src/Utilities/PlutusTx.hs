<<<<<<< HEAD
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE RankNTypes        #-}

module Utilities.PlutusTx
  ( wrap
  ) where

import           Plutus.V2.Ledger.Api (UnsafeFromData, unsafeFromBuiltinData)
import           PlutusTx.Prelude     (Bool, BuiltinData, check, ($))

{-# INLINABLE wrap #-}
wrap ::
  forall a b c.
  ( UnsafeFromData a,
    UnsafeFromData b,
    UnsafeFromData c
  ) =>
  (a -> b -> c -> Bool) ->
  BuiltinData ->
  BuiltinData ->
  BuiltinData ->
  ()
wrap f a b c =
  check $ f
      (unsafeFromBuiltinData a)
      (unsafeFromBuiltinData b)
      (unsafeFromBuiltinData c)
=======
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE RankNTypes        #-}

module Utilities.PlutusTx
  ( wrap
  ) where

import           Plutus.V2.Ledger.Api (ScriptContext, UnsafeFromData,
                                       unsafeFromBuiltinData)
import           PlutusTx.Prelude     (Bool, BuiltinData, check, ($))

{-# INLINABLE wrap #-}
wrap :: forall a b.
        ( UnsafeFromData a
        , UnsafeFromData b
        )
      => (a -> b -> ScriptContext -> Bool)
      -> (BuiltinData -> BuiltinData -> BuiltinData -> ())
wrap f a b ctx =
  check $ f
      (unsafeFromBuiltinData a)
      (unsafeFromBuiltinData b)
      (unsafeFromBuiltinData ctx)
>>>>>>> 22dac91e3821cc9cf356bdb0c89201175c73337c
