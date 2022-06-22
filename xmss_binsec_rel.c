// Adapted from the xmss.c in the test directory

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#include "libsym/sym.h"
#include "xmss.h"
#include "params.h"
#include "randombytes.h"

#define XMSS_MLEN 32
#define XMSS_SIGNATURES 16


#define XMSS_PARSE_OID xmss_parse_oid
#define XMSS_STR_TO_OID xmss_str_to_oid
#define XMSS_KEYPAIR xmss_keypair
#define XMSS_SIGN xmss_sign
#define XMSS_SIGN_OPEN xmss_sign_open
#define XMSS_VARIANT "XMSS-SHA2_10_256"


// n = 32 and padding_len = 32, full_height = 10
// tree_hight = 10/1 = 10, wots_w = 16
// wots_log_w = 4, wots_len_1 = 8 * 32 / 4 = 64
// wots_len_2 = 3, wots_len = 67,
// wots_sig_bytes = 67 * 32 = 2144
// sig_bytes = 4 + 32 + 1*2144 + 10*32 = 2500


int main()
{
    xmss_params params;
    uint32_t oid;
    int i;

    XMSS_STR_TO_OID(&oid, XMSS_VARIANT);
    XMSS_PARSE_OID(&params, oid);

    unsigned char pk[XMSS_OID_LEN + params.pk_bytes]; //4 + 64 = 68
    unsigned char sk[XMSS_OID_LEN + params.sk_bytes]; // 4 + 4 * 32 + 4 = 136
    unsigned char *m = malloc(XMSS_MLEN); // 32
    unsigned char *sm = malloc(params.sig_bytes + XMSS_MLEN); //2500 + 32 = 2532
    unsigned char *mout = malloc(params.sig_bytes + XMSS_MLEN); //2500 + 32 = 2532
    unsigned long long smlen; // 8
    unsigned long long mlen; // 8

    high_input_68(pk);
    high_input_136(sk);
    high_input_32(m);
    high_input_2532(sm);
    high_input_2532(mout);
    high_input_8(&smlen);
    high_input_8(&mlen);

    randombytes(m, XMSS_MLEN);

    XMSS_KEYPAIR(pk, sk, oid);

    for (i = 0; i < XMSS_SIGNATURES; i++) {
        XMSS_SIGN(sk, sm, &smlen, m, XMSS_MLEN);
        XMSS_SIGN_OPEN(mout, &mlen, sm, smlen, pk);
    }

    free(m);
    free(sm);
    free(mout);

    return 0;

}
