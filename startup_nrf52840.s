// Copyright (c) 2009-2020 ARM Limited. All rights reserved.
// 
//     SPDX-License-Identifier: Apache-2.0
// 
// Licensed under the Apache License, Version 2.0 (the License)// you may
// not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an AS IS BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
// NOTICE: This file has been modified by Nordic Semiconductor ASA.

// The modules in this file are included in the libraries, and may be replaced
// by any user-defined modules that define the PUBLIC symbol _program_start or
// a user defined start symbol.
// To override the cstartup defined in the library, simply add your modified
// version to the workbench project.
//
// The vector table is normally located at address 0.
// When debugging in RAM, it can be located in RAM, aligned to at least 2^6.
// The name "__vector_table" has special meaning for C-SPY:
// it is where the SP start value is found, and the NVIC vector
// table register (VTOR) is initialized to this address if != 0.

// ISR Vector
    .syntax unified
    .section .isr_vector, "a"
    .align 2
    .globl __isr_vector
__isr_vector:
    .long   __stack_end
    .long   Reset_Handler
// Exceptions
    .long   NMI_Handler
    .long   HardFault_Handler
    .long   MemManage_Handler
    .long   BusFault_Handler
    .long   UsageFault_Handler
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   SVC_Handler
    .long   DebugMon_Handler
    .long   0                           // Reserved
    .long   PendSV_Handler
    .long   SysTick_Handler

// External Interrupts
    .long   POWER_CLOCK_IRQHandler
    .long   RADIO_IRQHandler
    .long   UARTE0_UART0_IRQHandler
    .long   SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler
    .long   SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler
    .long   NFCT_IRQHandler
    .long   GPIOTE_IRQHandler
    .long   SAADC_IRQHandler
    .long   TIMER0_IRQHandler
    .long   TIMER1_IRQHandler
    .long   TIMER2_IRQHandler
    .long   RTC0_IRQHandler
    .long   TEMP_IRQHandler
    .long   RNG_IRQHandler
    .long   ECB_IRQHandler
    .long   CCM_AAR_IRQHandler
    .long   WDT_IRQHandler
    .long   RTC1_IRQHandler
    .long   QDEC_IRQHandler
    .long   COMP_LPCOMP_IRQHandler
    .long   SWI0_EGU0_IRQHandler
    .long   SWI1_EGU1_IRQHandler
    .long   SWI2_EGU2_IRQHandler
    .long   SWI3_EGU3_IRQHandler
    .long   SWI4_EGU4_IRQHandler
    .long   SWI5_EGU5_IRQHandler
    .long   TIMER3_IRQHandler
    .long   TIMER4_IRQHandler
    .long   PWM0_IRQHandler
    .long   PDM_IRQHandler
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   MWU_IRQHandler
    .long   PWM1_IRQHandler
    .long   PWM2_IRQHandler
    .long   SPIM2_SPIS2_SPI2_IRQHandler
    .long   RTC2_IRQHandler
    .long   I2S_IRQHandler
    .long   FPU_IRQHandler
    .long   USBD_IRQHandler
    .long   UARTE1_IRQHandler
    .long   QSPI_IRQHandler
    .long   CRYPTOCELL_IRQHandler
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   PWM3_IRQHandler
    .long   0                           // Reserved
    .long   SPIM3_IRQHandler
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .long   0                           // Reserved
    .size    __isr_vector, . - __isr_vector

    .text
    .thumb

// Reset Handler
    .thumb_func
    .align 2
    .weak Reset_Handler
    .type Reset_Handler, %function
Reset_Handler:
    // disable irqs
    cpsid i

    // copy data
    ldr r1, =__data_init
    ldr r2, =__data
    ldr r3, =__data_end
.LC0:
    cmp r2, r3
    ittt lt
    ldrlt r0, [r1], #4
    strlt r0, [r2], #4
    blt .LC0

    // clear bss
    ldr r1, =__bss
    ldr r2, =__bss_end
    movs r0, 0
.LC1:
    cmp r1, r2
    itt lt
    strlt r0, [r1], #4
    blt .LC1

    // init stdlib
    ldr r0, =__libc_init_array
    blx r0

    // enable irqs
    cpsie i

    // go to main!
    ldr r0, =main
    blx r0

    // loop if main exits
