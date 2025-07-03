// Mô hình MVC chia ứng dụng ra thành 3 thành phần chính: Model, View và Controller.
// Model nghĩa là các dữ liệu cần thiết để hiển thị ở View. Model đại diện cho một tập hợp các lớp mô tả business logic (business model và data model).
// View đại diện cho các thành phần UI như XML, HTML. View sẽ hiển thị dữ liệu đã qua xử lý từ Controller. Model và View tương tác với nhau qua Observer pattern.
// Controller có trách nhiệm xử lý các yêu cầu (request) được gửi đến. Nó sẽ xử lý các dữ liệu của người dùng qua Model và trả về kết quả ở View

#include <iostream>
using namespace std;

class Model {
private:
	int value;
public:
	inline void setValue(int v) { this->value = v; }
	inline int getValue() const { return this->value; }
};

class View {
public:
	void showValue(int value) { cout << "show value = " << value << endl; }
};

class Controller {
private:
	Model model;
	View view;
public:
	Controller(Model m, View v): model {m}, view {v} {}
	void setValue(int v) { model.setValue(v); }
	void getValue() { model.getValue(); }
	void showValue() { view.showValue(model.getValue()); }
};


int main() {
	cout << "start=================>" << endl;
	Model model;
	View view;
	model.setValue(69);

	Controller ctrol(model, view);
	ctrol.showValue();
	cout << "end===================>" << endl;
	return 0;
}
