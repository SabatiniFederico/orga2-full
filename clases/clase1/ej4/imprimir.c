#include <stdio.h>

extern void imprimir(char*);

int main(){

	char *string = "hello";
	imprimir(string);

	return 0;
}