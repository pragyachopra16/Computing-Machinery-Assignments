MAXOP = 20								//declaring constant MAXOP=20
NUMBER = 0								//declaring constant NUMBER=0
TOOBIG = 9								//declaring constant TOOBIG=9
MAXVAL = 100								//declaring constant MAXVAL=100
BUFFSIZE = 100								//declaring constant BUFFSIZE=100

stack_f:        .string "error: stack full\n"				//string to output stack full
stack_e:        .string "error: stack empty\n"				//string to output stack empty 
too_char:       .string "ungetch: too many characters\n"		//string to output too many characters

                .data							//begin .data section

                .global sp_r						//declare sp_r global
sp_r:           .word 0							//create the global variable with initial value 0

                .global val						//declare val global
val:            .skip 4*MAXVAL						//create global variable

                .global bufp						//declare bufp global
bufp:           .word 0 						//create the global variable with initial value 0

                .global buf						//declare buff global
buf:            .skip 1*BUFFSIZE					//create global variable

                .text							//begin .text section
                .balign 4						//aligning the code

                .global push						//declaring push as global
push:
                stp     x29, x30, [sp, -16]!				//Allocates stack space by pre incrementing SP to -16
                mov     x29, sp						//Update FP to current SP, saves the state
                mov     w9, w0						//move the value in w0(the value given to the method) to w9
                mov     w10, MAXVAL					//move the value of constant maxval in w10
                adrp    x11, sp_r					//setting the first value higher
                add     x11, x11, :lo12:sp_r				//setting the second value lower
                ldr     w15, [x11]					//load the contents of x11 in memory to w15
               	cmp     w15, w10					//compare contents of w15 and w10
		b.ge    error_f						//if contents of w15 are greater then go to error_f         
                adrp    x12, val					//setting the first value higher
                add     x12, x12, :lo12:val				//setting the second value lower
                str     w9, [x12, w15, SXTW 2]				//store the contents of w9 at val[sp++]
                add     w15, w15, 1					//incrementing sp_r
                adrp    x11, sp_r                                       //setting the first value higher
                add     x11, x11, :lo12:sp_r                            //setting the second value lower
                str     w15, [x11]					//storing the incremented value in memory
		b       push_end					//jump to push_end
error_f:        adrp    x0, stack_f					//setting the first value higher
                add     x0, x0, :lo12:stack_f				//setting the second value lower
                bl      printf						//call printf
                bl      clear						//call clear
                mov     w0, 0						//restoring registers
push_end:       ldp     x29, x30, [sp], 16				//restoring FP and SR
                ret							//return to caller

                .global pop						//declaring pop as global
pop:
                stp     x29, x30, [sp, -16]!				//Allocates stack space by pre incrementing SP to -16
                mov     x29, sp						//Update FP to current SP, saves the state
                adrp    x9, sp_r					//setting the first value higher
                add     x9, x9, :lo12:sp_r				//setting the second value lower
                ldr     w15, [x9]					//load the contents of x9 in memory to w15
                cmp     w15, 0						//compare contents in w15 to 0
                b.le    error_e						//if contents in w15 less than 0, jump to error_e
		sub     w15, w15, 1					//decrementthe contents in w15
                str     w15, [x9]					//store the decremented value in memory
                adrp    x10, val					//setting the first value higher
                add     x10, x10, :lo12:val				//setting the second value lower
                ldr     w11, [x10, w15, SXTW 2]				//load the contents of val[sp--] in w11
                mov     w0, w11						//move contents of w11 to w0
		b       pop_end						//jump to pop_end
error_e:        adrp    x0, stack_e					//setting the first value higher
                add     x0, x0, :lo12:stack_e				//setting the second value lower
                bl      printf						//call printf
                bl      clear						//call clear
                mov     w0,0						//restoring registers
pop_end:        ldp     x29, x30, [sp], 16				//restoring FP and SR
                ret							//return to caller
		
		.global clear						//declaring clear global
