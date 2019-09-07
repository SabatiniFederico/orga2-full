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

	char* strings[10] = {"aa","bb","dd","ff","00","zz","cc","ee","gg","hh"};
	list_t* l1 = listNew();

	char* a = strClone("aa");
	char* b = strClone("bb");
	char* c = strClone("00");

	int res = strCmp(a,c); // primero, aa
	int res2 = strCmp(a,b); // primero, aa
	printf("%d, %d", res, res2);

    for(int i=0; i<5;i++)
       listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));

    imprimirLista(l1);

	//[PRIMERO,00,aa,bb,dd,ff,ULTIMO]


    //listAddLast(l1,strClone("ULTIMO"));
    /*
    listAdd(l1,a,(funcCmp_t*)&strCmp);
    imprimirLista(l1);	
    listAdd(l1,b,(funcCmp_t*)&strCmp);
    imprimirLista(l1);	
    listAdd(l1,c,(funcCmp_t*)&strCmp);
    imprimirLista(l1);	
	*/

    //FILE *pfile = fopen("salida.caso.propios.txt","w");
    //test_hashTable(pfile);
    //fclose(pfile);



    return 0;
}

void imprimirLista(list_t* l1){
	if(l1 -> first == NULL) {
		printf("NULL");
	} else {
		printf("[");
		listElem_t* elem = l1 -> first;
		do {
			char* data = elem -> data;
			printf("%s,", data);
			elem = elem -> next;
		} while (elem != NULL);
		printf("]");
	}
}
