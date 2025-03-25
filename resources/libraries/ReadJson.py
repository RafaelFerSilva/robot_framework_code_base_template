import json

def read_json_file(json_file_path, file_name):
    try:
        with open(json_file_path + "/" + file_name, encoding='utf-8') as data_file:                           
            data = json.load(data_file)

        return data
    except Exception as e:
        raise Exception("Error reading the file: {}".format(e))