.LC2:
    wfi
    b .LC2
    .size Reset_Handler, . - Reset_Handler

// Exception handler hooks
    .align 2
    .thumb_func
    .weak NMI_Handler
    .type NMI_Handler, %function
NMI_Handler:
    b .
    .size NMI_Handler, . - NMI_Handler

    .align 2
    .thumb_func
    .weak HardFault_Handler
    .type HardFault_Handler, %function
HardFault_Handler:
    b .
    .size HardFault_Handler, . - HardFault_Handler

    .align 2
    .thumb_func
    .weak MemManage_Handler
    .type MemManage_Handler, %function
MemManage_Handler:
    b .
    .size MemManage_Handler, . - MemManage_Handler

    .align 2
    .thumb_func
    .weak BusFault_Handler
    .type BusFault_Handler, %function
BusFault_Handler:
    b .
    .size BusFault_Handler, . - BusFault_Handler

    .align 2
    .thumb_func
    .weak UsageFault_Handler
    .type UsageFault_Handler, %function
UsageFault_Handler:
    b .
    .size UsageFault_Handler, . - UsageFault_Handler

    .align 2
    .thumb_func
    .weak SVC_Handler
    .type SVC_Handler, %function
SVC_Handler:
    b .
    .size SVC_Handler, . - SVC_Handler

    .align 2
    .thumb_func
    .weak DebugMon_Handler
    .type DebugMon_Handler, %function
DebugMon_Handler:
    b .
    .size DebugMon_Handler, . - DebugMon_Handler

    .align 2
    .thumb_func
    .weak PendSV_Handler
    .type PendSV_Handler, %function
PendSV_Handler:
    b .
    .size PendSV_Handler, . - PendSV_Handler

    .align 2
    .thumb_func
    .weak SysTick_Handler
    .type SysTick_Handler, %function
SysTick_Handler:
    b .
    .size SysTick_Handler, . - SysTick_Handler

// Interrupt handler hooks
    .align 2
    .thumb_func
    .weak POWER_CLOCK_IRQHandler
    .type POWER_CLOCK_IRQHandler, %function
POWER_CLOCK_IRQHandler:
    b .
    .size POWER_CLOCK_IRQHandler, . - POWER_CLOCK_IRQHandler

    .align 2
    .thumb_func
    .weak RADIO_IRQHandler
    .type RADIO_IRQHandler, %function
RADIO_IRQHandler:
    b .
    .size RADIO_IRQHandler, . - RADIO_IRQHandler

    .align 2
    .thumb_func
    .weak UARTE0_UART0_IRQHandler
    .type UARTE0_UART0_IRQHandler, %function
UARTE0_UART0_IRQHandler:
    b .
    .size UARTE0_UART0_IRQHandler, . - UARTE0_UART0_IRQHandler

    .align 2
    .thumb_func
    .weak SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler
    .type SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler, %function
SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler:
    b .
    .size SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler, . - SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler

    .align 2
    .thumb_func
    .weak SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler
    .type SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler, %function
SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler:
    b .
    .size SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler, . - SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler

    .align 2
    .thumb_func
    .weak NFCT_IRQHandler
    .type NFCT_IRQHandler, %function
NFCT_IRQHandler:
    b .
    .size NFCT_IRQHandler, . - NFCT_IRQHandler

    .align 2
    .thumb_func
    .weak GPIOTE_IRQHandler
    .type GPIOTE_IRQHandler, %function
GPIOTE_IRQHandler:
    b .
    .size GPIOTE_IRQHandler, . - GPIOTE_IRQHandler

    .align 2
    .thumb_func
    .weak SAADC_IRQHandler
    .type SAADC_IRQHandler, %function
SAADC_IRQHandler:
    b .
    .size SAADC_IRQHandler, . - SAADC_IRQHandler

    .align 2
    .thumb_func
    .weak TIMER0_IRQHandler
    .type TIMER0_IRQHandler, %function
TIMER0_IRQHandler:
    b .
    .size TIMER0_IRQHandler, . - TIMER0_IRQHandler

    .align 2
    .thumb_func
    .weak TIMER1_IRQHandler
    .type TIMER1_IRQHandler, %function
