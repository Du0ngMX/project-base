SELF-INTRODUCATIO

----
Agenda
+ Personal infomation
+ Education background
+ Working experience
+ Reccent projects in charge
+ Plan after joining

---
Personal infomation: 
- Name:
- Date of birth:
- Address:

---
Education
+ 2010 - 2015 : Hanoi University of Science and technolory
+ Electronic and telecommunication
+ Talented Engineer class

---
Working experience

----
Plan after joining
-Improve skill
+ programming : c/c++, Qt, Android
+ Communication
+ leadership
- Become a team leader

----

### 1, Con trỏ là gì?
 - Là một biến được dùng để lưu trữ địa chỉ của biến khác.
 - khai báo: <data_type> *<name_of_pointer>;
 
 ví dụ:</br>
 ```
  int *ptr; //declare an int pointer
  
  int value = 5;
  ptr = &value; //ptr point to value

  cout << &value << endl; //print the address of value
  cout << ptr << endl;    //print the address of value which is held in ptr

  cout << value << endl;  //print the content of value
  cout << *(&value) << endl; //print the content of value
  cout << *ptr << endl;	//print the content of value
 ```
 
### 2, Cấp phát động trong c(malloc, calloc) và c++(new)

Trong c:
+ malloc:
ptr = (castType*) malloc(size);
ví dụ: ```ptr = (int*) malloc(100 * sizeof(int));```

+ calloc:
ptr = (castType*)calloc(n, size);
ví dụ: ```ptr = (int*) calloc(100, sizeof(int));```

+ realloc: thay đổi kích thước bộ nhớ đã được cấp phát trước đó
ptr = realloc(ptr, n);

+ free:
free(ptr); // ptr là con trỏ

Trong C++
+ sử dụng toán tử new và giải phóng bộ nhớ sử dụng delete.
ví dụ:</br>
```
float *ptr = new float[num];
delete [] ptr;
```

### 3, khác nhau malloc and calloc?

|               malloc()	              |                  calloc()                 |
|:--------------------------------------|:------------------------------------------|
|malloc viết tắt của memory allocation	| calloc viết tắt của contiguous allocation |
|=======================================|===========================================|
|malloc nhận 1 tham số truyền vào là số byte của vùng nhớ cần cấp phát   | calloc nhận 2 tham số truyền vào là số block và kích thước mỗi block (byte)      |
|=======================================|===========================================|
| void *malloc(size_t n);               | void *calloc(size_t n, size_t size);      |
|=======================================|===========================================|
|Hàm trả về con trỏ trỏ tới vùng nhớ nếu nếu cấp phát thành công, trả về NULL nếu cấp phát fail | Hàm trả về con trỏ trỏ tới vùng nhớ được cấp phát và vùng nhớ được khởi tạo bằng giá trị 0. Trả về NULL nếu cấp phát fail  |
|=======================================|===========================================|
|Hàm malloc() nhanh hơn hàm calloc()	  | Hàm calloc() tốn thêm thời gian khởi tạo vùng nhớ. Tuy nhiên, sự khác biệt này không đáng kể. 
|=======================================|===========================================|


### 4, dùng hàm gì để khởi tạo giá trị các ô nhớ sau khi dùng malloc?
- Chúng ta có thể đạt được chức năng tương tự như calloc() bằng cách sử dụng malloc() theo sau là memset().
```
ptr = malloc(size); 
memset(ptr, 0, size); 
```

### 5, Vì sao sau khi delete con trỏ thì nên gán giá trị nullptr cho nó?
- Thu hồi bộ nhớ c(free), c++ (delete): Nên check xem con trỏ khác null trước thi thực hiện xóa.
- Đặt con trỏ thành 0 (là "null" hoặc nullptr trong C ++ tiêu chuẩn, NULL xác định từ C có phần khác nhau) để tránh sự cố khi xóa hai lần.


