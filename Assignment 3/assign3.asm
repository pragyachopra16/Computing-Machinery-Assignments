//Pragya Chopra (30076078): Assignment 3- organize an array in the stack using selection sort 
define(i, w19)						//Defining i by assigning it register w19
define(j, w20)						//Defining j by assigning it register w20
define(min, w21)					//Defining min by assigning it register w21
define(temp, w22)					//Defining temp by assigning it register w22
define(random, w23)					//Defining random by assigning it register w23
define(ia_base_r, x28)					//Defining ia_base_r by assigning it register x28


//String
array:		.string "v[%d]: %d\n"			//String to output the current array
sorted_array:	.string "\nSorted Array: \n"		//String to output the heading "Sorted Array"

array_size=50						//assigning 50 to array_size
alloc=-(16+16+200) & -16				//allocating 4 bytes each for i, j, min and temp and 200 bytes for the array
dealloc=-alloc						//deallocating the 4 bytes each for i, j, min and temp and 200 bytes for array
i_s=16							//stack offset for i is 16 (from fp)
j_s=20							//stack offset for j is 20 (from fp)
min_s=24						//stack offset for min is 21 (from fp)
temp_s=28						//stack offset for temp is 28 (from fp)

		fp	.req x29			//Defining x29 as fp
		lr	.req x30			//defining x30 as sp

		.balign 4				//Alligning the code
		.global main				//Makes it global hence visible to OS

main:		
		stp	x29, x30, [sp,alloc]!		//Allocates stack space by pre incrementing SP to the value of alloc
		mov	fp,sp				//Update FP to current SP, saves the state
		
		add	ia_base_r, fp, 32		//setting the offset of array to fp+32 (16+4+4+4+4)

		mov	i, 0				//move 0 to i
		str	i, [fp, i_s]			//store the value of i in the stack 

		b	test_1				//jump to lable test_1

forloop_1:	
		bl	rand				//call rand
		ldr	i, [fp, i_s]			//load the value of i from the stack
		and	random, w0, 0xFF		//AND value of random with 0xFF, so that the number is between 0 and 255
		str	random, [ia_base_r, i, SXTW 2]	//store the value of the random into the array in the stack v[i]

		mov	w1, i				//move the value of i into w1
		mov	w2, random			//move the value of random into w2
		adrp	x0, array			//setting the first value of printf higher
		add	x0, x0, :lo12:array		//setting the second value of printf lower
		bl	printf				//call printf
		mov	w0, 0				//restoring registers
		
		add	i, i, 1				//increment i	
		str	i, [fp, i_s]			//store the value of new i in the stack

test_1:							//for loop test 1
		cmp	i,array_size			//comparing the value of i and array_size
		b.lt	forloop_1			//if i is less than array_size, jump to lable forloop_1

		mov	i, 0				//move 0 to i
		str	i, [fp, i_s]			//store the value of new i to the stack
		b	test_2				//jump to test_2

forloop_2:						//starting of the secon forloop
		ldr	i, [fp,i_s]			//load the value of i from the stack
		mov	min, i				//move the value of i to min
		str	min, [fp, min_s]		//store the value of min to stack
	
		add	i,i,1				//increment i
		mov	j, i				//move the valie of i to j
		str	j, [fp, j_s]			//store the value of j to stack

		b	test_3				//jump to test_3

forloop_3:						//starting to the third forloop 
		ldr	j, [fp, j_s]			//load the value of j from the stack 
		ldr	min, [fp, min_s]		//load the value of min from the stack 
		ldr	w24, [ia_base_r, j, SXTW 2]	//load the value of v[j] from the array in the stack and store it in w24
		ldr	w25, [ia_base_r, min, SXTW 2]	//load the value of v[min] from the array in the stack and store it in w25
		cmp	w25, w24			//compare w25(v[min]) and w24(v[j])
		b.lt	increment			//if w25(v[min]) is less than w24(v[j]) then jump to increment 
		mov	min, j				//move the value of j into min
		str	min, [fp, min_s]		//store the value of min in the stack 

increment:						//increments j for the loop
		add	j,j,1				//increment j
		str	j, [fp, j_s]			//store th evalue of updated j in the stack 

test_3:							//test 3 for forloop_3
		cmp	j, array_size			//compare j and array_size
		b.lt	forloop_3			//if j is less than array_size then jump to forloop_3
		
		ldr	min, [fp, min_s]		//load the value of min from the stack 
		ldr	temp, [ia_base_r, min, SXTW 2]	//load the value of v[min] from the array in the stack and store it in temp
		str	temp, [fp, temp_s]		//store the value of temp to the stack
		ldr	i, [fp, i_s]			//load the value of i from the stack
		ldr	w26, [ia_base_r, i, SXTW 2]	//load the value of v[i] from the stack and store it in register w26
		str	w26, [ia_base_r, min, sxtw 2]	//store the value of v[i] in w26 to v[min] in the array in the stack
		ldr	temp, [fp, temp_s]		//load the value of temp from the stack
		str	temp, [ia_base_r, i, SXTW 2]	//store the value of temp at v[i] in the array in the stack 

		add	i, i, 1				//increment i
		str	i, [fp, i_s]			//store the value of updated i in the stack 
test_2:							//test_2 for forloop 2
		cmp	i, array_size-1			//compare the value of i and array_size-1
		b.lt	forloop_2			//if i is less than array_size-1 then jump to forloop_2

 		mov   	w1, 0				//move 0 to w1
                adrp    x0, sorted_array		//setting the first value of printf higher
                add     x0, x0, :lo12:sorted_array	//setting the first value of printf lower	
                bl      printf				//call printf
                mov     w0, 0				//restoring registers
		
		mov	i, 0				//move 0 to i
		str	i, [fp,i_s]			//update the value of i in the stack 
		b	test_print			//jump to test_print
print_array:						//loop to print the array
		ldr	i, [fp, i_s]			//load the value of i from the stack
		mov     w1, i				//move the valie of i to w1
		ldr	w27, [ia_base_r, i, SXTW 2]	//load the valu eof v[i] from the array in teh stack and store it in w27
                mov     w2, w27				//move the value of w27 to w2
                adrp    x0, array			//setting the first value of printf higher
                add     x0, x0, :lo12:array		//setting the first value of printf lower 
                bl      printf				//call printf
                mov     w0, 0				//restoring registers

		add	i,i,1				//increment i
		str	i, [fp,i_s]			//store the updated value of i in the stack 
test_print:						//test for the print loop
		cmp	i, array_size			//compare i and array_size
		b.lt	print_array			//if i is less than array_size then jump to print_array

		mov	w0, 0				//restoring registers
		ldp	fp, lr, [sp], dealloc		//restoring FP and SR
		ret					//return to caller
