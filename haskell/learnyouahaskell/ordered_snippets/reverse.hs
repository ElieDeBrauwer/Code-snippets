-- Based upon http://learnyouahaskell.com/input-and-output
-- December 26, 2010 - Elie De Brauwer <elie @ de-brauwer.be>

{- Reads a line from input, print the line with the words reversed
   stop when reading a blank line. -}
main = do 
  line <- getLine
  if null line
     then return ()
     else do
          putStrLn $ reverseWords line
          main
          
reverseWords :: String -> String
reverseWords = unwords . map reverse . words