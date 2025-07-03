#include <iostream>
#include <string>
using namespace std;


int main() {

	int num1 = 2;
	int num2 = 10;
	const char *c = "data";

	//==============================================================
	// Hằng con trỏ : <data_type> * const <name> = <address>;
	// Khi khai báo cần phải khởi tạo
	// Địa chỉ khởi tạo là cố định, không được thay đổi
	// Có thể thay đổi được giá trị
	//==============================================================

	// int* const ptr1; //error
	int * const ptr1 = &num1;
	// ptr1++;       // error
	// ptr1 = &num2; // error
	*ptr1 = 10;

	//===============================================================
	// Con trỏ hằng : const <data_type> * <name>;
	// Có thể trỏ đến ô nhớ khác nhau
	// Không thể thay đổi giá trị
	//===============================================================

	const int *ptr2;
	ptr2 = &num1;
	ptr2 = &num2;
	ptr2++;
	// *ptr2 = 10; // error

	//===============================================================
	// Hằng con trỏ trỏ tới hằng : const <data_type> * const <name> = <address>;
	// Không thể thay đổi được địa chỉ mà con trỏ trỏ tới
	// Không thể thay đổi được giá trị tại địa chỉ mà con trỏ trỏ tới
	//================================================================

	const int * const ptr3 = &num1;
	// ptr3 = &num2; // error
	// ptr3++;       // error
	// *ptr3 = 100;  //error

	return 0;
}