clear:
		stp     x29, x30, [sp, -16]!				//Allocates stack space by pre incrementing SP to -16
                mov     x29, sp						//Update FP to current SP, saves the state
		adrp    x19, sp_r					//setting the first value higher
                add     x19, x19, :lo12:sp_r				//setting the second value lower
                ldr     w28, [x19]					//load contents of x9 in memory to w15
		mov	w28, 0						//move 0 to w15
		str	w28, [x19]					//store the updated value to memory
		ldp     x29, x30, [sp], 16				//restoring FP and SR
                ret							//return to caller

//		.global getop						//declaring getop global
//getop:
//		i_size=4						//declaring size of i =4
//		c_size=4						//declaring size of c =4
//		s_size=8						//declaring size of s =8
//		lim_size=4						//declaring size of lim =4
//
//		s_m=16							//offset of s
//		lim_m=24						//offset of lim
// 		c_m=28							//offset of 
// 		i_m=32							//offset of i
// 
// 		alloc= -(16+i_size+c_size+s_size+lim_size) &-16		//allocating memory in stack
// 		dealloc= -alloc						//dalloc is - of alloc

// 		stp     x29, x30, [sp, alloc]!				//Allocates stack space by pre incrementing SP to alloc
//              mov     x29, sp						//Update FP to current SP, saves the state
// 		mov   	X19, x0						//move the value of s in x0 to x19
// 		str     x19, [x29,s_m]					//store the value to stack
// 		mov     w20, w1						//move the value of lim in w1 to w20
// 		str	w20, [x29, lim_m]				//store the value to stack
//while:	bl      getch						//call getch
// 		mov     w21, w0 					//mov the value of c in w0 to w21
// 		str	w21, [x29, c_m]					//store the value in stack
// 		cmp     w21, ' '					//compare c to ' '
// 		b.eq    while						//if equal, jump to while
// 		cmp     w21, '\t'					//compare c to '\t'
// 		b.eq    while						//if equal, jump to while
// 		cmp     w21, '\n'					//compare c to '\n'
// 		b.eq    while						//if equal, jump to while
// 		cmp     w21,'0'						//compare c to '0'
// 		b.ge	next						//if c greater than or equal to '0' jump to next
//next:		cmp     w21, '9'					//compare c to '9'
// 		b.le    skip 						//if c is less than or equal to 9, jump to skip
// 		mov     w0, w21						//move the value of c to w0
// 		b       getop_end					//jump to getop_end
//skip:		ldr     x19, [x29, s_m]					//load value of s from memory
// 		str     w21, [x29, s_m]					//store c at s[0]
// 		mov     w22, 1						//move the value 1 to w22	
// 		str     w22, [x29, i_m]					//store new value of i in memory
//loop_test:	bl      getchar						//call getchar
// 		mov     w21, w0						//move the new value of c to w21
// 		str	w21, [x29, c_m]					//store the new value of c in memory
// 		cmp     w21,'9'						//compare c to 9
// 		b.gt   	for_loop2					//if greater than, jump to forloop_1
// 		cmp     w21, '0'					//compare c to 0
// 		b.lt	for_loop2					//if less than, jump to forloop_1
//forloop_1:	ldr     w20, [x29, lim_m]				//load value of lim from memory to w20
// 		ldr     w22, [x29, i_m]					//load value of i from memory to w22
// 		ldr     w21, [x29, c_m]					//load value of c from memory to w21
// 		cmp     w22, w20					//compare contents of w22 and w20
// 		b.ge    increment					//if i>=lim, jump to increment
// 		ldr     x19, [x29, s_m]					//load value of s from memory
// 		str     w21, [x29, w22, SXTW 2]				//s[i]=c
//increment:	ldr     w22, [x29, i_m]					//load value of i from memory
// 		add     w22, w22, 1					//increment i
// 		str     w22, [x29, i_m] 				//store the incremented value of i back to memory
// 		b       loop_test					//jump to loop_test
//for_loop2:	ldr     w20, [x29, lim_m]				//load value of lim from memory
// 		ldr     w22, [x29, i_m]					//load value of i from memory
// 		cmp     w22, w20					//compare i and lim
// 		b.ge	if1						//if i greater than or equal to lim, jump to if1
// 		ldr     w21, [x29, c_m]					//load value of c from memory to w21
// 		mov     w0, w21						//move the value of c to w0
// 		bl      ungetch						//call ungetch
// 		ldr     w22, [x29, i_m] 				//load value of i from memory to w22
// 		mov     w23, '\0'					//move '\0' to w23
// 		ldr     x19, [x29, s_m]					//load value of s from memory to x19
// 		str     w23, [x19, w22, SXTW 2]				//s[i]='\0'
// 		mov     w0, NUMBER					//move the value of number to w0
// 		b       getop_end					//jump to getop_end
//if1:		ldr     w21, [x29, c_m]					//load value of c from memory to w21
// 
// 		cmp     w21, '\n'					//compare c to '\n'
// 		b.eq	else						//if equal jump to else
// 		cmp     w21, -1						//compare c to -1(EOF)
// 		b.eq    else						//if equal, jump to else
// 		bl      getchar						//call getchar
// 		mov     w21, w0						//move the value of c to w21
// 		str     w21, [x29, c_m]					//store it in memory
// 		b	if1						//jump to if1
//else:		ldr     x19, [x29, s_m]					//load value of s from memory to x19
// 		ldr     w20, [x29, lim_m]				//load value of lim from memory to w20
// 		sub     w20, w20, 1					//decrement lim
// 		mov     w23, '\0'					//move '\0' to w23
// 		str     w23, [x19, w20, SXTW 2]				//s[lim-1]='\0'
// 		mov     w0, TOOBIG					//move value of toobig to w0
// getop_end:	ldp     x29, x30, [sp], dealloc				//restore FP and SR
//              ret							//return to caller

                .global getch						//declare getch global
