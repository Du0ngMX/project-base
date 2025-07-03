// State Pattern là một trong những Pattern thuộc nhóm hành vi (Behavior Pattern).
// Nó cho phép một đối tượng thay đổi hành vi của nó khi trạng thái nội bộ của nó thay đổi.
// Đối tượng sẽ xuất hiện để thay đổi lớp của nó.

#include <iostream>

using namespace std;

class State {
public:
	virtual void handleRequest() const = 0;
};

class NewState : public State {
public:
	void handleRequest() const {
		cout << "Create a new document" << endl;
	}
};

class SubmittedState : public State {
public:
	void handleRequest() const {
		cout << "Submitted" << endl;
	}
};

class ApprovedState : public State {
public:
	void handleRequest() const {
		cout << "Approved" << endl;
	}
};

class RejectedState : public State {
public:
	void handleRequest() const {
		cout << "Rejected" << endl;
	}
};

class DocumentContext {
private:
	State *state;
public:
	void setState(State *state) {
		this->state = state;
	}

	void applyState() {
		this->state->handleRequest();
	}
};

int main() {

	DocumentContext *context = new DocumentContext();

	context->setState(new NewState());
	context->applyState();

	context->setState(new SubmittedState());
	context->applyState();

	context->setState(new ApprovedState());
	context->applyState();

	//context->setState(new RejectedState());
	//context->applyState();

	delete context;
	return 0;
}

// Lợi ích:
// Đảm bảo nguyên tắc Single responsibility principle(SRP) : tách biệt mỗi State tương ứng với 1 class riêng biệt.
// Đảm bảo nguyên tắc Open / Closed Principle(OCP) : chúng ta có thể thêm một State mới mà không ảnh hưởng đến State khác hay Context hiện có.
// Giữ hành vi cụ thể tương ứng với trạng thái.
// Giúp chuyển trạng thái một cách rõ ràng.
