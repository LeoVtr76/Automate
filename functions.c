#include "functions.h"

void lightUp(){
    PORTB |= _BV(PORTB5);
    _delay_ms(BLINK_DELAY_MS);
}

void lightDown(){
    PORTB &= ~_BV(PORTB5);
    _delay_ms(BLINK_DELAY_MS);
}
