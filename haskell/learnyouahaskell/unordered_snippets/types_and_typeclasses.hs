-- Based upon http://learnyouahaskell.com/types-and-typeclasses
-- December 11, 2010 - Elie De Brauwer <elie @ de-brauwer.be>

removeNonUppercase :: [Char] -> [Char]
removeNonUppercase st = [ c | c <-st, c `elem` ['A'..'Z']]

-- [Char] equals String
removeNonLowercase :: String -> String
removeNonLowercase st = [ c | c <-st, c `elem` ['a'..'z']]

addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

-- Integer is unbound.
factorial :: Integer -> Integer 
factorial x = product [1..x]