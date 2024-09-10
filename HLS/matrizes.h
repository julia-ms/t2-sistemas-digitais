#ifndef __MATRIXMUL_H__
#define __MATRIXMUL_H__

#include <cmath>
using namespace std;



#define MAT_A_ROWS 8
#define MAT_A_COLS 8
#define MAT_B_ROWS 2
#define MAT_B_COLS 2
#define MAT_R_ROWS 2
#define MAT_R_COLS 2

typedef signed char mat_a_t; //8bits
typedef signed char mat_b_t; //8bits
typedef signed short result_t; //16bits

// Prototype of top level function for C-synthesis
void matrizes(
      mat_a_t a[MAT_A_ROWS][MAT_A_COLS],
      mat_b_t b[MAT_B_ROWS][MAT_B_COLS],
      result_t res[MAT_R_ROWS][MAT_R_COLS]);

#endif