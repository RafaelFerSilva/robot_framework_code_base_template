import pandas as pd
import datetime
import pathlib
import os
import shutil
from robot.api.deco import keyword

ROBOT_LIBRARY_DOC_FORMAT = 'text'


@keyword
def deleteContentOfFolder(folder_path):
    '''
    Deletes all contents of a specified folder.

    This keyword checks if the folder exists and then deletes all files and
    subdirectories within it.

    Arguments:
        folder_path (str): Path to the folder whose contents should be deleted

    Example:
        | Delete Content Of Folder | ${EXECDIR}/temp |
    '''
    if os.path.exists(folder_path):
        for filename in os.listdir(folder_path):
            file_path = os.path.join(folder_path, filename)
            try:
                if os.path.isfile(file_path):
                    os.remove(file_path)
                elif os.path.isdir(file_path):
                    os.rmdir(file_path)
            except Exception as e:
                print(f"Error deleting {file_path}: {e}")
        print("Deletion done")


@keyword
def createFilesBasedInExcelData(directory, excel_file_path, extension, colum):
    '''
    Creates files based on data from an Excel spreadsheet.

    This keyword reads a spreadsheet and creates files with the content from a specified column.
    If the directory already exists, it will be deleted and recreated.

    Arguments:
        directory (str): Path of directory to save the files
        excel_file_path (str): Path to the Excel file to read
        extension (str): File extension for the created files (without dot)
        colum (str): Name of the spreadsheet column containing the data to save in files

    Example:
        | Create Files Based In Excel Data | ${EXECDIR}/output | ${EXECDIR}/data.xlsx | txt | Content |
    '''
    try:
        df = pd.read_excel(excel_file_path, dtype=str)
        if os.path.exists(directory):
            shutil.rmtree(directory)
            print(f'Removing the folder and files: {directory}')
            os.mkdir(directory)
            print(f'Recreating the folder: {directory}')
        else:
            os.mkdir(directory)
            print(f'Creating the folder: {directory}')
        for index, row in df.iterrows():
            timestamp = datetime.datetime.now().timestamp()
            file_name = f'Test_{timestamp}.{extension}'
            if (isinstance(row[colum], str)):
                with open(f'{directory}/{file_name}', "w") as arquivo:
                    arquivo.write(row[colum])
                    print(f'Creating file: {file_name}')
    except Exception as e:
        raise Exception(f'Error for create files based in Excel Data: {e}')


@keyword
def createFileBasedInStringData(fileDirectory, data, file_name):
    """
    Creates a file with the provided string data.

    Arguments:
        fileDirectory (str): Path of directory to save the file
        data (str): Content to write to the file
        file_name (str): Name of the file with extension (e.g., test.xml)

    Example:
        | Create File Based In String Data | ${EXECDIR}/output | <data>Test content</data> | test.xml |
    """
    try:
        if (isinstance(data, str)):
            with open(f'{fileDirectory}/{file_name}', "w") as arquivo:
                arquivo.write(data)
                print(f'Creating file: {file_name}')
    except Exception as e:
        raise Exception(f'Error for create file based in String Data: {e}')


@keyword
def returnFilePathByExtension(directory_path=".", expected_extension=".xml"):
    '''
    Returns a list of file paths matching the specified extension.

    This keyword reads a directory and returns paths of all files with the specified extension.

    Arguments:
        directory_path (str): Path to the directory to search (default: current directory)
        expected_extension (str): File extension to filter by (default: ".xml")

    Returns:
        list: List of file paths matching the specified extension

    Example:
        | ${xml_files}= | Return File Path By Extension | ${EXECDIR}/data | .xml |
    '''
    try:
        file_list = []
        directiory = pathlib.Path(directory_path)
        for item in directiory.iterdir():
            if item.is_file():
                file_name, file_extension = os.path.splitext(
                    f"${directory_path}/${item}")
                if (file_extension == expected_extension):
                    file_list.append(str(item))
        return file_list
    except Exception as e:
        raise Exception(f'Error for return File Path By Extension: {e}')
