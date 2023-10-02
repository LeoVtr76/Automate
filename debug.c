#include <avr/io.h>

void debugQuickly(){
    DDRB |= (1<<DDB1);
}