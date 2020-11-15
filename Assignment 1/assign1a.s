fmt:	.string "Maximum: %ld\n\n"
fmt1:	.string "x value: %ld\n"
fmt2:	.string "y value: %ld\n"
fmt3:	.string "The Maximum is: %ld\n\n"

	.balign 4
	.global main

main:	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	
	mov	x19, -10 //stores the x valuea
	mov	x20, -2 //constant value for multiplication
	mov	x21, -22 
	mov	x22, 11
	mov	x23, 0 // stores the value of -2x^3
	mov	x24, 0 // stores value of -22x^2
	mov	x25, 0 // stores value of 11x
	mov	x26, -1000 //stores value of current max

	move:	mov	x27, x26 //x27 stores value of max 

	test:	cmp	x19, 4
		b.gt	exit
	
	// Calculations for -2x^3	
	mul	x23, x19, x19
	mul	x23, x23, x19
	mul	x23, x23, x20

	// Calculations for -22x^2
	mul	x24, x19, x19
	mul	x24, x24, x21

	// Calculations for 11x
	mul	x25, x19, x22

	// final addition of all terms
	add	x26, x23, x24
	add	x26, x26, x25
	add	x26, x26, 57


	test1:	cmp	x26, x27
		b.gt	move

	// printing for each itertion 
	mov	x1, x19	
	adrp	x0, fmt1
	add	x0, x0, :lo12:fmt1
	bl	printf
	mov	w0, 0

	mov	x1, x26
	adrp	x0, fmt2
	add	x0, x0, :lo12:fmt2
	bl	printf
	mov	w0, 0

	mov	x1, x27
	adrp	x0, fmt
	add	x0, x0, :lo12:fmt
	bl	printf
	mov	w0, 0
	
	add	x19, x19, 1

	b	test

exit:	mov     x1, x27
        adrp    x0, fmt3
        add     x0, x0, :lo12:fmt3
        bl      printf
        mov     w0, 0
	ldp	x29, x30, [sp], 16
	ret