### 6, Smart pointer
Có 2 loại này hay được dùng:
- std::unique_ptr : sử dụng để quản lý các vùng nhớ mà không cấp quyền sử dụng chung tài nguyên cho các đối tượng khác.
- std::shared_ptr : được thiết kế để nhiều đối tượng có thể sử dụng, chia sẻ, cùng quản lý chung một tài nguyên.
- std::shared_ptr cung cấp cơ chế theo dõi số lượng đối tượng std::shared_ptr đang chia sẻ cùng 1 tài nguyên với nhau.
- Tài nguyên được quản lý sẽ không bị hệ điều hành thu hồi cho đến khi đối tượng std::shared_ptr còn lại duy nhất đang quản lý nó bị hủy.

Cách dùng
```
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
		unique_ptr<Resource> res = make_unique<Resource>(); // khai báo

		if (res) {
			cout << res->getData() << endl;
		}
	}

	cout << "start=================>2" << endl;
	{
		shared_ptr<Resource> res1(new Resource()); //  khai báo
		{
			auto res2 = res1;
			cout << "Killing one shared pointer" << endl;
		}
	}

	cout << "end==================>" << endl;

	return 0;
}
```
### 7, Khi nào xảy ra memory leak?
memory leak sẽ xảy xa khi ứng dụng của chúng ta đã dùng quá nhiều bộ nhớ dẫn tới tình trạng thiếu hụt không gian lưu trữ. Nói cách khác, việc một đối tượng được tạo bởi ứng dụng nhưng ứng dụng không thể truy cập hoặc xử lý sẽ có thể dẫn đến lỗi memory leak.

### 8, 4 tính chất hướng đối tượng c++ là gì?
- Tính trừu tượng(Abstraction)
- Tính đóng gói (Encapsulation)
- Tính kế thừa (Inheritance)
- Tính đa hình (Polymorphism )

### 9, Cho 1 ví dụ về tính đa hình?
Trong C++, tính đa hình chủ yếu được chia thành hai loại:
- Compile time Polymorphism (Tính đa hình này được sử dụng bằng cách nạp chồng hàm hoặc nạp chồng toán tử).
- Runtime Polymorphism (Tính đa hình được thể hiện ở cách nạp chồng toán tử trong kế thừa).

### 10, overload, override khác nhau như nào?

### 11, Vì sao destructor của class cha nên khai báo virtual?
- Virtual destructor là một thứ rất quan trọng khi bạn làm việc với C++, nếu bạn có ý định cho phép kế thừa class mà bạn đang viết thì bạn bắt buộc phải thêm virtual destructor cho class đó, ngược lại thì bạn đang ngầm ám chỉ rằng class của bạn không cho phép kế thừa. Điều này tương đương với từ khoá final trong Java. Nếu bạn thấy một class không có virtual destructor, đơn giản là đừng có kế thừa nó, vì nó đi không đúng với ý định của người viết ra class, và có thể gây ra thiệt hại hệ thống nếu bạn cố tình bỏ qua.</br>
ví dụ:
```
class Animal {
public:
    virtual ~Animal(){printf("This is Animal's destructor\n");};
}; 

class Cat : public Animal {
public:
    ~Cat(){printf("This is Cat's destructor\n");};
};

int main() {
    Animal* tom = new Cat();
    delete tom;
}

```
output:</br>
```
This is Cat's destructor
This is Animal's destructor
```

### 12, truyền tham trỏ, tham trị, tham chiếu khác nhau như nào, khi nào dùng loại nào?

### 13, kích thước struct tính như nào, alignment memory là gì ?

- size của struct phải là tổng size của các thành phần bên trong nó.
- Data Structure Alignment là gì?
+ Data alignment: sắp xếp data sao cho địa chỉ của các biến luôn là số chẵn và phù hợp với hệ thống.
+ Data padding: để làm được việc alignment như ở trên chúng ta cần phải “padding” thêm một số byte vào sau biến “char c” để khi đó biến “int i” có thể ở địa chỉ chẵn.

