# ROBOT FRAMEWORK CODE BASE TEMPLATE

## Prerequisites

Browser Library installation requires both Python and NodeJs

Install [Python™](https://www.python.org/downloads/)

Install [Node.js®](https://nodejs.org/en/download/)

## Environment

Create a python virtual environment:

    python3 -m venv venv

Active environment:

- Windows
    
      venv\script\activate

- Linux/MacOS

      source venv/bin/activate

## Dependências.
Basic dependêncies for project are on requirements.txt file and use a make_install.py script for install and initializate the robotframework-browser library.

    python make_install.py
