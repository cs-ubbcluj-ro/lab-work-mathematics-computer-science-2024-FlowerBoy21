%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define KEYWORD 256
    #define ID 257
    #define INT_CONST 258
    #define FLOAT_CONST 259
    #define STRING_CONST 260
    #define OPERATOR 261
    #define SEPARATOR 262
    #define ERROR 263

    int yylval; // Define yylval directly here to avoid linker errors
    extern int yylineno; // Line number from Lex

    int st_index = 0; // Index for Symbol Table
    int yycolumn = 1; // Current column position in input line

    // Struct for Symbol Table
    typedef struct {
        char value[50]; // Value of the symbol (ID or Constant)
    } SymbolTableEntry;

    SymbolTableEntry symbolTable[100]; // Symbol Table

    // Keywords
    char *keywords[] = {
        "VAR", "BEGIN", "END", "READ", "WRITE", "IF", "THEN", "ELSE", 
        "WHILE", "DO", "int", "float", "char"
    };
    int num_keywords = 13;

    // Check if a word is a keyword
    int is_keyword(const char *str) {
        for (int i = 0; i < num_keywords; i++) {
            if (strcmp(str, keywords[i]) == 0) {
                return 1;
            }
        }
        return 0;
    }

    // Check if a symbol exists in the Symbol Table
    int is_in_symbol_table(const char *str) {
        for (int i = 0; i < st_index; i++) {
            if (strcmp(symbolTable[i].value, str) == 0) {
                return i; // Return position in ST
            }
        }
        return -1;
    }

    // Add a symbol to the Symbol Table
    void add_to_symbol_table(const char *str) {
        strcpy(symbolTable[st_index].value, str);
        st_index++;
    }
%}

%option noyywrap

%%
[ \t\r]+ {
    // Ignore whitespace (space, tab, carriage return)
    yycolumn += yyleng;
}

\n {
    yycolumn = 1; // Reset column on newline
    yylineno++;   // Increment line number
}

"VAR"|"BEGIN"|"END"|"READ"|"WRITE"|"IF"|"THEN"|"ELSE"|"WHILE"|"DO"|"int"|"float"|"char" {
    return KEYWORD;
}


":="|"<="|">="|"="|"<"|">"|"<>" { return OPERATOR; }

\+|\-|\*|\/|\% { return OPERATOR; }

"["|"]"|"{"|"}"|":"|";"|","|"("|")" { return SEPARATOR; }


[a-zA-Z][a-zA-Z0-9_]* {
    if (!is_keyword(yytext)) { // Not a keyword
        int pos = is_in_symbol_table(yytext);
        if (pos == -1) { // If not in Symbol Table
            add_to_symbol_table(yytext);
            yylval = st_index - 1; // Assign symbol table index to yylval
            return ID;
        } else {
            yylval = pos; // Assign existing position in Symbol Table to yylval
            return ID;
        }
    } else {
        return KEYWORD;
    }
}

[+-]?[0-9]+\.[0-9]+ {
    int pos = is_in_symbol_table(yytext);
    if (pos == -1) {
        add_to_symbol_table(yytext);
        yylval = st_index - 1; // Assign symbol table index to yylval
        return FLOAT_CONST;
    } else {
        yylval = pos; // Assign existing position in Symbol Table to yylval
        return FLOAT_CONST;
    }
}

[+-]?[0-9]+ {
    int pos = is_in_symbol_table(yytext);
    if (pos == -1) {
        add_to_symbol_table(yytext);
        yylval = st_index - 1; // Assign symbol table index to yylval
        return INT_CONST;
    } else {
        yylval = pos; // Assign existing position in Symbol Table to yylval
        return INT_CONST;
    }
}

\"[^\"]*\" {
    int pos = is_in_symbol_table(yytext);
    if (pos == -1) {
        add_to_symbol_table(yytext);
        yylval = st_index - 1; // Assign symbol table index to yylval
        return STRING_CONST;
    } else {
        yylval = pos; // Assign existing position in Symbol Table to yylval
        return STRING_CONST;
    }
}

. {
    fprintf(stderr, "Lexical error at line %d, column %d: %s\n", yylineno, yycolumn, yytext);
    return ERROR;
}

%%

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: ./scanner <input_file>\n");
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    if (!input) {
        printf("Cannot open file %s\n", argv[1]);
        return 1;
    }

    yyin = input;

    int token;
    while ((token = yylex()) != 0) {
        switch (token) {
            case KEYWORD:
                printf("KEYWORD: %s\n", yytext);
                break;
            case ID:
                printf("ID: %s (Symbol Table Index: %d)\n", yytext, yylval);
                break;
            case INT_CONST:
                printf("INT_CONST: %s (Symbol Table Index: %d)\n", yytext, yylval);
                break;
            case FLOAT_CONST:
                printf("FLOAT_CONST: %s (Symbol Table Index: %d)\n", yytext, yylval);
                break;
            case STRING_CONST:
                printf("STRING_CONST: %s (Symbol Table Index: %d)\n", yytext, yylval);
                break;
            case OPERATOR:
                printf("OPERATOR: %s\n", yytext);
                break;
            case SEPARATOR:
                printf("SEPARATOR: %s\n", yytext);
                break;
            case ERROR:
                printf("LEXICAL ERROR: %s\n", yytext);
                break;
            default:
                printf("UNKNOWN TOKEN: %s\n", yytext);
        }
    }

    fclose(input);
    return 0;
}
