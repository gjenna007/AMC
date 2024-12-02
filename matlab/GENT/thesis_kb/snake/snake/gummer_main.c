/*
 * MATLAB Compiler: 2.0
 * Date: Fri Feb 09 11:35:06 2001
 * Arguments: "-m" "gummer.m" "[gummer.c]" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "gummer.h"

static mlfFunctionTableEntry function_table[1]
  = { { "gummer", mlxGummer, 2, 1 } };

/*
 * The function "main" is a Compiler-generated main wrapper, suitable for
 * building a stand-alone application. It initializes a function table for use
 * by the feval function, and then calls the function "mlxGummer". Finally, it
 * clears the feval table and exits.
 */
int main(int argc, const char * * argv) {
    int status = 0;
    mxArray * varargin = mclInitialize(NULL);
    mxArray * result = mclInitialize(NULL);
    mlfEnterNewContext(0, 0);
    mlfFunctionTableSetup(1, function_table);
    mlfAssign(&varargin, mclCreateCellFromStrings(argc - 1, argv + 1));
    mlfAssign(
      &result,
      mlfFeval(
        mclValueVarargout(),
        mlxGummer,
        mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()),
        NULL));
    mxDestroyArray(varargin);
    if (mclIsInitialized(result) && ! mxIsEmpty(result)) {
        status = mclArrayToInt(result);
    }
    mxDestroyArray(result);
    mlfFunctionTableTakedown(1, function_table);
    mlfRestorePreviousContext(0, 0);
    return status;
}
