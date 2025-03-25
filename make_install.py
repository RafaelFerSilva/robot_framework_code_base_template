import os
import platform
import subprocess

def install(package, requirements_file=None):
    """Install a Python package or dependencies from a requirements file."""
    try:
        if requirements_file:
            print(f"Installing dependencies from: {requirements_file}")
            command = f"pip install -r {requirements_file}"
        else:
            print(f"Installing package: {package}")
            command = f"pip install {package}"
        
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as error:
        raise Exception(f"Unable to install dependencies: {error}")

def set_env_variable(key, value):
    """Set an environment variable."""
    try:
        print(f"Setting environment variable: {key}={value}")
        os.environ[key] = value
        if platform.system() in ["Linux", "Darwin"]:
            subprocess.run(f"export {key}={value}", shell=True, check=True)
    except Exception as error:
        raise Exception(f"Error setting environment variable {key}: {error}")

def is_pipeline_execution():
    """Check if the script is running in a CI/CD pipeline."""
    pipeline_vars = ["CI", "JENKINS_HOME", "GITHUB_ACTIONS"]
    return any(os.environ.get(var, "").strip().lower() in ["true", "1", "yes"] for var in pipeline_vars)

def init_browser_library():
    """Initialize the Robot Framework Browser Library."""
    try:
        print("Initializing Browser Library...")
        subprocess.run("rfbrowser init", shell=True, check=True)
    except subprocess.CalledProcessError as error:
        raise Exception(f"Unable to start Browser library: {error}")


if __name__ == "__main__":
    install(None, requirements_file="requirements.txt")

    if is_pipeline_execution():
        print("Configuration for pipeline execution.")
    
    init_browser_library()