TIMER1_IRQHandler:
    b .
    .size TIMER1_IRQHandler, . - TIMER1_IRQHandler

    .align 2
    .thumb_func
    .weak TIMER2_IRQHandler
    .type TIMER2_IRQHandler, %function
TIMER2_IRQHandler:
    b .
    .size TIMER2_IRQHandler, . - TIMER2_IRQHandler

    .align 2
    .thumb_func
    .weak RTC0_IRQHandler
    .type RTC0_IRQHandler, %function
RTC0_IRQHandler:
    b .
    .size RTC0_IRQHandler, . - RTC0_IRQHandler

    .align 2
    .thumb_func
    .weak TEMP_IRQHandler
    .type TEMP_IRQHandler, %function
TEMP_IRQHandler:
    b .
    .size TEMP_IRQHandler, . - TEMP_IRQHandler

    .align 2
    .thumb_func
    .weak RNG_IRQHandler
    .type RNG_IRQHandler, %function
RNG_IRQHandler:
    b .
    .size RNG_IRQHandler, . - RNG_IRQHandler

    .align 2
    .thumb_func
    .weak ECB_IRQHandler
    .type ECB_IRQHandler, %function
ECB_IRQHandler:
    b .
    .size ECB_IRQHandler, . - ECB_IRQHandler

    .align 2
    .thumb_func
    .weak CCM_AAR_IRQHandler
    .type CCM_AAR_IRQHandler, %function
CCM_AAR_IRQHandler:
    b .
    .size CCM_AAR_IRQHandler, . - CCM_AAR_IRQHandler

    .align 2
    .thumb_func
    .weak WDT_IRQHandler
    .type WDT_IRQHandler, %function
WDT_IRQHandler:
    b .
    .size WDT_IRQHandler, . - WDT_IRQHandler

    .align 2
    .thumb_func
    .weak RTC1_IRQHandler
    .type RTC1_IRQHandler, %function
RTC1_IRQHandler:
    b .
    .size RTC1_IRQHandler, . - RTC1_IRQHandler

    .align 2
    .thumb_func
    .weak QDEC_IRQHandler
    .type QDEC_IRQHandler, %function
QDEC_IRQHandler:
    b .
    .size QDEC_IRQHandler, . - QDEC_IRQHandler

    .align 2
    .thumb_func
    .weak COMP_LPCOMP_IRQHandler
    .type COMP_LPCOMP_IRQHandler, %function
COMP_LPCOMP_IRQHandler:
    b .
    .size COMP_LPCOMP_IRQHandler, . - COMP_LPCOMP_IRQHandler

    .align 2
    .thumb_func
    .weak SWI0_EGU0_IRQHandler
    .type SWI0_EGU0_IRQHandler, %function
SWI0_EGU0_IRQHandler:
    b .
    .size SWI0_EGU0_IRQHandler, . - SWI0_EGU0_IRQHandler

    .align 2
    .thumb_func
    .weak SWI1_EGU1_IRQHandler
    .type SWI1_EGU1_IRQHandler, %function
SWI1_EGU1_IRQHandler:
    b .
    .size SWI1_EGU1_IRQHandler, . - SWI1_EGU1_IRQHandler

    .align 2
    .thumb_func
    .weak SWI2_EGU2_IRQHandler
    .type SWI2_EGU2_IRQHandler, %function
SWI2_EGU2_IRQHandler:
    b .
    .size SWI2_EGU2_IRQHandler, . - SWI2_EGU2_IRQHandler

    .align 2
    .thumb_func
    .weak SWI3_EGU3_IRQHandler
    .type SWI3_EGU3_IRQHandler, %function
SWI3_EGU3_IRQHandler:
    b .
    .size SWI3_EGU3_IRQHandler, . - SWI3_EGU3_IRQHandler

    .align 2
    .thumb_func
    .weak SWI4_EGU4_IRQHandler
    .type SWI4_EGU4_IRQHandler, %function
SWI4_EGU4_IRQHandler:
    b .
    .size SWI4_EGU4_IRQHandler, . - SWI4_EGU4_IRQHandler

    .align 2
    .thumb_func
    .weak SWI5_EGU5_IRQHandler
    .type SWI5_EGU5_IRQHandler, %function
