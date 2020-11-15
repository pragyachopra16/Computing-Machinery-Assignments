//Macros definition
define(x_r, x19) // stores value for x
define(c1_r, x20) //stores value for constant
define(c2_r, x21) //stores value for constant
define(c3_r, x22) //stores value for constant 
define(cm_r, x26) //stores value for current max
define(m_r, x27) // stores value of maximum

fmt:    .string "Maximum: %ld\n\n"
fmt1:   .string "x value: %ld\n"
fmt2:   .string "y value: %ld\n"
fmt3:	.string "Maximum value is: %ld\n\n"

        .balign 4
        .global main

main:   stp     x29, x30, [sp, -16]!
        mov     x29, sp


        mov     x_r, -10
        mov     c1_r, -2
        mov     c2_r, -22
        mov     c3_r, 11
        mov     x23, 57
        mov     x24, 0
        mov     x25, 0
        mov     x26, -1000
	
	move:   mov     m_r, cm_r
	
        b       test

        top:    madd    x24, c3_r, x_r, x23
                mul     x25,  x_r, x_r
                mul     x25, x25, c2_r
                add     x24, x24, x25
                mul     x25, x_r, x_r
                mul     x25, x25, x_r
                madd    x26, x25, c1_r, x24

        test1:  cmp	cm_r, m_r
                b.gt    move
	
        mov     x1, x_r
        adrp    x0, fmt1
        add     x0, x0, :lo12:fmt1
        bl      printf
        mov     w0, 0

        mov     x1, cm_r
        adrp    x0, fmt2
        add     x0, x0, :lo12:fmt2
        bl      printf
        mov     w0, 0

        mov     x1, m_r
        adrp    x0, fmt
        add     x0, x0, :lo12:fmt
	bl      printf
        mov     w0, 0

	add     x_r, x_r, 1

	test:   cmp     x_r, 4
                b.le    top

exit:   mov     x1, m_r
        adrp    x0, fmt3
        add     x0, x0, :lo12:fmt3
	bl      printf
print:  mov     w0, 0
        ldp     x29, x30, [sp], 16
        ret

