#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"


char* strings[31] = {"alemania", "bolivia", "chile", "dedos", "espada", 
                    "flagelo", "ganar", "historia", "iran", "jamaica",
                    "karma", "lodo", "magia", "nano", "optar", "pera",
                    "queso", "raro", "sonar", "talar", "untar",
                    "validar", "wweeeey", "xaxo", "yema", "zamba",
                    "Vortex", "Waka Waka", "Xenegal", "Yeso", "Zafiro"};

void test_hashTable(FILE *pfile){

    hashTable_t *myHash;
    myHash = hashTableNew(33, (funcHash_t*)&strHash);

    for(int i=0;i<31;i++) 
            hashTableAdd(myHash, strClone(strings[i]));

    //Me faltan 2 slots, pero como soy re jodido y no los encontraba, fui al manual
    //de ASCII y meti el numero :P.
    char str124[2];
    str124[0] = 58;
    str124[1] = '\0';       // <- prints ":"

    char str125[2];
    str125[0] = 59;         // <- prints ";"
    str125[1] = '\0';
    hashTableAdd(myHash, strClone(str124));
    hashTableAdd(myHash, strClone(str125));

    hashTablePrint(myHash,pfile,(funcPrint_t*)&strPrint);
    hashTableDelete(myHash,(funcDelete_t*)&strDelete);


}


int main (void){

    FILE *pfile = fopen("salida.caso.propios.txt","w");

    test_hashTable(pfile);
 
    fclose(pfile);
    



    return 0;
}