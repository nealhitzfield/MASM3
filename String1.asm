;*****************************************************************************
;Name:		David Cruz
;Program:	String1.asm
;Class:		CS3B
;Lab:		MASM2
;Date:		April 19, 2018 at 11:59 PM
;Purpose:
;	Define String operations for MASM3
;*****************************************************************************

.486
.model flat, c
.stack 100h

memoryallocBailey	PROTO NEAR32 stdcall, dSize:dword

extern String_length: Near32, String_toLowerCase: Near32

	.data


	.code
String_equals proc, string1: ptr byte, string2: ptr byte
	push string1		
	call String_length	; get the length of string1 and store it in EDI
	add esp, 4
	mov edi, eax
	push string2
	call String_length	; get the length of string2 and store it in EAX
	add esp, 4

	.if edi != eax		; if the two strings have different length, we can return early
		mov eax, 0
		mov al, 0
		ret
	.endif

	mov esi, string1
	mov edi, string2

	.while byte ptr [esi] != 0		; loop through each character of string 1
		mov bl, byte ptr [edi]		; get the character from string 2 from memory
		.if byte ptr [esi] != bl	; compare the same character in both strings
			mov eax, 0				; if they aren't equal, return FALSE
			ret
		.endif
		inc esi						; increment ESI and EDI after each loop
		inc edi
	.endw

	mov eax, 0	
	mov al, 1						; if the loop finishes, all characters are equal
	ret
String_equals endp

String_equalsIgnoreCase proc, string1: ptr byte, string2: ptr byte
	push string1		
	call String_length	; get the length of string1 and store it in EDI
	add esp, 4
	mov edi, eax
	push string2
	call String_length	; get the length of string2 and store it in EAX
	add esp, 4

	.if edi != eax		; if the two strings have different length, we can return early
		mov eax, 0
		mov al, 0
		ret
	.endif

	mov esi, string1
	mov edi, string2

	.while byte ptr [esi] != 0		; loop through each character of string 1
		mov bl, byte ptr [edi]		; get the character from string 2 from memory
		mov dl, byte ptr [esi]
		or bl, 00100000b			; set the 32 bit to convert char1 to lowercase
		or dl, 00100000b			; set the 32 bit to convert char2 to lowercase
		.if dl != bl	; compare the same character in both strings
			mov eax, 0				; if they aren't equal, return FALSE
			ret
		.endif
		inc esi						; increment ESI and EDI after each loop
		inc edi
	.endw

	mov eax, 0	
	mov al, 1						; if the loop finishes, all characters are equal
	ret
String_equalsIgnoreCase endp

String_copy proc, string1: ptr byte
	push string1
	call String_length			; get the length of the string (num bytes to allocate)
	inc eax						; add 1 for the NULL

	invoke memoryallocBailey, eax

	mov esi, string1
	mov ecx, 0
	.while byte ptr [esi + ecx] != 0	; for each character in the source string
		mov bl, byte ptr [esi + ecx]	; get the character into a register
		mov byte ptr [eax + ecx], bl	; move the character into the new memory location
		inc ecx							; go to next char
	.endw

	; memory address is already in EAX, ready to return
	ret
String_copy endp

String_substring_1 proc, string1: ptr byte, beginIndex: dword, endIndex: dword
	mov esi, string1		; esi = memory location of first char to copy
	add esi, beginIndex

	mov ecx, endIndex		; memory to allocate is (endIndex - beginIndex) + 1 + 1
	sub ecx, beginIndex		; first +1 is to include both ends, second +1 is for NULL
	add ecx, 2
	invoke memoryallocBailey, ecx

	dec ecx					; ecx is now number of chars to copy
SUBSTR_COPY_LOOP:
	mov bl, byte ptr [esi + ecx - 1]	; get the character at position [ECX] in the input string
	mov byte ptr [eax + ecx - 1], bl	; move that character into the same position in the substr
	loop SUBSTR_COPY_LOOP				; repeat [ECX] times
	
	ret						; EAX contains the address of the new string
String_substring_1 endp

String_substring_2 proc, string1: ptr byte, beginIndex: dword
	push string1
	call String_length
	add esp, 4
	mov edx, eax

	push edx
	push beginIndex
	push string1
	call String_substring_1
	add esp, 12
	ret
String_substring_2 endp

String_charAt proc, string1: ptr byte, position: dword
	push string1
	call String_length	; have to check if the position is out of bounds, so we need length
	add esp, 4

	.if position < 0 || position >= eax ; if the position is outside of [0, length)
		mov eax, 0						; return NULL
		ret
	.endif

	mov esi, string1
	mov eax, 0
	mov al, byte ptr [esi + position] ; get the character at the specified position
	ret
String_charAt endp

String_startsWith_1 proc

String_startsWith_1 endp

String_startsWith_2 proc

String_startsWith_2 endp

String_endsWith proc

String_endsWith endp

end