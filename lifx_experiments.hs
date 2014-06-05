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



module Lifx where
--import Network
import Network.Socket --    (Socket, close)
import Lifx.Core
--import System.IO
--import Control.Exception
--import System.Posix
--import Control.Concurrent


-- Set up some basic variables.

--port = PortNumber 56700
--peerPort = PortNumber 56750

--main :: IO ()
main = withSocketsDo $ do
        -- Set up a UDP socket to listen for results
        -- (Listens on all interfaces.)
        s <- socket AF_INET Datagram defaultProtocol
        bindAddr <- inet_addr "0.0.0.0"
        setSocketOption s Broadcast 1
        bindSocket s (SockAddrInet 56700 bindAddr)
        sendTo s "Test" (SockAddrInet 56700 (-1))
        sClose s

        s <- socket AF_INET Datagram defaultProtocol
        bindAddr <- inet_addr "0.0.0.0"
        bindSocket s (SockAddrInet 56700 bindAddr)

        putStrLn "Waiting for master bulb response..."

        -- Get some message, max length 1000
        (msg, len, from) <- recvFrom s 1000

        putStrLn $ "Got message from "++(show from)
        putStrLn (show msg)

        sClose s
