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
	char* compareA = "federico";
	char* compareB = "sabatini";

	//int compare = strCmp(compareA, compareB);
	//printf("result of comp beetween %s, %s: %d", compareA, compareB, compare);
	//char* res = strConcat(compareA, compareB);
	//printf("concat %s", res);	

	list_t* mylist = listNew();

	listAddFirst(mylist, compareA);
	listAddFirst(mylist, compareB);

    char* resultA = mylist -> first -> data;
    char* resultB = mylist -> last -> data;	
	printf("mylist:  %s and %s", resultA, resultB);	
	



    //FILE *pfile = fopen("salida.caso.propios.txt","w");
    //test_hashTable(pfile);
    //fclose(pfile);
    return 0;
}