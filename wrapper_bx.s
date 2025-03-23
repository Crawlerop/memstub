p_assign_mem:
b mem_init /* Startup - 00 */
p_malloc:
b lwmem_malloc /* Malloc - 04 */
p_memcpy:
b memcpy /* Memcpy - 08 */
p_free:
b lwmem_free /* Free - 0c */
p_memset:
b memset /* Memset - 10 */
p_calloc:
b lwmem_calloc /* Calloc - 14 */
p_realloc:
b lwmem_realloc /* Realloc - 18 */
p_memmove:
b memmove /* Memmove - 1c */
p_exit:
b p_exit /* Exit - 20 */

.thumb_func
malloc_thumb:
    push {R4-R7, LR} /* save registers */
    blx p_malloc
    pop {R4-R7, PC} /* restore registers and return */
memcpy_thumb:
    push {R4-R7, LR} /* save registers */
    blx p_memcpy
    pop {R4-R7, PC} /* restore registers and return */
free_thumb:
    push {R4-R7, LR} /* save registers */
    blx p_free
    pop {R4-R7, PC} /* restore registers and return */
mmemset_thumb:
    push {R4-R7, LR} /* save registers */
    blx p_memset
    pop {R4-R7, PC} /* restore registers and return */
calloc_thumb:
    push {R4-R7, LR} /* save registers */
    blx p_calloc
    pop {R4-R7, PC} /* restore registers and return */
realloc_thumb:
    push {R4-R7, LR} /* save registers */
    blx p_realloc
    pop {R4-R7, PC} /* restore registers and return */
exit_thumb:
    push {R4-R7, LR} /* save registers */
    blx p_exit
    pop {R4-R7, PC} /* restore registers and return */
.arm

mem_init:
    mov r0, #0
    adr r0, mem_init_regs
    /* ldr r0, [r0] */
    b lwmem_assignmem

mem_init_regs:
.word 0xa0000000
.word 0x00800000
.word 0x00000000
.word 0x00000000

.ascii "Memstub (c) 2025 Wrapper"
.global null_function
null_function:
    mov pc, lr
.global memcpy
memcpy:
	mov	r12, r0
memcpy_loop:
	subs	r2, r2, #1
	bmi	memcpy_end
	ldrb	r3, [r1], #1
	strb	r3, [r0], #1
	b	memcpy_loop
memcpy_end:
	mov	r0, r12
	bx lr

.global memset
memset:
	mov	r12, r0
memset_loop:
	subs	r2, r2, #1
	bmi	memset_end
	strb	r1, [r0], #1
	b	memset_loop
memset_end:
	mov	r0, r12
	bx lr

.global memmove
memmove:
	mov	r12, r0
	cmp	r0, r1
	ble	.fw
	add	r3, r1, r2
	cmp	r0, r3
	bgt	.fw

	@ copying the memory in reverse order
	add	r0, r0, r2
	add	r1, r1, r2
.bw:
	subs	r2, r2, #1
	bmi	.ret
	ldrb	r3, [r1, #-1]!
	strb	r3, [r0, #-1]!
	b	.bw
.fw:
	subs	r2, r2, #1
	bmi	.ret
	ldrb	r3, [r1], #1
	strb	r3, [r0], #1
	b	.fw
.ret:
	mov	r0, r12
	bx lr
.ascii "ASM ENDS HERE."