ví dụ:
```
struct padding {
    char c1;
    int i1;
    char c2;
    short s1;
};
```
===> sizeof = 12
```
struct no_padding {
    int i1;
    char c1;
    char c2;
    short s1;
};
```
===> sizeof = 8

### 14, khác nhau struct và union?
- struct và union cơ bản giống nhau. Tuy nhiên, về mặt lưu trữ trong bộ nhớ, chúng có sự khác biệt rõ rệt như sau:
 =>>> chỉ khác một điều union tận dụng tối đa vùng nhớ trống để lưu trữ kiểu dữ liệu. Còn struct thì không.
 ```
typedef union Struct1{
    char a;
    char b;
    int c;
};
```
----------> sizeof = 4
```
typedef struct Struct2{
    char a;
    char b;
    int c;
};
```
---------> sizeof = 8

### 15, array(vector) và list khác nhau như nào?

- List là double linked list
- Vector là dynamic array, tức là array được cấp phát động bằng Allocator

Khi nào nên dùng list và khi nào nên dùng vector?

Nên mặc định sử dụng vector. Bởi vì phần lớn các trường hợp mình hay dùng là thêm phần tử vào cuối mảng và truy xuất random một phần từ nào đấy. Vector là array, việc thêm phần tử vào cuối mảng hay lấy một phần tử bất rất dễ dàng và nhanh.

Khi náo ử dụng list?

Khi ta cần thêm/xóa phần tử ở giữa mảng hoặc ở đầu mảng nhiều hơn so với việc thêm vào ở cuối. Và không có nhu cầu truy vấn random các phần tử một cách thường xuyên

Ưu và nhược của chúng là gì?

####Ưu của vector:
Thêm vào cuối mảng nhanh, truy xuất phần tử nhanh vì mỗi phần tử đều có index.

####Nhược của vector:
Chèn phần tử chậm, cần một khoảng nhớ liên tiếp để chứa mảng. Khi hết chứa đủ mảng thì cần phải allocate/move một mảng mới với số phần tử gấp đôi.

####Ưu của list:
Chèn phần tử, xóa phần tử nhanh, không cần một khoảng nhớ liên tiếp để chứa các phần tử vì nó là double linked list

####Nhược của list:
Truy xuất phần tử chậm vì các phần tử không có index thực, phải duyệt danh sách phần tử cho tới khi tới được phần tử cần.

### 16, Hàm inline đặc điểm?
- Hàm inline được sử dụng để yêu cầu trình biên dịch (compiler) thay thế lời gọi hàm bằng toàn bộ mã code của hàm nhằm mục đích giảm thời gian chạy chương trình.
- Hàm inline được sử dụng khi:
	+ Trong chương trình, khi cần thời gian thực hiện ngắn (ưu tiên hiệu suất), và chắc chắn rằng việc sử dụng sẽ mang lại hiệu suất.
	+ Các hàm có nội dung rất nhỏ và được gọi rất thường xuyên.
	+ Sử dụng hàm inline trong class, nên sử dụng từ khóa inline bên ngoài lớp với định nghĩa hàm.
- Trường hợp không nên sử dụng hàm inline:
	+ Do quá trình compiler thay thế các vị trí gọi hàm bằng nôi dung hàm nên các trường hợp hàm lớn, phức tạp, nếu sử dụng hàm inline sẽ dẫn tới tệp thực thi lớn và sẽ tốn tài nguyên để lưu các biến trong hàm inline.
	+ Hàm khởi tạo và hàm hủy.
	+ Hàm ảo hầu như sẽ không được là hàm inline. -> Hàm ảo khi được gọi bằng tham chiếu của lớp cơ sở hoặc con trỏ, thì không thể là inline_function (vì lời gọi sẽ được giải quyết trong thời gian chạy chương trình). Nhưng khi được gọi bằng cách sử dụng đối tượng (không có tham chiếu hoặc con trỏ) của lớp đó, có thể là inline_function vì trình biên dịch biết chính xác lớp của đối tượng trong thời gian biên dịch chương trình. 

