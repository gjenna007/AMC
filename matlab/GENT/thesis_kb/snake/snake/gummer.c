/*
 * MATLAB Compiler: 2.0
 * Date: Fri Feb 09 11:35:06 2001
 * Arguments: "-m" "gummer.m" "[gummer.c]" 
 */
#include "gummer.h"

/*
 * The function "Mgummer" is the implementation version of the "gummer"
 * M-function from file "\\Fuzzie\gs\GVF\snake\gummer.m" (lines 1-13). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function a=gummer(orig,getek)
 */
static mxArray * Mgummer(int nargout_, mxArray * orig, mxArray * getek) {
    mxArray * a = mclGetUninitializedArray();
    mxArray * S = mclUnassigned();
    mxArray * hor = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * s = mclGetUninitializedArray();
    mxArray * ver = mclGetUninitializedArray();
    mclValidateInputs("gummer", 2, &orig, &getek);
    /*
     * %blauwe pixels worden gecorrigeerd
     * s=size(orig);
     */
    mlfAssign(&s, mlfSize(mclValueVarargout(), orig, NULL));
    /*
     * a=getek;
     */
    mlfAssign(&a, getek);
    /*
     * for ver=1:s(1)
     */
    for (mclForStart(
           &iterator_0,
           mlfScalar(1.0),
           mlfIndexRef(s, "(?)", mlfScalar(1.0)),
           NULL);
         mclForNext(&iterator_0, &ver);
         ) {
        /*
         * for hor=1:S(2)
         */
        for (mclForStart(
               &iterator_1,
               mlfScalar(1.0),
               mlfIndexRef(S, "(?)", mlfScalar(2.0)),
               NULL);
             mclForNext(&iterator_1, &hor);
             ) {
            /*
             * if getek(ver,hor,3)>getek(ver,hor,2)
             */
            if (mlfTobool(
                  mlfGt(
                    mlfIndexRef(getek, "(?,?,?)", ver, hor, mlfScalar(3.0)),
                    mlfIndexRef(getek, "(?,?,?)", ver, hor, mlfScalar(2.0))))) {
                /*
                 * a(s(1),s(2),:)=orig(s(1),s(2),:);
                 */
                mlfIndexAssign(
                  &a,
                  "(?,?,?)",
                  mlfIndexRef(s, "(?)", mlfScalar(1.0)),
                  mlfIndexRef(s, "(?)", mlfScalar(2.0)),
                  mlfCreateColonIndex(),
                  mlfIndexRef(
                    orig,
                    "(?,?,?)",
                    mlfIndexRef(s, "(?)", mlfScalar(1.0)),
                    mlfIndexRef(s, "(?)", mlfScalar(2.0)),
                    mlfCreateColonIndex()));
            /*
             * end
             */
            }
        /*
         * end
         */
        }
        /*
         * ver
         */
        mclPrintArray(ver, "ver");
    /*
     * end
     */
    }
    mclValidateOutputs("gummer", 1, nargout_, &a);
    mxDestroyArray(S);
    mxDestroyArray(hor);
    mxDestroyArray(s);
    mxDestroyArray(ver);
    return a;
}

/*
 * The function "mlfGummer" contains the normal interface for the "gummer"
 * M-function from file "\\Fuzzie\gs\GVF\snake\gummer.m" (lines 1-13). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfGummer(mxArray * orig, mxArray * getek) {
    int nargout = 1;
    mxArray * a = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, orig, getek);
    a = Mgummer(nargout, orig, getek);
    mlfRestorePreviousContext(0, 2, orig, getek);
    return mlfReturnValue(a);
}

/*
 * The function "mlxGummer" contains the feval interface for the "gummer"
 * M-function from file "\\Fuzzie\gs\GVF\snake\gummer.m" (lines 1-13). The
 * feval function calls the implementation version of gummer through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxGummer(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: gummer Line: 1 Column: "
            "0 The function \"gummer\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: gummer Line: 1 Column: "
            "0 The function \"gummer\" was called with mor"
            "e than the declared number of inputs (2)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mgummer(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}
