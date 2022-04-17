/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */

DARROW          =>
LE              <=
ASSIGN          <-
DIGIT           [0-9]
WHITESPACE		[ \n\f\r\t\v]
TYPEID          {[A-Z]}({[a-zA-Z]}|{DIGIT}|_)*
OBJECTID        {[a-z]}({[a-zA-Z]}|{DIGIT}|_)*

%%

 /*
  *  Nested comments
  */


 /*
  *  The multiple-character operators.
  */

{DARROW}		{ return (DARROW); }
{LE}			{ return (LE); }
{ASSIGN}		{ return (ASSIGN); }


 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */

[cC][lL][aA][sS][sS]	            { return (CLASS); }
[eE][lL][sS][eE]	                { return (ELSE); }
f[aA][lL][sS][eE]	                { cool_yylval.boolean=false; return (BOOL_CONST); }
[fF][iI]	                        { return (FI); }
[iI][fF]	                        { return (IF); }
[iI][nN]	                        { return (IN); }
[iI][nN][hH][eE][rR][iI][tT][sS]	{ return (INHERITS); }
[iI][sS][vV][oO][iI][dD]	        { return (ISVOID); }
[lL][eE][tT]	                    { return (LET); }
[lL][oO][oO][pP]	                { return (LOOP); }
[pP][oO][oO][lL]	                { return (POOL); }
[tT][hH][eE][nN]	                { return {THEN}; }
[wW][hH][iI][lL][eE]	            { return (WHILE); }
[cC][aA][sS][eE]	                { return (CASE); }
[eE][sS][aA][cC]	                { return (ESAC); }
[nN][eE][wW]	                    { return (NEW); }
[oO][fF]	                        { return (OF); }
[nN][oO][tT]	                    { return (NOT); }
t[rR][uU][eE]	                    { cool_yylval.boolean=true; return (BOOL_CONST); }


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */


{DIGIT}+    {
                cool_yylval.symbol=inttable.add_string(yytext);
                return (INT_CONST); // token from cool-parse.h yytokentype
            }



{WHITESPACE}          /* eat up whitespace */

.           printf("Unrecognized character: %s\n", yytext);


%%