- Trình biên dịch có thể không thực hiện nội tuyến trong các trường hợp như:

	+ Hàm chứa vòng lặp (for, while, do-while).
	+ Hàm chứa các biến tĩnh.
	+ Hàm đệ quy.
	+ Hàm chứa câu lệnh switch hoặc goto.
	
Ưu điểm:
- Tiết kiệm chi phí gọi hàm.
- Tiết kiệm chi phí của các biến trên ngăn xếp khi hàm được gọi.
- Tiết kiệm chi phí cuộc gọi trả về từ một hàm.
- Có thể đặt định nghĩa hàm nội tuyến (inline functions) trong file tiêu đề (*.h) (nghĩa là nó có thể được include trong nhiều đơn vị biên dịch, hàm thông thường sẽ gây ra lỗi).

Nhược điểm:
- Tăng kích thước file thực thi do sự trùng lặp của cùng một mã.
- Khi được sử dụng trong file tiêu đề (*.h), nó làm cho file tiêu đề của bạn lớn hơn.
- Hàm nội tuyến có thể không hữu ích cho nhiều hệ thống nhúng. Vì trong các hệ thống nhúng, kích thước mã quan trọng hơn tốc độ.

### 17, Biến static và hàm thành viên static?

- Biến được định nghĩa bên trong một khối lệnh (block) được gọi là các biến cục bộ (Local variables).
- Biến cục bộ có thời gian tự động, nghĩa là chúng được tạo tại thời điểm định nghĩa, và bị hủy khi ra khỏi khối lệnh mà biến đó được định nghĩa</br>

Khi sử dụng từ khóa “static” với các biến cục bộ, nó sẽ trở thành biến tĩnh (static variables).

- Biến tĩnh (static variables) là biến được tạo ra duy nhất một lần khi gọi hàm lần đầu tiên và nó sẽ tiếp tục tồn trong suốt vòng đời của chương trình. Đây là sự khác biệt giữa biến tĩnh và biến cục bộ.

Biến tĩnh (static variables) là loại biến lưỡng tính, vừa có tính chất của 1 biến toàn cục (global variables), vừa mang tính chất của 1 biến cục bộ (local variables):

- Tính chất của biến toàn cục: biến không mất đi khi khối lệnh định nghĩa nó kết thúc, nó vẫn nằm trong vùng nhớ của chương trình và được tự động cập nhật khi khối lệnh đó được gọi lại.
- Tính chất của biến cục bộ: biến chỉ có thể được sử dụng trong khối lệnh mà nó được khai báo.</br>

Sử dụng biến tĩnh khi có nhu cầu giữ giá trị của biến trong chương trình.

### 18, multi thread và multi process khác nhau như nào?
- Điểm quan trọng nhất cần chú ý là một thread có thể làm bất cứ nhiệm vụ gì một process có thể làm. Tuy nhiên, vì một process có thể chứa nhiều thread, mỗi thread có thể coi như là một process nhỏ. Vậy, điểm khác biệt mấu chốt giữa thread và process là công việc mỗi cái thường phải làm. 

- Một điểm khác biệt nữa đó là nhiều thread nằm trong cùng một process dùng một không gian bộ nhớ giống nhau, trong khi process thì không. Điều này cho phép các thread đọc và viết cùng một kiểu cấu trúc và dữ liệu, giao tiếp dễ dàng giữa các thread với nhau. Giao thức giữa các process, hay còn gọi là IPC (inter-process communication) thì tương đối phức tạp bởi các dữ liệu có tính tập trung sâu hơn.
</br>
Sau đây là bảng tổng kết sự khác nhau giữa thread và process:

