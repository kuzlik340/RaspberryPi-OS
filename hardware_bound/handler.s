/*
 * handler.h   v1.0
 *
 * This module contains a vector table for the 
 * exceptions/interrupts occured while system was running
 *
 * T.Kuz    11.2024
 */

/* the processor here works based on the occured exception and based on the offset of element in table */
.section .text
.global vector_table
.global enable_irq


.balign 0x800
vector_table:
/* this part won't be used, if we are switching to el1 we use stack of el1 */
current_el_sp0_sync:        /* for sys calls and memory errors */
    b error
.balign 0x80
current_el_sp0_irq:         /* for interrupts */
    b error
.balign 0x80
current_el_sp0_fiq:         /* for high ptiority interrupts (not used) */
    b error
.balign 0x80
current_el_sp0_serror:      /* for system error */
    b error


.balign 0x80
current_el_spn_sync:        /* for sys calls and memory errors */
    b sync_handler
.balign 0x80
current_el_spn_irq:         /* for interrupts */
    b irq_handler
.balign 0x80
current_el_spn_fiq:         /* for high ptiority interrupts (not used) */
    b error
.balign 0x80
current_el_spn_serror:      /* for system error */
    b error


.balign 0x80
lower_el_aarch64_sync:      /* for sys calls and memory errors */
    b sync_handler
.balign 0x80
lower_el_aarch64_irq:       /* for interrupts */
    b irq_handler
.balign 0x80
lower_el_aarch64_fiq:       /* for high ptiority interrupts (not used) */
    b error
.balign 0x80
lower_el_aarch64_serror:    /* for system error */
    b error


/* this part won't be used, since we are working only with aarch64 */
.balign 0x80
lower_el_aarch32_sync:      /* for sys calls and memory errors */
    b error
.balign 0x80
lower_el_aarch32_irq:       /* for interrupts */
    b error
.balign 0x80
lower_el_aarch32_fiq:       /* for high ptiority interrupts (not used) */
    b error
.balign 0x80
lower_el_aarch32_serror:    /* for system error */
    b error


