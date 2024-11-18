%{
#include <stdio.h>
#include <string.h>

typedef struct {
    char token[257];
    int symbolTableCode;
} PIF;

typedef struct {
    char token[257];
    int index;
} ST;

ST SymbolTable[100];
int stLength = 1;  // Start indexing from 1 instead of 0

PIF ProgramInternalForm[300];
int pifLength = 0;

int errorFound = 0;
int lineNumber = 1;

/* Function Definitions */
int addToSymbolTable(char* token);
void addToProgramInternalForm(char* token, int stCode);
void showSymbolTable();
void showProgramInternalForm();

/* Function Implementations */
int addToSymbolTable(char* token) {
    for (int i = 0; i < stLength; i++) {
        if (strcmp(SymbolTable[i].token, token) == 0) {
            return SymbolTable[i].index;
        }
    }
    strcpy(SymbolTable[stLength].token, token);
    SymbolTable[stLength].index = stLength;
    stLength++;
    return stLength - 1;
}

void addToProgramInternalForm(char* token, int stCode) {
    strcpy(ProgramInternalForm[pifLength].token, token);
    ProgramInternalForm[pifLength].symbolTableCode = stCode;
    pifLength++;
}

void showSymbolTable() {
    printf("--------------- Symbol Table ---------------\n");
    for (int i = 1; i < stLength; i++) {  // Start displaying from index 1
        printf(" %s  %d\n", SymbolTable[i].token, SymbolTable[i].index);
        printf("-------------------------------------------\n");
    }
    printf("\n");
}

void showProgramInternalForm() {
    printf("--------------- Program Internal Form ---------------\n");
    for (int i = 0; i < pifLength; i++) {
        printf(" %s  %d\n", ProgramInternalForm[i].token, ProgramInternalForm[i].symbolTableCode);
        printf("-----------------------------------------------\n");
    }
}

/* Regular Expressions for Keywords, Identifiers, Numbers, Operators, and Symbols */
%}

%%

"array"            { addToProgramInternalForm(yytext, 0); }
"char"             { addToProgramInternalForm(yytext, 0); }
"int"              { addToProgramInternalForm(yytext, 0); }
"string"           { addToProgramInternalForm(yytext, 0); }
"bool"             { addToProgramInternalForm(yytext, 0); }
"double"           { addToProgramInternalForm(yytext, 0); }
"struct"           { addToProgramInternalForm(yytext, 0); }
"if"               { addToProgramInternalForm(yytext, 0); }
"then"             { addToProgramInternalForm(yytext, 0); }
"else"             { addToProgramInternalForm(yytext, 0); }
"for"              { addToProgramInternalForm(yytext, 0); }
"execute"          { addToProgramInternalForm(yytext, 0); }
"while"            { addToProgramInternalForm(yytext, 0); }
"read"             { addToProgramInternalForm(yytext, 0); }
"print"            { addToProgramInternalForm(yytext, 0); }
"return"           { addToProgramInternalForm(yytext, 0); }
"end" 		   { addToProgramInternalForm(yytext, 0); }


"="                { addToProgramInternalForm(yytext, 0); }
"+"                { addToProgramInternalForm(yytext, 0); }
"-"                { addToProgramInternalForm(yytext, 0); }
"*"                { addToProgramInternalForm(yytext, 0); }
"/"                { addToProgramInternalForm(yytext, 0); }
"%"                { addToProgramInternalForm(yytext, 0); }
"<"                { addToProgramInternalForm(yytext, 0); }
"<="               { addToProgramInternalForm(yytext, 0); }
">"                { addToProgramInternalForm(yytext, 0); }
">="               { addToProgramInternalForm(yytext, 0); }
"=="               { addToProgramInternalForm(yytext, 0); }
"!"                { addToProgramInternalForm(yytext, 0); }
"&&"               { addToProgramInternalForm(yytext, 0); }
"||"               { addToProgramInternalForm(yytext, 0); }
"["                { addToProgramInternalForm(yytext, 0); }
"]"                { addToProgramInternalForm(yytext, 0); }
"{"                { addToProgramInternalForm(yytext, 0); }
"}"                { addToProgramInternalForm(yytext, 0); }
":"                { addToProgramInternalForm(yytext, 0); }
";"                { addToProgramInternalForm(yytext, 0); }

[a-zA-Z][a-zA-Z0-9_]* { /* Match identifiers */ 
    int stCode = addToSymbolTable(yytext); 
    addToProgramInternalForm(yytext, stCode); 
}

[0-9]+             { /* Match integers */ 
    int stCode = addToSymbolTable(yytext); 
    addToProgramInternalForm(yytext, stCode); 
}

"\""[^"]*"\""      { /* Match strings */
    int stCode = addToSymbolTable(yytext); 
    addToProgramInternalForm(yytext, stCode); 
}

[ \t\n]+           { /* Skip whitespaces */ }
.                   { errorFound = 1; printf("Illegal token %s at line %d\n", yytext, lineNumber); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char** argv) {
    FILE *fp;
    if (argc < 2) {
        printf("Provide a file.\n");
        return 1;
    }

    fp = fopen(argv[1], "r");
    if (!fp) {
        printf("Failed to open file %s.\n", argv[1]);
        return 1;
    }

    yyin = fp;
    yylex();

    if (errorFound == 0) {
        showSymbolTable();
        showProgramInternalForm();
    }

    fclose(fp);
    return 0;
}
