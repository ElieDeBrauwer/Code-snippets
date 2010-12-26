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
                         
                                   
{- After deriving from Eq two persons can be compared  with ==, 
   deriving from show makes it printable, read makes it readable from  
   a string. -}
data Person' = Person' { fName :: String,
                         lName :: String
                         } deriving (Eq, Show)
                                    
{- Here False' < True' -}
data OrderedBool = False' | True' deriving (Eq, Ord)

{-
read: read "Saturday" :: Day
bounded allows us to get the min/max: minBound :: Day
enum allows us to get successor and predecessor: pred Tuesday or succ Tuesday
or even [Monday..Sunday]
-}
data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
           deriving (Eq, Ord, Show, Read, Bounded, Enum)
                    

{- Typedefs -}
type Name = String 
type PhoneNumber = String
type PhoneBook = [(Name, PhoneNumber)]


{- A binary search tree is an empty tree or a value and two other trees -}
data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

{- Creata a tree with one element -}
singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

{- Insert an elment into a tree -}
treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node a left right) 
  | x == a = Node x left right
  | x < a  = Node a (treeInsert x left) right
  | x > a  = Node a left (treeInsert x right)
             
{- Binary tree lookup -}
treeElem :: (Ord a) => a -> Tree a -> Bool
treeElem x EmptyTree = False
treeElem x (Node a left right)
  | x == a = True
  | x < a  = treeElem x left
  | x > a  = treeElem x right
             
{-
*Main> let nums = [1,6,7,9,4,5,8,3]
*Main> let numsTree = foldr treeInsert EmptyTree nums
*Main> numsTree
Node 3 (Node 1 EmptyTree EmptyTree) (Node 8 (Node 5 (Node 4 EmptyTree EmptyTree) (Node 7 (Node 6 EmptyTree EmptyTree) EmptyTree)) (Node 9 EmptyTree EmptyTree))
-}

data TrafficLight = Red | Yellow | Green
  
{- Instance if for making our types intances of typeclasses -}
instance Eq TrafficLight where
  Red == Red = True
  Green == Green = True
  Yellow == Yellow = True
  _ == _ = False 
  
instance Show TrafficLight where 
  show Red = "Red light"
  show Yellow = "Yellow light"
  show Green = "Green light"
  
  
{- Class declaration -}
class YesNo a where 
  yesno :: a -> Bool
  
{- Instance of YesNo for integers -}
instance YesNo Int where
  yesno 0 = False
  yesno _ = True

{- And for lists ... -}
instance YesNo [a] where
  yesno [] = False
  yesno _  = True

{- Bool is trivial, but id used is a function which returns its parameter -}
instance YesNo Bool where
  yesno = id 
  
instance YesNo (Maybe a) where
  yesno (Just _) = True
  yesno Nothing = False
  
instance YesNo (Tree a) where
  yesno EmptyTree = False
  yesno _ = True
  
instance YesNo TrafficLight where
  yesno Red = False
  yesno _ = True
  
{- Mimic an if which works with YesNo's -}
yesnoIf :: (YesNo y) => y -> a -> a -> a
yesnoIf yesnoVal yesResult noResult = if yesno yesnoVal then yesResult else noResult


class Functor f where
  fmap :: (a -> b) -> f a -> f b
  
instance Main.Functor [] where
  fmap = map
  
instance Main.Functor Maybe where
  fmap f (Just x) = Just (f x)
  fmap f Nothing = Nothing
  

instance Main.Functor Tree where
  fmap f EmptyTree = EmptyTree
  fmap f (Node x leftsub rightsub) = Node (f x) (Main.fmap f leftsub) (Main.fmap f rightsub)
  
