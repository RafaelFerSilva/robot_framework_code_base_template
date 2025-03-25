import pandas as pd
import datetime
import pathlib
import os, shutil
from robot.api.deco import keyword

ROBOT_LIBRARY_DOC_FORMAT = 'text'


@keyword
def deleteContentOfFolder(folder_path):
  '''
  Check if folder exist and delete content of folder
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
    Read a spreadsheet and create files with the content of one of the spreadsheet's colum.
    The argument colum is responsible for select data in spreadsheet based in passed colum
    - directory: path of directory to save file
    - excel_file_path: path to read spreadsheet file
    - extension: Extension to save created file
    - colum: spreadsheet colum with data to save in file
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
          if( isinstance(row[colum], str)):
            with open(f'{directory}/{file_name}', "w") as arquivo:
              arquivo.write(row[colum])
              print(f'Creating file: {file_name}')
    except Exception as e:
      raise Exception(f'Error for create files based in Excel Data: {e}')
    
@keyword
def createFileBasedInStringData(fileDirectory, data, file_name):
    """Create a file base in string data. 
    - fileDirectory: path of directory to save file
    - data: File content
    - file_name: Nome of file with extension. EX: test.xml
    """
    try:
      if( isinstance(data, str)):
        with open(f'{fileDirectory}/{file_name}', "w") as arquivo:
          arquivo.write(data)
          print(f'Creating file: {file_name}')
    except Exception as e:
      raise Exception(f'Error for create file based in String Data: {e}')

@keyword
def returnFilePathByExtension(directory_path = ".", expected_extension = ".xml"):
  '''
  Read a dictory and return path of files by your extension
  '''
  try:
    file_list = []
    directiory = pathlib.Path(directory_path)
    for item in directiory.iterdir():
      if item.is_file():
        file_name, file_extension = os.path.splitext(f"${directory_path}/${item}")
        if(file_extension == expected_extension):
          file_list.append(str(item))
    return file_list
  except Exception as e:
    raise Exception(f'Error for return File Path By Extension: {e}')
 