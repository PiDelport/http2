module Network.HTTP2.Arch.File where

import System.IO

import Network.HTTP2.Arch.Object

-- | Position read based on 'Handle'.
defaultPositionReadMaker :: PositionReadMaker
defaultPositionReadMaker file = do
    hdl <- openBinaryFile file ReadMode
    return (pread hdl, Closer $ hClose hdl)
  where
    pread :: Handle -> PositionRead
    pread hdl off bytes buf = do
        hSeek hdl AbsoluteSeek $ fromIntegral off
        fromIntegral <$> (hGetBufSome hdl buf $ fromIntegral bytes)