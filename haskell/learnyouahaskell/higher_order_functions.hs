-- Based upon http://learnyouahaskell.com/higher-order-functions
-- December 11, 2010 - Elie De Brauwer <elie @ de-brauwer.be>

-- 'regular' function
compareWithHundred :: (Num a, Ord a) => a -> Ordering
compareWithHundred x = compare 100 x 
-- This one returns a function, but is equivalent in use
compareWithHundred' :: (Num a, Ord a) => a -> Ordering
compareWithHundred' = compare 100 

-- Takes a function and applies it twice
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f ( f x )

-- Zipwith' zips two lists by applying a function (zipWith' (-) [1,2,3,4] [1,1,1,1] )
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

-- Swap arguments flip' (-) 5 1 return -4  
flip' :: (a -> b -> c) -> (b -> a -> c)
flip' f x y = f y x

-- Apply a function on all arguments e.g. map' (*2) [1,2,3,4] gives [2,4,6,8]
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map' f xs

-- Apply a predicate e.g. filter' (>5) [1..10] gives [6,7,8,9,10]
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
   | p x       = x : filter p xs
   | otherwise = filter p xs
                 
-- Another quicksort, now with the filter
quicksort2 :: (Ord a) => [a] -> [a]
quicksort2 [] = []
quicksort2 (x:xs) =
  let smaller = quicksort2 (filter (<=x) xs)
      bigger  = quicksort2 (filter (>x) xs)
  in smaller ++ [x] ++ bigger
     
-- Largest value smaller than 100000 and divisible by 3829     
largestDivisible :: (Integral a) => a
largestDivisible = head ( filter p [100000,99999..])
  where p x = x `mod` 3829 == 0
        
-- Collatz sequence (n=3n+1 n=n/2 for odd en even value)
chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain n
   | even n = n:chain (n `div` 2)
   | odd n  = n:chain (n*3 + 1)
        
-- Get the number of Collatz sequences of size larger than 15
numLongChains :: Int
numLongChains = length (filter isLong (map chain [1..1000]))
   where isLong xs = length xs > 15
         
-- The same as the above but now with a Lambda
numLongChains' :: Int          
numLongChains' = length (filter (\xs -> length xs > 15) (map chain [1..100]))

-- Foldl replaces the x:xs pattern and reduces a list to a single value (foldl = left fold)
sum' :: (Num a) => [a] -> a
sum' xs = foldl (\acc x -> acc +x) 0 xs

-- This is equivalent with the following, but curried
sum'' :: (Num a) => [a] -> a
sum'' = foldl (+) 0

-- foldl lambda takes the accumulator as the first param and the value as the second
elem' :: (Eq a) => a -> [a] -> Bool
elem' y ys = foldl (\acc x -> if x == y then True else acc) False ys

-- Standard functions using folds
maximum' :: (Ord a) => [a] -> a
maximum' = foldr1 (\x acc -> if x > acc then x else acc)

reverse' :: [a] -> [a]
reverse' = foldl (\acc x -> x : acc) [] 

product' :: (Num a) => [a] -> a
product' = foldr1 (*)

filter'' :: ( a -> Bool) -> [a] -> [a]
filter'' p = foldr (\x acc -> if p x then  x :acc else acc) []

head' :: [a] -> a
head' = foldr1 (\x _ -> x)

last' :: [a] -> a
last' = foldl1 (\_ x -> x)

