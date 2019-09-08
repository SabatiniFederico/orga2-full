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

	/*
	char* strings[10] = {"aa","aa","dd","ff","00","aa","cc","ee","gg","hh"};
	list_t* l1 = listNew();
    
    for(int i=0; i<5;i++)
       listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);

    listAdd(l1,strClone("RABAS"),(funcCmp_t*)&strCmp);
    imprimirLista(l1);
    
    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));
    

    //listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    //listRemoveLast(l1, (funcDelete_t*)&strDelete);

    imprimirLista(l1);
    
    listDelete(l1, (funcDelete_t*)&strDelete);

	//[PRIMERO,00,aa,bb,dd,ff,ULTIMO]
    */


    FILE *pfile = fopen("salida.caso.propios.txt","w");

    
    list_t* l1 = listNew();

    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));

    listPrint(l1,pfile,(funcPrint_t*)&strPrint);

    listDelete(l1, (funcDelete_t*)&strDelete);

    //test_strings(pfile);
    //test_hashTable(pfile);
    
    test_strings(pfile);    

    fclose(pfile);



    return 0;
}

void test_strings(FILE *pfile) {
    char *a, *b, *c;
    // clone
    fprintf(pfile,"==> Clone\n");
    a = strClone("casa");
    b = strClone("");
    strPrint(a,pfile);
    fprintf(pfile,"\n");
    strPrint(b,pfile);
    fprintf(pfile,"\n");
    strDelete(a);
    strDelete(b);
    // concat
    fprintf(pfile,"==> Concat\n");
    a = strClone("perro_");
    b = strClone("loco");
    fprintf(pfile,"%i\n",strLen(a));
    fprintf(pfile,"%i\n",strLen(b));
    c = strConcat(a,b);
    strPrint(c,pfile);
    fprintf(pfile,"\n");
    c = strConcat(c,strClone(""));
    strPrint(c,pfile);
    fprintf(pfile,"\n");
    c = strConcat(strClone(""),c);
    strPrint(c,pfile);
    fprintf(pfile,"\n");
    c = strConcat(c,c);
    strPrint(c,pfile);
    fprintf(pfile,"\n");
    // Substring
    fprintf(pfile,"==> Substring\n");
    fprintf(pfile,"%i\n",strLen(c));
    int h = strLen(c);
    for(int i=0; i<h+1; i++) {
        for(int j=0; j<h+1; j++) {    
            a = strClone(c);
            a = strSubstring(a,i,j);
            strPrint(a,pfile);
            fprintf(pfile,"\n");
            strDelete(a);
        }
        fprintf(pfile,"\n");
    }
    strDelete(c);
    // cmp
    fprintf(pfile,"==> Cmp\n");
    char* texts[5] = {"sar","23","taaa","tbb","tix"};
    for(int i=0; i<5; i++) {
        for(int j=0; j<5; j++) {
            fprintf(pfile,"cmp(%s,%s) -> %i\n",texts[i],texts[j],strCmp(texts[i],texts[j]));
        }
    }
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