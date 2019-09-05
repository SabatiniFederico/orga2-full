#include <stdio.h>

extern int suma(int,int);

int main(){

	int res =  suma(20,40);
	printf("The integer is %d\n", res);	

	return 0;
}