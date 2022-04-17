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

extern int curr_lineno; // line number
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

// Counter for nested comments
int nested_comment_counter=0;

// Handle String too long error
void add_char(char c);
int error_occurred();

%}

/*
 * Define names for regular expressions here.
 */

DARROW          =>
LE              <=
ASSIGN          <-
DIGIT           [0-9]
WHITESPACE		[ \n\f\r\t\v]
TYPEID          [A-Z]([a-zA-Z]|{DIGIT}|_)*
OBJECTID        [a-z]([a-zA-Z]|{DIGIT}|_)*
CHARS           [-+*/~<=(){};:,.@]

%x COMMENT STRING STR_ERROR

%%

 /*
  *  Nested comments
  */

--.*		/* eat up one-line comments */

"*)"	{
		    cool_yylval.error_msg="Unmatched *)";
		    return (ERROR);
		}

"(*"	{
		    BEGIN(COMMENT);	// Begin condition COMMENT
		    nested_comment_counter=1;
		}

<COMMENT>"(*"	{
				    nested_comment_counter++;
				}

<COMMENT>"*)"	{
				    nested_comment_counter--;
				    if(!nested_comment_counter)
				         /*	  Equivalent to BEGIN(0): returns to the original state
                          *   where only the  rules with no start conditions are active.
                          */
					    BEGIN(INITIAL);
				}

<COMMENT>\n		curr_lineno++;

<COMMENT>.		/* eat up everything inside of comment */

<COMMENT><<EOF>>	{
					    BEGIN(INITIAL);
					    cool_yylval.error_msg="EOF in comment";
					    return (ERROR);
					}

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
  * Integer constants.
  */
{DIGIT}+    {
                cool_yylval.symbol=inttable.add_string(yytext);
                return (INT_CONST); // token from cool-parse.h yytokentype
            }

 /*
  *  TypeID and ObjectID.
  */

{TYPEID}	{
			    cool_yylval.symbol=idtable.add_string(yytext);
			    return (TYPEID);
			}

{OBJECTID}	{
			    cool_yylval.symbol=idtable.add_string(yytext);
			    return (OBJECTID);
			}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for
  *  \n \t \b \f, the result is c.
  *
  */

\"	            {
	                BEGIN(STRING);	// Begin condition STRING
	                string_buf_ptr=string_buf;	// reset string_buf_ptr
	            }

<STRING>\"	    {
			        if(string_buf_ptr - string_buf >= MAX_STR_CONST)
				        {
				            cool_yylval.error_msg="String constant too long";
				            BEGIN(INITIAL);
				            return (ERROR);
				        }
			        cool_yylval.symbol=stringtable.add_string(string_buf);	//add the string to the STRING table
			        *string_buf_ptr='\0';	//terminate the formed string
			        BEGIN(INITIAL);	// end of string state
			        return (STR_CONST);
			    }

 /*
  * an unescaped newline
  */
<STRING>\n	    {
			        cool_yylval.error_msg="Unterminated string constant";
			        curr_lineno++;
			        BEGIN(INITIAL);
			        return (ERROR);
			    }

<STRING>\\n	    {
			        add_char('\n');
			    }

<STRING>\\\n	{
				    curr_lineno++;
				    add_char('\n');
				}

<STRING>\\t	    {
			        add_char('\t');
			    }

<STRING>\\b	    {
			        add_char('\b');
			    }

<STRING>\\f	    {
			        add_char('\f');
			    }


 /*
  * Handle null character error
  */
<STRING>\\\0	{
				    BEGIN(STR_ERROR);
				    cool_yylval.error_msg="String contains escaped null character.";
				    return (ERROR);
				}


<STRING>\0	    {
			        BEGIN(STR_ERROR);
			        cool_yylval.error_msg="String contains null character.";
			        return (ERROR);
			    }

 /*
  * Handle all other escaped character.
  */
<STRING>\\(.|\n)	{
				        add_char(yytext[1]);	// add char after backslash
				    }


<STRING><<EOF>>	    {
				        BEGIN(INITIAL);
				        cool_yylval.error_msg="EOF in string constant";
				        return (ERROR);
				    }

 /*
  * Handle all other character.
  */
<STRING>.	        {
			            add_char(yytext[0]);
			        }

 /*
  * Character string is ignored when the string is long or the character is invalid
  */
<STR_ERROR>\n	    {
                        curr_lineno++;
                        BEGIN(INITIAL);
                    }

<STR_ERROR>\\\n	     curr_lineno++;

<STR_ERROR>\\\"

<STR_ERROR>\\\\

<STR_ERROR>\"	     BEGIN(INITIAL);

<STR_ERROR>.

\n	 curr_lineno++; // count newline

{CHARS}	            {
					    return yytext[0]; // return matched char
					}

{WHITESPACE}          /* eat up whitespace */

 /*
  *  To any other symbol that is not covered by the rules
  */
.       {
    	    cool_yylval.error_msg=yytext;
    	    return (ERROR);
    	}


%%

void add_char(char c) {
    if(string_buf_ptr - string_buf >= MAX_STR_CONST)
		error_occurred();

	*string_buf_ptr++=c;
}

int error_occurred() {
     cool_yylval.error_msg="String constant too long";
     BEGIN(STR_ERROR);
     return (ERROR);
}