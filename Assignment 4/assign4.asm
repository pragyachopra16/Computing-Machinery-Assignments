//Pragya Chopra: 30076078					
//Assignment4: CPSC355

define(FALSE, 0) 							//Defining FALSE by assigning the value 0 to it
define(TRUE, 1)								//Defining TRUE by assigning the value 1 to it

//Struct point
x_s=0									//stack offset for x (from starting of struct)
y_s=4									//stack offset for y  (from starting of struct)
point_s=8								//size of struct point

//struct dimension
width_s=0								//stack offset for width (from starting of struct)
length_s=4								//stack offset for length (from starting of struct)
dimension_s=8								//size of struct dimension

//struct cuboid
origin_s=0								//stack offset for origin (struct point) 
base_s=8								//stack offset for base(struct dimension)
height_s=16								//stack offset for height
volume_s=20								//stack offset for volume
cuboid_size=24								//size od struct cuboid

cuboid_p:	.string "Cuboid %s origin = (%d, %d)\n"			//string to output origin and name of cuboid
base_p:		.string "\tBase width = %d  Base length = %d\n"		//string to output width and length of cuboid
height_p:	.string "\tHeight = %d\n"				//string to output height of cuboid
volume_p:	.string "\tVolume = %d\n\n"				//string to output volume of cuboid
name1_p:	.string "first"						//string to output the name "first"
name2_p:	.string "second"					//string to output the name "second"
initial:	.string "Initial cuboid values:\n"			//heading for outputing initial vales of cuboid
changed:	.string "\nChanged cuboid values:\n"			//heading for outputing changed values of cuboud

cuboid1_size=cuboid_size						//assigning cuboid 1 the size of cuboid
cuboid2_size=cuboid_size						//assigning cuboid 2 the size of cuboid
alloc=-(16+cuboid1_size+cuboid2_size)&-16				//allocating memory in stack for cuboid 1 and cuboid 2
dealloc=-alloc								//deallocating the memory in stack for cuboid 1 and cuboid 2
first_cuboid=16								//stack offset for cuboid 1 (from fp)
second_cuboid=first_cuboid+cuboid_size					//stack offset for cuboid 2 starts from the end of cuboid 1

		.global main						//make it global and hence visible to OS
                .balign 4						//aligning the code

main:								
		stp	x29, x30, [sp,alloc]!				//Allocates stack space by pre incrementing SP to the value of alloc
		mov	x29,sp						//Update FP to current SP, saves the state
		add	x8, x29, first_cuboid				//calculates the base address for cuboid 1 and stores it in x8
		bl	newCuboid					//calls the subroutine newCuboid to initiate cuboid 1
		add	x8, x29, second_cuboid				//calculates the base address for cuboid 2 and stores it in x8
		bl	newCuboid					//calls the subroutune newCuboid to initiate cuboid 2
		adrp	x0, initial					//Setting first argument of printf higher
		add	x0,x0, :lo12:initial				//Setting second argument of printf lower
		bl	printf						//calling printf to print initial string
		mov	w0,0						//restoring registers

		add	x2,x29, first_cuboid				//adding base address of cuboid 1 and storing it in x2
		adrp	x0, name1_p					//Setting first argument of printf higher
		add	x0,x0,:lo12:name1_p				//Setting second argument of printf lower
		bl	printCuboid					//calling printCuboid to print the first cuboid 
		mov	w0,0						//restoring registers

		add     x2,fp,second_cuboid				//adding base address of cuboid 2 and storing it in x2
        	adrp    x0, name2_p					//Setting first argument of printf higher
        	add     x0,x0,:lo12:name2_p				//Setting second argument of printf lower
        	bl      printCuboid					//calling printCuboid to print the second cuboid 
		mov	w0,0						//restoring registers

		add	x0, x29, first_cuboid				//adding base address of cuboid 1 and storing it in x0
		add	x1, x29, second_cuboid				//adding base address of cuboid 2 and storing it in x1
		bl	equalSize					//call subroutine equalSize
		mov	x21,x0						//move the value in x0 to x21
		cmp	x21,0						//compare the value in x21 with 0
		b.eq	print_c						//if the value in x21 is equal to zero then jump to print_c
	
		add     x0, x29, first_cuboid				//adding base address of cuboid 1 and storing it in x0
		mov	w1, 3						//move the value 3 into w1
		mov	w2,-6						//move the value -6 into w2
		bl	move						//call move

		add	x0, x29, second_cuboid				//adding base address of cuboid 2 and storing it in x0
		mov	w1,4						//move the value of 4 in w1
		bl	scale						//call subroutine scale
	
