// Adapter Pattern (Người chuyển đổi) là một trong những Pattern thuộc nhóm cấu trúc (Structural Pattern).
// Adapter Pattern cho phép các inteface (giao diện) không liên quan tới nhau có thể làm việc cùng nhau.
// Đối tượng giúp kết nối các interface gọi là Adapter.

#include <iostream>
#include <string>
using namespace std;

// đây là nội dung message được Client cung cấp cho thông dịch viên (Translator / Adapter)
class VietnameseTarget {
public:
	virtual ~VietnameseTarget() = default;
	virtual void send(string word) = 0;
};

// đây là interface hoặc class được người Nhật sử dụng để nhận message được chuyển đổi từ thông dịch viên (Translator).
class JapaneseAdaptee {
public:
	void receive(string words) {
		cout << "Retrieving words from Adapter ..." << endl;
		cout << words << endl;
	}
};

// thông dịch viên (Translator) sẽ là Adapter,
// nhận message tiếng Việt từ Client và chuyển đổi nó sang tiếng Nhật trước khi gởi cho người Nhật.
class TranslatorAdapter : public VietnameseTarget {
private:
	JapaneseAdaptee *adaptee;

	string translate(string vietnameseWords) {
		cout << "Translated!" << endl;
		return "こんにちは";
	}
public:
	TranslatorAdapter(JapaneseAdaptee *adaptee) {
		this->adaptee = adaptee;
	}

	void send(string words) {
		cout << "Reading Words ..." << endl;
		cout << words << endl;
		string vietnameseWords = this->translate(words);
		cout << "Sending Words ..." << endl;
		adaptee->receive(vietnameseWords);
	}
};

int main() {
	//  người Việt sẽ là Client trong ví dụ này,vì anh ta cần gửi một số message cho người Nhật.
	JapaneseAdaptee *adaptee = new JapaneseAdaptee();
	VietnameseTarget *client = new TranslatorAdapter(adaptee);
	client->send("Xin chào");

	delete adaptee;
	delete client;
	return 0;
}
