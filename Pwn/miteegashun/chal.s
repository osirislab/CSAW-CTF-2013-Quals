BITS 32
	extern printf
	extern gets
	extern exit
	extern write
	
	;;	global _start
	global main
	global savedRets
	
	;; inline prolog
	mov eax,[esp]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov [edx],eax
	inc dword [retCount]
	push ebp
	mov ebp,esp
	
	

	mov esp,ebp
	pop ebp
	dec dword [retCount]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov eax,[edx]
	mov [esp],eax
	ret
	
v3:	
	mov eax,[esp]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov [edx],eax
	inc dword [retCount]
	push ebp
	mov ebp,esp


	sub esp,0x100
	
	push esp
	call gets
	add esp,4
	
	mov esp,ebp
	pop ebp
	dec dword [retCount]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov eax,[edx]
	mov [esp],eax
	ret

v2:
	mov eax,[esp]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov [edx],eax
	inc dword [retCount]
	push ebp
	mov ebp,esp
	
	call v3

	mov esp,ebp
	pop ebp
	dec dword [retCount]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov eax,[edx]
	mov [esp],eax
	ret

	
v1:
	mov eax,[esp]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov [edx],eax
	inc dword [retCount]
	push ebp
	mov ebp,esp
	sub esp,8
	and esp,0xfffffff0
	
	mov [ebp-4],dword welcomeStr
	mov [ebp-8],dword jerk
	
	pusha
	push jerk-welcomeStr
	push dword [ebp-4]
	push 1
	call write
	add esp,4*3
	popa

	call v2

	pusha
	push savedRets-jerk
	push dword [ebp-8]
	push 1
	call write
	add esp,4*3
	popa
	
	mov esp,ebp
	pop ebp
	dec dword [retCount]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov eax,[edx]
	mov [esp],eax
	ret
	
main:
	;;
	mov [originalStack],dword esp
	;;
	mov esp, secureStack
	mov eax,[esp]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov [edx],eax
	inc dword [retCount]
	push ebp
	mov ebp,esp
	
	call v1

	mov esp,ebp
	pop ebp
	dec dword [retCount]
	mov ecx,[retCount]
	mov edx,savedRets
	lea edx,[edx+ecx*4]
	mov eax,[edx]
	mov [esp],eax
	;;
 	mov esp,dword [originalStack]
	ret
	
_start:
	call main
	push 0
	call exit

section .secureStack write alloc
	;; secureStack:	times 0x800 dd 0

	
section .data
stuff:		times 0x100 dd 0x0badf00d
s:		times 0x800-1 dd 0
secureStack:	dd 0 

welcomeStr:	db "Welcome to this demo of my exploit mitigation",0xa,"This mitigation is unbeatable, prove me wrong",0xa,0

jerk:		db "See? Flawless.",0xa,0

	


savedRets:	times 100 dd 0
originalStack:	dd 0
retCount:	dd 0