SWI5_EGU5_IRQHandler:
    b .
    .size SWI5_EGU5_IRQHandler, . - SWI5_EGU5_IRQHandler

    .align 2
    .thumb_func
    .weak TIMER3_IRQHandler
    .type TIMER3_IRQHandler, %function
TIMER3_IRQHandler:
    b .
    .size TIMER3_IRQHandler, . - TIMER3_IRQHandler

    .align 2
    .thumb_func
    .weak TIMER4_IRQHandler
    .type TIMER4_IRQHandler, %function
TIMER4_IRQHandler:
    b .
    .size TIMER4_IRQHandler, . - TIMER4_IRQHandler

    .align 2
    .thumb_func
    .weak PWM0_IRQHandler
    .type PWM0_IRQHandler, %function
PWM0_IRQHandler:
    b .
    .size PWM0_IRQHandler, . - PWM0_IRQHandler

    .align 2
    .thumb_func
    .weak PDM_IRQHandler
    .type PDM_IRQHandler, %function
PDM_IRQHandler:
    b .
    .size PDM_IRQHandler, . - PDM_IRQHandler

    .align 2
    .thumb_func
    .weak MWU_IRQHandler
    .type MWU_IRQHandler, %function
MWU_IRQHandler:
    b .
    .size MWU_IRQHandler, . - MWU_IRQHandler

    .align 2
    .thumb_func
    .weak PWM1_IRQHandler
    .type PWM1_IRQHandler, %function
PWM1_IRQHandler:
    b .
    .size PWM1_IRQHandler, . - PWM1_IRQHandler

    .align 2
    .thumb_func
    .weak PWM2_IRQHandler
    .type PWM2_IRQHandler, %function
PWM2_IRQHandler:
    b .
    .size PWM2_IRQHandler, . - PWM2_IRQHandler

    .align 2
    .thumb_func
    .weak SPIM2_SPIS2_SPI2_IRQHandler
    .type SPIM2_SPIS2_SPI2_IRQHandler, %function
SPIM2_SPIS2_SPI2_IRQHandler:
    b .
    .size SPIM2_SPIS2_SPI2_IRQHandler, . - SPIM2_SPIS2_SPI2_IRQHandler

    .align 2
    .thumb_func
    .weak RTC2_IRQHandler
    .type RTC2_IRQHandler, %function
RTC2_IRQHandler:
    b .
    .size RTC2_IRQHandler, . - RTC2_IRQHandler

    .align 2
    .thumb_func
    .weak I2S_IRQHandler
    .type I2S_IRQHandler, %function
I2S_IRQHandler:
    b .
    .size I2S_IRQHandler, . - I2S_IRQHandler

    .align 2
    .thumb_func
    .weak FPU_IRQHandler
    .type FPU_IRQHandler, %function
FPU_IRQHandler:
    b .
    .size FPU_IRQHandler, . - FPU_IRQHandler

    .align 2
    .thumb_func
    .weak USBD_IRQHandler
    .type USBD_IRQHandler, %function
USBD_IRQHandler:
    b .
    .size USBD_IRQHandler, . - USBD_IRQHandler

    .align 2
    .thumb_func
    .weak UARTE1_IRQHandler
    .type UARTE1_IRQHandler, %function
UARTE1_IRQHandler:
    b .
    .size UARTE1_IRQHandler, . - UARTE1_IRQHandler

    .align 2
    .thumb_func
    .weak QSPI_IRQHandler
    .type QSPI_IRQHandler, %function
QSPI_IRQHandler:
    b .
    .size QSPI_IRQHandler, . - QSPI_IRQHandler

    .align 2
    .thumb_func
    .weak CRYPTOCELL_IRQHandler
    .type CRYPTOCELL_IRQHandler, %function
CRYPTOCELL_IRQHandler:
    b .
    .size CRYPTOCELL_IRQHandler, . - CRYPTOCELL_IRQHandler

    .align 2
    .thumb_func
    .weak PWM3_IRQHandler
    .type PWM3_IRQHandler, %function
PWM3_IRQHandler:
    b .
    .size PWM3_IRQHandler, . - PWM3_IRQHandler

    .align 2
    .thumb_func
    .weak SPIM3_IRQHandler
    .type SPIM3_IRQHandler, %function
SPIM3_IRQHandler:
    b .
    .size SPIM3_IRQHandler, . - SPIM3_IRQHandler

    .end