print_c:	adrp	x0, changed					//Setting first argument of printf higher
		add	x0,x0, :lo12:changed				//Setting second argument of printf lower
		bl	printf						//call printf to print the changed heading
		mov	w0,0						//restoring registers

		add     x2,x29, first_cuboid				//adding base address of cuboid 1 and storing it in x2
        	adrp    x0, name1_p					//Setting first argument of printf higher
        	add     x0,x0,:lo12:name1_p				//Setting second argument of printf lower
        	bl      printCuboid					//call subroutie printCuboid to print the changed cuboid 1
		mov	w0,0						//restoring registers

        	add     x2,x29,second_cuboid				//adding base address of cuboid 2 and storing it in x2
        	adrp    x0, name2_p					//Setting first argument of printf higher
        	add     x0,x0,:lo12:name2_p				//Setting second argument of printf lower
        	bl      printCuboid					//call subroutie printCuboid to print the changed cuboid 2
		mov	w0,0						//restoring registers
	
		ldp	x29, x30, [sp], dealloc				//restoring FP and SR
		ret							//return to caller

//Struct newcuboid begins
		alloc= -(16+cuboid_size)&-16				//allocating 24 bytes(cuboid_size) in stack for cuboid
		dealloc=-alloc						//deallocating 24 bytes(cuboid_size) in stack fro cuboid
		cuboid_s=16						//stack offset for cuboid
newCuboid:	stp	x29, x30, [sp,alloc]!				//Allocates stack space by pre incrementing SP to the value of alloc
		mov	x29, sp						//update the fp with the value of current SP

		add	x9, x29, cuboid_s				//calculating the base address for cuboid by adding cuboid offset to fp and storing it in x9
		mov	w19,2						//move the value 2 into w19
		mov	w20,3						//move the value 3 into w20
		str	wzr, [x9, origin_s+x_s]				//store the value 0 into c.origin.x
		str	wzr, [x9, origin_s+y_s]				//storing the value 0 into c.origin.y
		str	w19, [x9, base_s+width_s]			//storing the value of w19(2) into c.base.width
		str	w19, [x9, base_s+length_s]			//storing the value of w19(2) into c.base.length
		str	w20, [x9, height_s]				//storing the value of w20(3) into c.height
		ldr	w21, [x9, base_s+width_s]			//load register w21 with the value of c.base.width
		ldr	w22, [x9, base_s+length_s]			//load register w22 with the value of c.base.length
		ldr	w23, [x9, height_s]				//load register w23 witht the value of c.height
		mul	w21, w21, w22					//multiply the value stored in register w21(2) and w22(2) and store it in w21
		mul	w21, w21, w23					//multiply the current value of w21 and w23(3) and store it in w21
		str	w21, [x9, volume_s]				//store the current value of w21 in c.volume
		ldr	x10, [x9, origin_s+x_s]				//load the value of c.origin.x into x10
		str	x10, [x8, origin_s+x_s]				//store the value of c.origin.x into main stack
		ldr	x10, [x9, origin_s+y_s]				//load the value of c.origin.y into x10
		str	x10, [x8, origin_s+y_s]				//store the value of c.origin.y into main stack
		ldr	x10, [x9, base_s+width_s]			//load the value of c.base.width into x10
		str	x10, [x8, base_s+width_s]			//store the value of c.base.width into main stack
		ldr	x10, [x9, base_s+length_s]			//load the value of c.base.length into x10
		str	x10, [x8, base_s+length_s]			//store the value of c.base.length into main stack
		ldr	x10, [x9, height_s]				//load the value of c.height into x10
		str	x10, [x8, height_s]				//store the value of c.height into main stack
		ldr	x10, [x9, volume_s]				//load the value of c.volume into x10
		str	x10, [x8, volume_s]				//store the value of c.volume into main stack
		
		ldp	x29, x30, [sp], dealloc				//restoring FP and SR
		ret							//return to caller
//Struct newCuboid ends

//Struct move begins
move:		stp	x29, x30, [sp,-16]!				//allocating memory for stack
		mov	x29, sp						//update the fp with the value of current SP
		
		mov	w22,w1						//move the value of w1 into w22
		mov	w23,w2						//move the value of w2 into w23
		ldr	w24,[x0, origin_s+x_s]				//load w24 with the value of c.origin.x from stack
		add	w24, w24, w22					//add the value in w24 and w22 and store in w24
		str	w24,[x0, origin_s+x_s]				//store the value in c.origin.x in stack
		ldr	w25,[x0, origin_s+y_s]				//load w25 with the value of c.origin.y from stack
		add	w25, w25, w23					//add the values in w23 and w25 and store it in w25
		str	w25,[x0, origin_s+y_s]				//store the value of in c.origin.y in stack

		ldp	x29, x30, [sp], 16				//deallocating memory for stack
		ret							//return to caller
//Struct move ends

