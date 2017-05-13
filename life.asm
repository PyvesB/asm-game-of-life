;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;											;
;	 ooooo                          ooooooo           o                      	;
;	o     o   oo   o    o oooooo    o     o oooooo    o       o oooooo oooooo	;
;	o        o  o  oo  oo o         o     o o         o       o o      o     	;
;	o  oooo o    o o oo o ooooo     o     o ooooo     o       o ooooo  ooooo 	;
;	o     o oooooo o    o o         o     o o         o       o o      o     	;
;	o     o o    o o    o o         o     o o         o       o o      o     	;
;	 ooooo  o    o o    o oooooo    ooooooo o         ooooooo o o      oooooo	;
;											;
;				NASM assembler, Linux x86-64				;
;											;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%macro print 2
	mov eax, sys_write
	mov edi, 1 	; stdout
	mov rsi, %1
	mov edx, %2
	syscall
%endmacro

global _start

section .data

	row_cells:	equ 32	; set to any (reasonable) value you wish
	column_cells: 	equ 128 ; set to any (reasonable) value you wish
	array_length:	equ row_cells * column_cells + row_cells ; cells are mapped to bytes in the array and a new line char ends each row

	cells1: 	times array_length db new_line
	cells2:		times array_length db new_line

	live:		equ 111	; ascii code for live cells, can be any odd number
	dead:		equ 32	; ascii code for dead cells, can be any even number
	new_line:	equ 10	; ascii code for new line

	timespec:
    		tv_sec  dq 0
    		tv_nsec dq 200000000

	clear:		db 27, "[2J", 27, "[H"
	clear_length:	equ $-clear
	
	sys_write:	equ 1
	sys_nanosleep:	equ 35
	sys_time:	equ 201


section .text

_start:

	print clear, clear_length
	call first_generation
	mov r9, cells1
	mov r8, cells2
	.generate_cells:
		xchg r8, r9		; exchange roles of current and next generation cell containers		
		print r8, array_length	; print current generation
		mov eax, sys_nanosleep
		mov rdi, timespec
		xor esi, esi		; ignore remaining time in case of call interruption
		syscall			; sleep for tv_sec seconds + tv_nsec nanoseconds
		print clear, clear_length		
		jmp next_generation


; r8: current generation, r9: next generation
next_generation:

	xor ebx, ebx	; array index counter
	.process_cell:
		cmp byte [r8 + rbx], new_line
		je .next_cell	; do not count live neighbours if new_line
		xor eax, eax 	; live neighbours
		.lower_index_neighbours:
			mov rdx, rbx 			; copy of array index counter, will point to neighbour positions
			dec rdx				; move to middle left neighbour
			js .higher_index_neighbours	; < 0, jump to neighbours with higher indexes
			mov cl, [r8 + rdx]
			and cl, 1			; 1 if live, 0 if dead or new_line
			add al, cl
			sub rdx, column_cells - 1 	; move to top right neighbour
			js .higher_index_neighbours	; < 0, jump to neighbours with higher indexes
			mov cl, [r8 + rdx]
			and cl, 1			; 1 if live, 0 if dead or new_line
			add al, cl
			dec rdx				; move to top middle neighbour
			js .higher_index_neighbours	; < 0, jump to neighbours with higher indexes
			mov cl, [r8 + rdx]
			and cl, 1			; 1 if live, 0 if dead or new_line
			add al, cl
			dec rdx				; move to top left neighbour
			js .higher_index_neighbours 	; < 0, jump to neighbours with higher indexes		
			mov cl, [r8 + rdx]
			and cl, 1			; 1 if live, 0 if dead or new_line
			add al, cl
		.higher_index_neighbours:
			mov rdx, rbx			; reset neighbour index
			inc rdx				; move to middle right neighbour
			cmp rdx, array_length - 1
			jge .assign_cell		; out of bounds, no more neighbours to consider
			mov cl, [r8 + rdx]
			and cl, 1			; 1 if live, 0 if dead or new_line
			add al, cl
			add rdx, column_cells - 1	; move to bottom left neighbour
			cmp rdx, array_length - 1
			jge .assign_cell		; out of bounds, no more neighbours to consider
			mov cl, [r8 + rdx]
			and cl, 1			; 1 if live, 0 if dead or new_line
			add al, cl
			inc rdx				; move to bottom middle neighbour
			cmp rdx, array_length - 1
			jge .assign_cell		; out of bounds, no more neighbours to consider
			mov cl, [r8 + rdx]
			and cl, 1			; 1 if live, 0 if dead or new_line
			add al, cl
			inc rdx				; move to bottom right neighbour
			cmp rdx, array_length - 1
			jge .assign_cell		; out of bounds, no more neighbours to consider
			mov cl, [r8 + rdx]
			and cl, 1			; 1 if live, 0 if dead or new_line
			add al, cl
		.assign_cell:
			cmp al, 2
			je .keep_current		; 2 live neigbours, next generation cell same as current 
			mov byte [r9 + rbx], dead
			cmp al, 3
			jne .next_cell			; neither 2 or 3, dead cell
			mov byte [r9 + rbx], live	; 3 live neighbours, live cell
			jmp .next_cell
		.keep_current:
			mov cl, [r8 + rbx]
			mov [r9 + rbx], cl
		.next_cell:
			inc rbx
			cmp rbx, array_length		; check whether end of array
			jne .process_cell
			jmp _start.generate_cells


; array cells1 is initialised with pseudorandom cells using a middle-square Weyl sequence RNG
first_generation:

	mov eax, sys_time
        xor edi, edi 		; time stored in rax, rdi later used as array index counter 
        syscall
	mov r8w, ax 		; r8w stores seed, must be odd
	and ax, 1		; 1 if odd and 0 if even
	dec ax			; map to 0 if odd and - 1 if even
	sub r8w, ax		; make seed odd
	xor cx, cx 		; rcx stores random number	
	xor r9w, r9w 		; r9w stores Weyl sequence	
	mov rbx, column_cells	; rbx stores index of next new_line
	.init_cell:		
		mov ax, cx
		mul cx 			; square random number
		add r9w, r8w 		; calculate next iteration of Weyl sequence
		add ax, r9w 		; add Weyl sequence
    		mov al, ah		; get lower byte of random number from higher byte of ax
    		mov ah, dl		; get higher byte of random number from lower byte of dx
		mov cx, ax		; save random number for next iteration
		and rax, 1		; test whether even or odd
		jz .add_dead		; 0 dead, 1 live
		add rax, live - dead - 1		
		.add_dead:
			add rax, dead	; rax is either 0 or live - dead
		mov [cells1 + rdi], al 	; store ascii code in array		
		inc rdi			; increment array index
		cmp rdi, rbx		; check whether index of new_line
		jne .init_next
		inc rdi			; increment array index again to preserve new_line
		add rbx, column_cells + 1 ; update index of next expected new_line
		.init_next:			
			cmp rdi, array_length	; check whether end of array
			jne .init_cell
			ret

