all: helloworld getname

helloworld: helloworld.hs
	ghc -o $@ $^

getname: getname.hs
	ghc -o $@ $^

clean:
	rm -f `ls * | grep -v Makefile | grep -v .hs`