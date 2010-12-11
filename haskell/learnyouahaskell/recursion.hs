-- Based upon http://learnyouahaskell.com/recursion
-- December 11, 2010  - Elie De Brauwer <elie @ de-brauwer.be>


maximum' :: (Ord a) => [a] -> a
maximum' [] = error "Maximum of empty list"
maximum' [x] = x 
maximum' (x:xs) 
  | x > maxval = x
  | otherwise  = maxval
  where maxval = maximum' xs
        
minimum' :: (Ord a) => [a] -> a
minimum' [] = error "Minimum of empty list"
minimum' [x] = x 
minimum' (x:xs) 
  | x <  minval = x
  | otherwise  = minval
  where minval = minimum' xs

-- Making use of max a b
maximum'' :: (Ord a) => [a] -> a
maximum'' [] = error "Maximum of empty list"
maximum'' [x] = x 
maximum'' (x:xs) = max x (maximum'' xs)

-- repeat a value a given number of time
replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x
   | n <= 0    = []
   | otherwise = x : replicate' (n-1) x
                 
-- take a number of items from a list
take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
   | n <= 0    = []
take' _ []     = []
take' n (x:xs) = x : take' (n-1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

-- A while(1), no edge condition
repeat' :: a -> [a]
repeat' x = x : repeat' x

-- zip [1,2,3] [1,2] creates [(1,1), (2,2)]
zip' :: [a] -> [b] -> [(a,b)]
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' a (x:xs) 
   | a == x    = True
   | otherwise =  elem' a xs
                  
-- Small items to the left, big items to he right, and concatenate with the 
-- pivot in the middle
qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x:xs) =
  let smaller = qsort [ a | a <- xs, a <= x]
      bigger  = qsort [ a | a <- xs, a > x]  
  in smaller ++ [x] ++ bigger 
  
