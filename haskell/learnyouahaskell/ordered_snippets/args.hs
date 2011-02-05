-- Based upon http://learnyouahaskell.com/input-and-output
-- February 5, 2011 - Elie De Brauwer <elie @ de-brauwer.be>

import System.Environment
import Data.List 

main = do
  args <- getArgs
  progName <- getProgName
  putStrLn "The Program name is:"
  putStrLn progName
  putStrLn "The arguments are:"
  mapM putStrLn args
  