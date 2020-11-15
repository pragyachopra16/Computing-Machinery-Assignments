define(month, w19)					//defining month by assigning it w19
define(year, x20)					//defining year by assigning it x20
define(date, w21)					//defining date by assigning it w21
define(argc_r, w22)					//defining argc_r by assigning it w22
define(argv_r, x28)					//defining argv_r by assigning it x28
		.text					//.text section
fmt:		.string "%s %d%s, %d\n"			//string to output date
error:		.string "usage: a5b mm dd yyyy\n"	//string to output error

jan_m:		.string "January"			//string to output january 
feb_m:		.string "Feburary"			//string to output feburary
mar_m:		.string "March"				//string to output march
apr_m:		.string "April"				//string to output april
may_m:		.string "May"				//string to output may
june_m:		.string "June"				//string to output june
july_m:		.string "July"				//string to output july
aug_m:		.string "August"			//string to output august
sept_m:		.string "September"			//string to output september
oct_m:		.string "October"			//string to output october
nov_m:		.string "November"			//string to output november
dec_m:		.string "December"			//string to output december

st_m:		.string "st"				//string to output st
nd_m:		.string "nd"				//string to output nd
rd_m:		.string "rd"				//string to output rd
th_m:		.string "th"				//string to output th
		
		.data					//.data section
//array of pointer, each pointer points to a string
month_m:	.dword jan_m, feb_m, mar_m, apr_m, may_m, june_m, july_m, aug_m, sept_m, oct_m, nov_m, dec_m

ext_m:		.dword st_m, nd_m, rd_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, st_m, nd_m, rd_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, st_m
	
		.text					//.text section
		.balign 4				//aligning the code
		.global main				//make main global

main:		stp	x29, x30, [sp,-16]!		//Allocates stack space by pre incrementing SP to -16
		mov	x29, sp				//Update FP to current FP, saves the state
		mov	argc_r, w0			//move first input given to method to argv_r
		mov	argv_r, x1			//move second input given to method to argc_r
		cmp	argc_r,4			//compare argc_r and 4
		b.lt	error_out			//if less that 4 then jump to error_out
		mov	w23, 1				//move 1 to w23
		mov	w24, 2				//move 2 to w24
		mov	w25, 3				//move 3 to w25

		ldr	x0, [argv_r, w23, SXTW 3]	//reading the month from the input given
		bl	atoi				//converts string to integer
		mov	month, w0			//move value in w0 to month

		ldr     x0, [argv_r, w24, SXTW 3]	//reading the date from input given
        	bl      atoi				//converts string to integer
        	mov     date, w0			//move value in w0 to date

		ldr     x0, [argv_r, w25, SXTW 3]	//reading year from the input given
        	bl      atoi				//converts string to integer
        	sxtw    x0, w0				//sign extension from w0 to x0
        	mov     year, x0			//move value in x0 to year

		cmp	month, 0			//compare month and 0
		b.le	error_out			//if month less than zero, jump to error_out
		cmp	month, 12			//compare month and 12
		b.gt	error_out			//if month greater than 12 then jump to error_out

		cmp	date, 0				//compare date and 0
		b.le	error_out			//if date less than zero, jump to error_out
		cmp	date, 31			//compare date and 31
		b.gt	error_out			//if date greater than 31, jump to error_out

		cmp	year,0				//compare year and 0
		b.le	error_out			//if year less than zero then jump to error_out


		adrp    x0, fmt				//setting first value lower
        	add     x0, x0, :lo12:fmt		//setting second value higher
		adrp    x26, month_m			//setting first value lower
        	add     x26, x26, :lo12:month_m		//setting second value higher
		sub	month, month, 1			//subtract one from month as month starts from 1 but index starts from 0
		ldr	x1, [x26, month, SXTW 3]	//load the month from the array
		mov	w2, date			//move date to w2
		sub	date, date, 1			//subtract one from date
		adrp    x27, ext_m			//setting first value lower
        	add     x27, x27, :lo12:ext_m		//setting second value higher
		ldr	x3, [x27, date, SXTW 3]		//load the extension from the array using the date
		mov	x4, year			//move year to x4
		bl	printf				//call printf
		mov	w0, 0				//restoring registers
		b	exit 				//jump to exit

error_out:
		adrp	x0, error			//setting first value lower
		add	x0, x0, :lo12:error		//setting second value higher
		bl	printf				//call printf
		mov	w0, 0				//restoring registers
		b	exit				//jumpt to exit

exit:
		ldp	x29, x30, [sp], 16		//restore FP and SR
		ret					//return to caller
