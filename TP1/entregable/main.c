#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"

void test_hashTable(FILE *pfile){
    
}

int main (void){
	char* z = "hola mundo";
	uint32_t a = strLen(z);
	char* b = strClone(z);
	//printf("%s, %s, %d", z, b, a);


	char* compareA = "a";
	char* compareB = "b";

	int compare = strCmp(compareA, compareB);
	//printf("result of comp beetween %s, %s: %d", compareA, compareB, compare);

	char* res = strConcat(compareA, compareB);
	printf("concat %s", res);	

    //FILE *pfile = fopen("salida.caso.propios.txt","w");
    //test_hashTable(pfile);
    //fclose(pfile);
    return 0;
}