- Để tạo nhiều thread thì dễ dàng hơn so với process vì chúng không cần các địa chỉ nhớ riêng rẽ.
- Việc chạy đa luồng cần được lập trình một cách chi tiết vì các thread chia sẻ các cấu trúc chung mà chỉ sử dụng được bởi từng thread vào mỗi thời điểm. Khác với thread, các process không dùng chung địa chỉ nhớ.
- Thread được xếp hạng “nhẹ cân” bởi vì chúng sử dụng ít tài nguyên hơn so với các process.
- Các process chạy độc lập với nhau. Các thread thì sử dụng chung các địa chỉ nhớ liên kết với nhau, vì thế cần thận trọng tránh việc thread này nhảy sang thread khác. (Điều đã được nhắc đến trong ý thứ 2 vừa trên)
- Một process có thể chứa nhiều thread. 

### 19, Khi dùng multi thread phải chú ý gì? Dùng hàm gì để tránh gây xung đột bộ nhớ khi dùng multi thread?

### 20, So sánh sự khác nhau giữa abstract class và interface?
Interface:
- Không phải là class.
- Chỉ chứa những method/properties trống không có thực thi.
- Nó giống như một khuôn mẫu, một khung để để các lớp implement và follow.
- Các lớp có thể implements nhiều interface.
- Là một contract, các class implement phải triển khai các method theo như interface đã định nghĩa.

Abstract class:
- Khá giống Interface nhưng nó có thể làm nhiều việc hơn.
- Có 2 loại method là abstract method và method thường:
- abstract method là method trống không có thực thi.
- method thường là method có thực thi.
- Các lớp chỉ có thể kế thừa một Abstract class
- Hướng đến tính năng và những tính năng có thực thi được sử dụng làm hàm chung cho các class extend.

Ưu điểm:
- Interface
	+ Có thể kế thừa nhiều interface(tính đa hình).
	+ Xây dựng được bộ khung mẫu mà các lớp phải follow theo.
	+ Giúp quản lý tốt, nắm bắt được các chức năng phải có cho một đối tượng nào đó.
- Abstract class
	+ Có thể linh động các method. giống như một class thông thường.
	+ Các class extend có thể override hoặc không override các method thường.

Nhược điểm:
- Interface: Mỗi khi định nghĩa thêm tính năng, các class impelement nó đồng lọat phải thêm tính năng đó, khả năng cao sẽ không có xử lý gì.
- Abstract class: Không thể extend nhiều abstract class.

### 21, Pure virtual khai báo như nào, có đặc điểm gì?
- Hàm ảo thuần túy là một hàm ảo trong C ++ mà chúng ta không cần phải viết bất kỳ định nghĩa hàm nào và chỉ chúng ta phải khai báo nó. Nó được khai báo bằng cách gán 0 trong khai báo.

- Abstract class có thể có các hàm và biến thông thường cùng với một hàm thuần ảo.

- Abstract class không thể được khởi tạo, nhưng con trỏ và tham chiếu của loại lớp Trừu tượng có thể được tạo.

- Abstract class chủ yếu được sử dụng cho Upcasting, do đó các lớp dẫn xuất của nó có thể sử dụng giao diện của nó.

- Nếu Abstract class có lớp dẫn xuất, chúng phải thực hiện tất cả các hàm ảo thuần túy, nếu không chúng cũng sẽ trở thành Trừu tượng.

- Chúng ta có thể tạo đối tượng của Abstract class khi chúng tôi dành một vị trí cho một hàm thuần ảo trong Vtable, nhưng chúng ta không đặt bất kỳ địa chỉ nào, vì vậy Vtable sẽ không đầy đủ.

### 22, guard header file là gì,tại sao cần guard header?
- Header guard (hay còn gọi là inlcude guard) là một phương pháp cực kì đơn giản để tránh việc include header file 2 lần trong một file source.
- Hiện nay rất nhiều compiler hổ trợ #pragma once, và nó có mục đích tương tự như header guard.
- Tuy nhiên, #pragma once không phải là thành phần chính thức trong C++, không phải compiler nào cũng hổ trợ.
- Nên sử dụng header guard thay vì #pragma once

