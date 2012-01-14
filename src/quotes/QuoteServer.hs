import Control.Applicative
import Control.Monad
import System.IO
import System.Exit
import System.Environment
import qualified System.ZMQ3 as ZMQ
import qualified Data.ByteString.UTF8 as SB
import qualified Data.ByteString.Char8 as SB
import Codec.Binary.UTF8.String(encode)

-- | main program loop
main :: IO ()
main = do
    args <- getArgs
    when (length args /= 1) $ do
        hPutStrLn stderr "usage: prompt <address> <username>"
        exitFailure
    let addr = args !! 0
        name = SB.append (SB.fromString "test") (SB.fromString ": ")
    ZMQ.withContext 1 $ \c ->
        ZMQ.withSocket c ZMQ.Pub $ \s -> do
            ZMQ.bind s addr
            forever $ do
                line <- SB.fromString <$> getLine
                ZMQ.send s [] (SB.append name line)

