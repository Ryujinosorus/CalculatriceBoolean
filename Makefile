all : BooleanCalc

BooleanCalc : lex.yy.c ytab.c 
	gcc -o BooleanCalc *.c

lex.yy.c : calc.l
	lex calc.l


ytab.c : calc.y 
	yacc calc.y 


clean :
	rm -rf *.c

mrproper : clean
	rm -rf BooleanCalc
zip : BooleanCalc
	zip BooleanCalc.zip *
	make mrproper
