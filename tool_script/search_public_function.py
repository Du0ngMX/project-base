import os
import re

def find_public_functions(file_path):
    public_functions = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.strip().startswith('public async'):
                public_functions.append(line.strip())
    return public_functions

def find_cs_files(directory):
    cs_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.cs'):
                cs_files.append(os.path.join(root, file))
    return cs_files

# Duyệt qua tất cả các tệp tin .cs trong Dự án A và tìm các hàm public
project_a_directory = 'E:\\RegionLinkage\\TuHu\TaskNo19_10140\\PG\\MJO\\16j_sbe_SBELinkageLib_mjo_it\\SBELinkageLib\\SBELinkageLib\\DB'
cs_files = find_cs_files(project_a_directory)
public_functions = {}
for cs_file in cs_files:
    functions = find_public_functions(cs_file)
    if functions:
        public_functions[cs_file] = functions

# Ghi danh sách các hàm public và tập tin .cs chứa chúng vào một tệp tin hoặc hiển thị ra màn hình
with open('public_functions.txt', 'w') as output_file:
    for cs_file, functions in public_functions.items():
        output_file.write(f'File: {cs_file}\n')
        for function in functions:
            output_file.write(f'- {function}\n')
        output_file.write('\n')
