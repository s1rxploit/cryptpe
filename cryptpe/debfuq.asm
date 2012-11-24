; Code to hide the debugger detector
.386
.model flat, c
.code		
assume fs:nothing
debfuq PROC
		mov eax, _label
		db 0ebh			; EB FF	JMP -1 The Disassembler should lose sync here.
		jmp eax			; FF E0	Note the FF coming from the previous instruction.
		db 8dh, 0ffh

; Debugger detector proper, part I
_label:
		mov eax, fs:[30h]
		mov eax, [eax+68h]

		mov ebx, _label2
		db 0ebh			; Same as above, ebx this time, because 
		jmp ebx			; we use eax to test for the debugger. 

; Debugger detector, part II
_label2:
		and eax, 70h
		test eax, eax
		jne _xor			; If there is a debugger present, skip
		mov ebx, 42h

_xor:
		xor ebx, 42h
		mov eax, ebx
		retn
debfuq ENDP

end