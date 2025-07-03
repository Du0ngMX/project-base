
# Senior C/C++ Interview Topics and Questions with Answers

## 1. C/C++ Core Language

### Kiến thức cần nắm:

* Con trỏ (pointer), tham chiếu (reference), tham trị (pass by value).
* Khai báo và sử dụng const, volatile, static, extern: ý nghĩa, phạm vi, và khi nào sử dụng phù hợp?
* Con trỏ hàm, mảng, struct, union.
* Quy trình biên dịch: Preprocessing → Compilation → Linking.
* Guard header file (#ifndef/#define): tránh include đệ quy.

### Câu hỏi và phân tích:

**Q1:** Sự khác biệt giữa con trỏ và tham chiếu là gì?

**Q2:** Tham trị và tham chiếu khác nhau ra sao trong truyền tham số?

**Q3:** Khi nào xảy ra memory leak? Ví dụ? Giải pháp?

**Q4:** Sự khác nhau giữa `malloc` và `calloc` là gì? Dùng khi nào?

**Q5:** Guard header file là gì và tại sao cần dùng?

| Hàm      | Chức năng                             | Giá trị khởi tạo | Hiệu năng |
|----------|----------------------------------------|------------------|-----------|
| `malloc` | Cấp phát bộ nhớ chưa khởi tạo         | Không có         | Nhanh hơn |
| `calloc` | Cấp phát và khởi tạo toàn bộ bằng 0   | Mỗi byte = 0     | Chậm hơn  |

**Ví dụ:**

```cpp
int* arr1 = (int*)malloc(5 * sizeof(int));    // arr1 chưa được khởi tạo
int* arr2 = (int*)calloc(5, sizeof(int));     // arr2 được khởi tạo = 0
````

**Ghi chú:**

* Nếu dùng `malloc`, sau đó muốn khởi tạo giá trị về 0, có thể dùng `memset`:

```cpp
int* arr = (int*)malloc(10 * sizeof(int));
memset(arr, 0, 10 * sizeof(int));
```

* Với `calloc`, không cần gọi `memset` vì đã được 0 hóa.

**Khi nào nên dùng:**

* Dùng `malloc` khi bạn sẽ gán giá trị cho toàn bộ vùng nhớ sau đó và muốn hiệu năng cao.
* Dùng `calloc` khi bạn cần chắc chắn vùng nhớ có giá trị ban đầu bằng 0 để tránh lỗi truy cập vào giá trị rác.

**Ví dụ minh họa các vùng nhớ hoạt động song song:**

```cpp
#include <iostream>

int global = 1;                 // Data segment
static int static_global;       // BSS

void exampleMemory() {
    int local = 10;             // Stack
    static int static_local = 20; // Data
    int* heapVar = new int(30); // Heap

    std::cout << "Global: " << global << std::endl;
    std::cout << "Static Local: " << static_local << std::endl;
    std::cout << "Local: " << local << std::endl;
    std::cout << "Heap: " << *heapVar << std::endl;

    delete heapVar; // Giải phóng heap
}
```

---

## Từ khóa `const`, `volatile`, `static`, `extern` – dùng khi nào?

| Từ khóa    | Ý nghĩa                                               | Dùng để làm gì                         | Phạm vi ảnh hưởng | Ví dụ                               |
| ---------- | ----------------------------------------------------- | -------------------------------------- | ----------------- | ----------------------------------- |
| `const`    | Không thay đổi                                        | Bảo vệ biến không bị sửa               | Compile-time      | `const int x = 10;`                 |
| `volatile` | Biến có thể thay đổi ngoài tầm kiểm soát của compiler | Tránh tối ưu hóa không đúng            | Runtime           | `volatile int* reg = (int*)0x1234;` |
| `static`   | Giữ nguyên giá trị giữa các lần gọi                   | Ẩn biến trong file hoặc giữ trạng thái | File/Hàm          | `static int counter = 0;`           |
| `extern`   | Khai báo biến nằm ở file khác                         | Kết nối giữa các file                  | Global            | `extern int g_counter;`             |

---

## Q1: Sự khác biệt giữa con trỏ và tham chiếu là gì?

| Đặc điểm         | Con trỏ (`*`)      | Tham chiếu (`&`)   |
| ---------------- | ------------------ | ------------------ |
| Có thể NULL      | Có                 | Không              |
| Thay đổi địa chỉ | Có                 | Không              |
| Phải khởi tạo    | Không bắt buộc     | Bắt buộc           |
| Cách truy cập    | Dùng `*` hoặc `->` | Truy cập trực tiếp |
| Bộ nhớ lưu trữ   | Stack hoặc Heap    | Stack (bản danh)   |

**Ví dụ:**

```cpp
int a = 10;
int* p = &a;   // Con trỏ
int& r = a;    // Tham chiếu

void incrementPointer(int* p) {
    (*p)++;
}

void incrementReference(int& r) {
    r++;
}

int main() {
    int x = 5;
    incrementPointer(&x);   // x = 6
    incrementReference(x);  // x = 7
}
```

**Khi nào dùng cái nào?**

* Dùng **con trỏ** khi:

  * Cần trỏ tới NULL hoặc thay đổi đối tượng trỏ tới tại runtime.
  * Dùng trong cấu trúc dữ liệu như danh sách liên kết, cây, mảng động.
* Dùng **tham chiếu** khi:

  * Truyền tham số để thay đổi giá trị gốc mà không muốn làm việc với con trỏ.
  * An toàn hơn, dễ hiểu, tránh lỗi NULL.

---

## Q2: Tham trị và tham chiếu khác nhau ra sao trong truyền tham số?

* **Tham trị:** Tạo bản sao → thay đổi trong hàm không ảnh hưởng biến gốc.
* **Tham chiếu/con trỏ:** Truy cập trực tiếp → thay đổi ảnh hưởng đến biến gốc.

---

## Q3: Khi nào xảy ra memory leak? Ví dụ? Giải pháp?

**Memory leak xảy ra khi:**

* Bộ nhớ được cấp phát nhưng không được giải phóng (dùng `new`/`malloc` mà không `delete`/`free`)
* Mất quyền truy cập đến vùng nhớ (con trỏ bị ghi đè, vượt scope...)

**Ví dụ gây memory leak:**

```cpp
void foo() {
    int* p = new int[100];
    p = new int[50]; // vùng nhớ đầu tiên bị rò rỉ
}
```

**Giải pháp:**

* Sử dụng **smart pointer** như `std::unique_ptr`, `std::shared_ptr`.
* Luôn `delete` hoặc `free` trước khi cấp phát lại.
* Dùng công cụ như **Valgrind**, **AddressSanitizer** để kiểm tra.

**Lưu ý:** Gán con trỏ về `nullptr` sau khi `delete` để tránh trỏ lung tung (dangling pointer):

```cpp
int* p = new int;
delete p;
p = nullptr;
```

---

## Q4: Guard header file là gì và tại sao cần dùng?

Dùng để tránh include đệ quy khi header bị gọi nhiều lần trong các file khác nhau:

```cpp
#ifndef MY_HEADER_H
#define MY_HEADER_H

// nội dung file .h

#endif
```

---

## 2. Object-Oriented Programming (OOP) in C++

### Định nghĩa OOP và các tính chất:

* **OOP (Lập trình hướng đối tượng)** là mô hình lập trình tổ chức phần mềm thành các **đối tượng** (object) thay vì chỉ dùng hàm hoặc thủ tục. Mỗi đối tượng bao gồm **dữ liệu (thuộc tính)** và **hành vi (phương thức)**.

* **Bốn tính chất chính của OOP:**

  1. **Encapsulation (Đóng gói):** che giấu chi tiết cài đặt, chỉ cung cấp giao diện truy cập.
  2. **Abstraction (Trừu tượng hóa):** mô tả những đặc điểm cần thiết, bỏ qua chi tiết không quan trọng.
  3. **Inheritance (Kế thừa):** lớp con có thể kế thừa thuộc tính và phương thức của lớp cha.
  4. **Polymorphism (Đa hình):** đối tượng có thể hành xử khác nhau khi gọi cùng một phương thức (ví dụ qua hàm ảo).

* **Tính chất quan trọng nhất:**

  * Tùy bối cảnh, nhưng trong thực tế **Encapsulation** thường là nền tảng giúp bảo trì hệ thống dễ dàng.
  * Với hệ thống lớn, **Polymorphism** giúp mở rộng linh hoạt, tránh sửa code gốc (tuân theo Open/Closed Principle).

* **Ví dụ đơn giản:**

```cpp
class Animal {
public:
    virtual void speak() const { std::cout << "Unknown"; }
};

class Dog : public Animal {
public:
    void speak() const override { std::cout << "Woof"; }
};

void makeItSpeak(const Animal& a) {
    a.speak();
}

int main() {
    Dog d;
    makeItSpeak(d); // In ra: Woof
}
````

---

### Kiến thức cần nắm:

* Class, struct, kế thừa, đa hình.
* Virtual function, pure virtual, abstract class.
* Rule of 3 / 5 / 0.
* Destructor ảo (`virtual ~Base()`): cần để gọi đúng destructor khi xóa qua con trỏ base.

---

### Câu hỏi và phân tích:

**Q1:** Khác nhau giữa overload và override?

#### Overload (Nạp chồng):

* Là khi có nhiều hàm cùng tên nhưng khác tham số (số lượng hoặc kiểu tham số).
* Xảy ra tại compile-time.
* Cho phép định nghĩa nhiều hành vi cho cùng một tên hàm nhưng với đối số khác nhau.

```cpp
class Printer {
public:
    void print(int i) { std::cout << "int: " << i; }
    void print(const std::string& s) { std::cout << "string: " << s; }
};
```

#### Override (Ghi đè):

* Là khi lớp con cung cấp định nghĩa mới cho hàm ảo (`virtual`) của lớp cha.
* Xảy ra tại runtime.
* Yêu cầu từ khóa `virtual` ở lớp cha và `override` ở lớp con (từ C++11).

```cpp
class Base {
public:
    virtual void speak() const { std::cout << "Base"; }
};

class Derived : public Base {
public:
    void speak() const override { std::cout << "Derived"; }
};
```

#### So sánh:

| Đặc điểm        | Overload        | Override                            |
| --------------- | --------------- | ----------------------------------- |
| Thời điểm xử lý | Compile-time    | Runtime (qua vtable)                |
| Dựa vào         | Khác tham số    | Cùng hàm `virtual`, khác triển khai |
| Mục đích        | Đa năng với hàm | Thay đổi hành vi kế thừa            |

---

**Q2:** Vì sao destructor class cha nên khai báo là `virtual`?

* Nếu xóa object của lớp con qua con trỏ của lớp cha **mà destructor không `virtual`**, chỉ destructor của lớp cha được gọi → gây **memory leak** nếu lớp con cấp phát động.

```cpp
class Base {
public:
    ~Base() { std::cout << "~Base"; }
};

class Derived : public Base {
public:
    ~Derived() { std::cout << "~Derived"; }
};

Base* obj = new Derived();
delete obj; // chỉ gọi ~Base() nếu không virtual
```

#### Giải pháp:

Dùng `virtual ~Base()` để đảm bảo gọi đúng thứ tự hủy từ lớp con lên lớp cha:

```cpp
class Base {
public:
    virtual ~Base() { std::cout << "~Base"; }
};
```

---

**Q3:** Pure virtual function khai báo thế nào? Đặc điểm của abstract class?

* **Pure virtual function** là hàm ảo không có phần thân, khai báo bằng `= 0`:

```cpp
class Shape {
public:
    virtual void draw() = 0; // pure virtual
};
```

* Một lớp có ít nhất một pure virtual function là **abstract class**, không thể tạo đối tượng trực tiếp.
* Abstract class dùng làm interface hoặc lớp cơ sở chung.

```cpp
class Circle : public Shape {
public:
    void draw() override { std::cout << "Draw circle"; }
};

Shape* s = new Circle();
s->draw(); // In ra: Draw circle
```

---

**Q4:** So sánh abstract class và interface:

* Trong C++, không có từ khóa `interface`, nhưng abstract class có thể được dùng như interface.

| Tiêu chí         | Abstract Class                      | Interface (pure abstract class)       |
| ---------------- | ----------------------------------- | ------------------------------------- |
| Hàm thành viên   | Có thể có cả hàm thường và thuần ảo | Chỉ gồm các hàm thuần ảo              |
| Biến thành viên  | Có thể có                           | Không nên có                          |
| Khả năng mở rộng | Dễ mở rộng                          | Chỉ định nghĩa API                    |
| Tính kế thừa     | Hỗ trợ kế thừa đơn                  | C++ không hỗ trợ đa kế thừa interface |

#### Ví dụ abstract class đóng vai trò interface:

```cpp
class IPrintable {
public:
    virtual void print() = 0;
    virtual ~IPrintable() {}
};

class Document : public IPrintable {
public:
    void print() override { std::cout << "Print doc"; }
};
```

---

Bạn có thể sao chép đoạn này hoặc yêu cầu mình xuất ra file `.md` để tải về dễ dàng.

👉 Gõ: **“xuất file giúp tôi”** nếu bạn muốn mình tạo file Markdown đã sửa.


**Khi nào dùng cái gì:**

* Dùng abstract class khi cần:

  * Định nghĩa hành vi chung có thể có triển khai mặc định.
  * Tái sử dụng code.

* Dùng interface (pure abstract class) khi:

  * Chỉ muốn định nghĩa API, không chứa logic thực thi.

* C++ không có từ khóa `interface` riêng, nhưng abstract class với chỉ các pure virtual functions tương đương với interface trong Java. Tuy nhiên, C++ cho phép có code triển khai trong abstract class.

---

## 3. Memory Management

### Các vùng nhớ trong chương trình C/C++:

1. **Text segment (Code segment):** chứa mã lệnh của chương trình.
2. **Data segment:** chứa biến toàn cục, biến static đã được khởi tạo.
3. **BSS (Block Started by Symbol):** chứa biến toàn cục/static chưa khởi tạo.
4. **Heap:** quản lý bởi lập trình viên, dùng `malloc/new`, giải phóng bằng `free/delete`.
5. **Stack:** chứa biến cục bộ, tham số hàm, con trỏ trả về. Tự động cấp phát/thu hồi khi vào/thoát hàm.

---

### So sánh các vùng nhớ:

| Vùng nhớ   | Quản lý bởi       | Tốc độ truy cập | Khi nào dùng              | Ví dụ biến                  |
|------------|-------------------|------------------|---------------------------|-----------------------------|
| Stack      | Hệ điều hành       | Nhanh            | Biến cục bộ, tham số hàm  | `int x;` trong hàm          |
| Heap       | Lập trình viên     | Trung bình       | Dữ liệu động, mảng lớn    | `int* p = new int[100];`    |
| Data       | HĐH + compiler     | Nhanh            | Biến toàn cục khởi tạo    | `int g = 10;`               |
| BSS        | HĐH + compiler     | Nhanh            | Biến toàn cục chưa init   | `static int x;`             |
| Text (Code)| Compiler           | Chỉ đọc          | Mã lệnh chương trình      | `main()`                    |

---

### Ví dụ minh họa vùng nhớ:

```cpp
int globalVar = 1;             // Data segment
static int staticGlobal;       // BSS

void func() {
    int localVar = 2;          // Stack
    static int staticVar = 3;  // Data
    int* heapVar = new int(4); // Heap
    delete heapVar;
}
```

### Kiến thức cần nắm:

* Stack vs Heap.
* Allocation (`malloc/new`) và deallocation (`free/delete`).
* Smart pointers (`unique_ptr`, `shared_ptr`, `weak_ptr`).
* Dangling pointer, memory leak, buffer overflow.

---

### Câu hỏi và phân tích:

**Q1:** Memory leak xảy ra khi nào?

* Khi vùng nhớ cấp phát không được giải phóng. Ví dụ: trong vòng lặp cấp phát mà không `delete`.

**Q2:** Cách tránh hoặc phát hiện memory leak?

* Sử dụng smart pointers.
* Dùng công cụ: Valgrind, AddressSanitizer, Visual Leak Detector.

**Q3:** `unique_ptr` vs `shared_ptr`?

* `unique_ptr`: độc quyền, không copy được, nhẹ và an toàn.
* `shared_ptr`: nhiều con trỏ cùng quản lý, có reference count.

---

## 4. Template và STL

### Kiến thức cần nắm:

* Function templates, class templates.
* STL containers: `vector`, `map`, `set`, `unordered_map`.
* Iterator, algorithm.

### Định nghĩa các container phổ biến:

**`vector<T>`:**

* Mảng động, cho phép truy cập theo chỉ số (random access).
* Tự động mở rộng dung lượng khi thêm phần tử.
* Nội dung lưu liên tục trong bộ nhớ.

**`map<Key, Value>`:**

* Cấu trúc cây đỏ-đen (balanced BST).
* Duy trì thứ tự tăng dần của key.
* Tìm kiếm, chèn, xóa: O(log n).

**`set<T>`:**

* Tương tự `map`, nhưng chỉ lưu key duy nhất (không có value).
* Không cho phép phần tử trùng.

**`unordered_map<Key, Value>`:**

* Cấu trúc bảng băm (hash table).
* Không duy trì thứ tự key.
* Truy cập trung bình O(1), nhưng có thể O(n) trong trường hợp hash xấu.

---

### So sánh hiệu năng:

| Container       | Truy cập ngẫu nhiên | Tìm kiếm       | Duy trì thứ tự | Cho phép phần tử trùng |
|-----------------|---------------------|----------------|----------------|-------------------------|
| `vector`        | O(1)                | O(n)           | Không          | Có                      |
| `map`           | O(log n)            | O(log n)       | Có             | Không                   |
| `set`           | Không               | O(log n)       | Có             | Không                   |
| `unordered_map` | Không               | O(1) (trung bình) | Không       | Không                   |

---

### Tips cần lưu ý khi dùng:

* Với `vector`, tránh dùng `push_back` trong vòng lặp lớn mà không dùng `reserve` → tránh reallocations không cần thiết:

```cpp
std::vector<int> v;
v.reserve(1000); // tăng hiệu năng rõ rệt nếu biết trước kích thước
```

* `unordered_map` cần custom hash cho các kiểu dữ liệu phức tạp.
* `map` phù hợp khi cần duyệt theo thứ tự.
* Không dùng `vector<bool>` nếu cần truy cập nhiều → bị tối ưu thành bitset, hiệu năng thấp.
* Dùng `emplace_back` thay vì `push_back` với object phức tạp để tránh copy.

---

### Câu hỏi và phân tích:

**Q1:** Template specialization là gì?

* Cho phép định nghĩa lại hành vi template cho kiểu cụ thể.

**Q2:** `map` vs `unordered_map`?

* `map`: Cây đỏ-đen, sắp xếp theo key, O(log n).
* `unordered_map`: Hash table, không sắp xếp, O(1) trung bình.

---

## 5. Struct, Union và Memory Layout

### Kiến thức cần nắm:

* Sự khác nhau giữa `struct` và `union`.
* Tính kích thước struct với padding/alignment.
* So sánh `struct` và `class` trong C++.
* Dùng `#pragma pack`, `alignas`, `offsetof` để kiểm soát layout.

---

### Câu hỏi và phân tích:

**Q1:** Sự khác nhau giữa `struct` và `union`:

```cpp
struct MyStruct {
    int a;
    float b;
};

union MyUnion {
    int a;
    float b;
};
```

* `MyStruct` sẽ có kích thước bằng tổng các phần tử (có thể thêm padding).
* `MyUnion` sẽ có kích thước bằng phần tử lớn nhất.

---

**Q2:** Khi nào dùng `struct`, khi nào dùng `union`?

* **Union** được dùng khi các trường dữ liệu dùng chung bộ nhớ để tiết kiệm, ví dụ trong giao thức truyền tin.
* **Struct** dùng khi các trường cần tồn tại độc lập.

---

**Q3:** So sánh `struct` và `class` trong C++:

| Đặc điểm        | struct | class   |
| --------------- | ------ | ------- |
| Mặc định access | public | private |
| Tính kế thừa    | Có     | Có      |
| Dùng trong C    | Có     | Không   |

**Ví dụ minh họa:**

```cpp
struct Point {
    int x, y;
};

class PointClass {
    int x, y;
public:
    void set(int a, int b) { x = a; y = b; }
};
```

---

**Q4:** Alignment và Padding là gì?

```cpp
struct S1 {
    char a;   // 1 byte
    int b;    // 4 bytes (padding 3 byte sau a)
};
```

* Tổng kích thước = 8 byte (thay vì 5), để đảm bảo `b` bắt đầu tại địa chỉ chia hết cho 4 (alignment 4-byte).

---

**Dùng pragma để bỏ padding:**

```cpp
#pragma pack(1)
struct Packed {
    char a;
    int b;
};
#pragma pack()
```

* Sau khi dùng `#pragma pack(1)`, tổng kích thước `Packed` sẽ là 5 byte (không có padding), nhưng hiệu năng có thể giảm trên một số kiến trúc CPU.

---

## 6. Multithreading v? Multiprocessing

### Kiến thức cần nắm:

* Sự khác nhau giữa đa luồng (multithreading) và đa tiến trình (multiprocessing).
* Race condition, deadlock, synchronization.
* Dùng mutex, semaphore, condition variable.
* Các cơ chế giao tiếp liên tiến trình (IPC): shared memory, pipe, socket.

---

**Shared Memory:**

* Vùng nhớ được chia sẻ giữa các tiến trình.
* Hiệu năng cao nhưng cần đồng bộ (sử dụng semaphore hoặc mutex).
* Thường dùng trong hệ thống real-time hoặc embedded.

**Pipe:**

* Một chiều, dùng để truyền dữ liệu giữa các tiến trình cha-con.
* Có sẵn trong hệ thống Unix/Linux.

**Socket:**

* Giao tiếp hai chiều giữa các tiến trình trên cùng hoặc khác máy.
* Thường dùng trong ứng dụng client-server.

---

**So sánh:**

| Phương pháp     | Hai chiều | Hệ điều hành    | Khả năng chia sẻ        | Dễ dùng     | Ghi chú                |
|-----------------|-----------|-----------------|--------------------------|-------------|------------------------|
| Shared memory   | Có        | Unix/Windows    | Có                       | Trung bình  | Cần đồng bộ            |
| Pipe            | Một chiều | Unix            | Không                    | Dễ          | Giao tiếp cơ bản       |
| Socket          | Có        | Mọi nền tảng     | Không (dữ liệu qua mạng) | Trung bình  | Giao tiếp phân tán     |

---

### Câu hỏi và phân tích:

**Q1:** So sánh multithreading và multiprocessing:

| Tiêu chí            | Multithreading                         | Multiprocessing                          |
|---------------------|----------------------------------------|-------------------------------------------|
| Bộ nhớ              | Chia sẻ cùng bộ nhớ                    | Bộ nhớ tách biệt                          |
| Tạo mới             | Nhanh (lightweight)                    | Chậm hơn (process nặng hơn thread)        |
| Giao tiếp           | Dễ (qua shared memory)                | Khó hơn (qua IPC: pipe, socket...)        |
| Ảnh hưởng lẫn nhau  | Có thể ảnh hưởng nếu không đồng bộ     | Tách biệt nên ít ảnh hưởng nhau           |
| Độ ổn định          | Dễ bị lỗi nếu không quản lý tốt        | Ổn định hơn do không chia sẻ trạng thái   |

---

**Q2:** Khi nào nên dùng multithreading?

* Khi các tác vụ nhẹ, cần tốc độ cao và chia sẻ dữ liệu.
* Ví dụ: đọc file song song, xử lý mạng, giao diện đồ họa.

---

**Q3:** Khi nào nên dùng multiprocessing?

* Khi các tác vụ độc lập, tiêu tốn CPU hoặc có thể gây lỗi nghiêm trọng.
* Ví dụ: rendering video, xử lý dữ liệu lớn, sandboxing.

---

**Q4:** Cách tránh xung đột trong multithread:

* Dùng `std::mutex`, `std::lock_guard` để tránh race condition.

```cpp
std::mutex mtx;
void func() {
    std::lock_guard<std::mutex> lock(mtx);
    // xử lý dữ liệu an toàn ở đây
}
```

---

**Q5:** Sự khác nhau giữa `mutex` và `semaphore`:

| Đặc điểm     | Mutex                                 | Semaphore                                |
| ------------ | ------------------------------------- | ---------------------------------------- |
| Đơn vị       | 1 thread giữ lock                     | Cho nhiều đơn vị đồng thời chờ           |
| Sử dụng      | Tránh truy cập đồng thời 1 tài nguyên | Điều phối nhiều luồng cùng lúc           |
| API phổ biến | `std::mutex`, `pthread_mutex`         | `std::counting_semaphore`, POSIX `sem_t` |

---

## 7. Build System và Linking

### Kiến thức cần nắm:

* Quá trình biên dịch C/C++:

  1. **Preprocessing** (`#include`, `#define`, `#ifdef`...)
  2. **Compilation** (dịch từng file `.cpp` thành `.o`)
  3. **Assembling** (tạo mã máy)
  4. **Linking** (kết nối các symbol lại với nhau, tạo executable)

---

* **Static Linking (LIB):**

  * Thư viện được nhúng trực tiếp vào executable tại thời điểm build.
  * Kích thước file lớn hơn.
  * Không phụ thuộc thư viện ngoài khi chạy.

* **Dynamic Linking (DLL/SO):**

  * Không nhúng nội dung thư viện vào executable.
  * Chỉ liên kết các symbol tại runtime.
  * Cho phép chia sẻ thư viện giữa nhiều chương trình, dễ cập nhật.

---

### So sánh DLL và Static LIB:

| Đặc điểm            | Static LIB (.lib)      | DLL (.dll / .so)                        |
|---------------------|------------------------|------------------------------------------|
| Liên kết            | Tại thời điểm build     | Tại thời điểm chạy (runtime)            |
| Kích thước file exe | Lớn hơn                 | Nhỏ hơn                                  |
| Phụ thuộc runtime   | Không                   | Có (phải có DLL tại runtime)             |
| Chia sẻ thư viện    | Không                   | Có (giữa các chương trình khác nhau)     |

---

### Câu hỏi và phân tích:

**Q1:** Muốn sử dụng thư viện C++ (build dạng DLL hoặc LIB) trong ứng dụng C# thì phải làm gì?

* **Giải pháp:** Dùng kỹ thuật gọi hàm C-style từ C# thông qua `P/Invoke` (Platform Invocation Services).

* Thư viện C++ cần:

  * Export hàm dưới dạng `extern "C" __declspec(dllexport)` để tránh name mangling.
  * Không dùng class C++ trực tiếp, chỉ dùng hàm C-style.

---

**Ví dụ bên C++:**

```cpp
extern "C" __declspec(dllexport)
int Add(int a, int b) {
    return a + b;
}
```

---

**Bên C#:**

```csharp
[DllImport("MyCppLibrary.dll")]
public static extern int Add(int a, int b);
```

---

* Khi build, cần đảm bảo DLL được đặt cạnh file `.exe` của C# hoặc đăng ký vào hệ thống (GAC hoặc PATH).

---

## 8. Debugging và Performance Tuning

### Kiến thức cần nắm:

* GDB, Valgrind, perf, Address Sanitizer.
* Inline function, loop unrolling.
* Memory access pattern, branch prediction.

---

### Câu hỏi và phân tích:

**Q1:** Làm sao xác định segmentation fault?

* Dùng GDB để backtrace.
* Kiểm tra con trỏ NULL hoặc vùng nhớ chưa cấp phát.

---

**Q2:** Dụng cụ gì để debug?

* GDB, Valgrind, Sanitizer.

---

**Q3:** Làm sao tối ưu vòng lặp?

* Giảm số phép toán, dùng dữ liệu cache-friendly, áp dụng loop unrolling.


---

## 9. Design Patterns và Kiến trúc
### Kiến thức cần nắm:

* Singleton, Factory, Strategy, Observer,...
* Nguyên lý SOLID.
* Clean code, maintainability.

---

### Câu hỏi và phân tích:

**Q1:** Singleton pattern?

* Chỉ tạo một instance duy nhất. Dùng `static` và đảm bảo thread-safe bằng mutex hoặc `std::call_once`.

**Q2:** Khi nào dùng Factory?

* Khi cần tách biệt quá trình tạo object khỏi class sử dụng, hỗ trợ mở rộng dễ dàng.

---

## 10. Câu hỏi Thực tế / Kỹ năng hệ thống

* Viết lại `memcpy` thủ công:

```cpp
void* my_memcpy(void* dest, const void* src, size_t size) {
    char* d = static_cast<char*>(dest);
    const char* s = static_cast<const char*>(src);
    for (size_t i = 0; i < size; ++i) d[i] = s[i];
    return dest;
}
```

* Thiết kế hệ thống xử lý đa tiến trình / đa luồng.
* Tối ưu hiệu năng khi xử lý tập dữ liệu lớn.
