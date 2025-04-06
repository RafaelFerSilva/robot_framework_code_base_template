import json

def read_json_file(json_file_path, file_name):
    """
    Reads and parses a JSON file.

    This function opens a JSON file from the specified path and file name,
    parses its contents, and returns the resulting data structure.

    Arguments:
        json_file_path (str): Directory path where the JSON file is located
        file_name (str): Name of the JSON file to read

    Returns:
        dict/list: Parsed JSON data structure

    Raises:
        Exception: If there is an error reading or parsing the file

    Example:
        | ${data}= | Read Json File | ${EXECDIR}/resources/files | config.json |
    """
    try:
        with open(json_file_path + "/" + file_name, encoding='utf-8') as data_file:
            data = json.load(data_file)

        return data
    except Exception as e:
        raise Exception("Error reading the file: {}".format(e))