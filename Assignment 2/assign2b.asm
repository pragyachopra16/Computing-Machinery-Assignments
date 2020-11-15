//assign2b 
//To implement integer multiplication using shift and add

//Define Macros 
define(FALSE,0)                                                                         //Defining FALSE by assigning the value 0 to it
define(TRUE,1)                                                                          //Defining TRUE by assigning the value 1 to it

//32-bit registers
define(multiplier, w19)                                                                 //Defining multiplier by assigning it w19 register
define(multiplicand, w20)                                                               //Defining multiplicand by assigning it w20 register
define(product, w21)                                                                    //Defining product by assigning it w21 register
define(i, w22)                                                                          //Defining i by assigning it w22 register
define(negative, w23)                                                                   //Defining negative by assigning it w23 register

//64-bit registers
define(result, x24)                                                                     //Defining result by assigning it x24 register
define(temp1, x25)                                                                      //Defining temp1 by assigning it x25 register
define(temp2, x26)                                                                      //Defining temp2 by assigning it x26 register

//Defining the strings
initialvalue:   .string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"       //String to output initial value
productmulti:   .string "product = 0x%08x  multiplier = 0x%08x  \n"                     //String to output product and multiplier
result64bit:    .string "64-bit result = 0x%016lx (%ld)\n"                              //String to output 64-bit result

                .balign 4                                                               //Alligns the code
                .global main                                                            //Makes it global hence visible to OS

main:
                stp     x29, x30, [sp, -16]!                                            //Allocates stack space by pre incrementing SP to -16
                mov     x29, sp                                                         //Update FP to current FP, saves the state

                mov     multiplicand, 522133279                                         //Initializes the multiplicant to 522133279
                mov	multiplier, 200                                                 //Initializes the multiplier to 200
                mov     product, 0                                                      //Initializes the product to 0

//Printing initial values
                mov     w1, multiplier                                                  //Moving the value of multiplier into w1
                mov     w2, multiplier                                                  //Moving the value of multiplier into w2
                mov     w3, multiplicand                                                //Moving the value of multiplicand into w3
                mov     w4, multiplicand                                                //Moving the value of multiplicand into w4
                adrp    x0, initialvalue                                                //Setting first argument of printf higher
                add     x0, x0, :lo12:initialvalue                                      //Setting second argument of printf lower
                bl      printf                                                          //Calling printf to print the inital value
                mov     w0, 0                                                           //restoring registers

//Check if multiplier is negative
                cmp     multiplier, 0                                                   //Comparing the value of the multiplier and 0 
                b.ge    setF                                                            //If multiplier is greater than or equat to 0 then jump to setF 
                cmp     multiplier, 0                                                   //Comparing the value of the multiplier and 0
                b.lt    setT                                                            //If multiplier is less than 0 then jump to setT 
setF:
                mov     negative, FALSE                                                 //Moves the value FALSE to negative
                b       forloop								//Jump to forloop
setT:
                mov     negative, TRUE                                                  //Moves the value TRUE to negative
                b       forloop								//jump to forloop

//repeated add shift
forloop:
                mov     i, 0                                                            //Moves the value 0 to i
                b       maincheck                                                       //jump to maincheck 
if1:                                                                                    //First if condition
                tst     multiplier, 0x1                                                 //compare multiplier and 1
                b.eq    if2                                                             //if multiplier and 1 is equal to 0 then jump to if2
                add     product, product, multiplicand                                  //otherwise product=product+multiplicand


if2:                                                                                    //Second if condition
                asr     multiplier, multiplier, 1                                       //arithmetic shift right of the multiplier
                tst     product, 0x1                                                    //compare product and 1
                b.eq    andf                                                            //if product and 1 is equal to 0 then jump to andf
                orr     multiplier, multiplier, 0x80000000                              //execute multiplier or 1000...0000(32 bits)
                b       increment                                                       //jump to increment

andf:
                and     multiplier, multiplier, 0x7FFFFFFF                              //execute multiplier and 1111...1111(32bits)

increment:
                asr     product, product, 1                                             //arithmetic shift right of the product
                add     i, i, 1                                                         //execute i=i+1


maincheck:
                cmp     i, 32                                                           //compare i and 32
                b.lt    if1                                                             //if i is less than 32 then jump to if1
//For loop ends

                cmp     negative, TRUE                                                  //compare negative and true
                b.ne    printpm                                                         //if negative is not equal to true then jump to printpm
                sub     product, product, multiplicand                                  //execute product=product-multiplicand

printpm:
                mov     w1, product                                                     //move the value of product to w1
                mov     w2, multiplier                                                  //move the value of multiplier to w2
                adrp    x0, productmulti                                                //setting the first value of printf higher
                add     x0, x0, :lo12:productmulti                                      //setting the second value of printf lower
                bl      printf                                                          //call printf
                mov     w0, 0                                                           //restoring registers

//Combine product and multiplier together

                sxtw    temp1, product                                                  //sign extended word moves value of product and its sign to temp1 (from 32 bit to 64 bit)
                and     temp1, temp1, 0xFFFFFFFF                                        //executes temp1 and 1111....1111
                lsl     temp1, temp1, 32                                                //logical shift right of the bits
                sxtw    temp2, multiplier                                               //sign extended word moves value of multiplier and its sign to temp2 (from 32 bit to 64 bit)
                and     temp2, temp2, 0xFFFFFFFF                                        //executes temp2 and 1111....1111
                add     result, temp1, temp2                                            //executes result= temp1+temp2

                mov     x1, result                                                      //move the value of result to x1
                mov     x2, result                                                      //move the value of result to x2
                adrp    x0, result64bit                                                 //setting the first value of printf higher
                add     x0, x0, :lo12:result64bit                                       //setting the second value of printf lower
                bl      printf                                                          //call printf
                mov     w0,0                                                            //restoring registers
                ldp     x29, x30, [sp], 16                                              //restoring FP and SR
                ret                                                                     //return to caller
                   
