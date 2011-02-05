all: helloworld getname palindromes reverse shortlines toupper

helloworld: helloworld.hs
	ghc -o $@ $^

getname: getname.hs
	ghc -o $@ $^

palindromes: palindromes.hs
	ghc -o $@ $^

reverse: reverse.hs
	ghc -o $@ $^

shortlines: shortlines.hs
	ghc -o $@ $^

toupper: toupper.hs
	ghc -o $@ $^

clean:
	rm -f `ls * | grep -v Makefile | grep -v .hs`