; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=SSE2-SSSE3,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+ssse3 | FileCheck %s --check-prefixes=SSE2-SSSE3,SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX12,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX12,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefixes=AVX512 --check-prefixes=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl,+avx512bw | FileCheck %s --check-prefixes=AVX512 --check-prefixes=AVX512BW

define i8 @v8i16(<8 x i16> %a, <8 x i16> %b, <8 x i16> %c, <8 x i16> %d) {
; SSE2-SSSE3-LABEL: v8i16:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    pand %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    packsswb %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    pmovmskb %xmm2, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v8i16:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpcmpgtw %xmm3, %xmm2, %xmm1
; AVX12-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpacksswb %xmm0, %xmm0, %xmm0
; AVX12-NEXT:    vpmovmskb %xmm0, %eax
; AVX12-NEXT:    # kill: def %al killed %al killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v8i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    vpmovsxwd %xmm0, %ymm0
; AVX512F-NEXT:    vpslld $31, %ymm0, %ymm0
; AVX512F-NEXT:    vptestmd %ymm0, %ymm0, %k1
; AVX512F-NEXT:    vpcmpgtw %xmm3, %xmm2, %xmm0
; AVX512F-NEXT:    vpmovsxwd %xmm0, %ymm0
; AVX512F-NEXT:    vpslld $31, %ymm0, %ymm0
; AVX512F-NEXT:    vptestmd %ymm0, %ymm0, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def %al killed %al killed %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtw %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtw %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def %al killed %al killed %eax
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <8 x i16> %a, %b
  %x1 = icmp sgt <8 x i16> %c, %d
  %y = and <8 x i1> %x0, %x1
  %res = bitcast <8 x i1> %y to i8
  ret i8 %res
}

define i4 @v4i32(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c, <4 x i32> %d) {
; SSE2-SSSE3-LABEL: v4i32:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    pand %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    movmskps %xmm2, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v4i32:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpcmpgtd %xmm3, %xmm2, %xmm1
; AVX12-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vmovmskps %xmm0, %eax
; AVX12-NEXT:    # kill: def %al killed %al killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v4i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtd %xmm1, %xmm0, %k1
; AVX512F-NEXT:    vpcmpgtd %xmm3, %xmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtd %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtd %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <4 x i32> %a, %b
  %x1 = icmp sgt <4 x i32> %c, %d
  %y = and <4 x i1> %x0, %x1
  %res = bitcast <4 x i1> %y to i4
  ret i4 %res
}

define i4 @v4f32(<4 x float> %a, <4 x float> %b, <4 x float> %c, <4 x float> %d) {
; SSE2-SSSE3-LABEL: v4f32:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    cmpltps %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    cmpltps %xmm2, %xmm3
; SSE2-SSSE3-NEXT:    andps %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    movmskps %xmm3, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v4f32:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltps %xmm0, %xmm1, %xmm0
; AVX12-NEXT:    vcmpltps %xmm2, %xmm3, %xmm1
; AVX12-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vmovmskps %xmm0, %eax
; AVX12-NEXT:    # kill: def %al killed %al killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v4f32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltps %xmm0, %xmm1, %k1
; AVX512F-NEXT:    vcmpltps %xmm2, %xmm3, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4f32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltps %xmm0, %xmm1, %k1
; AVX512BW-NEXT:    vcmpltps %xmm2, %xmm3, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = fcmp ogt <4 x float> %a, %b
  %x1 = fcmp ogt <4 x float> %c, %d
  %y = and <4 x i1> %x0, %x1
  %res = bitcast <4 x i1> %y to i4
  ret i4 %res
}

define i16 @v16i8(<16 x i8> %a, <16 x i8> %b, <16 x i8> %c, <16 x i8> %d) {
; SSE2-SSSE3-LABEL: v16i8:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    pand %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    pmovmskb %xmm2, %eax
; SSE2-SSSE3-NEXT:    # kill: def %ax killed %ax killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v16i8:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vpcmpgtb %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpcmpgtb %xmm3, %xmm2, %xmm1
; AVX12-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpmovmskb %xmm0, %eax
; AVX12-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v16i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtb %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vpcmpgtb %xmm3, %xmm2, %xmm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v16i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtb %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtb %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <16 x i8> %a, %b
  %x1 = icmp sgt <16 x i8> %c, %d
  %y = and <16 x i1> %x0, %x1
  %res = bitcast <16 x i1> %y to i16
  ret i16 %res
}

