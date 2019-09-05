#include <stdio.h>

extern double suma(double,double);

int main(){

	double res =  suma(20.7,40);
	printf("The double is %f\n", res);	

	return 0;
}