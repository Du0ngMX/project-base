# Tool Script Collection

Bộ công cụ Python hỗ trợ xử lý file và phân tích mã nguồn.

## Tổng quan

Repository này chứa 4 công cụ Python được thiết kế để hỗ trợ các tác vụ thông dụng:
- Xử lý và chuyển đổi OpenAPI/Swagger specification
- Gộp file Excel
- Tìm kiếm và phân tích hàm trong mã nguồn C#

## Các file trong dự án

### 1. `bakup.py`
**Mục đích**: Xử lý và chuyển đổi OpenAPI/Swagger specification files

**Chức năng chính**:
- Validate OpenAPI YAML files
- Tách các paths thành các file YAML riêng biệt
- Chuyển đổi YAML sang JSON format
- Cập nhật schema cho parameters và responses

**Cách sử dụng**:
```bash
python bakup.py
```

**Yêu cầu**:
- File input: `input1.yaml`
- Output directories: `output_yaml/`, `output_json/`
- Dependencies: `ruamel.yaml`, `openapi_schema_validator`

### 2. `merge_file_excel.py`
**Mục đích**: Gộp nhiều file Excel thành một file duy nhất

**Chức năng chính**:
- Duyệt qua tất cả file .xlsx trong thư mục chỉ định
- Tạo file Excel mới với tất cả sheet names được sắp xếp
- Loại bỏ sheet mặc định

**Cách sử dụng**:
```bash
python merge_file_excel.py
```

**Cấu hình**:
- Input folder: `E:\CRUD\input` (cần thay đổi theo path thực tế)
- Output file: `merged_file.xlsx`
- Dependencies: `openpyxl`

### 3. `search_public_function.py`
**Mục đích**: Tìm kiếm các hàm public trong mã nguồn C#

**Chức năng chính**:
- Duyệt qua tất cả file .cs trong thư mục
- Tìm các hàm public async
- Xuất danh sách hàm ra file text

**Cách sử dụng**:
```bash
python search_public_function.py
```

**Cấu hình**:
- Input directory: Cần cập nhật `project_a_directory` variable
- Output file: `public_functions.txt`

### 4. `search_function_calls.py`
**Mục đích**: Tìm kiếm các lời gọi hàm trong mã nguồn với số dòng

**Chức năng chính**:
- Tìm các lời gọi đến hàm public
- Ghi lại file và số dòng chứa lời gọi
- Xuất kết quả ra file text với thông tin chi tiết

**Cách sử dụng**:
```bash
python search_function_calls.py
```

**Cấu hình**:
- Input directory: Cần cập nhật `project_b_directory` variable
- Output file: `function_calls_with_line_numbers.txt`
- Dependencies: `re`

## Yêu cầu hệ thống

### Python packages cần thiết:
```bash
pip install openpyxl ruamel.yaml openapi-schema-validator
```

### Python version:
- Python 3.6+

## Hướng dẫn cài đặt

1. Clone hoặc download repository
2. Cài đặt dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Cập nhật các đường dẫn trong từng file theo môi trường thực tế
4. Chạy từng script theo nhu cầu

## Lưu ý

- **bakup.py**: Yêu cầu file `input1.yaml` tồn tại trong cùng thư mục
- **merge_file_excel.py**: Cần cập nhật đường dẫn `folder_path` 
- **search_public_function.py**: Cần cập nhật `project_a_directory`
- **search_function_calls.py**: File này thiếu imports và có thể cần điều chỉnh để hoạt động đúng

## Cấu trúc thư mục đầu ra

```
tool_script/
├── output_yaml/          # YAML files được tách từ bakup.py
├── output_json/          # JSON files được chuyển đổi
├── merged_file.xlsx      # File Excel gộp
├── public_functions.txt  # Danh sách hàm public
└── function_calls_with_line_numbers.txt  # Lời gọi hàm với số dòng
```

## Liên hệ

Nếu có thắc mắc hoặc cần hỗ trợ, vui lòng tạo issue trong repository này.