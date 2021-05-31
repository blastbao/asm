// Code generated by command: go run blend_asm.go -pkg mem -out ../mem/blend_amd64.s -stubs ../mem/blend_amd64.go. DO NOT EDIT.

#include "textflag.h"

// func Blend(dst []byte, src []byte) int
// Requires: AVX, AVX2, CMOV, SSE2
TEXT ·Blend(SB), NOSPLIT, $0-56
	MOVQ    dst_base+0(FP), AX
	MOVQ    src_base+24(FP), CX
	MOVQ    dst_len+8(FP), DX
	MOVQ    src_len+32(FP), BX
	CMPQ    BX, DX
	CMOVQGT BX, DX
	MOVQ    DX, ret+48(FP)

tail:
	CMPQ DX, $0x00
	JE   done
	CMPQ DX, $0x01
	JE   handle1
	CMPQ DX, $0x03
	JBE  handle2to3
	CMPQ DX, $0x04
	JE   handle4
	CMPQ DX, $0x08
	JB   handle5to7
	JE   handle8
	CMPQ DX, $0x10
	JBE  handle9to16
	CMPQ DX, $0x20
	JBE  handle17to32
	CMPQ DX, $0x40
	JBE  handle33to64
	BTL  $0x08, github·com∕segmentio∕asm∕cpu·X86+0(SB)
	JCC  generic
	CMPQ DX, $0x80
	JB   avx2_tail
	JMP  avx2

generic:
	MOVQ (CX), BX
	MOVQ (AX), SI
	ORQ  SI, BX
	MOVQ BX, (AX)
	ADDQ $0x08, CX
	ADDQ $0x08, AX
	SUBQ $0x08, DX
	CMPQ DX, $0x08
	JBE  tail
	JMP  generic

done:
	RET

handle1:
	MOVB (CX), CL
	MOVB (AX), DL
	ORB  DL, CL
	MOVB CL, (AX)
	RET

handle2to3:
	MOVW (CX), BX
	MOVW (AX), SI
	MOVW -2(CX)(DX*1), CX
	MOVW -2(AX)(DX*1), DI
	ORW  SI, BX
	ORW  DI, CX
	MOVW BX, (AX)
	MOVW CX, -2(AX)(DX*1)
	RET

handle4:
	MOVL (CX), CX
	MOVL (AX), DX
	ORL  DX, CX
	MOVL CX, (AX)
	RET

handle5to7:
	MOVL (CX), BX
	MOVL (AX), SI
	MOVL -4(CX)(DX*1), CX
	MOVL -4(AX)(DX*1), DI
	ORL  SI, BX
	ORL  DI, CX
	MOVL BX, (AX)
	MOVL CX, -4(AX)(DX*1)
	RET

handle8:
	MOVQ (CX), CX
	MOVQ (AX), DX
	ORQ  DX, CX
	MOVQ CX, (AX)
	RET

handle9to16:
	MOVQ (CX), BX
	MOVQ (AX), SI
	MOVQ -8(CX)(DX*1), CX
	MOVQ -8(AX)(DX*1), DI
	ORQ  SI, BX
	ORQ  DI, CX
	MOVQ BX, (AX)
	MOVQ CX, -8(AX)(DX*1)
	RET

handle17to32:
	MOVOU (CX), X0
	MOVOU (AX), X1
	MOVOU -16(CX)(DX*1), X2
	MOVOU -16(AX)(DX*1), X3
	POR   X1, X0
	POR   X3, X2
	MOVOU X0, (AX)
	MOVOU X2, -16(AX)(DX*1)
	RET

handle33to64:
	MOVOU (CX), X0
	MOVOU (AX), X1
	MOVOU 16(CX), X2
	MOVOU 16(AX), X3
	MOVOU -32(CX)(DX*1), X4
	MOVOU -32(AX)(DX*1), X5
	MOVOU -16(CX)(DX*1), X6
	MOVOU -16(AX)(DX*1), X7
	POR   X1, X0
	POR   X3, X2
	POR   X5, X4
	POR   X7, X6
	MOVOU X0, (AX)
	MOVOU X2, 16(AX)
	MOVOU X4, -32(AX)(DX*1)
	MOVOU X6, -16(AX)(DX*1)
	RET

	// AVX optimized version for medium to large size inputs.
avx2:
	VMOVUPS (CX), Y0
	VMOVUPS 32(CX), Y1
	VMOVUPS 64(CX), Y2
	VMOVUPS 96(CX), Y3
	VPOR    (AX), Y0, Y0
	VPOR    32(AX), Y1, Y1
	VPOR    64(AX), Y2, Y2
	VPOR    96(AX), Y3, Y3
	VMOVUPS Y0, (AX)
	VMOVUPS Y1, 32(AX)
	VMOVUPS Y2, 64(AX)
	VMOVUPS Y3, 96(AX)
	ADDQ    $0x80, CX
	ADDQ    $0x80, AX
	SUBQ    $0x80, DX
	CMPQ    DX, $0x80
	JAE     avx2

avx2_tail:
	JZ      done
	CMPQ    DX, $0x40
	JBE     avx2_tail_1to64
	VMOVUPS (CX), Y0
	VMOVUPS 32(CX), Y1
	VMOVUPS 64(CX), Y2
	VMOVUPS -32(CX)(DX*1), Y3
	VPOR    (AX), Y0, Y0
	VPOR    32(AX), Y1, Y1
	VPOR    64(AX), Y2, Y2
	VPOR    -32(AX)(DX*1), Y3, Y3
	VMOVUPS Y0, (AX)
	VMOVUPS Y1, 32(AX)
	VMOVUPS Y2, 64(AX)
	VMOVUPS Y3, -32(AX)(DX*1)
	RET

avx2_tail_1to64:
	VMOVUPS -64(CX)(DX*1), Y0
	VMOVUPS -32(CX)(DX*1), Y1
	VPOR    -64(AX)(DX*1), Y0, Y0
	VPOR    -32(AX)(DX*1), Y1, Y1
	VMOVUPS Y0, -64(AX)(DX*1)
	VMOVUPS Y1, -32(AX)(DX*1)
	RET
