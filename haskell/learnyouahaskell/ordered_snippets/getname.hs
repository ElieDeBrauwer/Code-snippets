-- Based upon http://learnyouahaskell.com/input-and-output
-- December 26, 2010 - Elie De Brauwer <elie @ de-brauwer.be>

import Data.Char

main = do
  putStrLn "What's your first name?"
  firstName <- getLine
  putStrLn "What's your last name?"
  lastName <- getLine
  let bigFirstName = map toUpper firstName
      bigLastName = map toUpper lastName
  putStrLn $ "hey " ++ bigFirstName ++ " " ++ bigLastName
  