# Đuổi Hình Bắt Chữ (DHBC)

## Giới thiệu
DHBC (Đuổi Hình Bắt Chữ) là một ứng dụng trò chơi giải đố được xây dựng bằng Electron. Người chơi sẽ dựa vào hình ảnh để đoán từ khóa tương ứng.

## Tác giả
DuongMX

## Luật chơi
- Có 10 hình ảnh tương ứng với 10 từ khóa của chương trình
- Người chơi dựa vào hình ảnh để đoán từ khóa
- Mỗi từ khóa đúng được 10 điểm
- Thời gian cho mỗi câu hỏi là 10 giây

## Giao diện trò chơi (UI/UX)
- **Hình ảnh**: Hiển thị hình ảnh gợi ý cho từ khóa cần đoán
- **Danh sách ký tự**: Các ký tự được xáo trộn để gợi ý cho người chơi
- **Form trả lời**: Người chơi chọn ký tự từ danh sách để ghép thành câu trả lời
- **Đồng hồ đếm ngược**: Hiển thị thời gian còn lại (10 giây)
- **Số câu hỏi**: Hiển thị đang ở câu hỏi thứ mấy
- **Điểm số**: Hiển thị tổng điểm hiện tại

## Công nghệ sử dụng
- **Electron** v4.1.4 - Framework để xây dựng ứng dụng desktop cross-platform
- **HTML/CSS/JavaScript** - Giao diện và logic ứng dụng

## Cấu trúc thư mục
```
DHBC/
├── contents/                    # Thư mục chứa giao diện
│   ├── main_window/            # Cửa sổ chính
│   │   ├── css/               # Style cho cửa sổ chính
│   │   ├── images/            # Hình ảnh cho cửa sổ chính
│   │   ├── index.html         # File HTML cửa sổ chính
│   │   └── js/                # JavaScript cho cửa sổ chính
│   └── play_window/            # Cửa sổ chơi game
│       ├── css/               # Style cho cửa sổ chơi
│       ├── images/            # Hình ảnh cho cửa sổ chơi
│       ├── index.html         # File HTML cửa sổ chơi
│       └── js/                # JavaScript cho cửa sổ chơi
├── databases/                  # Thư mục dữ liệu
│   ├── database.db            # File database
│   └── item/                  # Thư mục chứa hình ảnh (1.jpg - 20.jpg)
├── lib/                       # Thư viện
│   └── windowControl.js       # Module quản lý cửa sổ
├── main.js                    # File chính của ứng dụng
├── package.json               # Cấu hình npm
└── package-lock.json          # Lock file npm
```

## Tính năng chính

### Cửa sổ chính (Main Window)
- **Start**: Bắt đầu trò chơi - mở cửa sổ chơi game
- **Option**: Tùy chọn (chưa hoàn thiện)
- **About**: Thoát ứng dụng

### Cửa sổ chơi game (Play Window)
- Hiển thị hình ảnh gợi ý từ thư mục `databases/item/`
- Hiển thị danh sách ký tự xáo trộn để người chơi lựa chọn
- Form nhập đáp án bằng cách chọn ký tự
- Đồng hồ đếm ngược 10 giây cho mỗi câu
- Hiển thị số thứ tự câu hỏi và điểm số
- Có 10 hình ảnh tương ứng 10 từ khóa cần đoán

## Cài đặt và chạy

### Yêu cầu hệ thống
- Node.js và npm đã được cài đặt

### Cài đặt
```bash
# Di chuyển vào thư mục dự án
cd DHBC

# Cài đặt dependencies
npm install
```

### Chạy ứng dụng
```bash
npm start
```

## Chi tiết kỹ thuật

### Cửa sổ chính
- Kích thước: 500x600 pixels
- Không thể resize
- Menu bị ẩn

### Cửa sổ chơi game
- Kích thước: 600x900 pixels
- Không thể resize
- Menu bị ẩn

### Cơ chế hoạt động
1. Khi khởi động, ứng dụng hiển thị cửa sổ chính với 3 tùy chọn
2. Khi người dùng chọn "Start", cửa sổ chơi game được mở
3. Trong cửa sổ chơi game:
   - Hiển thị hình ảnh gợi ý
   - Hiển thị các ký tự xáo trộn
   - Người chơi chọn ký tự để ghép thành từ khóa
   - Đồng hồ đếm ngược 10 giây
   - Nếu đúng: cộng 10 điểm và chuyển câu tiếp theo
   - Nếu hết giờ hoặc sai: chuyển câu tiếp theo
4. Trò chơi kết thúc sau 10 câu hỏi

## Lưu ý
- Ứng dụng sử dụng phiên bản Electron cũ (v4.1.4), nên cân nhắc nâng cấp phiên bản mới hơn để đảm bảo bảo mật
- Chức năng "Option" chưa được triển khai
- Code hiện tại chỉ hiển thị hình ảnh ngẫu nhiên, chưa triển khai đầy đủ logic trò chơi Đuổi Hình Bắt Chữ
- Cần bổ sung:
  - Logic đoán từ khóa
  - Hệ thống tính điểm
  - Đồng hồ đếm ngược
  - Danh sách ký tự xáo trộn
  - Form ghép chữ từ các ký tự

## License
UNLICENSED - Đây là phần mềm riêng tư