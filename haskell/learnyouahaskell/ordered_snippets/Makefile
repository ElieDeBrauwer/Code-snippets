all: helloworld getname reverse

helloworld: helloworld.hs
	ghc -o $@ $^

getname: getname.hs
	ghc -o $@ $^

reverse: reverse.hs
	ghc -o $@ $^

clean:
	rm -f `ls * | grep -v Makefile | grep -v .hs`