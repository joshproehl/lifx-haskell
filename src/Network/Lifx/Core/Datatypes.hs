{- LANGUAGE DeriveGeneric #-}

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

module Network.Lifx.Core.Datatypes where

import Data.Int
import qualified Data.ByteString       as B
import qualified Data.ByteString.Char8 as BC
import Data.Binary
import Data.Binary.Put
import Data.Binary.Get
import GHC.Generics (Generic)


{-
A packet has a number of number of fields that exist in every packet, and
a payload which varies per packet type.
Per https://github.com/magicmonkey/lifxjs/blob/master/Protocol.md, the
packet structure is:
packet
{
  uint16 size;              // LE
  uint16 protocol;
  uint32 reserved1;         // Always 0x0000
  byte   target_mac_address[6];
  uint16 reserved2;         // Always 0x00
  byte   site[6];           // MAC address of gateway PAN controller bulb
  uint16 reserved3;         // Always 0x00
  uint64 timestamp;
  uint16 packet_type;       // LE
  uint16 reserved4;         // Always 0x0000

  varies payload;           // Documented below per packet type
}
-}
data Packet = Packet {
       size               :: Word16
     , protocol           :: Word16
     --, reserved1          :: Int32
     , target_mac_address :: B.ByteString
     --, reserved2          :: Int16
     , site               :: B.ByteString
     --, reserved3          :: Int16
     , timestamp          :: Word64
     , packet_type        :: Word16
     --, reserved4          :: Int16
     , payload            :: Payload
} deriving (Show)


-- Make it possible to encode/decode Packets from binary format.
instance Binary Packet where
  put (Packet s p tma st ts pt pl) = do
      putWord16le s
      putWord16le p
      putWord32be 0
      --BEGIN 6-byte block which should be mac_addr
      --put         tma
      putWord32be 0
      putWord16be 0
      -- END 6-byte
      putWord16be 0
      -- BEGIN 6-byte block which should be "site"
      --put         st
      putWord32be 0
      putWord16be 0
      --END 6-byte
      putWord16be 0
      putWord64be ts
      putWord16le pt
      putWord16be 0
      put pl

  get = do
          s <- getWord16le
          p <- getWord16le
          getWord32be

          -- 6-byte block which should be mac_addr
          --getWord32be
          --getWord16be
          tma <- getByteString 6

          getWord16be

          -- 6-byte block which should be "site"
          --getWord32be
          --getWord16be
          st <- getByteString 6

          getWord16be
          ts <- getWord64be
          pt <- getWord16le

          getWord16be

          pl <- get

          return (Packet s p tma st ts pt pl)




{-
Each packet has a specific payload type, which can be identified by it's
packet_type value.
-}
data Payload = None
      deriving (Show)

instance Binary Payload where
  put None = do
      return ()

  get = do
      return None

{-
 getTrades :: Get [Trade]
 getTrades = do
   empty <- isEmpty
   if empty
     then return []
     else do trade <- getTrade
             trades <- getTrades
             return (trade:trades)
-}
