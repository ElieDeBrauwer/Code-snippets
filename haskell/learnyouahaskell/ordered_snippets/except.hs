-- Based upon http://learnyouahaskell.com/input-and-output
-- February 5, 2011 - Elie De Brauwer <elie @ de-brauwer.be>

import System.Environment
import System.IO
import System.IO.Error

main = toTry `catch` handler

toTry :: IO()
toTry = do (fileName:_) <- getArgs
           contents <- readFile fileName
           putStrLn $ "the file has " ++ show (length (lines contents)) ++ " lines!"
           
handler :: IOError -> IO()
handler e 
  | isDoesNotExistError e = putStrLn "File does not exist"
  | otherwise = ioError e
  
