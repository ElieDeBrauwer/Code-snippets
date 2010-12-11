-- Based upon http://learnyouahaskell.com/syntax-in-functions
-- December 11, 2010  - Elie De Brauwer <elie @ de-brauwer.be>

-- Integral means both Int and Integer are allowed
lucky :: (Integral a) => a -> String
lucky 7 = "Lucky number seven!"
lucky 7777777777777777777777777777777 = "Very lucky number seven!"
lucky x = "No luck :("

-- Filters are executed in this order
sayMe :: (Integral a) => a -> String
sayMe 1 = "One"
sayMe 2 = "Two"
sayMe 3 = "Three"
sayMe x = "No between one and three"

-- Recursion
factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- fst and snd get the first and second element of a pair
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors a b = (fst a + fst b, snd a + snd b)

-- Without the fst and snd
addVectors2 :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors2 (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- _ is a don't care
third :: (a, b, c) -> c 
third (_, _, c) = c 

-- x:xs splits a list in its head (x) and a remainder (xs)
head' :: [a] -> a
head' [] = error "Can't call head on an empty list"
head' (x:_) = x

-- Switch case alternative
head'' :: [a] -> a 
head'' xs = case xs of []   -> error "No head for empty lists"
                       (x:_) -> x
                       
-- Show = things which can be represented as strings
tell :: (Show a) => [a] -> String
tell [] = "The list is empty"
tell (x:[]) = "The list has one element: " ++ show x
tell (x:y:[]) = "The list has two elements: " ++ show x ++ " and " ++ show y
tell (x:y:_) = "The list is long, the first two elements are " ++ show x ++ " and " ++ show y

length' :: (Num b) => [a] -> b
length' [] = 0
length' (_:xs) = 1 + length' xs

sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

-- Pattern, break up but keep a reference to the whole
first_letter :: String -> String
first_letter all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]

-- Guards are indicated with a |  and return a Bool
bmiTell :: (RealFloat a) => a -> String
bmiTell bmi
  | bmi <= 18.5 = "Under"
  | bmi <= 25.0 = "Normal"
  | bmi <= 30.0 = "Over"
  | otherwise   = "Muchos over"
                  
-- With inline calculations
bmiTell' :: (RealFloat a) => a -> a -> String
bmiTell' weight height
  | weight / height ^ 2 <= 18.5 = "Under"
  | weight / height ^ 2 <= 25.0 = "Normal"
  | weight / height ^ 2 <= 30.0 = "Over"
  | otherwise                   = "Muchos over"
                  
-- Using where 
bmiTell'' :: (RealFloat a) => a -> a -> String
bmiTell'' weight height
  | bmi <= skinny = "Under"
  | bmi <= normal = "Normal"
  | bmi <= fat    = "Over"
  | otherwise     = "Muchos over"
  where bmi = weight / height ^ 2 
        (skinny, normal, fat) = (18.5, 25.0, 30.0)
                                  
-- Guards can also be inlined,  but we don't want to go that way.
max' :: (Ord a) => a -> a -> a
max' a b 
  | a > b     = a
  | otherwise = b
                
-- Compare, returns an ordering but with an infix function.
compare' :: (Ord a) => a -> a -> Ordering
a `compare'` b
  | a > b     = GT
  | a < b     = LT
  | otherwise = EQ
                
-- Where without guards
initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
   where (f:_) = firstname
         (l:_) = lastname
         
-- Where-cylinder, where are syntactic constructs
cylinder :: (RealFloat a) => a -> a -> a 
cylinder r h = side + 2 * top 
   where side = 2 * pi * r * h
         top  = pi * r ^ 2 

-- Let-cylinder, let are expressions
cylinder' :: (RealFloat a) => a -> a -> a
cylinder' r h =
  let side = 2 * pi * r * h
      top  = pi * r ^ 2 
  in side + 2 * top
     

                       