// Code generated by command: go run intersect16_asm.go -pkg sortedset -out ../sortedset/intersect16_amd64.s -stubs ../sortedset/intersect16_amd64.go. DO NOT EDIT.

//go:build !purego
// +build !purego

#include "textflag.h"

// func intersect16(dst []byte, a []byte, b []byte) int
// Requires: AVX
TEXT ·intersect16(SB), NOSPLIT, $0-80
	MOVQ     dst_base+0(FP), AX
	MOVQ     a_base+24(FP), CX
	MOVQ     b_base+48(FP), DX
	MOVQ     a_len+32(FP), BX
	ADDQ     CX, BX
	MOVQ     b_len+56(FP), SI
	ADDQ     DX, SI
	VPCMPEQB X0, X0, X0
	VMOVUPS  (CX), X1
	VMOVUPS  (DX), X2

loop:
	VPCMPEQB  X1, X2, X3
	VPXOR     X3, X0, X3
	VPMINUB   X1, X2, X4
	VPCMPEQB  X1, X4, X4
	VPAND     X4, X3, X4
	VPMOVMSKB X3, DI
	VPMOVMSKB X4, R8
	TESTL     DI, DI
	JZ        equal
	BSFL      DI, R9
	BTSL      R9, R8
	JCS       less
	ADDQ      $0x10, DX
	CMPQ      DX, SI
	JE        done
	VMOVUPS   (DX), X2
	JMP       loop

less:
	ADDQ    $0x10, CX
	CMPQ    CX, BX
	JE      done
	VMOVUPS (CX), X1
	JMP     loop

equal:
	VMOVUPS X1, (AX)
	ADDQ    $0x10, AX
	ADDQ    $0x10, CX
	ADDQ    $0x10, DX
	CMPQ    CX, BX
	JE      done
	CMPQ    DX, SI
	JE      done
	VMOVUPS (CX), X1
	VMOVUPS (DX), X2
	JMP     loop

done:
	MOVQ dst_base+0(FP), CX
	SUBQ CX, AX
	MOVQ AX, ret+72(FP)
	RET
