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

import           Network.Socket
import qualified Network.Socket.ByteString as BS
import           Control.Monad.Reader -- (ReaderT(..), ask)
import           Control.Monad.State --(StateT, MonadIO(..))
import           System.IO (Handle, hPutStrLn)
import           Data.Binary
import qualified Data.ByteString       as B
import qualified Data.ByteString.Char8 as BC (pack, getLine, putStrLn)
import qualified Data.ByteString.Lazy  as BL (copy, toStrict, fromStrict)


newtype Lifx a = Lifx { runLifx :: StateT LifxState IO a }
                 deriving (Functor, Monad, MonadIO)

-- | The inner state. Contains the connection to the master bulb.
data LifxState = LifxState { controllerSock :: Socket
                           , controllerSite :: [Word8]
                           }



-- | Find the master bulb and get the connection to it set up.
{-
openLifx :: Lifx ()
openLifx = Lifx $ withSocketsDo $ do
          -- Set up the "request master bulb" packet
          let p = Packet 36 13312 ([0,0,0,0,0,0]::[Word8]) ([0,0,0,0,0,0]::[Word8]) 0 2 None

          -- Set up a UDP socket to listen for results
          -- (Listens on all interfaces.)
          s <- socket AF_INET Datagram defaultProtocol
          bindAddr <- inet_addr "0.0.0.0"
          setSocketOption s Broadcast 1
          bindSocket s (SockAddrInet 56700 bindAddr)
          connect s (SockAddrInet 56700 (-1))
          BS.sendAll s (BL.toStrict (encode p))

          -- Get the master bulb response. TODO: Should loop until it gets the right packet type...
          (msg, addr) <- BS.recvFrom s 1024
          let r = (decode (BL.fromStrict msg)) :: Packet
          let site = getSite r

          modify (\st -> st { controllerSock = s, controllerSite = site })

          return ()
-}
