-- Based upon http://learnyouahaskell.com/making-our-own-types-and-typeclasses
-- December 20, 2010 - Elie De Brauwer <elie @ de-brauwer.be>


-- data defines a new data type
data Point = Point Float Float deriving (Show)
-- deriving from Show makes a type printable
data Shape = Circle Point Float | Rectangle Point Point deriving (Show)

surface :: Shape -> Float 
surface (Circle _ r) = pi * r ^ 2
surface (Rectangle (Point x1 y1) (Point x2 y2)) = (abs $ x2 - x1) * (abs $ y2 - y1)


data Person = Person String String Int Float String String deriving (Show)
firstName :: Person -> String
firstName (Person firstname _ _ _ _ _) = firstname

lastName :: Person -> String
lastName (Person _ lastname _ _ _ _) = lastname

age :: Person -> Int
age (Person _ _ age _ _ _) = age

height :: Person -> Float
height (Person _ _ _ height _ _) = height 

phoneNumber :: Person -> String
phoneNumber (Person _ _ _ _ number _) = number

flavor :: Person -> String
flavor (Person _ _ _ _ _ flavor) = flavor

-- There must be a better way, you say! Well no, there isn't, sorry.
-- Just kidding, there is. Commented out to avoid duplicates.
{-
data Person = Person { firstName :: String,
                       lastName :: String,
                       age :: Int,
                       height :: Float,
                       phoneNumber :: String,
                       flavor :: String
                     } deriving (Show)
                                    
-}
                         