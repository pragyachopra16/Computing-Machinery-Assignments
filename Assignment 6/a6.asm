define(x_r, d8)								//defining x by assigning it d8
define(totalx, d9)							//defining totalx by assigning it d9
define(accumulator, d10)						//defining accumulator by assigning it d10
define(increment, d11)							//defining increment by assigning it d11
define(xfraction, d12)							//defining xfraction by assigning it d12
define(total, d13)							//defining total by assigning it d13
define(one, d14)							//defining one by assigning it d14
define(fd, w19)								//defining fd by assigning it w19
define(argc_r, w20)							//defining argc_r by assigning it w20
define(argv_r, x21)							//defining argv_r by assigning it x21
define(n_read, x22)							//defining n_read by assigning it x22

fmt1:	.string "Input:\t\tln(x):\n"					//string to output heading
fmt2:	.string "%13.10f\t%13.10f\n"					//string to output the data
error1:	.string "Usage: ./a6 <filename.bin>\n"				//string to output invalid number of arguments error 
error2: .string "Error opening file. Aborting\n"			//string to output file open error

check:	.double 0r1.0e-13 						//constant for checking
check2:	.double 0r0.25							//constant for checking
float0:	.double 0r0.0							//constant 0 

	AT_FDCWD = -100							//for reading input from file
	buf_size = 8							//8-bytes for reading iputs
	alloc = -(16+buf_size) & -16					//allocating space on stack for buffer
	dealloc = -alloc						//dealloc is negative of alloc
	buf_s = 16							//starting of buffer in stack
	
	.balign 4							//aligning the code
	.global main							//making main global hence visible to OS

main:
	stp 	x29, x30, [sp, alloc]!					//Allocates stack space by pre incrementing SP to the value of alloc
	mov	x29, sp							//Update FP to current SP, saves the state
	
	mov	argc_r, w0						//copy argc(number of pointer)
	mov	argv_r, x1						//copy argv(base address to an array containing the args)

	cmp	argc_r, 2						//compare the number of arguments with 2
	b.eq	next							//if equal then jump to next
	
	adrp	x0, error1						//setting the first value higher
	add	x0, x0, :lo12:error1					//setting the second value lower
	bl	printf							//call printf
	b	exit							//jump to exit

next:	mov	w0, AT_FDCWD						//reading input from file
	ldr	x1, [argv_r, 8]						//2nd arg pathname
	mov	w2, 0							//3rd arg read only
	mov	w3, 0							//4th arg not used
	mov	w8, 56							//open at I/O request
	svc	0							//call system function
									
	mov	fd, w0							//record file descripter
	
	cmp	fd, 0							//compare it with 0
	b.ge	start							//if its greater than 0, continue, or else output error

	adrp	x0, error2						//setting the first value higher
	add	x0, x0, :lo12:error2					//setting the second value lower
	bl	printf							//call printf
	mov     w0,-1							//move -1 in w0
	b	exit							//jump to exit

start:	adrp	x0, fmt1						//setting the first value higher
	add	x0, x0, :lo12:fmt1					//setting the second value lower
	bl	printf							//call printf
	mov	w0, 0							//restoring registers

openok:
	mov	w0, fd							//1st arg fd
	add	x1, x29, buf_s						//2nd arg buf base
	mov	x2, buf_size						//3rd arg buf_size
	mov	x8, 63							//read I/O request
	svc	0							//call system function
	mov	n_read, x0						//record number of bytes actually read
	
	cmp	n_read, buf_size					//error checking for read
	b.ne	end							//if error then jump to end

	ldr	x_r, [x29, buf_s]					//load the first value from file
	adrp	x0, check2						//setting the first value higher
	add	x0, x0, :lo12:check2					//setting the second value lower
	fmov	d15, x0							//moving the value of check2(0.25) to d15
	fcmp	x_r, d15						//compare d15 and the input value
	b.le	openok							//if input value less than 0.25, jump to openok
	fmov	d0, x_r							//move the input value to d0
	bl	ln							//call ln
	fmov	d1, d0							//move the returned value to d1

	adrp	x0, fmt2						//setting the first value higher
	add	x0, x0, :lo12:fmt2					//setting the second value lower
	ldr	d0,[x29, buf_s]						//read the value from file
	bl	printf							//call printf

	b	openok							//jump to openok
end:	
	mov	w0, fd							//close binary file
	mov	x8, 57							//close file
	svc	0							//call system function


exit:	ldp	x29, x30, [sp], dealloc					//deallocating memory 
	ret								//restoring registers


	.global ln							//make ln global and hence visible to OS
	.balign 4							//align the code

ln:	stp 	x29, x30, [sp, -16]!                             	//Allocates stack space by pre incrementing SP to -16
	mov 	x29, sp                					//Update FP to current SP, saves the state
	adrp	x23, check						//setting the first value higher
	add	x23, x23, :lo12:check					//setting the second value lower
	ldr	d3, [x23]						//loading the value of check from memory
		
	fmov	totalx, 1.0						//move 1 to totalx
	fmov	one, 1.0						//move 1.0 to one
	fmov	increment, 1.0						//move 1.0 to increment
	adrp	x24, float0						//setting the first value higher
	add	x24, x24, :lo12:float0					//setting the second value lower
	fmov	accumulator, x24					//moving the value 0.0 from memory to accumulator
	fmov	x_r, d0							//move input value to x_r

	fmov	xfraction, x_r						//move value in x_r to xfraction
	fsub	xfraction, xfraction, one				//xfraction= x-1
	fdiv	xfraction, xfraction,x_r 				//xfraction= x-1/x
calc:	fmul    totalx, totalx, xfraction				//multiple xfraction with total x(keeps track of the power of x-1/x)
	fdiv	total, totalx, increment 				//divide by increment (keeps track of the total value)
	fadd	increment, increment, one 				//add 1 to increment
	fadd	accumulator, accumulator, total				//add total to accumulator (holds the ln value)
	fabs	total, total						//absolute value of total
	fcmp	total, d3						//if greater than check1, continue
	b.ge	calc

	fmov	d0, accumulator						//return value in accumulator
	ldp	x29, x30, [sp], 16					//deallocating memory 
	ret								//restoring registers
