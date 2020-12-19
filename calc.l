%{
#include "y.tab.h"
extern int yyerror(char *);
%}
%%
"print"			{return print;}
"exit"			{return exit_command;}
[a-zA-Z]		{yylval.id = yytext[0]; return identifier;}
0|"false"			{yylval.num = 0; return number;}
1|"true"			{yylval.num = 1; return number;}
[ \t\n]			;
[=;^()]			{return yytext[0];}
"=>"           {return 'i';}
"<=>"         {return 'e';}
"&"|"and"   {return '&';}
"|"|"or"   {return '|';}
"!"|"not"   {return '!';}
.			{ECHO; yyerror("unexpected character");}

%%
int yywrap (void) {return 1;}
