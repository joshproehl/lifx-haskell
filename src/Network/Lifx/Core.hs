{-# LANGUAGE GeneralizedNewtypeDeriving #-}

{-
Network.Lifx - A Library to interact with Lifx light bulbs. (lifx.co)
Copyright (C) 2014  Josh Proehl <josh@daedalusdreams.com>

***************************************************************************
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
***************************************************************************


-}



module Network.Lifx.Core (
  Lifx
  ) where

import           Network.Lifx.Core.Datatypes

import           Control.Monad.Reader (ReaderT(..), ask)
import           Control.Monad.State (StateT, MonadIO(..))
import           System.IO (Handle, hPutStrLn)


newtype Lifx a = Lifx { runLifx :: StateT LifxState IO a }
                 deriving (Functor, Monad, MonadIO)

-- | The inner state. Contains the connection to the master bulb.
data LifxState = LifxState { controllerH :: Maybe Handle }



-- | Find the master bulb and get the connection to it set up.
-- openLifx :: Lifx ()
-- openLifx :: Lifx $ do
