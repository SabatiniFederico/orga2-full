#include "lib.h"

/** STRING **/

char* strSubstring(char* pString, uint32_t inicio, uint32_t fin) {

	uint32_t lenght = strLen(pString);

	if(inicio > fin){
		return pString;
	}

	if (inicio > lenght){
		return strClone("");
	}

	fin = fin + 1;
	if(fin > lenght){
		fin = lenght; 
	}

	//terminados casos borde.
	for(uint32_t i = 0; i < fin - inicio; i++)
		pString[i] = pString[i + inicio];

	pString[fin - inicio] = '\0';
	return pString;
}

/** Lista **/

void listPrintReverse(list_t* pList, FILE *pFile, funcPrint_t* fp) {

	listElem_t* element = pList -> last;

	fprintf(pFile,"[");

	while (element) {
		fp(element -> data, pFile);
		if (element -> prev)
			fprintf(pFile,",");
		element = element -> prev;
	}
	fprintf(pFile,"]");
}

/** HashTable **/

uint32_t strHash(char* pString) {
  if(strLen(pString) != 0)
      return (uint32_t)pString[0] - 'a';
  else
      return 0;
}

void hashTableRemoveAll(hashTable_t* pTable, void* data, funcCmp_t* fc, funcDelete_t* fd) {
	uint32_t slot = strHash(data) % pTable -> size;

	list_t* l1 = pTable -> listArray; 
	listElem_t* elem = l1 -> first;	//Intente hacerlo en 2 lineas abusando listArray[slot] pero no me salio. 

	uint32_t i = 0;
	while (slot != i){
	    	elem = elem -> next;
			i++;
		}

	listRemove(elem -> data, data, fc, fd);
}

void hashTablePrint(hashTable_t* pTable, FILE *pFile, funcPrint_t* fp) {
	uint32_t size = pTable -> size;
	if(size != 0){

		list_t* l1 = pTable -> listArray; 
		listElem_t* elem = l1 -> first;

		uint32_t i = 0;
		while (size != i){
			fprintf(pFile,"%d = ", i);
	    	listPrint(elem -> data,pFile,fp); fprintf(pFile,"\n");
	    	elem = elem -> next;
			i++;
		}
	}
}
