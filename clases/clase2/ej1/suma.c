#include <stdio.h>

extern int suma(short* vector, short n);

int main(){

	short a[] = {1,4,5,2};
	short *v = a;

	int res = suma(v, 4);

	printf("The integer is %d\n", res);	

	return 0;
}