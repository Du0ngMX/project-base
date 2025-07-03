// Mẫu thiết kế này đảm bảo rằng chỉ có một đối tượng instance được khởi tạo.
// Nó thường được sử dụng cho logging class nên chỉ có 1 đối tượng có quyền truy cập vào log files.

#include <iostream>

class Singleton {
private:
	static Singleton* instance;  // Khai báo 1 instance để lưu trữ

	// Để constructor là private là để ngăn thằng này hoạt động kiểu khi tạo đối tượng theo =>  new Singleton()
	// Chỉ có instance mới có thể gọi constructor, không cho phép truy cập public
	Singleton();

public:
	static Singleton* getInstance();  // tạo 1 phương thức để truy cập đối tượng
};

Singleton* Singleton::instance = 0; // Khởi tạo đối tượng = 0 hoặc NULL 

Singleton* Singleton::getInstance() {
	if (instance == 0) {
		instance = new Singleton();
	}
	return instance;
}

Singleton::Singleton(){}

int main() {
	//new Singleton(); Không khởi tạo được đối tượng bằng kiểu này được
	Singleton* s = Singleton::getInstance(); // Ok
	Singleton* r = Singleton::getInstance();

	// In ra địa chỉ 2 thằng này sẽ giống nhau
	std::cout << s << std::endl;
	std::cout << r << std::endl;

	return 0;
}