//Struct scale begins
scale:		stp	x29,x30, [sp,-16]!				//allocating memory for stack
		mov	x29, sp						//update the fp with the value of current SP

		mov	w22,w1						//move the value of w1 into w22
		ldr	w23,[x0, base_s+width_s]			//load w24 with the value of c.base.width from stack
		mul	w23, w23, w22					//multiply the values stored in w23 and w22 and store in w23
		str	w23,[x0, base_s+width_s]			//store the value of w23 in c.base.width in stack
		ldr	w24,[x0, base_s+length_s]			//load w24 with the value of c.base.length from stack
		mul	w24,w24,w22					//multiply the values stored in w24 and w22 and store in w24
		str	w24,[x0, base_s+length_s]			//store the value of w24 in c.base.length in stack
		ldr	w25,[x0, height_s]				//load w24 with the value of c.height from stack
		mul	w25, w25, w22					//multiply the values in w22 and w25 and store in w25
		str	w25,[x0, height_s]				//store the value in w25 in c.height in stack
		mul	w26, w23, w24					//multiply the values in w23(c.base.width) and w24(c.base.length)  and store in w26
		mul	w26, w26, w25					//multiply the current value of w26 with value in w25(c.length) and store in w26
		str	w26,[x0, volume_s]				//store the value of w26 into c.volume in stack

		ldp	x29, x30, [sp], 16				//deallocate memory for stack
		ret							//return to caller
//Struct scale ends

//Struct printCuboid begins
printCuboid:	stp	x29, x30, [sp, -16]!				//allocate memory for stack
		mov	x29, sp						//update the fp with the value of current SP
		
		mov	x1, x0						//move the value of x0 into x1
		mov	x19,x2						//move the value of x2 into x19
		ldr	w2, [x19, origin_s+x_s]				//load the value of c.origin.x from stack and store it in w2
		ldr 	w3, [x19, origin_s+y_s]				//load the value of c.origin.y from stack and store it in w3
		adrp	x0, cuboid_p					//setting the first value of printf higher
		add	x0, x0, :lo12:cuboid_p				//setting the second value of printf lower
		bl	printf						//calling the printf function to print the cuboid 
		mov	w0,0						//restoring registers

		ldr	w1, [x19, base_s+width_s]			//load the value of c.base.width from stack into w1
		ldr	w2, [x19, base_s+length_s]			//load the value of c.base.length from stack into w2
		adrp	x0, base_p					//setting the first value of printf higher
		add	x0, x0, :lo12:base_p				//setting the second value of printf lower
		bl	printf						//calling the printf function to print the base
		mov 	w0,0						//restoring registers

		ldr	w1, [x19, height_s]				//load the value of c.height from stack to w1
		adrp	x0, height_p					//setting the first value of printf higher
		add	x0, x0, :lo12:height_p				//setting the second value of printf lower
		bl	printf						//calling printf to print the height
		mov	w0,0						//restoring registers

		ldr     w1, [x19, volume_s]				//load the value of c.volume from stack to w1
                adrp    x0, volume_p					//setting the first value of printf higher
                add     x0, x0, :lo12:volume_p				//setting the second value of printf lower
                bl      printf						//calling printf to print volume
                mov     w0,0						//restoring registers
		
		ldp	x29, x30, [sp], 16				//deallocating memory for stack
		ret							//restoring registers
//Struct printCuboid ends

//Struct equalSiz begins
equalSize:	stp     x29, x30, [sp, -16]!				//allocate memory for stack
                mov     x29, sp						//update the fp with the value of current SP
		
		ldr	w19,[x0, base_s+width_s]			//load register w19 with width of cuboid 1
		ldr	w20,[x1, base_s+width_s]			//load register w20 with width of cuboid 2
		cmp	w19,w20						//compare the values in w19 and w20
		b.ne	result_f					//if not equal then jump to result_f

		ldr	w21,[x0, base_s+length_s]			//load register w21 with length of cuboid 1
		ldr	w22,[x1, base_s+length_s]			//load register w22 with length of cuboid 2
		cmp	w21,w22						//compare the values in w21 and w22
		b.ne	result_f					//if not equal then jump to result_f

		ldr	w23,[x0, height_s]				//load register w23 with height of cuboid 1
		ldr	w24,[x1, height_s]				//load register w24 with height of cuboid 2
		cmp	w23, w24					//compare the values in w23 and w24
		b.ne	result_f					//if not equal then jump to result_f

		mov	x0, TRUE					//move the value of true(1) into x0
		b	done_eq						//jump to done_eq

result_f:	mov	x0, FALSE					//move the value of false(0) into x0

done_eq:	ldp     x29, x30, [sp], 16				//deallocating memory for stack
                ret							//restoring registers
//Struct equalSize ends

		
		
