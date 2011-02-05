-- Based upon http://learnyouahaskell.com/input-and-output
-- February 5, 2011 - Elie De Brauwer <elie @ de-brauwer.be>

import Data.Char

main = do
  contents <- getContents
  putStr (map toUpper contents)