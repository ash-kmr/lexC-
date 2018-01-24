datatype 	(char)|(int)|(float)|(double)|(string)
line 	\n
valid_name1	[a-z][a-z0-9]*[ ,;\t\n]
valid_name2		[a-z][a-z0-9]*[ ]*=[^;,\n]*[;,\n]
valid_name3		[a-z][a-z0-9_]*[ ]*[(].*[)][ ]*[{][ \t\n]
invalid_name1 	[a-z]+[a-z0-9]*[^a-z0-9;,"){""(){" ]+.*[ ;,\n]
invalid_name2	[^a-z \n].*[\ \t;,\n]
comment 		["/*"][.* \n]*["*/"]	
%s namefn
%s namecn
%x commentscope
%{
	int com = 0;
	int dtype = 0;
	int line = 1;
%}
%%
{comment} 		{com = 1;	printf("comment\n");}
{datatype}	{dtype = 1;printf("found datatype %s \n" ,yytext); BEGIN namecn;}
<namecn>{valid_name1}|{valid_name2} 		{
												if(com  == 1){
													printf("valid %s text\n", yytext);
												}else {
													printf("Comments required %d \n", line);
												}
												com = 0;
											}
<namecn>{valid_name3}						{
												if(com == 1){
													printf("valid function declaration %s line %d", yytext, line);
													com = 0;
												}else{
													printf("invalid function declaration %s line %d", yytext, line);
												}
											}
<namecn>{invalid_name1}|{invalid_name2}		{
											printf("line %d syntax error %s \n", line, yytext);
											}
{line}	 		{
				printf("line %d\n", line);
				line++;
				printf("line %d\n", line);
				BEGIN 0;
				}
. 	;
%%
int main(int argc, char* argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
}