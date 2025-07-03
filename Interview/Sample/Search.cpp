#include <iostream>

using namespace std;
 
 // ĐỘ PHỨC TẠP HAY THỜI GIAN THỰC THI CỦA THUẬT TOÁN LÀ: O(log(n))
int BinarySearch(int arr[], const int& left, const int& right, const int& x) {
  if (right >= left) {
    int mid = left + (right - left)/2;
    
    if (arr[mid] == x) {
      return mid;
    }
 
    if (arr[mid] < x) {
      return BinarySearch(arr, mid + 1, right, x);
    }
 
    return BinarySearch(arr, left, mid - 1, x);
  }

  return -1;
}

int LinearSearch(int arr[], const int &n, const int &x) {
    for(int i = 0; i <= n - 1; ++i) {
        if (arr[i] == x) {
            return i;
        }
    }
    return -1;
}

int main() {
  int arr[] = {1, 4, 7, 8, 9, 14, 16, 18};
  int s_val = 14;
  auto num = sizeof(arr)/sizeof(arr[0]);
//   auto ret1 = BinarySearch(arr, 0, num -1, s_val);
  
  auto ret1 = LinearSearch(arr, num, s_val);
 
  if (ret1 != -1)
    std::cout << "Vi tri cua 14 la: " << ret1;
  else 
    std::cout << "Khong tim dc";
 
    return 0;
}
