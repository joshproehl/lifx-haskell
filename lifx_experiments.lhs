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




> module Lifx where
> import Network
> import Network.Socket     (Socket, close)
> import System.IO
> import Control.Exception
> import System.Posix
> import Control.Concurrent


Set up some basic variables.

> port = PortNumber 56700
> peerPort = PortNumber 56750

> main :: IO ()
> main = withSocketsDo $ do
>           installHandler sigPIPE Ignore Nothing
>           bracket
>               (listenOn port)
>               (close)
>               (\s -> acceptConnection s logIt)

> logIt :: Handle -> IO ()
> logIt h = do
>            putStrLn "Got something..."
>            hPutStrLn h "Str" >> hFlush h >> hClose h


> acceptConnection :: Socket -> (Handle -> IO ()) -> IO ()
> acceptConnection socket handler = do
>         (h,_,_) <- accept socket
>         forkIO (handler h)
>         acceptConnection socket handler
