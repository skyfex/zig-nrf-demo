
#include <nrf.h>


void main () {
  NRF_GPIO->PIN_CNF[17] = 1;
  NRF_GPIO->PIN_CNF[18] = 1;
  NRF_GPIO->PIN_CNF[19] = 1;
  NRF_GPIO->OUTCLR = 1<<17;
  NRF_GPIO->OUTCLR = 1<<18;
  NRF_GPIO->OUTCLR = 1<<19;
}
