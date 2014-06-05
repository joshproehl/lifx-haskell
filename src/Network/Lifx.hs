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
import qualified Data.ByteString.Char8 as BC (pack, getLine, putStrLn)
import qualified Data.ByteString.Lazy  as BL (copy, toStrict, fromStrict)
import Control.Concurrent (threadDelay)




main = withSocketsDo $ do
        -- Set up the "request master bulb" packet
        let p = Packet 36 13312 ([0,0,0,0,0,0]::[Word8]) ([0,0,0,0,0,0]::[Word8]) 0 2 None

        putStrLn $ "Sending Packet: " ++ (show p)

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
        let site = getSite r
        putStrLn ("Site is: "++(show site))

        putStrLn ("Got message from "++(show addr)++": "++(show r))
        -- TODO: Loop until you get a packet_type of 3, or 
        --       time limit expires. THAT'S our target.

        sClose s


        -- Set up a TCP socket to the master bulb
        sock <- socket AF_INET Stream defaultProtocol
        connect sock addr

        -- Lets get the status of the bulb.
        let pp = Packet 36 13312 ([0,0,0,0,0,0]::[Word8]) site 0 101 None
        sendPacket sock pp


        --let powerOff = Packet 38 13312 ([0,0,0,0,0,0]::[Word8]) site 0 21 (SetPowerState 0)
        --sendPacket sock powerOff

        let powerOn = Packet 38 13312 ([0,0,0,0,0,0]::[Word8]) site 0 21 (SetPowerState 1)
        sendPacket sock powerOn

        let redFade = Packet 49 13312 ([0,0,0,0,0,0]::[Word8]) site 0 102 (SetLightColor 65535 65535 65535 3500 10000)
        sendPacket sock redFade

        putStrLn "sleeping"
        threadDelay 9000000
        putStrLn "done"

        let greenFade = Packet 49 13312 ([0,0,0,0,0,0]::[Word8]) site 0 102 (SetLightColor 21845 32767 65535 3500 10000)
        sendPacket sock greenFade

{-
        putStrLn "sleeping"
        threadDelay 11000000
        putStrLn "done"

        let powerOff = Packet 38 13312 ([0,0,0,0,0,0]::[Word8]) site 0 21 (SetPowerState 0)
        sendPacket sock powerOff
-}

        sClose sock
 
msgSender :: Socket -> [Word8] -> IO ()
msgSender sock site = do
  -- Set up the "request master bulb" packet
  let p = Packet 36 13312 ([0,0,0,0,0,0]::[Word8]) site 0 2 None
  let pp = Packet 36 13312 ([0,0,0,0,0,0]::[Word8]) site 0 101 None
  putStrLn $ "Sending to master bulb: "++(show pp)
  -- msg <- BC.getLine
  BS.sendAll sock (BL.toStrict (encode pp))
  --putStrLn "Waiting for response..."
  --
  --rMsg <- BS.recv sock 1024
  --let r = (decode (BL.fromStrict rMsg)) :: Packet
  --putStrLn $ "Got: " ++ (show r)
  --if msg == BC.pack "q" then putStrLn "Disconnected!" else msgSender sock
  --msgSender sock

sendPacket :: Socket -> Packet -> IO ()
sendPacket sock pkt = do
  BS.sendAll sock (BL.toStrict (encode pkt))
  --rMsg <- BS.recv sock 1024
  --let r = (decode (BL.fromStrict rMsg)) :: Packet
  --putStrLn $ "SendPacket Response: \n  " ++ (show r)
  --return (decode (BL.fromStrict rMsg)) ::Packet
  return ()
