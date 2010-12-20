-- Based upon http://learnyouahaskell.com/making-our-own-types-and-typeclasses
-- December 20, 2010 - Elie De Brauwer <elie @ de-brauwer.be>


-- data defines a new data type
data Point = Point Float Float deriving (Show)
-- deriving from Show makes a type printable
data Shape = Circle Point Float | Rectangle Point Point deriving (Show)

surface :: Shape -> Float 
surface (Circle _ r) = pi * r ^ 2
surface (Rectangle (Point x1 y1) (Point x2 y2)) = (abs $ x2 - x1) * (abs $ y2 - y1)