### 23, Khi nào dùng friend class?
Mục đích:
- Friend được xây dựng để khắc phục điểm yếu lớp dẫn xuất không thể truy cập tới các biến private của lớp cơ sở.

Định nghĩa:
- Một friend có thể là một hàm, một mẫu hàm, hoặc hàm thành viên, hoặc một lớp hoặc một mẫu lớp, trong trường hợp này, toàn bộ lớp và tất cả thành viên của nó là friend.
- Hàm friend trong C++ của một lớp được định nghĩa bên ngoài phạm vi lớp đó, nhưng nó có quyền truy cập tất cả thành viên private và protected của lớp đó. Ngay cả khi các nguyên mẫu cho hàm friend xuất hiện trong định nghĩa lớp, thì các hàm friend không là các hàm thành viên.</br>

Tính chất:
- Friend của một class có thể là thành viên của 1 class khác
- Friend của 1 class có thể là thành viên của class khác hoặc tất cả các class trong cùng 1 chương trình. Như là 1 GLOBAL FRIEND
- Friend có thể access private hoặc protected của class được khai báo là Friend.
- Friends không phải là một thành viên vì vậy không có con trỏ “this”
- Friend có thể khai báo ở bất cứ đâu ( public, protected or private section) trong một class.
Khai báo
- Để khai báo một hàm dạng hàm friend của một lớp, đặt trước nguyên mẫu hàm đó trong định nghĩa lớp với từ khóa friend trong C++, như sau:
```
class Person {
private:
   string name;
public:
   friend void DisplayName( Person person); //hàmhiển thị tên
   void setName( string name );
};
```
- Để khai báo tất cả hàm thành viên của lớp Employee là dạng friend của lớp Person, đặt một khai báo sau trong định nghĩa của lớp Person:
```
class Person {
   friend class Employee; // Employee là friend của person
};
```

### 24, dll và lib khác nhau như nào?
– Dynamic Link library (.dll, .so, .dylib) : chứa mã nhị phân, là ngôn ngữ bậc thấp của hệ điều hành, do đó chúng ta không thể mở nó ra như mở file text được.Các chương trình (hay các file .exe) có sử dụng đến thư viện liên kết động sẽ đọc code trong các file .dll (hay .so trên linux…) này để sử dụng trong quá trình chạy.
 
– Static library (.lib, .a): chứa mã nhị phân, chúng được các chương trình gọi tới trong quá trình biên dịch,  bây giờ code trong file .exe của bạn sẽ bao gồm code của cả file thư viện.

- Thư viện liên kết động giảm thiểu số lượng code có trong chương trình của bạn, do đó chương trình bạn viết ra sẽ luôn gọn nhẹ hơn so với dùng thư viện liên kết tĩnh.
- Thư viện liên kết động cho phép nhiều chương trình sử dụng nó một cách trực tiếp mà không cần phải biên dịch lại.
- sử dụng thư viện liên kết động sẽ làm cho thời gian chạy chương trình lâu hơn do phải truy cập file, đọc file… từ đĩa cứng… vốn là công việc đòi hỏi thời gian.

- Thư viện liên kết tĩnh thì ngược lại, chúng sẽ làm cho chương trình của bạn phình to ra do phải copy code trong thư viện vào code của chính nó.
- chương trình của bạn sẽ chạy rất nhanh, bởi vì chúng không mất thời gian mở các file .dll ra để đọc code, chúng đã có sẵn code trong RAM cùng với code của mình rồi.

### 25,  Overload operator?

### 26, Linked Lists?

### 27, Stack, queue, heap.

### 28, Đệ Quy?

