#include <avr/io.h>
#include <util/delay.h>

#define BLINK_DELAY_MS 1000

vid lightUp(){
    PORTB |= (PORTB5);
    _delay_ms(BLINK_DELAY_MS);
}
void lightDown(){
    PORTB &= ~ _BV(PORTB5);
    _delay_ms(BLINK_DELAY_MS);
}