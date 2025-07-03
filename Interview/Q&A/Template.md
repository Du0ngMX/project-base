- template là một từ khóa trong C++, nó biểu diễn cho một kiểu dữ liệu trừu tượng có thể là int, float, class….
- Tại sao lại sử dụng template ? Thay vì viết overloading từng phương thức cho các kiểu dữ liệu khác nhau thì ta chỉ cần viết một phương thức template cho tất cả.
- template là từ khóa để báo cho trình biên dịch rằng đoạn mã sau đây định nghĩa cho nhiều kiểu dữ liệu và mã nguồn của nó sẽ được compile sinh ra tương ứng cho từng kiểu dữ liệu trong quá trình biên dịch.

-------------------------------------
- Có 2 loại template cơ bản:

  + Function template: là một khuôn mẫu hàm, cho phép định nghĩa các hàm tổng quát thao tác cho nhiều kiểu dữ liệu.
  + Class template: là một khuôn mẫu lớp, cho phép định nghĩa các lớp tổng quát cho nhiều kiểu dữ liệu.

- Cách dùng Function template trong C++

```
#include <iostream>

template <typename T>
const T& max(const T& x, const T& y) {
	return (x > y) ? x : y;
}

int main() {
	int i = max(3, 7); // returns 7
	std::cout << i << std::endl;

	double d = max(6.34, 18.523); // returns 18.523
	std::cout << d << std::endl;

	char ch = max('a', '6'); // returns 'a'
	std::cout << ch << std::endl;

	return 0;
}
```

- Giả sử bạn muốn dùng hai kiểu dữ liệu thì chúng ta sẽ làm như thế nào ?</br> Đơn giản ta chỉ cần khai báo thêm một kiểu dữ liệu tông quát mà thôi.

```
template<typename T, typename X>
void Swap(T &a, X &b) {
    T temp = a;
    a = (T)b;
    b = (X)temp;
}
```

- Cách dùng class template trong C++

```
#include <iostream>

template<class Type>
class Point {
private:
	Type x;
	Type y;
public:
	Point(Type x, Type y) : x {x}, y{y} {}
	Point() {}
	void printPoint() {
		std::cout << "(x = " << x << ", y = " << y << ")" << std::endl;
	}
};

int main() {

	Point<int> p(5, 10);
	p.printPoint();

	return 0;
}
```