getch:
                stp     x29, x30, [sp, -16]!				//Allocates stack space by pre incrementing SP to -16
                mov     x29, sp						//Update FP to current SP, saves the state
                adrp    x9, bufp					//setting the first value higher
                add     x9, x9, :lo12:bufp				//setting the second value lower
                ldr     w15, [x9]					//load the value of bufp from memory to w15
                cmp     w15, 0						//compare bufp and 0
                b.le    get_char					//if bufp less than or equal to 0 then jump to get_char
                sub     w15, w15, 1					//decrememnt bufp
                str     w15, [x9]					//store decremented value in memory
                adrp    x10, buf					//setting the first value higher
                add     x10, x10, :lo12:buf				//setting the second value lower
                ldr     w11, [x10, w15, SXTW 2]				//load value of buf[bufp--] to w11
                mov     w0, w11						//mov buf[bufp--] to w0
                b       getch_end					//jump to getch_end
get_char:       bl      getchar						//call getchar
getch_end:      ldp     x29, x30, [sp], 16				//restore FP and SR
                ret							//return to caller

                .global ungetch						//declare global ungetch
ungetch:
                stp     x29, x30, [sp, -16]!				//Allocates stack space by pre incrementing SP to -16
                mov     x29, sp						//Update FP to current SP, saves the state
                mov     w9, w0						//move value of c to w9
                adrp    x10, bufp  					//setting the first value higher
                add     x10, x10, :lo12:bufp				//setting the second value lower
                ldr     w15, [x10]					//load value of bufp from memory
                mov     w11, BUFFSIZE					//move th evalue of buffsize to w11
                cmp     w15, w11					//compare bufp and buffsize
                b.le    else2						//if bufp<=buffsize, jump to else2
                adrp    x0, too_char					//setting the first value higher
                add     x0, x0, :lo12:too_char				//setting the second value lower
                bl      printf						//call printf
                b       ungetch_end					//jump to ungetch_end
else2:          adrp    x12, buf					//setting the first value higher
                add     x12, x12, :lo12:buf				//setting the second value lower
                str     w9,[x12, w15, SXTW 2]				//buf[bufp++]=c
                add     w15, w15, 1					//increment bufp
                str     w15, [x10]					//store in memory
ungetch_end:    ldp     x29, x30, [sp], 16				//restore FP and SR
		ret 							//return to caller
