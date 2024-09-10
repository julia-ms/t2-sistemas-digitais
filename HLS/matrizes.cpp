#include "matrizes.h"

void matrizes(
      mat_a_t mat[MAT_A_ROWS][MAT_A_COLS],
      mat_b_t mat2[MAT_B_ROWS][MAT_B_COLS],
      result_t mat3[MAT_A_ROWS][MAT_B_COLS])
{
   //Media e bota na matriz 2x2--------------------------
    
    for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            mat2[0][0] += mat[i][j];
        }
    }
    mat2[0][0] /= 16;
    
    for(int i = 0; i < 4; i++){
        for(int j = 4; j < 8; j++){
            mat2[0][1] += mat[i][j];
        }
    }
    mat2[0][1] /= 16;
    
    for(int i = 4; i < 8; i++){
        for(int j = 0; j < 4; j++){
            mat2[1][0] += mat[i][j];
        }
    }
    mat2[1][0] /= 16;
    
    for(int i = 4; i < 8; i++){
        for(int j = 4; j < 8; j++){
            mat2[1][1] += mat[i][j];
        }
    }
    mat2[1][1] /= 16;
    
    //Multiplicacao da matriz por ela mesma----------------------
    
    mat3[0][0] = mat2[0][0]*mat2[0][0] + mat2[0][1]*mat2[1][0];
    mat3[0][1] = mat2[0][0]*mat2[0][1] + mat2[0][1]*mat2[1][1];
    mat3[1][0] = mat2[1][0]*mat2[0][0] + mat2[1][1]*mat2[1][0];
    mat3[1][1] = mat2[0][1]*mat2[1][0] + mat2[1][1]*mat2[1][1];

}