define i2 @v2i8(<2 x i8> %a, <2 x i8> %b, <2 x i8> %c, <2 x i8> %d) {
; SSE2-SSSE3-LABEL: v2i8:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    psllq $56, %xmm2
; SSE2-SSSE3-NEXT:    movdqa %xmm2, %xmm4
; SSE2-SSSE3-NEXT:    psrad $31, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $24, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm4[0],xmm2[1],xmm4[1]
; SSE2-SSSE3-NEXT:    psllq $56, %xmm3
; SSE2-SSSE3-NEXT:    movdqa %xmm3, %xmm4
; SSE2-SSSE3-NEXT:    psrad $31, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $24, %xmm3
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm4[0],xmm3[1],xmm4[1]
; SSE2-SSSE3-NEXT:    psllq $56, %xmm0
; SSE2-SSSE3-NEXT:    movdqa %xmm0, %xmm4
; SSE2-SSSE3-NEXT:    psrad $31, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $24, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[1],xmm4[1]
; SSE2-SSSE3-NEXT:    psllq $56, %xmm1
; SSE2-SSSE3-NEXT:    movdqa %xmm1, %xmm4
; SSE2-SSSE3-NEXT:    psrad $31, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $24, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm4[0],xmm1[1],xmm4[1]
; SSE2-SSSE3-NEXT:    movdqa {{.*#+}} xmm4 = [2147483648,0,2147483648,0]
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm1
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm0
; SSE2-SSSE3-NEXT:    movdqa %xmm0, %xmm5
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm1, %xmm5
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm6 = xmm5[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm6, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm5[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm2
; SSE2-SSSE3-NEXT:    movdqa %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm4, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pand %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    movmskpd %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v2i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsllq $56, %xmm3, %xmm3
; AVX1-NEXT:    vpsrad $31, %xmm3, %xmm4
; AVX1-NEXT:    vpsrad $24, %xmm3, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm3 = xmm3[0,1],xmm4[2,3],xmm3[4,5],xmm4[6,7]
; AVX1-NEXT:    vpsllq $56, %xmm2, %xmm2
; AVX1-NEXT:    vpsrad $31, %xmm2, %xmm4
; AVX1-NEXT:    vpsrad $24, %xmm2, %xmm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm2[0,1],xmm4[2,3],xmm2[4,5],xmm4[6,7]
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsllq $56, %xmm1, %xmm1
; AVX1-NEXT:    vpsrad $31, %xmm1, %xmm3
; AVX1-NEXT:    vpsrad $24, %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; AVX1-NEXT:    vpsllq $56, %xmm0, %xmm0
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm3
; AVX1-NEXT:    vpsrad $24, %xmm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm3[2,3],xmm0[4,5],xmm3[6,7]
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovmskpd %xmm0, %eax
; AVX1-NEXT:    # kill: def %al killed %al killed %eax
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v2i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsllq $56, %xmm3, %xmm3
; AVX2-NEXT:    vpsrad $31, %xmm3, %xmm4
; AVX2-NEXT:    vpsrad $24, %xmm3, %xmm3
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm3 = xmm3[0],xmm4[1],xmm3[2],xmm4[3]
; AVX2-NEXT:    vpsllq $56, %xmm2, %xmm2
; AVX2-NEXT:    vpsrad $31, %xmm2, %xmm4
; AVX2-NEXT:    vpsrad $24, %xmm2, %xmm2
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm2 = xmm2[0],xmm4[1],xmm2[2],xmm4[3]
; AVX2-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vpsllq $56, %xmm1, %xmm1
; AVX2-NEXT:    vpsrad $31, %xmm1, %xmm3
; AVX2-NEXT:    vpsrad $24, %xmm1, %xmm1
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm3[1],xmm1[2],xmm3[3]
; AVX2-NEXT:    vpsllq $56, %xmm0, %xmm0
; AVX2-NEXT:    vpsrad $31, %xmm0, %xmm3
; AVX2-NEXT:    vpsrad $24, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm3[1],xmm0[2],xmm3[3]
; AVX2-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vmovmskpd %xmm0, %eax
; AVX2-NEXT:    # kill: def %al killed %al killed %eax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v2i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpsllq $56, %xmm3, %xmm3
; AVX512F-NEXT:    vpsraq $56, %xmm3, %xmm3
; AVX512F-NEXT:    vpsllq $56, %xmm2, %xmm2
; AVX512F-NEXT:    vpsraq $56, %xmm2, %xmm2
; AVX512F-NEXT:    vpsllq $56, %xmm1, %xmm1
; AVX512F-NEXT:    vpsraq $56, %xmm1, %xmm1
; AVX512F-NEXT:    vpsllq $56, %xmm0, %xmm0
; AVX512F-NEXT:    vpsraq $56, %xmm0, %xmm0
; AVX512F-NEXT:    vpcmpgtq %xmm1, %xmm0, %k1
; AVX512F-NEXT:    vpcmpgtq %xmm3, %xmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v2i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsllq $56, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsraq $56, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsllq $56, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsraq $56, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsllq $56, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsraq $56, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsllq $56, %xmm0, %xmm0
; AVX512BW-NEXT:    vpsraq $56, %xmm0, %xmm0
; AVX512BW-NEXT:    vpcmpgtq %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtq %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <2 x i8> %a, %b
  %x1 = icmp sgt <2 x i8> %c, %d
  %y = and <2 x i1> %x0, %x1
  %res = bitcast <2 x i1> %y to i2
  ret i2 %res
}

define i2 @v2i16(<2 x i16> %a, <2 x i16> %b, <2 x i16> %c, <2 x i16> %d) {
; SSE2-SSSE3-LABEL: v2i16:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    psllq $48, %xmm2
; SSE2-SSSE3-NEXT:    movdqa %xmm2, %xmm4
; SSE2-SSSE3-NEXT:    psrad $31, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $16, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm4[0],xmm2[1],xmm4[1]
; SSE2-SSSE3-NEXT:    psllq $48, %xmm3
; SSE2-SSSE3-NEXT:    movdqa %xmm3, %xmm4
; SSE2-SSSE3-NEXT:    psrad $31, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $16, %xmm3
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm4[0],xmm3[1],xmm4[1]
; SSE2-SSSE3-NEXT:    psllq $48, %xmm0
; SSE2-SSSE3-NEXT:    movdqa %xmm0, %xmm4
; SSE2-SSSE3-NEXT:    psrad $31, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $16, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[1],xmm4[1]
; SSE2-SSSE3-NEXT:    psllq $48, %xmm1
; SSE2-SSSE3-NEXT:    movdqa %xmm1, %xmm4
; SSE2-SSSE3-NEXT:    psrad $31, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $16, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm4[0],xmm1[1],xmm4[1]
; SSE2-SSSE3-NEXT:    movdqa {{.*#+}} xmm4 = [2147483648,0,2147483648,0]
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm1
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm0
; SSE2-SSSE3-NEXT:    movdqa %xmm0, %xmm5
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm1, %xmm5
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm6 = xmm5[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm6, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm5[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm2
; SSE2-SSSE3-NEXT:    movdqa %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm4, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pand %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    movmskpd %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v2i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsllq $48, %xmm3, %xmm3
; AVX1-NEXT:    vpsrad $31, %xmm3, %xmm4
; AVX1-NEXT:    vpsrad $16, %xmm3, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm3 = xmm3[0,1],xmm4[2,3],xmm3[4,5],xmm4[6,7]
; AVX1-NEXT:    vpsllq $48, %xmm2, %xmm2
; AVX1-NEXT:    vpsrad $31, %xmm2, %xmm4
; AVX1-NEXT:    vpsrad $16, %xmm2, %xmm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm2[0,1],xmm4[2,3],xmm2[4,5],xmm4[6,7]
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsllq $48, %xmm1, %xmm1
; AVX1-NEXT:    vpsrad $31, %xmm1, %xmm3
; AVX1-NEXT:    vpsrad $16, %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; AVX1-NEXT:    vpsllq $48, %xmm0, %xmm0
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm3
; AVX1-NEXT:    vpsrad $16, %xmm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm3[2,3],xmm0[4,5],xmm3[6,7]
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovmskpd %xmm0, %eax
; AVX1-NEXT:    # kill: def %al killed %al killed %eax
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v2i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsllq $48, %xmm3, %xmm3
; AVX2-NEXT:    vpsrad $31, %xmm3, %xmm4
; AVX2-NEXT:    vpsrad $16, %xmm3, %xmm3
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm3 = xmm3[0],xmm4[1],xmm3[2],xmm4[3]
; AVX2-NEXT:    vpsllq $48, %xmm2, %xmm2
; AVX2-NEXT:    vpsrad $31, %xmm2, %xmm4
; AVX2-NEXT:    vpsrad $16, %xmm2, %xmm2
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm2 = xmm2[0],xmm4[1],xmm2[2],xmm4[3]
; AVX2-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vpsllq $48, %xmm1, %xmm1
; AVX2-NEXT:    vpsrad $31, %xmm1, %xmm3
; AVX2-NEXT:    vpsrad $16, %xmm1, %xmm1
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm3[1],xmm1[2],xmm3[3]
; AVX2-NEXT:    vpsllq $48, %xmm0, %xmm0
; AVX2-NEXT:    vpsrad $31, %xmm0, %xmm3
; AVX2-NEXT:    vpsrad $16, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm3[1],xmm0[2],xmm3[3]
; AVX2-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vmovmskpd %xmm0, %eax
; AVX2-NEXT:    # kill: def %al killed %al killed %eax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v2i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpsllq $48, %xmm3, %xmm3
; AVX512F-NEXT:    vpsraq $48, %xmm3, %xmm3
; AVX512F-NEXT:    vpsllq $48, %xmm2, %xmm2
; AVX512F-NEXT:    vpsraq $48, %xmm2, %xmm2
; AVX512F-NEXT:    vpsllq $48, %xmm1, %xmm1
; AVX512F-NEXT:    vpsraq $48, %xmm1, %xmm1
; AVX512F-NEXT:    vpsllq $48, %xmm0, %xmm0
; AVX512F-NEXT:    vpsraq $48, %xmm0, %xmm0
; AVX512F-NEXT:    vpcmpgtq %xmm1, %xmm0, %k1
; AVX512F-NEXT:    vpcmpgtq %xmm3, %xmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v2i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsllq $48, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsraq $48, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsllq $48, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsraq $48, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsllq $48, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsraq $48, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsllq $48, %xmm0, %xmm0
; AVX512BW-NEXT:    vpsraq $48, %xmm0, %xmm0
; AVX512BW-NEXT:    vpcmpgtq %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtq %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <2 x i16> %a, %b
  %x1 = icmp sgt <2 x i16> %c, %d
  %y = and <2 x i1> %x0, %x1
  %res = bitcast <2 x i1> %y to i2
  ret i2 %res
}

define i2 @v2i32(<2 x i32> %a, <2 x i32> %b, <2 x i32> %c, <2 x i32> %d) {
; SSE2-SSSE3-LABEL: v2i32:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    psllq $32, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm2[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $31, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1]
; SSE2-SSSE3-NEXT:    psllq $32, %xmm3
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $31, %xmm3
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; SSE2-SSSE3-NEXT:    psllq $32, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $31, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1]
; SSE2-SSSE3-NEXT:    psllq $32, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,3,2,3]
; SSE2-SSSE3-NEXT:    psrad $31, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,3,2,3]
; SSE2-SSSE3-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE2-SSSE3-NEXT:    movdqa {{.*#+}} xmm1 = [2147483648,0,2147483648,0]
; SSE2-SSSE3-NEXT:    pxor %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pxor %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    movdqa %xmm3, %xmm5
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm0, %xmm5
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm6 = xmm5[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm0, %xmm3
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm3[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm6, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm3 = xmm5[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm1, %xmm2
; SSE2-SSSE3-NEXT:    pxor %xmm1, %xmm4
; SSE2-SSSE3-NEXT:    movdqa %xmm4, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm2, %xmm4
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm4[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm1, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pand %xmm3, %xmm0
; SSE2-SSSE3-NEXT:    movmskpd %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v2i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsllq $32, %xmm3, %xmm3
; AVX1-NEXT:    vpsrad $31, %xmm3, %xmm4
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm3 = xmm3[0,1],xmm4[2,3],xmm3[4,5],xmm4[6,7]
; AVX1-NEXT:    vpsllq $32, %xmm2, %xmm2
; AVX1-NEXT:    vpsrad $31, %xmm2, %xmm4
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm2[0,1],xmm4[2,3],xmm2[4,5],xmm4[6,7]
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsllq $32, %xmm1, %xmm1
; AVX1-NEXT:    vpsrad $31, %xmm1, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; AVX1-NEXT:    vpsllq $32, %xmm0, %xmm0
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm3[2,3],xmm0[4,5],xmm3[6,7]
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovmskpd %xmm0, %eax
; AVX1-NEXT:    # kill: def %al killed %al killed %eax
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v2i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsllq $32, %xmm3, %xmm3
; AVX2-NEXT:    vpsrad $31, %xmm3, %xmm4
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm3 = xmm3[0],xmm4[1],xmm3[2],xmm4[3]
; AVX2-NEXT:    vpsllq $32, %xmm2, %xmm2
; AVX2-NEXT:    vpsrad $31, %xmm2, %xmm4
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm2 = xmm2[0],xmm4[1],xmm2[2],xmm4[3]
; AVX2-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vpsllq $32, %xmm1, %xmm1
; AVX2-NEXT:    vpsrad $31, %xmm1, %xmm3
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm3[1],xmm1[2],xmm3[3]
; AVX2-NEXT:    vpsllq $32, %xmm0, %xmm0
; AVX2-NEXT:    vpsrad $31, %xmm0, %xmm3
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm3[1],xmm0[2],xmm3[3]
; AVX2-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vmovmskpd %xmm0, %eax
; AVX2-NEXT:    # kill: def %al killed %al killed %eax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v2i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpsllq $32, %xmm3, %xmm3
; AVX512F-NEXT:    vpsraq $32, %xmm3, %xmm3
; AVX512F-NEXT:    vpsllq $32, %xmm2, %xmm2
; AVX512F-NEXT:    vpsraq $32, %xmm2, %xmm2
; AVX512F-NEXT:    vpsllq $32, %xmm1, %xmm1
; AVX512F-NEXT:    vpsraq $32, %xmm1, %xmm1
; AVX512F-NEXT:    vpsllq $32, %xmm0, %xmm0
; AVX512F-NEXT:    vpsraq $32, %xmm0, %xmm0
; AVX512F-NEXT:    vpcmpgtq %xmm1, %xmm0, %k1
; AVX512F-NEXT:    vpcmpgtq %xmm3, %xmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v2i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsllq $32, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsraq $32, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsllq $32, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsraq $32, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsllq $32, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsraq $32, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsllq $32, %xmm0, %xmm0
; AVX512BW-NEXT:    vpsraq $32, %xmm0, %xmm0
; AVX512BW-NEXT:    vpcmpgtq %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtq %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <2 x i32> %a, %b
  %x1 = icmp sgt <2 x i32> %c, %d
  %y = and <2 x i1> %x0, %x1
  %res = bitcast <2 x i1> %y to i2
  ret i2 %res
}

define i2 @v2i64(<2 x i64> %a, <2 x i64> %b, <2 x i64> %c, <2 x i64> %d) {
; SSE2-SSSE3-LABEL: v2i64:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    movdqa {{.*#+}} xmm4 = [2147483648,0,2147483648,0]
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm1
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm0
; SSE2-SSSE3-NEXT:    movdqa %xmm0, %xmm5
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm1, %xmm5
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm6 = xmm5[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm6, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm5[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm2
; SSE2-SSSE3-NEXT:    movdqa %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm4, %xmm2
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pand %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    movmskpd %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v2i64:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm1
; AVX12-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vmovmskpd %xmm0, %eax
; AVX12-NEXT:    # kill: def %al killed %al killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v2i64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtq %xmm1, %xmm0, %k1
; AVX512F-NEXT:    vpcmpgtq %xmm3, %xmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v2i64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtq %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtq %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <2 x i64> %a, %b
  %x1 = icmp sgt <2 x i64> %c, %d
  %y = and <2 x i1> %x0, %x1
  %res = bitcast <2 x i1> %y to i2
  ret i2 %res
}

define i2 @v2f64(<2 x double> %a, <2 x double> %b, <2 x double> %c, <2 x double> %d) {
; SSE2-SSSE3-LABEL: v2f64:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    cmpltpd %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    cmpltpd %xmm2, %xmm3
; SSE2-SSSE3-NEXT:    andpd %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    movmskpd %xmm3, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v2f64:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltpd %xmm0, %xmm1, %xmm0
; AVX12-NEXT:    vcmpltpd %xmm2, %xmm3, %xmm1
; AVX12-NEXT:    vandpd %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vmovmskpd %xmm0, %eax
; AVX12-NEXT:    # kill: def %al killed %al killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v2f64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltpd %xmm0, %xmm1, %k1
; AVX512F-NEXT:    vcmpltpd %xmm2, %xmm3, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v2f64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltpd %xmm0, %xmm1, %k1
; AVX512BW-NEXT:    vcmpltpd %xmm2, %xmm3, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = fcmp ogt <2 x double> %a, %b
  %x1 = fcmp ogt <2 x double> %c, %d
  %y = and <2 x i1> %x0, %x1
  %res = bitcast <2 x i1> %y to i2
  ret i2 %res
}

define i4 @v4i8(<4 x i8> %a, <4 x i8> %b, <4 x i8> %c, <4 x i8> %d) {
; SSE2-SSSE3-LABEL: v4i8:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pslld $24, %xmm3
; SSE2-SSSE3-NEXT:    psrad $24, %xmm3
; SSE2-SSSE3-NEXT:    pslld $24, %xmm2
; SSE2-SSSE3-NEXT:    psrad $24, %xmm2
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    pslld $24, %xmm1
; SSE2-SSSE3-NEXT:    psrad $24, %xmm1
; SSE2-SSSE3-NEXT:    pslld $24, %xmm0
; SSE2-SSSE3-NEXT:    psrad $24, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pand %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    movmskps %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v4i8:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vpslld $24, %xmm3, %xmm3
; AVX12-NEXT:    vpsrad $24, %xmm3, %xmm3
; AVX12-NEXT:    vpslld $24, %xmm2, %xmm2
; AVX12-NEXT:    vpsrad $24, %xmm2, %xmm2
; AVX12-NEXT:    vpcmpgtd %xmm3, %xmm2, %xmm2
; AVX12-NEXT:    vpslld $24, %xmm1, %xmm1
; AVX12-NEXT:    vpsrad $24, %xmm1, %xmm1
; AVX12-NEXT:    vpslld $24, %xmm0, %xmm0
; AVX12-NEXT:    vpsrad $24, %xmm0, %xmm0
; AVX12-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX12-NEXT:    vmovmskps %xmm0, %eax
; AVX12-NEXT:    # kill: def %al killed %al killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v4i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpslld $24, %xmm3, %xmm3
; AVX512F-NEXT:    vpsrad $24, %xmm3, %xmm3
; AVX512F-NEXT:    vpslld $24, %xmm2, %xmm2
; AVX512F-NEXT:    vpsrad $24, %xmm2, %xmm2
; AVX512F-NEXT:    vpslld $24, %xmm1, %xmm1
; AVX512F-NEXT:    vpsrad $24, %xmm1, %xmm1
; AVX512F-NEXT:    vpslld $24, %xmm0, %xmm0
; AVX512F-NEXT:    vpsrad $24, %xmm0, %xmm0
; AVX512F-NEXT:    vpcmpgtd %xmm1, %xmm0, %k1
; AVX512F-NEXT:    vpcmpgtd %xmm3, %xmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpslld $24, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsrad $24, %xmm3, %xmm3
; AVX512BW-NEXT:    vpslld $24, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsrad $24, %xmm2, %xmm2
; AVX512BW-NEXT:    vpslld $24, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsrad $24, %xmm1, %xmm1
; AVX512BW-NEXT:    vpslld $24, %xmm0, %xmm0
; AVX512BW-NEXT:    vpsrad $24, %xmm0, %xmm0
; AVX512BW-NEXT:    vpcmpgtd %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtd %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <4 x i8> %a, %b
  %x1 = icmp sgt <4 x i8> %c, %d
  %y = and <4 x i1> %x0, %x1
  %res = bitcast <4 x i1> %y to i4
  ret i4 %res
}

define i4 @v4i16(<4 x i16> %a, <4 x i16> %b, <4 x i16> %c, <4 x i16> %d) {
; SSE2-SSSE3-LABEL: v4i16:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pslld $16, %xmm3
; SSE2-SSSE3-NEXT:    psrad $16, %xmm3
; SSE2-SSSE3-NEXT:    pslld $16, %xmm2
; SSE2-SSSE3-NEXT:    psrad $16, %xmm2
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    pslld $16, %xmm1
; SSE2-SSSE3-NEXT:    psrad $16, %xmm1
; SSE2-SSSE3-NEXT:    pslld $16, %xmm0
; SSE2-SSSE3-NEXT:    psrad $16, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pand %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    movmskps %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v4i16:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vpslld $16, %xmm3, %xmm3
; AVX12-NEXT:    vpsrad $16, %xmm3, %xmm3
; AVX12-NEXT:    vpslld $16, %xmm2, %xmm2
; AVX12-NEXT:    vpsrad $16, %xmm2, %xmm2
; AVX12-NEXT:    vpcmpgtd %xmm3, %xmm2, %xmm2
; AVX12-NEXT:    vpslld $16, %xmm1, %xmm1
; AVX12-NEXT:    vpsrad $16, %xmm1, %xmm1
; AVX12-NEXT:    vpslld $16, %xmm0, %xmm0
; AVX12-NEXT:    vpsrad $16, %xmm0, %xmm0
; AVX12-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX12-NEXT:    vmovmskps %xmm0, %eax
; AVX12-NEXT:    # kill: def %al killed %al killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v4i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpslld $16, %xmm3, %xmm3
; AVX512F-NEXT:    vpsrad $16, %xmm3, %xmm3
; AVX512F-NEXT:    vpslld $16, %xmm2, %xmm2
; AVX512F-NEXT:    vpsrad $16, %xmm2, %xmm2
; AVX512F-NEXT:    vpslld $16, %xmm1, %xmm1
; AVX512F-NEXT:    vpsrad $16, %xmm1, %xmm1
; AVX512F-NEXT:    vpslld $16, %xmm0, %xmm0
; AVX512F-NEXT:    vpsrad $16, %xmm0, %xmm0
; AVX512F-NEXT:    vpcmpgtd %xmm1, %xmm0, %k1
; AVX512F-NEXT:    vpcmpgtd %xmm3, %xmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512F-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpslld $16, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsrad $16, %xmm3, %xmm3
; AVX512BW-NEXT:    vpslld $16, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsrad $16, %xmm2, %xmm2
; AVX512BW-NEXT:    vpslld $16, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsrad $16, %xmm1, %xmm1
; AVX512BW-NEXT:    vpslld $16, %xmm0, %xmm0
; AVX512BW-NEXT:    vpsrad $16, %xmm0, %xmm0
; AVX512BW-NEXT:    vpcmpgtd %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtd %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX512BW-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <4 x i16> %a, %b
  %x1 = icmp sgt <4 x i16> %c, %d
  %y = and <4 x i1> %x0, %x1
  %res = bitcast <4 x i1> %y to i4
  ret i4 %res
}

define i8 @v8i8(<8 x i8> %a, <8 x i8> %b, <8 x i8> %c, <8 x i8> %d) {
; SSE2-SSSE3-LABEL: v8i8:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    psllw $8, %xmm3
; SSE2-SSSE3-NEXT:    psraw $8, %xmm3
; SSE2-SSSE3-NEXT:    psllw $8, %xmm2
; SSE2-SSSE3-NEXT:    psraw $8, %xmm2
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    psllw $8, %xmm1
; SSE2-SSSE3-NEXT:    psraw $8, %xmm1
; SSE2-SSSE3-NEXT:    psllw $8, %xmm0
; SSE2-SSSE3-NEXT:    psraw $8, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pand %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packsswb %xmm0, %xmm0
; SSE2-SSSE3-NEXT:    pmovmskb %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def %al killed %al killed %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v8i8:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vpsllw $8, %xmm3, %xmm3
; AVX12-NEXT:    vpsraw $8, %xmm3, %xmm3
; AVX12-NEXT:    vpsllw $8, %xmm2, %xmm2
; AVX12-NEXT:    vpsraw $8, %xmm2, %xmm2
; AVX12-NEXT:    vpcmpgtw %xmm3, %xmm2, %xmm2
; AVX12-NEXT:    vpsllw $8, %xmm1, %xmm1
; AVX12-NEXT:    vpsraw $8, %xmm1, %xmm1
; AVX12-NEXT:    vpsllw $8, %xmm0, %xmm0
; AVX12-NEXT:    vpsraw $8, %xmm0, %xmm0
; AVX12-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX12-NEXT:    vpacksswb %xmm0, %xmm0, %xmm0
; AVX12-NEXT:    vpmovmskb %xmm0, %eax
; AVX12-NEXT:    # kill: def %al killed %al killed %eax
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v8i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpsllw $8, %xmm3, %xmm3
; AVX512F-NEXT:    vpsraw $8, %xmm3, %xmm3
; AVX512F-NEXT:    vpsllw $8, %xmm2, %xmm2
; AVX512F-NEXT:    vpsraw $8, %xmm2, %xmm2
; AVX512F-NEXT:    vpcmpgtw %xmm3, %xmm2, %xmm2
; AVX512F-NEXT:    vpsllw $8, %xmm1, %xmm1
; AVX512F-NEXT:    vpsraw $8, %xmm1, %xmm1
; AVX512F-NEXT:    vpsllw $8, %xmm0, %xmm0
; AVX512F-NEXT:    vpsraw $8, %xmm0, %xmm0
; AVX512F-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    vpmovsxwd %xmm0, %ymm0
; AVX512F-NEXT:    vpslld $31, %ymm0, %ymm0
; AVX512F-NEXT:    vptestmd %ymm0, %ymm0, %k1
; AVX512F-NEXT:    vpmovsxwd %xmm2, %ymm0
; AVX512F-NEXT:    vpslld $31, %ymm0, %ymm0
; AVX512F-NEXT:    vptestmd %ymm0, %ymm0, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def %al killed %al killed %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsllw $8, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsraw $8, %xmm3, %xmm3
; AVX512BW-NEXT:    vpsllw $8, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsraw $8, %xmm2, %xmm2
; AVX512BW-NEXT:    vpsllw $8, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsraw $8, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsllw $8, %xmm0, %xmm0
; AVX512BW-NEXT:    vpsraw $8, %xmm0, %xmm0
; AVX512BW-NEXT:    vpcmpgtw %xmm1, %xmm0, %k1
; AVX512BW-NEXT:    vpcmpgtw %xmm3, %xmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def %al killed %al killed %eax
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <8 x i8> %a, %b
  %x1 = icmp sgt <8 x i8> %c, %d
  %y = and <8 x i1> %x0, %x1
  %res = bitcast <8 x i1> %y to i8
  ret i8 %res
}
