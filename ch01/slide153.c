// gcc ch01/slide153.cpp -I${MSAT_DIR}/include -L${MSAT_DIR}/lib -lmathsat
//
// #28 (res-chain
//   #27 (clause-hyp
//     #21 (`not` B0)
//     #24 (`not` B1)
//   )
//   #17 B0
//   #26 (clause-hyp
//     @17
//     @24
//     #25 A1
//   )
//   #18 B1
//   #23 (res-chain
//     #22 (clause-hyp
//       @21
//       @18
//       #19 A2
//     )
//     @17
//     #20 (clause-hyp
//       @17
//       @18
//       @19
//     )
//     @19
//     #16 (clause-hyp
//       #14 (`not` A2)
//       #15 B2
//     )
//     @15
//     #13 (clause-hyp
//       #12 (`not` B2)
//       #7 (`not` B4)
//     )
//     #1 B4
//     #2 (clause-hyp
//       @1
//     )
//   )
//   @25
//   #11 (clause-hyp
//     #9 (`not` A1)
//     #10 B6
//   )
//   @10
//   #8 (clause-hyp
//     #5 (`not` B6)
//     #6 (`not` (`or` (`not` B4) (`not` B6)))
//     @7
//   )
//   #3 (`or` (`not` B4) (`not` B6))
//   #4 (clause-hyp
//     @3
//   )
//   @1
//   @2
// )

#include "mathsat.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>


static void ensure_size(char **arr, size_t *cursz, size_t newsz)
{
    if (newsz > *cursz) {
        *arr = (char *)realloc(*arr, newsz);
        memset(*arr + *cursz, 0, newsz - *cursz);
        *cursz = newsz;
    }
}


static int is_seen(char **seen, size_t *sz, msat_proof p)
{
    int id = msat_proof_id(p);
    ensure_size(seen, sz, id+1);

    return (*seen)[id];
}


static void set_seen(char **seen, size_t *sz, msat_proof p)
{
    int id = msat_proof_id(p);
    ensure_size(seen, sz, id+1);

    (*seen)[id] = 1;
}


static void print_proof_rec(msat_proof p, int indent,
                            char **seen, size_t *sz)
{
    int i, id;
    for (i = 0; i < indent; ++i) {
        putchar(' ');
    }

    id = msat_proof_id(p);

    if (is_seen(seen, sz, p)) {
        printf("@%d", id);
    } else {
        set_seen(seen, sz, p);

        printf("#%d ", id);
        if (msat_proof_is_term(p)) {
            char *s = msat_term_repr(msat_proof_get_term(p));
            printf("%s", s);
            msat_free(s);
        } else {
            putchar('(');
            printf("%s\n", msat_proof_get_name(p));
            size_t j;
            size_t arity = msat_proof_get_arity(p);
            for (j = 0; j < arity; ++j) {
                print_proof_rec(msat_proof_get_child(p, j), indent+2, seen, sz);
                putchar('\n');
            }
            for (i = 0; i < indent; ++i) {
                putchar(' ');
            }
            putchar(')');
        }
    }
}


static void print_proof(msat_proof p)
{
    char *seen = NULL;
    size_t sz = 0;

    print_proof_rec(p, 0, &seen, &sz);
    putchar('\n');
    fflush(stdout);

    if (seen) {
        free(seen);
    }
}


int main(int argc, const char **argv)
{
    msat_config cfg = msat_create_config();
    msat_set_option(cfg, "proof_generation", "true");
    msat_set_option(cfg, "preprocessor.toplevel_propagation", "false");
    msat_set_option(cfg, "preprocessor.simplification", "0");
    msat_set_option(cfg, "theory.bv.eager",  /* for BV, only the lazy */
                    "false");                /* solver is proof-producing */
    msat_set_option(cfg, "theory.fp.mode", "2");
    msat_env env = msat_create_env(cfg);
    msat_destroy_config(cfg);

    msat_term f;
    if (argc == 2) {
        FILE *src = fopen(argv[1], "r");
        if (!src) {
            printf("Error opening %s\n", argv[1]);
            return 1;
        }
        f = msat_from_smtlib2_file(env, src);
        fclose(src);
    } else {
        f = msat_from_smtlib2(
            env,
            "(declare-const A1 Bool)"
            "(declare-const A2 Bool)"
            "(declare-const B0 Bool)"
            "(declare-const B1 Bool)"
            "(declare-const B2 Bool)"
            "(declare-const B3 Bool)"
            "(declare-const B4 Bool)"
            "(declare-const B5 Bool)"
            "(declare-const B6 Bool)"
            "(declare-const B7 Bool)"
            "(assert (or B0 (not B1) A1))"
            "(assert (or B0 B1 A2))"
            "(assert (or (not B0) B1 A2))"
            "(assert (or (not B0) (not B1)))"
            "(assert (or (not B2) (not B4)))"
            "(assert (or (not A2) B2))"
            "(assert (or (not A1) B3))"
            "(assert B4)"
            "(assert (or A2 B5))"
            "(assert (or (not B6) (not B4)))"
            "(assert (or B6 (not A1)))"
            "(assert B7)");
    }
    assert(!MSAT_ERROR_TERM(f));
    msat_assert_formula(env, f);
    msat_result res = msat_solve(env);

    assert(res == MSAT_UNSAT);
    if (res == MSAT_UNSAT) {
        msat_proof_manager pm = msat_get_proof_manager(env);
        assert(!MSAT_ERROR_PROOF_MANAGER(pm));
        msat_proof p = msat_get_proof(pm);
        print_proof(p);
        msat_destroy_proof_manager(pm);
    }

    msat_destroy_env(env);

    return 0;
}