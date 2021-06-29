TITLE TEMPERATURE CALCULATION SYSTEM
.686
.MODEL flat, stdcall
.STACK
INCLUDE Irvine32.inc
.data
TempArray DWORD 102,78,99,112,45,65,76,52,23,133
TAVG DWORD ?
HIGHEST DWORD 0
SD DWORD ?
T DWORD 0
Line BYTE "---------------------------------------------------------",0,0
AvgTempText BYTE "Average Temperature is: ",0,0
HighestTempText BYTE "Highest Temperature is: ",0,0
StandardDeviationText BYTE "Standard Deviation is: ",0,0

.code
main PROC
    call Clrscr
    call AverageTemp
    call WriteDec
    call HighestTemp
    call WriteDec
    call Deviation
    exit
main endp


;-----------------------------------------------------
;FIND AVERAGE TEMP
;Adding all Temp and dividing by 10.  
;-----------------------------------------------------
AverageTemp proc

    mov esi, 0
    mov ecx, LENGTHOF TempArray
    mov eax, 0
L1:
    add eax, TempArray[esi*4] ; due to DWORD is 4 byte
    inc esi
    cmp esi, 10
    je Average
loop L1

Average:
    lea edx,Line
    call WriteString

    mov edx, 0
    mov ecx, 10
    idiv ecx
    call Crlf
    lea edx, AvgTempText
    call WriteString
    mov TAVG, eax
    ret

AverageTemp endp

;-----------------------------------------------------
;Find Highest Temperature
;Comparing which is the highest and store it into HIGHEST variable.  
;-----------------------------------------------------
HighestTemp proc

    mov esi, 0
    mov eax, 0
    mov ebx, 0
    mov ecx, LENGTHOF TempArray

L2:
    inc esi
    cmp eax, TempArray[ebx]
    jg higher
    mov eax, TempArray[ebx]
    mov HIGHEST,eax


higher:
    add ebx,4
    loop L2
    call Crlf
    lea edx,HighestTempText
    call WriteString
ret

HighestTemp endp

;-----------------------------------------------------
;Find Standard Deviation
;Stores Standard Deviation into Variable SD
;-----------------------------------------------------
Deviation proc

mov ecx, LENGTHOF TempArray
mov esi,0
mov ebx,0

L3:
    mov eax,TempArray[esi * 4]
    sub eax,TAVG
    mov ebx,eax
    add T,ebx
    inc esi
    cmp esi,10
    je next
loop L3

next:
    mov edx,0
    mov eax,T
    mov ecx,10
    idiv ecx

    mov eax,edx
    mov ebx,5
    mul ebx
    mov ebx,eax

    mov ecx,edx
    call Crlf
    
    lea edx,StandardDeviationText
    call WriteString
    
    mov eax,ecx
    call WriteDec
    mov al, '.'
    call WriteChar

    mov eax,ebx
    call WriteDec



    call Crlf
    lea edx,Line
    call WriteString

    exit
Deviation endp



MakeLine PROC
    call Crlf
    lea edx, Line
    call WriteString
    ret
MakeLine ENDP

END main