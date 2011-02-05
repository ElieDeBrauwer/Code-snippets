-- Based upon http://learnyouahaskell.com/input-and-output
-- February 5, 2011 - Elie De Brauwer <elie @ de-brauwer.be>

main = interact respondPalindromes

respondPalindromes = unlines . map (\xs -> if isPalindrome xs then "palindrome" else "not a palindrome") . lines 
   where isPalindrome xs = xs == reverse xs