#include <avr/io.h>
#include "debug.h"

#define DEBUG 1

void lightUp();
void lightDown();
int main(void){
    DDRB |= _BV(DDB5);
    while (1){
        if(DEBUG){
            debugQuickly();
        }
        lightUp();
        lightDown();
    }
}