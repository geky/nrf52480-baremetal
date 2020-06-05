#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <nrfx_clock.h>
#include <nrfx_uarte.h>

// uart config, note that Nordic's UARTE DMA does not
// support writing from flash
nrfx_uarte_t uart = {
    .p_reg = NRF_UARTE0,
    .drv_inst_idx = NRFX_UARTE0_INST_IDX,
};
const nrfx_uarte_config_t uart_config = {
    .pseltxd = 6,
    .pselrxd = 8,
    .pselcts = NRF_UARTE_PSEL_DISCONNECTED,
    .pselrts = NRF_UARTE_PSEL_DISCONNECTED,
    .p_context = NULL,
    .baudrate = NRF_UARTE_BAUDRATE_115200,
    .interrupt_priority = NRFX_UARTE_DEFAULT_CONFIG_IRQ_PRIORITY,
    .hal_cfg = {
        .hwfc = NRF_UARTE_HWFC_DISABLED,
        .parity = NRF_UARTE_PARITY_EXCLUDED,
        NRFX_UARTE_DEFAULT_EXTENDED_STOP_CONFIG
        NRFX_UARTE_DEFAULT_EXTENDED_PARITYTYPE_CONFIG
    }
};

// gcc stdlib write hook
int _write(int handle, char *buffer, int size) {
    // stdout or stderr only
    assert(handle == 1 || handle == 2);

    int i = 0;
    while (true) {
        char *nl = memchr(&buffer[i], '\n', size-i);
        int span = nl ? nl-&buffer[i] : size-i;
        nrfx_err_t err = nrfx_uarte_tx(&uart, (uint8_t*)&buffer[i], span);
        assert(err == NRFX_SUCCESS);
        i += span;

        if (i >= size) {
            return size;
        }

        char r[2] = "\r\n";
        err = nrfx_uarte_tx(&uart, (uint8_t*)r, sizeof(r));
        assert(err == NRFX_SUCCESS);
        i += 1;
    }
}

// hook for clock init callback.
void clock_handler(nrfx_clock_evt_type_t event) {}

// entry point
void main(void) {
    // setup LCLK
    nrfx_err_t err = nrfx_clock_init(clock_handler);
    assert(err == NRFX_SUCCESS);
    nrfx_clock_start(NRF_CLOCK_DOMAIN_LFCLK);

    // setup UARTE
    err = nrfx_uarte_init(&uart, &uart_config, NULL);
    assert(err == NRFX_SUCCESS);

    printf("Hi from nrf52840!\n");
}
