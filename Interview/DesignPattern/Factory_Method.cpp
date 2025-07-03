// Tạo ra đối tượng tương ứng

#include <iostream>

using namespace std;

enum RequestType {
	USER = 0,
	TASK
};

// Đây là lớp cơ sở của tất cả các trình xử lý sử dụng dữ liệu
class BaseHandler {
  public:
	  BaseHandler() {}
	  virtual ~BaseHandler(void) {}
	  virtual void Show() {}
	  virtual void handleRequest() { cout << "Base handle request" << endl; }
};

class UserHandler : public BaseHandler {
public:
	UserHandler() { cout << "Constructor User Handler" << endl; }
	~UserHandler(void) = default;
	void handleRequest() { cout << "User handle request" << endl; }
};

class TaskHandler : public BaseHandler {
public:
	TaskHandler() { cout << "Constructor Task Handler" << endl; }
	~TaskHandler(void) = default;
	void handleRequest() { cout << "Task handle request" << endl; }
};


// handler factory file for creating ApIF request handlers
class RequestHandlerFactory {
public:
	RequestHandlerFactory() {}
	~RequestHandlerFactory(void) {}

	BaseHandler *createRequestHandler(RequestType type) {
		auto handler = static_cast<BaseHandler *>(nullptr);

		if (type == RequestType::USER) {
			handler = new UserHandler();
		}
		else if (type == RequestType::TASK) {
			handler = new TaskHandler();
		}
		return handler;
	}
};

int main() {

	cout << "Start =====================>" << endl;
	// actual get request handler
	RequestHandlerFactory *pFactory = new RequestHandlerFactory();
	auto handler = pFactory->createRequestHandler(RequestType::USER);
	handler->handleRequest();
	cout << "End =====================>" << endl;

	// release memory
	delete pFactory;
	delete handler;

	return 0;
}
