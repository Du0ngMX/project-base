#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <ctime>
using namespace std;

void swap(int &a, int &b) {
  a = a + b;
  b = a - b;
  a = a - b;
}

/* Hàm xuất mảng */
void printArray(int *arr, int size) {
  cout << "Arr Sorted: ";
  for (int i = 0; i < size; i++) {
    cout << *(arr + i) << " ";
  }
  cout << endl;
}

//=============================================================================
// O(n2)
void bubbleSort(int arr[], int n) { 
  bool swapped; 
  for (int i = 0; i < n-1; i++) { 
    swapped = false; 
    for (int j = 0; j < n-i-1; j++) { 
       if (arr[j] > arr[j+1]) { 
          swap(arr[j], arr[j+1]); 
          swapped = true; // Kiểm tra lần lặp này có swap không
       } 
    }
    printArray(arr, n);
    // Nếu không có swap nào được thực hiện => mảng đã sắp xếp. Không cần lặp thêm
    if (swapped == false) 
      break; 
  } 
}

// O(n2)
void selectionSort(int a[], int n) {
	int vtmin;
	for (int i = 0; i < n - 1; i++){
		vtmin = i;
		for (int j = i + 1; j < n; j++) { //Tìm phần tử nhỏ trong mảng chưa sắp xếp
			if (a[j] < a[vtmin]) {
				vtmin = j;
				swap(a[i], a[vtmin]); // Hoán đổi phần tử nhỏ nhất được tìm thấy với phần tử đầu tiên
			}
		}		
		printArray(a, n);
	}
}

// O (n2)
void insertionSort(int arr[], int n) {
	int key, pos;
	for (int i = 1; i < n; i++) {
		key = arr[i];
		pos = i - 1; // Tìm vị trí chèn key

		while (pos >= 0 && arr[pos] > key) {
			arr[pos + 1] = arr[pos];
			pos--;
		}
		arr[pos + 1] = key; // Chèn key vào đây
		printArray(arr, n);
	}
}

int main() {
  int arr[] = {64, 34, 25, 12, 22, 11, 90};
  int n = sizeof(arr)/sizeof(arr[0]);
  selectionSort(arr, n);
  
  cout << "Mang sau khi sap xep la: " << endl;
  printArray(arr, n);
  
  system("PAUSE");
  return 0; 
}
