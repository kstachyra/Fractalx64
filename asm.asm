.code
ASM proc

	PUSH RBP
	MOV RBP, RSP

	sub rsp, 48
	movdqu xmmword ptr [rsp], xmm6
	movdqu xmmword ptr [rsp+16], xmm7
	movdqu xmmword ptr [rsp+32], xmm8

	push r13
	push r14
	push r15

	;kopia poczatkowego xmm1 w xmm8
	movsd xmm8, xmm1

	;xmm1 p_x
	;xmm2 p_y
	;xmm3 zoom
	;
	;xmm4 z_x
	;xmm5 z_y
	;xmm6 modul
	;
	;r15 licznik dokladnosc
	;
	;r13, r14 liczniki petli rysujacej obraz
	;
	;xmm0, xmm7 temp
	;r8 temp
	;
	;przesuniecie o piksel w xmm3



	mov r8, 512
	cvtsi2sd xmm0, r8
	divsd xmm3, xmm0

	mov r14, 512
for_x:
	
	mov r13, 512
for_y:

	;dla kazdego pixela================================================================

	;dokl = 255, "zerowanie" licznika
	mov r15, 255

	;z=0
	xor r8, r8		;zerowanie
	cvtsi2sd xmm4, r8
	cvtsi2sd xmm5, r8

granica:

	;z=z^2+p
	movsd xmm7, xmm4
	movsd xmm0, xmm5
		
	;x = x^2-y^2 + p_x
	mulsd xmm7, xmm4
	mulsd xmm0, xmm0
	subsd xmm7, xmm0
	addsd xmm7, xmm1

	;y = 2*a*b + p_y
	mov r8, 2
	cvtsi2sd xmm0, r8
	mulsd xmm5, xmm0
	mulsd xmm5, xmm4
	addsd xmm5, xmm2

	movsd xmm4, xmm7

	;licz modul |z| = x^2 + y^2 do xmm6
	movsd xmm0, xmm4
	movsd xmm6, xmm5
	mulsd xmm6, xmm6
	mulsd xmm0, xmm0
	addsd xmm6, xmm0

	;jezeli modul>=2 to punkt nie nalezy, liczymy kolorek
	mov r8, 4
	cvtsi2sd xmm0, r8
	subsd xmm6, xmm0
	xor r8, r8
	cvtsi2sd xmm0, r8
	minsd xmm6, xmm0
	mulsd xmm6, xmm6

	mov r8, 1000000000
	cvtsi2sd xmm0, r8
	mulsd xmm6, xmm0

	cvtsd2si r8, xmm6
	cmp r8, 0
	jz kolor

	dec r15
	jnz granica

kolor:
	mov byte ptr [rcx], r15b
	mov r8, r15
	shl r8, 1
	mov byte ptr [rcx+1], r8b
	shl r8, 1
	mov byte ptr [rcx+2], r15b
	mov byte ptr [rcx+3], 255

	add rcx, 4

	;p_x nastepny piksel
	addsd xmm1, xmm3

	;koniec dla kazdego piksela=======================================================

	dec r13
	jnz for_y
	;end for_y

	;p_y nastepny piksel
	addsd xmm2, xmm3
	movsd xmm1, xmm8

	dec r14
	jnz for_x
	;end for_x


	pop r15
	pop r14
	pop r13

	movdqu xmm8, xmmword ptr [rsp+32]
	movdqu xmm7, xmmword ptr [rsp+16]
	movdqu xmm6, xmmword ptr [rsp]
	
	add rsp, 48

	POP RBP
	ret

ASM endp
end