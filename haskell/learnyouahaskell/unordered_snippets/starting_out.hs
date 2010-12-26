-- Based upon http://learnyouahaskell.com/starting-out
-- December 10, 2010  - Elie De Brauwer <elie @ de-brauwer.be>

{- 
edb@lapedb:~$ ghci
GHCi, version 6.12.1: http://www.haskell.org/ghc/  :? for help
Loading package ghc-prim ... linking ... done.
Loading package integer-gmp ... linking ... done.
Loading package base ... linking ... done.
Prelude> :l intro.hs
[1 of 1] Compiling Main             ( intro.hs, interpreted )
Ok, modules loaded: Main.
*Main> doubleMe 2
4
*Main>
-}
doubleMe x = x + x 
doubleUs x y = x*2 + y*2
doubleUs2 x y = doubleMe x + doubleMe y
-- An if should always have an else.
doubleSmallNumber x = if x > 100
                      then x
                      else x*2
doubleSmallNumber' x = (if x > 100 then x else x*2) + 1
boomBang xs = [ if x < 10 then "small" else "big" | x <- xs, odd x]
removeNonUpperCase st = [ c | c <- st, c `elem` ['A'..'Z'] ]
rightTriangles = [ (a,b,c) | a <- [1..10], b<-[1..10], c<-[1..10], a^2+b^2==c^2]
