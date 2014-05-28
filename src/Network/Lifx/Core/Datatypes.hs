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
       size               :: Int16 -- TODO: All data types here need to be checked
     , protocol           :: Int16
     , reserved1          :: Int32
     , target_mac_address :: 
     , reserved2          :: Int16
     , site               :: 
     , reserved3          :: Int16
     , timestamp          :: Int64
     , packet_type        :: Int16
     , reserved4          :: Int16
     , payload            :: Payload
} -- deriving...



{-
Each packet has a specific payload type, which can be identified by it's
packet_type value.
-}
data Payload = 
