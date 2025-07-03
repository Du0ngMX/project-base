/**
* std::unique_ptr : sử dụng để quản lý các vùng nhớ mà không cấp quyền sử dụng chung tài nguyên cho các đối tượng khác.
* std::shared_ptr : được thiết kế để nhiều đối tượng có thể sử dụng, chia sẻ, cùng quản lý chung một tài nguyên.
* std::shared_ptr cung cấp cơ chế theo dõi số lượng đối tượng std::shared_ptr đang chia sẻ cùng 1 tài nguyên với nhau.
* Tài nguyên được quản lý sẽ không bị hệ điều hành thu hồi cho đến khi đối tượng std::shared_ptr còn lại duy nhất đang quản lý nó bị hủy.
*/ 

#include <iostream>
#include <memory>
#include <string>
using namespace std;

struct Resource {
	Resource() { cout << "Resource contructor" << endl; }
	~Resource() { cout <<"Resource destructor" << endl; }
	string getData() { return "I'm data"; }
};

int main() {

	cout << "start=================>1" << endl;

	{
		unique_ptr<Resource> res = make_unique<Resource>();

		if (res) {
			cout << res->getData() << endl;
		}
	}

	cout << "start=================>2" << endl;
	{
		shared_ptr<Resource> res1(new Resource());
		{
			auto res2 = res1;
			cout << "Killing one shared pointer" << endl;
		}
	}

	cout << "end==================>" << endl;

	return 0;
}