### 29, Sự khác biệt giữa Semaphore và Mutex
|Cơ sở để so sánh|	Semaphore|	Mutex|
|:---------------|:----------|:-----------|
|Căn bản|	Semaphore là một cơ chế báo hiệu.|	Mutex là một cơ chế khóa.|
| | | |
|Sự tồn tại|	Semaphore là một biến số nguyên.|	Mutex là một đối tượng.|
| | | |
|Chức năng|	Semaphore cho phép nhiều luồng chương trình truy cập vào một thể hiện hữu hạn của tài nguyên.|	Mutex cho phép nhiều luồng chương trình truy cập vào một tài nguyên nhưng không đồng thời.|
| | | |
|Quyền sở hữu|	Giá trị semaphore có thể được thay đổi bởi bất kỳ quá trình có được hoặc giải phóng tài nguyên.|	Khóa đối tượng Mutex chỉ được phát hành bởi quá trình đã có được khóa trên nó.|
| | | |
|Phân loại|	Semaphore có thể được phân loại thành đếm semaphore và semaphore nhị phân.|	Mutex không được phân loại thêm.|
| | | |
|Hoạt động|	Giá trị semaphore được sửa đổi bằng cách sử dụng thao tác Wait () và signal ().|	Đối tượng Mutex bị khóa hoặc mở khóa bởi quá trình yêu cầu hoặc giải phóng tài nguyên.|
| | | |
|Tài nguyên chiếm dụng|	Nếu tất cả các tài nguyên đang được sử dụng, quá trình yêu cầu tài nguyên thực hiện thao tác Wait () và tự chặn cho đến khi số lượng semaphore trở nên lớn hơn một.| Nếu một đối tượng mutex đã bị khóa, quá trình yêu cầu tài nguyên chờ và được hệ thống xếp hàng cho đến khi khóa được giải phóng.|
| | | |

#### Sự khác biệt chính giữa Semaphore và Mutex
- Semaphore là một cơ chế báo hiệu khi hoạt động Wait () và signal () được thực hiện trên biến semaphore cho biết liệu một quá trình có thu được tài nguyên hay giải phóng tài nguyên hay không. Mặt khác, mutex là một cơ chế khóa, vì để có được một tài nguyên, một quá trình cần phải khóa đối tượng mutex và trong khi phát hành một quy trình tài nguyên phải mở khóa đối tượng mutex.
- Semaphore thường là một biến số nguyên trong khi đó, mutex là một đối tượng .
- Semaphore cho phép nhiều luồng chương trình truy cập vào tài nguyên hữu hạn . Mặt khác, Mutex cho phép nhiều luồng chương trình truy cập vào một tài nguyên được chia sẻ nhưng mỗi lần một tài nguyên .
- Giá trị biến semaphore có thể được sửa đổi bởi bất kỳ quá trình nào có được hoặc giải phóng tài nguyên bằng cách thực hiện thao tác Wait () và signal (). Mặt khác, khóa thu được trên đối tượng mutex chỉ có thể được giải phóng bằng quá trình đã thu được khóa trên đối tượng mutex.
- Semaphore có hai loại đếm semaphore và semaphore nhị phân khá giống với mutex.
- Giá trị biến semaphore được sửa đổi bằng thao tác Wait () và signal () ngoài khởi tạo. Tuy nhiên, đối tượng tắt tiếng bị khóa hoặc mở khóa bằng quá trình lấy hoặc giải phóng tài nguyên.
- Nếu tất cả các tài nguyên được thu thập bởi quy trình và không có tài nguyên nào là miễn phí thì quy trình mong muốn có được tài nguyên thực hiện thao tác Wait () trên biến semaphore và tự chặn cho đến khi số lượng semaphore lớn hơn 0. Nhưng nếu một đối tượng mutex đã bị khóa sau đó quá trình mong muốn có được tài nguyên chờ đợi và được hệ thống xếp hàng cho đến khi tài nguyên được giải phóng và đối tượng mutex được mở khóa.

- Semaphore là một lựa chọn tốt hơn trong trường hợp có nhiều phiên bản tài nguyên có sẵn. Trong trường hợp mutex tài nguyên chia sẻ duy nhất là một lựa chọn tốt hơn.

