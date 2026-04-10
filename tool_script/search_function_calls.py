def find_function_calls_with_line_numbers(file_path, public_functions):
    function_calls = []
    with open(file_path, 'r') as file:
        content = file.read()
        lines = content.split('\n')  # Chia mã nguồn thành các dòng
        for func_name in public_functions:
            pattern = rf'\b{func_name}\s*\('
            for line_number, line in enumerate(lines, start=1):
                matches = re.finditer(pattern, line)
                for match in matches:
                    function_calls.append((func_name, file_path, line_number))
    return function_calls

# Duyệt qua tất cả các tệp tin .cs trong Dự án B và tìm các lời gọi đến các hàm public cùng với dòng gọi
project_b_directory = 'path/to/project_b'
cs_files_b = find_cs_files(project_b_directory)
function_calls = []
for cs_file_b in cs_files_b:
    calls = find_function_calls_with_line_numbers(cs_file_b, public_functions)
    if calls:
        function_calls.extend(calls)

# Ghi danh sách các lời gọi hàm, tập tin .cs chứa chúng và dòng gọi vào một tệp tin hoặc hiển thị ra màn hình
with open('function_calls_with_line_numbers.txt', 'w') as output_file:
    for func_name, file_path, line_number in function_calls:
        output_file.write(f'Function: {func_name}\n')
        output_file.write(f'Called in: {file_path}\n')
        output_file.write(f'Line Number: {line_number}\n\n')
