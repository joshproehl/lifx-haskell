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
import qualified Control.Exception as Ex
import           Network.Lifx.Core


