%{
void yyerror (char *s);
#include <stdio.h> 	/* declarations utilises dans les actions */
#include <ctype.h>
#include <stdlib.h>
int symbols[52];
int symbolVal(char symbol);
char* toS(int b);
int change(int i);
void updateSymbolVal(char symbol, int val);
extern int yylex();
%}

%union {int num; char id;} /* definitions Yacc */
%start line
%token print
%left '|' 'e' 'i' '^'
%left '&'
%left '!'
%token exit_command
%token <num> number
%token <id> identifier 
%type <num> line exp term
%type <id> assignment

%%
/* description de la grammaire 		actions en C */

line	: assignment ';'	{;}
	| exit_command ';'	{exit(EXIT_SUCCESS);}
	| print exp ';'		{printf("Printing \"%s\" \n", toS($2));}
	| line assignment ';'	{;}
	| line print exp ';'	{printf("Printing \"%s\"\n", toS($3));}
	| line exit_command ';' {exit(EXIT_SUCCESS);}
	;

assignment : identifier '=' exp {updateSymbolVal($1, $3);}
	     ;

exp	: term		{$$ = $1;}
	| '!' exp 		{$$ = change($2);}
	| exp '&' exp	{$$ = $1 & $3;}
	| exp '|' exp	{$$ = $1 || $3;}
	| exp 'i' exp	{$$ = !$1 || $3 ;}
	| exp 'e' exp	{$$ = ($1 == $3) ;}
	| exp '^' exp	{$$ = (($1 && !$3) || ($3 && !$1)) ;}
	| '(' exp ')'	{$$ = $2;}
	;
term	: number 			{$$ = $1;}
	| identifier	{$$ = symbolVal($1);}
	;

%% 	/* C code */ 

int computeSymbolIndex(char token)
{
	int idx = -1;
	if (islower(token)) {
		idx = token - 'a' + 26;
	} else if (isupper(token)){
		idx = token - 'A';
	}
	return idx;
}

/* retourne la valeur d'un symbole donnee */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

char* toS(int b){
	if(b)
		return "Vrai";
	return "Faux";
}
int change(int i){
	if(i)
		return 0;
	return 1;
}
/* mise a jour de la valeur d'un symbole donnee */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main(void)
{
	/* initialisation de la table des symboles */
	int i;
	for (i=0; i<52; i++){
		symbols[i] = 0;
	}
	return yyparse();
}

void yyerror(char * s) {fprintf(stderr, "%s\n", s);}

