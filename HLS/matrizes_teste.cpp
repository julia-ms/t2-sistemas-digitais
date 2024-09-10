#include <iostream>
#include "matrizes.h"

using namespace std;

int main(int argc, char **argv)
{
   mat_a_t in_mat_a[8][8] = {
        {1,1,1,1,5,5,5,5},
        {-1,-2,-3,-4,-5,-6,-7,-8},
        {1,1,1,1,5,5,5,5},
        {-1,-2,-3,-4,-5,-6,-7,-8},
        {1,2,3,4,5,6,7,8},
        {-2,-2,-2,-2,-2,-2,-2,-2},
        {1,2,3,4,5,6,7,8},
        {-2,-2,-2,-2,-2,-2,-2,-2}
   };

   mat_b_t in_mat_b[2][2];

   result_t hw_result[2][2], sw_result[2][2];
   int err_cnt = 0;

   // Generate the expected result
   for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            in_mat_b[0][0] += in_mat_a[i][j];
        }
    }
    in_mat_b[0][0] /= 16;
    
    for(int i = 0; i < 4; i++){
        for(int j = 4; j < 8; j++){
            in_mat_b[0][1] += in_mat_a[i][j];
        }
    }
    in_mat_b[0][1] /= 16;
    
    for(int i = 4; i < 8; i++){
        for(int j = 0; j < 4; j++){
            in_mat_b[1][0] += in_mat_a[i][j];
        }
    }
    in_mat_b[1][0] /= 16;
    
    for(int i = 4; i < 8; i++){
        for(int j = 4; j < 8; j++){
            in_mat_b[1][1] += in_mat_a[i][j];
        }
    }
    in_mat_b[1][1] /= 16;
    
    //Multiplicacao da matriz por ela mesma----------------------
    
    sw_result[0][0] = in_mat_b[0][0]*in_mat_b[0][0] + in_mat_b[0][1]*in_mat_b[1][0];
    sw_result[0][1] = in_mat_b[0][0]*in_mat_b[0][1] + in_mat_b[0][1]*in_mat_b[1][1];
    sw_result[1][0] = in_mat_b[1][0]*in_mat_b[0][0] + in_mat_b[1][1]*in_mat_b[1][0];
    sw_result[1][1] = in_mat_b[0][1]*in_mat_b[1][0] + in_mat_b[1][1]*in_mat_b[1][1];
    

   // Compare TB vs HW C-model and/or RTL
   // Run function
   matrizes(in_mat_a,in_mat_b, hw_result);


   // Compare hw_result with sw_result
   for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
         // Check HW result against SW
         if (hw_result[i][j] != sw_result[i][j]) {
            err_cnt++;
         }

      }
   }


   if (err_cnt){
	  cout << "\n" << endl;
      cout << ">> ERROR: " << err_cnt << " mismatches detected!" << endl;

      //print matrix error results
      cout << "Matrix results:" << endl;
	  for (int i = 0; i < MAT_A_ROWS; i++) {
		  cout << "\n" << endl;
		  for (int j = 0; j < MAT_B_COLS; j++) {
			 cout << hw_result[i][j] << " ";
		  }
	  }
	 cout << "\n" << endl;

   }
   else{
	  cout << "\n" << endl;
      cout << "Test passes!! \n" << endl;

     //print matrix results
     cout << "Matrix results:" << endl;
   	 for (int i = 0; i < MAT_A_ROWS; i++) {
   		  cout << "\n" << endl;
   		  for (int j = 0; j < MAT_B_COLS; j++) {
   			 cout << hw_result[i][j] << " ";
   		  }
   	   }
   	 cout << "\n" << endl;
   }
 // return err_cnt;
}
