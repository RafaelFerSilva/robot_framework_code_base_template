"""
Installation and Setup Script for Robot Framework Project

This script handles the installation of dependencies and setup of the environment
for a Robot Framework automation project. It performs the following tasks:
1. Installs Python packages from requirements.txt
2. Sets environment variables
3. Initializes the Robot Framework Browser Library
4. Provides special handling for CI/CD pipeline environments

Usage:
    python make_install.py
"""

import os
import platform
import subprocess

def install():
    """
    Install project dependencies using uv sync.

    This function uses uv to synchronize the project's dependencies
    as defined in pyproject.toml and uv.lock.

    Raises:
        Exception: If synchronization fails
    """
    try:
        print("Synchronizing dependencies with uv...")
        subprocess.run("uv sync", shell=True, check=True)
    except subprocess.CalledProcessError as error:
        raise Exception(f"Unable to synchronize dependencies: {error}")

def set_env_variable(key, value):
    """
    Set an environment variable.

    This function sets an environment variable for the current process and,
    on Unix-like systems, attempts to export it to the shell.

    Args:
        key (str): Environment variable name
        value (str): Environment variable value

    Raises:
        Exception: If setting the environment variable fails
    """
    try:
        print(f"Setting environment variable: {key}={value}")
        os.environ[key] = value
        if platform.system() in ["Linux", "Darwin"]:
            subprocess.run(f"export {key}={value}", shell=True, check=True)
    except Exception as error:
        raise Exception(f"Error setting environment variable {key}: {error}")

def is_pipeline_execution():
    """
    Check if the script is running in a CI/CD pipeline.

    This function detects common CI/CD environment variables to determine
    if the script is running in a pipeline environment.

    Returns:
        bool: True if running in a CI/CD pipeline, False otherwise
    """
    pipeline_vars = ["CI", "JENKINS_HOME", "GITHUB_ACTIONS"]
    return any(os.environ.get(var, "").strip().lower() in ["true", "1", "yes"] for var in pipeline_vars)

def init_browser_library():
    """
    Initialize the Robot Framework Browser Library.

    This function runs the initialization command for the Browser library,
    which installs browser binaries and dependencies.

    Raises:
        Exception: If initialization fails
    """
    try:
        print("Initializing Browser Library...")
        subprocess.run("rfbrowser init", shell=True, check=True)
    except subprocess.CalledProcessError as error:
        raise Exception(f"Unable to start Browser library: {error}")


if __name__ == "__main__":
    # Install dependencies from pyproject.toml using uv sync
    install()

    # Apply special configuration for pipeline environments
    if is_pipeline_execution():
        print("Configuration for pipeline execution.")

    # Initialize the Browser library
    init_browser_library()