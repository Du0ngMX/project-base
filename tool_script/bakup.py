import os
import json
import yaml
import ruamel.yaml
from ruamel.yaml.comments import CommentedMap
from openapi_schema_validator import validate

common_data_header = '''
openapi: 3.0.3
info:
  title: Kintaro APIs MNAO MyMazda APP
  version: 4.2.8
servers:
- url: https://kintaro.host/dev
'''
def is_openapi_valid(yaml_data):
    try:
        validate(yaml_data)
        return True
    except Exception as e:
        print(f"Validation failed: {e}")
        return False

def validate_openapi(input_file_name):
    errors = []
    try:
        with open(input_file_name, 'r') as input_file:
            yaml_data = ruamel.yaml.YAML().load(input_file)
        validate(yaml_data)
    except Exception as e:
        errors.append(str(e))
    return errors

def load_input_yaml(input_file_name):
    with open(input_file_name, 'r') as input_file:
        return ruamel.yaml.YAML().load(input_file)

def create_output_directory(output_dir):
    os.makedirs(output_dir, exist_ok=True)

def process_paths(input_data, output_dir):
    index = 0
    # output_data = CommentedMap()
    # output_data.update(ruamel.yaml.YAML().load(common_data_header))
    output_data = copy_common_fields(input_data)
    for path, path_data in input_data.get('paths', {}).items():
        output_file_name = f"{output_dir}/IF_{index:03d}.yaml"
        # output_data['paths'] = CommentedMap({path: path_data})
        create_output_file(output_data, path, path_data, output_file_name)
        print(f"--> Created {output_file_name} based on {path}.")
        index += 1

def copy_common_fields(input_data):
    output_data = CommentedMap()
    output_data['swagger'] = '3.5'
    output_data['info'] = input_data['info']
    output_data['host'] = input_data['host']
    output_data['basePath'] = input_data['basePath']
    output_data['schemes'] = input_data['schemes']
    output_data['consumes'] = input_data['consumes']
    output_data['produces'] = input_data['produces']
    return output_data

def add_schema_to_parameters_responses(path_data):
    for method_data in path_data.values():
        for param in method_data.get('parameters', []):
            update_schema(param)

        for response_data in method_data.get('responses', {}).values():
            update_schema(response_data)

def update_schema(data):
    if 'schema' not in data:
        data['schema'] = CommentedMap()
        # Kiểm tra xem có format, minLength, maxLength, pattern, để build schema
        if 'format' in data:
            data['schema']['format'] = data['format']
            data.pop('format', None) # Xóa key format nếu tồn tại (đã thêm vào schema)
        if 'minLength' in data:
            data['schema']['minLength'] = data['minLength']
            data.pop('minLength', None) # Xóa key minLength nếu tồn tại (đã thêm vào schema)
        if 'maxLength' in data:
            data['schema']['maxLength'] = data['maxLength']
            data.pop('maxLength', None) # Xóa key maxLength nếu tồn tại (đã thêm vào schema)
        if 'pattern' in data:
            data['schema']['pattern'] = data['pattern']
            data.pop('pattern', None) # Xóa key pattern nếu tồn tại (đã thêm vào schema)
        if 'type' not in data:
            # Nếu không có type trong data, sử dụng giá trị type default là string
            data['schema']['type'] = data.get('type', 'string')
        else:
            data['schema']['type'] = data['type']
            data.pop('type', None) # Xóa key type nếu tồn tại (đã thêm vào schema)
    else:
        print("Update schema done!!!")

def create_output_file(output_data, path, path_data, output_file_name):
    # Thêm schema cho parameters và responses
    add_schema_to_parameters_responses(path_data)

    # Thêm path_data vào output_data
    output_data['paths'] = CommentedMap({path: path_data})

    yaml = ruamel.yaml.YAML()
    yaml.indent(sequence=4, offset=2)  # Use 2 spaces for indentation

    with open(output_file_name, 'w', newline='') as output_file:
        yaml.dump(output_data, output_file)

def convert_yaml_to_json(output_yaml_dir, output_json_dir):
    yaml_files = [f for f in os.listdir(output_yaml_dir) if f.endswith('.yaml')]

    for yaml_file in yaml_files:
        yaml_file_path = os.path.join(output_yaml_dir, yaml_file)
        json_file_path = os.path.join(output_json_dir, os.path.splitext(yaml_file)[0] + '.json')

        with open(yaml_file_path, 'r', encoding='utf-8') as input_file:
            yaml_data = yaml.safe_load(input_file)

        # if is_openapi_valid(yaml_data):
        #     print(f"--> {yaml_file} is a valid OpenAPI document.")
        # else:
        #     print(f"--> {yaml_file} is not a valid OpenAPI document.")
        #     continue

        with open(json_file_path, 'w', newline='', encoding='utf-8') as json_file:
            json.dump(yaml_data, json_file, indent=2, ensure_ascii=False)
        print(f"<<<<<-->>>>> Convert {yaml_file} ---> to ---> {json_file_path}")

def main():
    input_file_name = 'input1.yaml'
    output_yaml_dir = 'output_yaml'
    output_json_dir = 'output_json'
    
    print(f"\n\n===> Step 1: check validation {input_file_name} <===")
    validation_errors = validate_openapi(input_file_name)
    if validation_errors:
        print("Validation failed with the following errors:")
        for error in validation_errors:
            print(error)
    else:
        print("Validation passed!!!")

    print("===> Processing complete...")
  
    input_data = load_input_yaml(input_file_name)
    create_output_directory(output_yaml_dir)
    create_output_directory(output_json_dir)

    print("\n\n===> Step 2: create yaml file <===")
    process_paths(input_data, output_yaml_dir)
    print("===> Processing complete...")

    print("\n\n===> Step 3: convert yaml to json <===")
    convert_yaml_to_json(output_yaml_dir, output_json_dir)
    print("===> Processing complete...")

if __name__ == "__main__":
    main()
