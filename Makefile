CC = /usr/bin/gcc
CFLAGS = -Wall -g -O3 -Wextra -Wpedantic -m32 -static
LDLIBS = -lcrypto -L. -L openssl32

SOURCES = params.c hash.c fips202.c hash_address.c randombytes.c wots.c xmss.c xmss_core.c xmss_commons.c utils.c
HEADERS = params.h hash.h fips202.h hash_address.h randombytes.h wots.h xmss.h xmss_core.h xmss_commons.h utils.h

SOURCES_FAST = $(subst xmss_core.c,xmss_core_fast.c,$(SOURCES))
HEADERS_FAST = $(subst xmss_core.c,xmss_core_fast.c,$(HEADERS))

# TESTS = test/wots \
# 		test/oid \
# 		test/speed \
# 		test/xmss_determinism \
# 		test/xmss \
# 		test/xmss_fast \
# 		test/xmssmt \
# 		test/xmssmt_fast \
# 		test/maxsigsxmss \
# 		test/maxsigsxmssmt \

UI = ui/xmss_keypair \
	 ui/xmss_sign \
	 ui/xmss_open \
	 ui/xmssmt_keypair \
	 ui/xmssmt_sign \
	 ui/xmssmt_open \
	 ui/xmss_keypair_fast \
	 ui/xmss_sign_fast \
	 ui/xmss_open_fast \
	 ui/xmssmt_keypair_fast \
	 ui/xmssmt_sign_fast \
	 ui/xmssmt_open_fast \

BINSEC_REL = xmss_binsec

#CFLAGS_BINSEC_REL = -m32  -static
LDLIBS_BINSEC_REL = -lsym
LINKS_BINSEC_REL = -L libsym

all: ui xmss_binsec

#tests: $(TESTS)
ui: $(UI)

#test: $(TESTS:=.exec)

.PHONY: clean #test


xmss_binsec: xmss_binsec_rel.c $(SOURCES_XMSS) $(OBJS) $(HEADERS_XMSS)
	$(CC) $(CFLAGS) -o $@ $(SOURCES) $< $(LINKS) $(LINKS_BINSEC_REL) $(LDLIBS) $(LDLIBS_BINSEC_REL)

# test/%.exec: test/%
# 	@$<

# test/xmss_fast: test/xmss.c $(SOURCES_FAST) $(OBJS) $(HEADERS_FAST)
# 	$(CC) -DXMSS_SIGNATURES=1024 $(CFLAGS) -o $@ $(SOURCES_FAST) $< $(LDLIBS)

# test/xmss: test/xmss.c $(SOURCES) $(OBJS) $(HEADERS)
# 	$(CC) $(CFLAGS) -o $@ $(SOURCES) $< $(LDLIBS)

# test/xmssmt_fast: test/xmss.c $(SOURCES_FAST) $(OBJS) $(HEADERS_FAST)
# 	$(CC) -DXMSSMT -DXMSS_SIGNATURES=1024 $(CFLAGS) -o $@ $(SOURCES_FAST) $< $(LDLIBS)

# test/xmssmt: test/xmss.c $(SOURCES) $(OBJS) $(HEADERS)
# 	$(CC) -DXMSSMT $(CFLAGS) -o $@ $(SOURCES) $< $(LDLIBS)

# test/speed: test/speed.c $(SOURCES_FAST) $(OBJS) $(HEADERS_FAST)
# 	$(CC) -DXMSSMT -DXMSS_VARIANT=\"XMSSMT-SHA2_20/2_256\" $(CFLAGS) -o $@ $(SOURCES_FAST) $< $(LDLIBS)

# test/vectors: test/vectors.c $(SOURCES) $(OBJS) $(HEADERS)
# 	$(CC) -DXMSSMT $(CFLAGS) -o $@ $(SOURCES) $< $(LDLIBS)

# test/maxsigsxmss: test/xmss_max_signatures.c $(SOURCES_FAST) $(OBJS) $(HEADERS_FAST)
# 	$(CC) $(CFLAGS) -o $@ $(SOURCES_FAST) $< $(LDLIBS)

# test/maxsigsxmssmt: test/xmss_max_signatures.c $(SOURCES_FAST) $(OBJS) $(HEADERS_FAST)
# 	$(CC) -DXMSSMT $(CFLAGS) -o $@ $(SOURCES_FAST) $< $(LDLIBS)

# test/%: test/%.c $(SOURCES) $(OBJS) $(HEADERS)
# 	$(CC) $(CFLAGS) -o $@ $(SOURCES) $< $(LDLIBS)

ui/xmss_%_fast: ui/%.c $(SOURCES_FAST) $(OBJS) $(HEADERS_FAST)
	$(CC) $(CFLAGS) -o $@ $(SOURCES_FAST) $< $(LDLIBS)

ui/xmssmt_%_fast: ui/%.c $(SOURCES_FAST) $(OBJS) $(HEADERS_FAST)
	$(CC) -DXMSSMT $(CFLAGS) -o $@ $(SOURCES_FAST) $< $(LDLIBS)

ui/xmss_%: ui/%.c $(SOURCES) $(OBJS) $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $(SOURCES) $< $(LDLIBS)

ui/xmssmt_%: ui/%.c $(SOURCES) $(OBJS) $(HEADERS)
	$(CC) -DXMSSMT $(CFLAGS) -o $@ $(SOURCES) $< $(LDLIBS)

clean:
	-$(RM) $(TESTS)
	-$(RM) test/vectors
	-$(RM) $(UI)