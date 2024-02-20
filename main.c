#include <avr/io.h>
#include "functions.h"



void lightUp();
void lightDown();
int main(void){
    DDRB |= _BV(DDB5);
    while (1){
        lightUp();
        lightDown();
    }
}