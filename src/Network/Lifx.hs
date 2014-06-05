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

module Network.Lifx (

{-
  --  Basic data types
  MonadMPD, MPD, MPDError(..), ACKType(..), Response,
  Host, Port, Password,

  -- * Connections
  withMPD, withMPD_, withMPDEx,
  module Network.MPD.Commands,
#ifdef TEST
  getConnectionSettings, getEnvDefault
#endif
-}


  ) where


import           Prelude
-- import qualified Control.Exception as Ex
import           Network.Socket
import qualified Network.Socket.ByteString as BS
import           Network.Lifx.Core

-- TEMP:
import Network.Lifx.Core.Datatypes
import Data.Binary
import qualified Data.ByteString       as B
import qualified Data.ByteString.Char8 as BC (pack)
import qualified Data.ByteString.Lazy  as BL (copy, toStrict, fromStrict)



main = withSocketsDo $ do
        -- Set up the "request master bulb" packet
        let p = Packet 36 13312 (BC.pack "000000") (BC.pack "000000") 0 2 None

        -- Set up a UDP socket to listen for results
        -- (Listens on all interfaces.)
        s <- socket AF_INET Datagram defaultProtocol
        bindAddr <- inet_addr "0.0.0.0"
        setSocketOption s Broadcast 1
        bindSocket s (SockAddrInet 56700 bindAddr)
        connect s (SockAddrInet 56700 (-1))
        BS.sendAll s (BL.toStrict (encode p))
        sClose s

        s <- socket AF_INET Datagram defaultProtocol
        bindAddr <- inet_addr "0.0.0.0"
        bindSocket s (SockAddrInet 56700 bindAddr)

        putStrLn "Waiting for master bulb response..."

        -- Get some message, max length 1000
        -- (msg, len, from) <- recvFrom s 1000
        (msg, addr) <- BS.recvFrom s 1024
        let r = (decode (BL.fromStrict msg)) :: Packet

        putStrLn $ "Got message from "++(show addr)
        putStrLn (show r)
        -- TODO: Loop until you get a packet_type of 3, or 
        --       time limit expires. THAT'S our target.

        sClose s
