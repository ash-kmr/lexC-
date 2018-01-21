datatype 	(char)|(int)|(float)|(double)|(string)
line 	\n
valid_name	[a-z][a-z0-9]*[ ,;\t\n]
invalid_name [^a-z]+[a-z0-9]*[^a-z0-9;]+.*[ ;+,\t\n]
comment 		[/*].*[*/]
%s namecn
%{
	int com = 0;
	int dtype = 0;
	int line = 0;
%}
%%
{line} 		{printf("line %d\n", ++line);}
{comment} 		{com = 1;	printf("comment\n");}
{datatype}	{dtype = 1;printf("found datatype %s \n" ,yytext); BEGIN namecn;}
<namecn> {valid_name} 		{
							printf("valid %s text\n", yytext);
							}
<namecn> {invalid_name}		{
							printf("line %d syntax error\n", line);
							}
<>
. 	;
%%
int main(int argc, char* argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
}