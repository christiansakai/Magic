{-# LANGUAGE TypeOperators #-}

module Labels where

import Prelude hiding ((.), id)

import Control.Arrow (ArrowZero(..), ArrowChoice(..), arr, returnA)
import Control.Category (Category(..), (>>>))
import Control.Monad (MonadPlus)
import Control.Monad.State (MonadState)

import Data.Label (Lens(..))
import Data.Label.Abstract (lens)
import Data.Label.Maybe ((:~>))
import Data.Label.MaybeM (modify)
import Data.IntMap (IntMap, Key)
import qualified Data.IntMap as IntMap


ref :: (ArrowZero (~>), ArrowChoice (~>)) => Key -> Lens (~>) (IntMap a) a
ref key = lens ((zeroArrow ||| returnA) . arr g) (arr s)
  where
    g im = maybe (Left ()) Right (IntMap.lookup key im)
    s (el, im) = IntMap.insert key el im

(.^) :: Category (~>) => a ~> b -> b ~> c -> a ~> c
(.^) = (>>>)

(.~) :: (MonadState f m, MonadPlus m) => (f :~> a) -> (a -> a) -> m ()
(.~) = modify