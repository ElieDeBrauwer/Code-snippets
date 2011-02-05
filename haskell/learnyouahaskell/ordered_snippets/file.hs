-- Based upon http://learnyouahaskell.com/input-and-output
-- February 5, 2011 - Elie De Brauwer <elie @ de-brauwer.be>

import System.IO

main = do
  handle <- openFile "file.hs" ReadMode
  contents <- hGetContents handle
  putStr contents
  hClose handle
  -- Same but in a oneliner
  withFile "file.hs" ReadMode (\handle -> do
      contents <- hGetContents handle                                  
      putStr contents)
    
  -- Without handles
  contents <- readFile "file.hs"
  putStr contents 
  