sync_handler:
    sub sp, sp, #(32 * 8)   /* reserving space in stack to save 32 registers */
    stp x0, x1, [sp]        /* saving 32 registers */
    stp x2, x3, [sp, #(16 * 1)]
    stp x4, x5, [sp, #(16 * 2)]
    stp x6, x7, [sp, #(16 * 3)]
    stp x8, x9, [sp, #(16 * 4)]
    stp x10, x11, [sp, #(16 * 5)]
    stp x12, x13, [sp, #(16 * 6)]
    stp x14, x15, [sp, #(16 * 7)]
    stp x16, x17, [sp, #(16 * 8)]
    stp x18, x19, [sp, #(16 * 9)]
    stp x20, x21, [sp, #(16 * 10)]
    stp x22, x23, [sp, #(16 * 11)]
    stp x24, x25, [sp, #(16 * 12)]
    stp x26, x27, [sp, #(16 * 13)]
    stp x28, x29, [sp, #(16 * 14)]
    str x30, [sp, #(16 * 15)]

    mov x0, #1              /* first argument: id of exception */
    mrs x1, esr_el1         /* second argument: Exception Syndrome Register */
    mrs x2, elr_el1         /* third argument: address of inctruction that called exception */
    bl handler              /* call handler */

    ldp x0, x1, [sp]        /* loading 32 registers */
    ldp x2, x3, [sp, #(16 * 1)]
    ldp x4, x5, [sp, #(16 * 2)]
    ldp x6, x7, [sp, #(16 * 3)]
    ldp x8, x9, [sp, #(16 * 4)]
    ldp x10, x11, [sp, #(16 * 5)]
    ldp x12, x13, [sp, #(16 * 6)]
    ldp x14, x15, [sp, #(16 * 7)]
    ldp x16, x17, [sp, #(16 * 8)]
    ldp x18, x19, [sp, #(16 * 9)]
    ldp x20, x21, [sp, #(16 * 10)]
    ldp x22, x23, [sp, #(16 * 11)]
    ldp x24, x25, [sp, #(16 * 12)]
    ldp x26, x27, [sp, #(16 * 13)]
    ldp x28, x29, [sp, #(16 * 14)]
    ldr x30, [sp, #(16 * 15)]
    add sp, sp, #(32 * 8)   /* deallocating space in stack to save 32 registers */


    eret                    /* use eret to return to instruction that was after 
    * the instruction that caused exception */

    



error:
    sub sp, sp, #(32 * 8)   /* reserving space in stack to save 32 registers */
    stp x0, x1, [sp]        /* saving 32 registers */
    stp x2, x3, [sp, #(16 * 1)]
    stp x4, x5, [sp, #(16 * 2)]
    stp x6, x7, [sp, #(16 * 3)]
    stp x8, x9, [sp, #(16 * 4)]
    stp x10, x11, [sp, #(16 * 5)]
    stp x12, x13, [sp, #(16 * 6)]
    stp x14, x15, [sp, #(16 * 7)]
    stp x16, x17, [sp, #(16 * 8)]
    stp x18, x19, [sp, #(16 * 9)]
    stp x20, x21, [sp, #(16 * 10)]
    stp x22, x23, [sp, #(16 * 11)]
    stp x24, x25, [sp, #(16 * 12)]
    stp x26, x27, [sp, #(16 * 13)]
    stp x28, x29, [sp, #(16 * 14)]
    str x30, [sp, #(16 * 15)]
    mov x29, sp

    mov x0, #0              /* first argument: error code */
    bl handler              /* call handler */

    ldp x0, x1, [x29]        /* loading 32 registers */
    ldp x2, x3, [x29, #(16 * 1)]
    ldp x4, x5, [x29, #(16 * 2)]
    ldp x6, x7, [x29, #(16 * 3)]
    ldp x8, x9, [x29, #(16 * 4)]
    ldp x10, x11, [x29, #(16 * 5)]
    ldp x12, x13, [x29, #(16 * 6)]
    ldp x14, x15, [x29, #(16 * 7)]
    ldp x16, x17, [x29, #(16 * 8)]
    ldp x18, x19, [x29, #(16 * 9)]
    ldp x20, x21, [x29, #(16 * 10)]
    ldp x22, x23, [x29, #(16 * 11)]
    ldp x24, x25, [x29, #(16 * 12)]
    ldp x26, x27, [x29, #(16 * 13)]
    ldp x28, x29, [x29, #(16 * 14)]
    ldr x30, [x29, #(16 * 15)]
    add sp, sp, #(32 * 8)   /* deallocating space in stack to save 32 registers */
    mov x29, xzr

    eret

irq_handler:
    sub sp, sp, #(32 * 8)   /* reserving space in stack to save 32 registers */
    stp x0, x1, [sp]        /* saving 32 registers */
    stp x2, x3, [sp, #(16 * 1)]
    stp x4, x5, [sp, #(16 * 2)]
    stp x6, x7, [sp, #(16 * 3)]
    stp x8, x9, [sp, #(16 * 4)]
    stp x10, x11, [sp, #(16 * 5)]
    stp x12, x13, [sp, #(16 * 6)]
    stp x14, x15, [sp, #(16 * 7)]
    stp x16, x17, [sp, #(16 * 8)]
    stp x18, x19, [sp, #(16 * 9)]
    stp x20, x21, [sp, #(16 * 10)]
    stp x22, x23, [sp, #(16 * 11)]
    stp x24, x25, [sp, #(16 * 12)]
    stp x26, x27, [sp, #(16 * 13)]
    stp x28, x29, [sp, #(16 * 14)]
    str x30, [sp, #(16 * 15)]

    mov x0, #2              /* first argument: id of interrupt */
    mrs x1, esr_el1         /* second argument: Exception Syndrome Register */
    mrs x2, elr_el1         /* third argument: address of inctruction that called exception */
    bl handler              /* call handler */

    ldp x0, x1, [sp]         /* loading 32 registers */
    ldp x2, x3, [sp, #(16 * 1)]
    ldp x4, x5, [sp, #(16 * 2)]
    ldp x6, x7, [sp, #(16 * 3)]
    ldp x8, x9, [sp, #(16 * 4)]
    ldp x10, x11, [sp, #(16 * 5)]
    ldp x12, x13, [sp, #(16 * 6)]
    ldp x14, x15, [sp, #(16 * 7)]
    ldp x16, x17, [sp, #(16 * 8)]
    ldp x18, x19, [sp, #(16 * 9)]
    ldp x20, x21, [sp, #(16 * 10)]
    ldp x22, x23, [sp, #(16 * 11)]
    ldp x24, x25, [sp, #(16 * 12)]
    ldp x26, x27, [sp, #(16 * 13)]
    ldp x28, x29, [sp, #(16 * 14)]
    ldr x30, [sp, #(16 * 15)]
    add sp, sp, #(32 * 8)   /* deallocating space in stack to save 32 registers */

    /* use eret to return to instruction that was after 
    * the instruction that caused exception */
    eret                    

enable_irq:
    msr daifclr, #2
    ret    