#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"

void test_hashTable(FILE *pfile){
    
}

char* strings[10] = {"aa","bb","dd","ff","00","zz","cc","ee","gg","hh"};

int main (void){

    FILE *pfile = fopen("salida.caso.propios.txt","w");


    //test_strings(pfile);
    //test_hashTable(pfile);
    
    //test_strings(pfile); 
    //test_list(pfile);   

    hashTable_t* hash = hashTableNew(33, (funcHash_t*)&strHash);

    hashTableAdd(hash, strClone(strings[0]));
    hashTableAdd(hash, strClone(strings[1]));
    hashTableAdd(hash, strClone(strings[2]));
    hashTableAdd(hash, strClone("arboleda"));

    hashTableDeleteSlot(hash, 0,(funcDelete_t*)&strDelete);
    hashTablePrint(hash, pfile, (funcPrint_t*)&strPrint);


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

/** List **/
void test_list(FILE *pfile) {
    char *a, *b, *c;
    list_t* l1;
    // listAddFirst
    fprintf(pfile,"==> listAddFirst\n");
    l1 = listNew();    
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddFirst(l1,strClone("PRIMERO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listAddLast
    fprintf(pfile,"==> listAddLast\n");
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listAdd
    fprintf(pfile,"==> listAdd\n");
    l1 = listNew();
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listRemove
    fprintf(pfile,"==> listRemove\n");
    l1 = listNew();
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    for(int i=0; i<5;i++) {
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
        listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    }
    listRemove(l1, strings[1], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listAddFirst(l1,strClone("PRIMERO"));
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listAddLast(l1,strClone("ULTIMO"));
    listRemove(l1, "PRIMERO", (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listRemove(l1, "ULTIMO", (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listRemoveFirst
    fprintf(pfile,"==> listRemoveFirst\n");
    l1 = listNew();
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listAddFirst(l1,strClone("PRIMERO"));
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listAddLast(l1,strClone("ULTIMO"));
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listRemoveLast
    fprintf(pfile,"==> listRemoveLast\n");
    l1 = listNew();
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listAddFirst(l1,strClone("PRIMERO"));
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listAddLast(l1,strClone("ULTIMO"));
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listRemove listRemoveFirst listRemoveLast
    fprintf(pfile,"==> listRemove listRemoveFirst listRemoveLast\n");
    l1 = listNew();
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, 0);
    listRemoveFirst(l1, 0);
    listRemoveLast(l1, 0);
    char* stringsLocal[10];
    for(int i=0; i<10;i++)
        stringsLocal[i] = strClone(strings[i]);
    for(int i=0; i<10;i++)
        listAdd(l1,stringsLocal[i],(funcCmp_t*)&strCmp);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveLast(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveFirst(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveLast(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveFirst(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveLast(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemoveFirst(l1, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, 0);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,0);
    for(int i=0; i<10;i++)
        free(stringsLocal[i]);
}
