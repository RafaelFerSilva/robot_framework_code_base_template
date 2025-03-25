import os
from dotenv import dotenv_values, load_dotenv
from robot.api.deco import keyword
from robot.api import Failure

@keyword('Set Environment Project Variables')
def set_environment_project_variables(pipeline: bool = False, environment: str = 'rc', print_variables: bool = False):
    """
    Set Environment Project Variables

    This keyword configures environment variables for the current session. It supports two modes:

    1. Pipeline Mode (`pipeline=True`): Loads variables directly from the OS environment.
    2. File Environment Mode (`pipeline=False`): Loads variables from a `.env` file corresponding to the specified environment name.

    Arguments:
        pipeline (bool): Flag to determine if variables should be loaded from the OS environment (default: False).
        environment (str): The name of the `.env` file to load (default: 'rc').
        print_variables (bool): Flag to print loaded environment variables to the console (default: False).

    Returns:
        dict: Key-value pairs of the loaded environment variables.

    Raises:
        Failure: If the specified environment or file cannot be loaded.

    Additional Behavior:
        If `print_variables` is True, prints all loaded environment variables in the format "key: value" to the console.
    """

    if(pipeline):
        value = os.environ
    else :
        load_dotenv(f"{environment.lower()}.env")
        value = dotenv_values(f"{environment.lower()}.env")

    if(print_variables):
        for name, value in value.items():
            print("{0}: {1}".format(name, value))
        
    if(value):
        return value
    else:
        raise Failure(f"Please check environment key value ou file: key value {environment}")
        