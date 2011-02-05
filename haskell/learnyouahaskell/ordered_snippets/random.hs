-- Based upon http://learnyouahaskell.com/input-and-output
-- February 5, 2011 - Elie De Brauwer <elie @ de-brauwer.be>

import Data.List 
import Random 

main = do
  mapM print (take 5 $ randoms (mkStdGen 10) :: [Int])
  mapM print (take 5 $ randoms (mkStdGen 10) :: [Bool])
  -- Dice roll
  mapM print (take 5 $ randomRs (1,6) (mkStdGen 10) :: [Int] )
  -- Without seeding
  gen <- getStdGen
  putStr $ take 20 (randomRs ('A','z') gen)
  