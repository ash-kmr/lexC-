datatype 	(char)|(int)|(float)|(double)|(string)
line 	\n
valid_name1	[a-z][a-z0-9]*[\ ,;\t\n]
valid_name2		[a-z][a-z0-9]*[\ ]*=*[^;,\n]*[\ ;,]?
valid_name3		[a-z][a-z0-9_]*[\ ]*[(].*[)][\ ]*[{][\ \t\n]+
invalid_name1 	[a-z]+[a-z0-9]*[^a-z0-9=;,"){""(){"\ ]+.*[\ ;,\n]
invalid_name2	[^a-z\ \n].*[\ \t;,\n]
comment 		"/*"
endcomment 		"*/"
%s namefn
%x namecn
%x commentscope
%{
	int com = 0;
	int dtype = 0;
	int line = 1;
%}
%%
{comment} 		{com = 1; BEGIN commentscope;}
{datatype}[ ]	{dtype = 1; BEGIN namecn;}
<namecn>{valid_name1}|{valid_name2} 		{
												if(com != 1){
													printf("Comments required before line %d \n", line);
												}
											}
<namecn>{valid_name3}						{
												if(com != 1){
													printf("invalid function declaration %s comments required before line %d", yytext, line);
													BEGIN 0;
												}
												line++;
												com = 0;
												BEGIN 0;

											}
<namecn>{invalid_name1}|{invalid_name2}		{
											printf("line %d declaration error %s \n", line, yytext);
											line++;
											BEGIN 0;
											}
<commentscope>{line} 		{
								line++;
							}
<commentscope>{endcomment}	{	
								BEGIN 0;
							}
<commentscope>.				;

<namecn>{line}		{
					BEGIN 0;
					com = 0;
					line++;
					}

{line}	 		{
				line++;
				BEGIN 0;
				}
. 	;
%%
int main(int argc, char* argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
}