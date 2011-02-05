-- Based upon http://learnyouahaskell.com/input-and-output
-- February 5, 2011 - Elie De Brauwer <elie @ de-brauwer.be>

main = interact shortLinesOnly
--main = do
--  contents <- getContents
--  putStr (shortLinesOnly contents)
  
shortLinesOnly :: String -> String
shortLinesOnly input = 
  let allLines = lines input
      shortLines = filter (\line -> length line < 10) allLines
      result = unlines shortLines
  in result
     
-- A really dense version which is functionally the same
--main = interact $ unlines . filter ((<10) . length) . lines