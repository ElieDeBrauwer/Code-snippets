all: args except file helloworld getname palindromes random reverse shortlines toupper

args: args.hs
	ghc -o $@ $^ 

except: except.hs
	ghc -o $@ $^ 

file: file.hs
	ghc -o $@ $^

helloworld: helloworld.hs
	ghc -o $@ $^

getname: getname.hs
	ghc -o $@ $^

palindromes: palindromes.hs
	ghc -o $@ $^

random: random.hs
	ghc -o $@ $^ 

reverse: reverse.hs
	ghc -o $@ $^

shortlines: shortlines.hs
	ghc -o $@ $^

toupper: toupper.hs
	ghc -o $@ $^

clean:
	rm -f `ls * | grep -v Makefile | grep -v .hs`