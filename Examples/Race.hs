{-|
Module      : Examples.Race
Description : 
Copyright   : (c) Alexander Vieth, 2016
Licence     : BSD3
Maintainer  : aovieth@gmail.com
Stability   : experimental
Portability : non-portable (GHC only)

Example of very simple concurrency. Two events are raced, so that the value of
the first one to occur (left-biased in case of simultaneity) is given.
This is expressed by the Alternative combinator (<|>).
Different biasing can be expressed via unionEvents.

-}

import Control.Applicative ((<|>))
import Control.Concurrent
import Control.Monad.Embedding
import Reactive.Frappe

main = do

  let networkDescription = do
        evTrue <- async $ threadDelay 500000 >> pure True
        evFalse <- async $ threadDelay 1000000 >> pure False
        pure (evTrue <|> evFalse)

  network <- reactimate embedding networkDescription
  outcome <- runNetwork network (\_ -> pure ()) pure

  -- The network delivers a Bool when it's done. Let's print it.
  print outcome

  where

  embedding = embedIdentity