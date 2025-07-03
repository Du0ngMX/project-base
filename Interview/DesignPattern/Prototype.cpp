// Prototype pattern là một trong những Creational pattern.
// Nó có nhiệm vụ khởi tạo một đối tượng bằng cách clone một đối tượng đã tồn tại thay vì khởi tạo với từ khoá new.
// Đối tượng mới là một bản sao có thể giống 100 % với đối tượng gốc,
// chúng ta có thể thay đổi dữ liệu của nó mà không ảnh hưởng đến đối tượng gốc.

#include <iostream>
#include <vector>

using namespace std;

class Shape {
protected:
	int X;
	int Y;
	string color;

public:
	Shape() {} // constructor 
	Shape(const Shape &s) : X{ s.X }, Y{ s.Y }, color{ s.color } {} // Copy Constructor
	virtual ~Shape() {}
	virtual Shape *Clone() const = 0; // Phương thức Clone trả về 1 con trỏ đến đối tượng Shape, chú ý giải phóng bộ nhớ khi dùng chỗ này không toang.
};

class Rectangle : public Shape {
private:
	int width;
	int height;

public:
	Rectangle(int w, int h) : Shape{}, width{ w }, height{ h } {} // constructor 
	Rectangle(const Rectangle &r) : Shape{}, width{ r.width }, height{ r.height } {} // Copy Constructor

	Shape *Clone() const override{
		return new Rectangle(*this);
	}
};

class Circle : public Shape {
private:
	int radius;

public:
	Circle(int r) : Shape{}, radius{ r } {} // constructor 
	Circle(const Circle &c): Shape {}, radius{c.radius} {} // Copy Constructor

	Shape *Clone() const override{
		return new Circle(*this);
	}
};

class PrototypeFactory {
private:
	vector<Shape*> shapes;
	string type;

public:
	PrototypeFactory(const string &type) : type{ type } {} // constructor 
	PrototypeFactory(const PrototypeFactory &p) : type{ p.type } {
		for (auto it = p.shapes.begin(); it != p.shapes.end(); it++)
			shapes.push_back((*it)->Clone());
	}
	~PrototypeFactory() {}

	void AddMember(Shape* ptr) { shapes.push_back(ptr); }
};

int main() {
	PrototypeFactory *prototype1 = new PrototypeFactory("type1");
	Shape* ptr1 = new Rectangle(10, 20);
	Shape* ptr2 = new Rectangle(30, 50);
	Shape* ptr3 = new Circle(10);
	prototype1->AddMember(ptr1);
	prototype1->AddMember(ptr2);
	prototype1->AddMember(ptr3);
	// Gọi hàm sao chép của lớp PrototypeFactory, Lần lượt gọi phương thức Clone() của Shape
	PrototypeFactory *prototype2= new PrototypeFactory(*prototype1);

	delete prototype1;
	delete prototype2;

	return 0;
}
