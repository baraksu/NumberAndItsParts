; -  Find Number Divisors   -
; - Written by Yonatan Daga -

.MODEL	small
.STACK	100h

.DATA
	prompt		db	'Enter a 4-digit number: $'	; prompt to be printed
	minus		dw 	0				; 1 if the input is a negative number
	
	str_len		dw 	5				; string length
	num_str		db 	5 dup(0) 			; the input number as a string
	num_final	dw 	0				; the input number as a number
	
	my_string	db 	'$$$$$$'			; a string that its content change. used to print different things.
	len		db 	5				; the string's length
	
	backup	 	dw 	0     				; used to backup different registers in the code
	
	new_line	db 	13,10,'$'			; different characters to be printed in the appropriate time
	divide	 	db 	'  : $'
	equal		db 	' = $'
	comma		db 	' , $'
	minus_symbol	db 	'-$'

	main		dw 	0				; will store the first number of every equation
	second	 	dw 	0				; will store the second number of every equation
	result	 	dw 	0				; will store the result of every equation
	remain	 	dw 	0				; will store the remainder of every equation
	
	message		db 	'*****************************',13,10,'---- Find Number Divisors ---',13,10,'-- Written by Yonatan Daga --',13,10,'*****************************',13,10,13,10,'$'
	
.CODE
	mov	ax, @data
	mov	ds, ax
	
	; PRINT 1ST MESSAGE
	push	offset message
	call	print	
	; PRINT PROMPT:
	push	offset prompt
	call	print
	
	; GET 4-DIGIT INPUT:
	mov	cl, 0
	input:
		; get input
		mov	ah, 01h
		int	21h
		
		; load offset into bx
		mov	bx, offset num_str
		
		; get to the correct element
		mov	ch, 0
		add	bx, cx
		
		; load input into array
		mov	[bx], al
	
	cmp	cl, 3
	jae	end_loop
	inc	cl
	jmp	input
	
	end_loop:
	; empty label
	

	; CHECK FOR A MINUS SIGN:
	call	check_minus
	
	push	offset new_line
	call	print
	
	; CONVERT STR TO NUM:
	push	offset num_str 
	push	str_len
	call	str_to_num
	
	push	num_final
	call	printDivisors
	
	exit:
		mov	ah, 4ch
		int	21h


	; Procedure 1:	Print
	; Gets:		1. String	| Reference
	; Prints the string to the console.

	print proc 
		; backup registers
		push	bp
		push	ax
		push	dx
		
		mov	bp, sp	; use bp as the stack pointer
		
		; CURRENT STACK STATE:
		;  [BP+0] - dx backup
		;  [BP+2] - ax backup
		;  [BP+4] - bp backup
		;  [BP+6] - return address
		;  [BP+8] - string reference
		
		; Print the string
		mov	ah, 09h
		mov	dx, [bp+8]
		int	21h
		
		; Restore registers 
		pop	dx
		pop	ax
		pop	bp
		
		ret 
	print endp
	
	
	; Procedure 2: Check minus
	; 	Checks for a minus sign in string "num_str".
	; 	If there is a minus:
	;		1. Gets another digit as an input, adds it to the string.
	; 		2. Sets "minus" var to 1.

	check_minus proc
		; backup registers
		push	bx
		push	ax
		
		cmp	num_str, '-'
		je	another_digit
		jne	end_proc
		
		another_digit:
			mov	bx, offset minus
			mov	[bx], 1
			
			; get input
			mov	ah, 01h
			int	21h
			
			; get to the correct element
			mov	bx, offset num_str
			add	bx, 4
			
			; add input to arr
			mov	[bx], al

		end_proc:
			; restore registers
			pop	ax
			pop	bx
			ret
	check_minus endp
	
	
	; Procedure 3: Convert String to Number
	; Gets:		1. String containing a number	| Reference
	; 		2. Length 			| Value
	; Sets variable "num_final" to the number inside the string.
	
	str_to_num proc
		; backup registers
		push ax
		push bx
		push cx
		push dx
		push bp
		push si
		
		mov bp, sp
		
		; CURRENT STACK STATE:
		;	[BP+0]  - SI Backup
		;	[BP+2]  - BP Backup
		;	[BP+4]  - DX Backup
		; 	[BP+6]  - CX Backup
		;	[BP+8]  - BX Backup
		;	[BP+10] - AX Backup
		; 	[BP+12] - Return Address
		; 	[BP+14] - String Length
		; 	[BP+16] - String Reference
		
		mov ax, [bp+14]		; str len
		sub ax, 1
		add ax, minus
		
		mov bx, [bp+16]		; str reference
		mov dx, 1000	
		
		mov cx, minus 		; loop counter - starts from 1 if there's a minus in the string
		my_loop:
			mov bx, [bp+16]	; reset bx to str reference
			add bx, cx	; get to the right element
			sub [bx], 30h	; convert char to digit
			
			; backup registers
			push ax
			push bx
			push cx
			push dx
			
			; MULTIPLY [BX] BY DX
			mov ax, [bx]
			mov ah, 0
			mul dx		; ax now stores the result
			
			mov bx, offset num_final
			add [bx], ax
			
			pop dx 		; restore dx
			
			; DIVIDE DX BY 10
			mov ax, dx
			mov cl, 10
			div cl
			mov ah, 0
			mov dx, ax
			
			pop cx
			pop bx
			pop ax
			
			inc cx
			
		cmp cx, ax
		jb my_loop
		
		; if minus=1, make num_final negative.
		;cmp minus, 1
		;jne end_proc3
		;neg num_final
		
		end_proc3:
			; restore registers
			pop si
			pop bp
			pop dx
			pop cx
			pop bx
			pop ax	
			ret
	str_to_num endp
	

	; Procedure 4: Convert Number to String
	; Gets:		1. Number	| Value
	; 		2. String	| Reference
	; Converts the number to string, puts it in the reference.
	
	proc num_to_str
		push bp
		mov  bp, sp
		push cx
		push bx
		mov  ax, [bp+4]
		mov  si, [bp+6]
		mov  bx, 10
		xor  cx, cx
    	
		digit1:
			xor  dx, dx
			test ax, ax
			jns  positive
			neg ax
			mov byte ptr [si], '-'
			inc si
		positive:
			div  bx
			push dx
			inc  cx
			cmp  ax,0
			jne  digit1
		convdigit:
			pop  dx
			add  dl, 30h
			mov  [si], dl
			inc  si
			loop convdigit
		pop  bx
		pop  cx
		pop  bp
		ret  4
	endp num_to_str


	; Procedure 5: Reset String
	; Sets every value of "my_string" to '$'.

	proc resetStr
		push bp
		mov bp, sp
		
		mov al, len
		xor ah,ah
		inc ax
		reset_str8:
			dec ax
			mov bx, offset my_string
			add bx, ax
			mov [bx], '$'
		cmp ax, 0
		ja reset_str8

		pop bp
		ret
	endp resetStr
	
	
	; Procedure 6: Print Divisors
	; Gets:		1. Number	| Value	
	; Prints all of the divisors for the number 
	
	proc printDivisors
		push bp
		mov  bp, sp
		
		;bp+0 = bp backup
		;bp+2 = return address
		;bp+4 = input number
		
		mov cx, [bp+4]
		mov ax, [bp+4]

		myloop:
			mov backup, ax
			
			cmp cx, 0
			je ending
			
			; divide ax/cx, print ax,cx and dx
			mov second, cx
			mov main, ax
			
			mov dx, 0
			div cx
			
			mov result, ax
			mov remain, dx
			
			; If remainder = 0, print the entire equation
			cmp remain, 0
			jne ending
			
			; first check for minus sign
			cmp minus, 1
			jne not_minus
			
			push offset minus_symbol ; print minus sign before main number
			call print
			
			not_minus:
			; empty 
			
			push offset my_string
			push main
			call num_to_str
			push offset my_string
			call print
			
			call resetStr
	  
			push offset divide
			call print
			
			call resetStr
			
			push offset my_string
			push second
			call num_to_str
			push offset my_string
			call print
			
			call resetStr

			push offset equal
			call print
			
			call resetStr
			
			; check for minus sign again
			cmp minus, 1
			jne not_minus2
			
			push offset minus_symbol ; print minus sign before result
			call print
			
			not_minus2:
			; empty
			
			push offset my_string
			push result
			call num_to_str
			push offset my_string
			call print
			
			call resetStr
			
			push offset comma
			call print
			
			call resetStr
			
			push offset my_string
			push remain
			call num_to_str
			push offset my_string
			call print
			
			call resetStr
			
			push offset new_line
			call print
			
			call resetStr
			
			; if there's a minus sign - print the whole equation again with minus in other places
			
			cmp minus, 1
			jne continue_loop
			
			; if minus=1:
			
			push offset minus_symbol ; print minus sign main num
			call print
			
			push offset my_string
			push main
			call num_to_str
			push offset my_string
			call print
			
			call resetStr
	  
			push offset divide
			call print
			
			call resetStr
			
			; print minus before second
			push offset minus_symbol
			call print
			
			push offset my_string
			push second
			call num_to_str
			push offset my_string
			call print
			
			call resetStr

			push offset equal
			call print
			
			call resetStr
			
			push offset my_string
			push result
			call num_to_str
			push offset my_string
			call print
			
			call resetStr
			
			push offset comma
			call print
			
			call resetStr
			
			push offset my_string
			push remain
			call num_to_str
			push offset my_string
			call print
			
			call resetStr
			
			push offset new_line
			call print
			
			call resetStr

			continue_loop:
			; empty
			
			; terminate the program when result = main
			mov di, result
			cmp di, main
			je exit

			ending:
			; empty       

			mov ax, backup
			
		loop myloop
		
		pop bp
		ret
	endp printDivisors
	
END
