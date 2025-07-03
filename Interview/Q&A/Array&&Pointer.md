
### 1, con trỏ và mảng một chiều

```
int arr[] = { 32, 13, 66, 11, 22 };
```

- địa chỉ của mảng một chiều cũng là địa chỉ của phần tử đầu tiên (&arr[0]).
- việc sử dụng tên mảng một chiều cũng chính là chúng ta đang sử dụng địa chỉ của mảng một chiều (&arr tương đương với arr).
- arr, arr + 1, arr + 2, arr + 3, arr + 4 chính là địa chỉ của 5 phần tử của mảng arr. vì vậy chúng ta có thể sử dụng toán tử * để truy xuất giá trị của chúng

Tổng kết:</br>

- Tên mảng là một hằng địa chỉ (hằng con trỏ), nó chính là địa chỉ của phần tử đầu tiên của mảng.
- Địa chỉ:
  + arr　<=>　&arr[0]　<=>　&arr
  + (arr + i)　<=>　&arr[i]
- Giá trị:

  + *arr　<=>　arr[0]
  + *(arr + i)　<=>　arr[i]

### 2, con trỏ và mảng ký tự

```
char my_name[] = "Le Tran Dat";
my_name[1] = 'E'; //=> "LE Tran Dat"
```

- Điều này chứng tỏ mảng my_name được cấp phát bộ nhớ tại địa chỉ khác chuỗi hằng kí tự "Le Tran Dat", việc khởi tạo mảng kí tự bằng một chuỗi hằng kí tự chỉ đơn giản là copy từng kí tự của chuỗi "Le Tran Dat" và đưa vào mảng.

- Do đó, con trỏ kiểu char (char *) trỏ đến mảng my_name và trỏ đến vùng nhớ của chuỗi hằng kí tự "Le Tran Dat" là 2 trường hợp khác nhau.

- ví dụ:
```
// con trỏ p_name sau khi trỏ đến mảng my_name thì có thể thay đổi
// giá trị bên trong vùng nhớ mà mảng my_name đang nắm giữ,
// vì vùng nhớ này không phải là vùng nhớ hằng.

  char my_name[] = "Le Tran Dat";
  char *p_name = my_name;

  p_name[1] = 'E';
  cout << my_name << endl;
```


```
// Error nguyên nhân là do vùng nhớ lưu trữ chuỗi kí tự "Le Tran Dat" là vùng nhớ hằng,
// giá trị bên trong vùng nhớ này không thể thay đổi, trong khi đó lệnh p_name[1] = 'E';
// cố gắng thay đổi giá trị bên trong vùng nhớ hằng.

  char *p_name = "Le Tran Dat";
  p_name[1] = 'E';

  cout << p_name << endl;
```

- Như vậy, mỗi chuỗi hằng kí tự có nội dung khác nhau sẽ có một địa chỉ khác nhau. Chúng ta có thể sử dụng nội dung của chuỗi hằng kí tự này như mảng một chiều, nhưng không thể thay đổi nội dung của nó.

```
  for (int i = 0; i < strlen("Le Tran Dat"); i++) {
    cout << "Le Tran Dat"[i];
  }
 
  cout << endl;

  "Le Tran Dat"[1] = 'E'; //this line will make an error
```


