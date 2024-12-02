/*
 * MATLAB Compiler: 2.0
 * Date: Fri Feb 09 11:35:06 2001
 * Arguments: "-m" "gummer.m" "[gummer.c]" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __gummer_h
#define __gummer_h 1

#include "matlab.h"

extern mxArray * mlfGummer(mxArray * orig, mxArray * getek);
extern void mlxGummer(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
