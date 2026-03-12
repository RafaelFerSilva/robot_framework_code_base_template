"""
Documentation Generator Script

This script automatically generates HTML documentation for resource files, Python libraries,
and test suites using the libdoc and testdoc tools.

It scans the resources and tests directories for .resource, .robot, and .py files,
then generates documentation for each file in the documentation directory.
"""

import os
import subprocess
import sys
from pathlib import Path
from robot.libdoc import libdoc
from robot.testdoc import testdoc

# Files to exclude from documentation generation
EXCLUDED_FILES = ['__init__.py', 'config_variables.py', 'test_coverage_validator.py', '__init__.robot']

def create_documentation_directory(doc_dir):
    """
    Create the documentation directory if it doesn't exist.

    Args:
        doc_dir (Path): Path to the documentation directory
    """
    if not doc_dir.exists():
        print(f"Creating documentation directory: {doc_dir}")
        doc_dir.mkdir(parents=True)

def generate_library_documentation(source_file, output_file):
    """
    Generate HTML documentation for a resource or Python library using libdoc.

    Args:
        source_file (Path): Path to the source file
        output_file (Path): Path to the output HTML file

    Returns:
        bool: True if documentation was generated successfully, False otherwise
    """
    try:
        print(f"Generating library documentation for: {source_file}")
        libdoc(str(source_file), str(output_file))
        print(f"Library documentation generated: {output_file}")
        return True
    except Exception as e:
        print(f"Error generating library documentation for {source_file}: {e}")
        return False

def generate_test_documentation(source_file, output_file):
    """
    Generate HTML documentation for a test suite using testdoc.

    Args:
        source_file (Path): Path to the source file
        output_file (Path): Path to the output HTML file

    Returns:
        bool: True if documentation was generated successfully, False otherwise
    """
    try:
        print(f"Generating test documentation for: {source_file}")
        testdoc(str(source_file), str(output_file))
        print(f"Test documentation generated: {output_file}")
        return True
    except Exception as e:
        print(f"Error generating test documentation for {source_file}: {e}")
        return False

def process_resources_directory(directory, doc_dir, processed_files=None):
    """
    Process a directory to find and document resources and Python libraries.

    Args:
        directory (Path): Directory to process
        doc_dir (Path): Documentation output directory
        processed_files (set, optional): Set of already processed files

    Returns:
        set: Set of processed files
    """
    if processed_files is None:
        processed_files = set()

    for item in directory.iterdir():
        if item.is_file():
            # Skip files that have already been processed or are in the exclusion list
            if item in processed_files or item.name in EXCLUDED_FILES:
                continue

            # Process .resource, .robot, and .py files
            if item.suffix.lower() in ['.resource', '.robot', '.py']:
                # Create subdirectory in documentation folder if needed
                relative_path = item.relative_to(project_root / 'resources')
                parent_dirs = relative_path.parent
                output_dir = doc_dir / 'resources' / parent_dirs

                if not output_dir.exists():
                    output_dir.mkdir(parents=True, exist_ok=True)

                # Generate output filename
                output_file = output_dir / f"{item.stem}.html"

                # Generate documentation
                if generate_library_documentation(item, output_file):
                    processed_files.add(item)
                    print(f"Successfully processed resource: {item}")

        elif item.is_dir() and not item.name.startswith('.'):
            # Recursively process subdirectories
            process_resources_directory(item, doc_dir, processed_files)

    return processed_files

def process_tests_directory(directory, doc_dir, processed_files=None):
    """
    Process a directory to find and document test suites.

    Args:
        directory (Path): Directory to process
        doc_dir (Path): Documentation output directory
        processed_files (set, optional): Set of already processed files

    Returns:
        set: Set of processed files
    """
    if processed_files is None:
        processed_files = set()

    for item in directory.iterdir():
        if item.is_file():
            # Skip files that have already been processed or are in the exclusion list
            if item in processed_files or item.name in EXCLUDED_FILES:
                continue

            # Process .robot files
            if item.suffix.lower() == '.robot':
                # Create subdirectory in documentation folder if needed
                relative_path = item.relative_to(project_root / 'tests')
                parent_dirs = relative_path.parent
                output_dir = doc_dir / 'tests' / parent_dirs

                if not output_dir.exists():
                    output_dir.mkdir(parents=True, exist_ok=True)

                # Generate output filename
                output_file = output_dir / f"{item.stem}.html"

                # Generate documentation
                if generate_test_documentation(item, output_file):
                    processed_files.add(item)
                    print(f"Successfully processed test: {item}")

        elif item.is_dir() and not item.name.startswith('.'):
            # Recursively process subdirectories
            process_tests_directory(item, doc_dir, processed_files)

    return processed_files

def create_index_file(doc_dir, resource_files, test_files, project_name):
    """
    Create an index.html file that links to all generated documentation files.

    Args:
        doc_dir (Path): Documentation output directory
        resource_files (set): Set of processed resource files
        test_files (set): Set of processed test files
        project_name (str): Name of the project
    """
    index_path = doc_dir / "index.html"

    with open(index_path, 'w', encoding='utf-8') as index_file:
        index_file.write(f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{project_name} Documentation</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
        }}
        h1 {{
            color: #0056b3;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }}
        h2 {{
            color: #0056b3;
            margin-top: 30px;
        }}
        .container {{
            max-width: 1200px;
            margin: 0 auto;
        }}
        ul {{
            padding-left: 20px;
        }}
        li {{
            margin-bottom: 8px;
        }}
        a {{
            color: #0056b3;
            text-decoration: none;
        }}
        a:hover {{
            text-decoration: underline;
        }}
        .file-type {{
            color: #666;
            font-size: 0.9em;
        }}
        .section {{
            margin-bottom: 40px;
        }}
        .section-title {{
            font-size: 1.8em;
            color: #0056b3;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h1>{project_name} Documentation</h1>
        <p>Documentation generated for {project_name} resources, libraries, and test suites.</p>

        <div class="section">
            <h2 class="section-title">Resources and Libraries</h2>
""")

        # Group resource files by directory
        resources_by_dir = {}
        for file_path in resource_files:
            relative_path = file_path.relative_to(project_root / 'resources')
            parent_dir = str(relative_path.parent)
            if parent_dir not in resources_by_dir:
                resources_by_dir[parent_dir] = []
            resources_by_dir[parent_dir].append(file_path)

        # Sort directories with libraries first, then keywords, then others
        def dir_sort_key(dir_name):
            if 'libraries' in dir_name.lower():
                return (0, dir_name)
            elif 'keywords' in dir_name.lower():
                return (1, dir_name)
            else:
                return (2, dir_name)

        # Sort directories for resources
        for dir_name in sorted(resources_by_dir.keys(), key=dir_sort_key):
            if dir_name == '.':
                index_file.write(f"            <h3>Root Directory</h3>\n")
            else:
                index_file.write(f"            <h3>{dir_name}</h3>\n")

            index_file.write("            <ul>\n")

            # Sort files within each directory
            for file_path in sorted(resources_by_dir[dir_name], key=lambda x: x.name):
                relative_path = file_path.relative_to(project_root / 'resources')
                doc_path = 'resources' / relative_path.parent / f"{file_path.stem}.html"

                file_type = ""
                if file_path.suffix.lower() == '.resource':
                    file_type = "Resource"
                elif file_path.suffix.lower() == '.robot':
                    file_type = "Robot"
                elif file_path.suffix.lower() == '.py':
                    file_type = "Python Library"

                index_file.write(f'                <li><a href="{doc_path}">{file_path.name}</a> <span class="file-type">({file_type})</span></li>\n')

            index_file.write("            </ul>\n")

        # Add test suites section
        index_file.write("""
        </div>

        <div class="section">
            <h2 class="section-title">Test Suites</h2>
""")

        # Group test files by directory
        tests_by_dir = {}
        for file_path in test_files:
            relative_path = file_path.relative_to(project_root / 'tests')
            parent_dir = str(relative_path.parent)
            if parent_dir not in tests_by_dir:
                tests_by_dir[parent_dir] = []
            tests_by_dir[parent_dir].append(file_path)

        # Sort directories for tests
        for dir_name in sorted(tests_by_dir.keys()):
            if dir_name == '.':
                index_file.write(f"            <h3>Root Test Directory</h3>\n")
            else:
                index_file.write(f"            <h3>{dir_name}</h3>\n")

            index_file.write("            <ul>\n")

            # Sort files within each directory
            for file_path in sorted(tests_by_dir[dir_name], key=lambda x: x.name):
                relative_path = file_path.relative_to(project_root / 'tests')
                doc_path = 'tests' / relative_path.parent / f"{file_path.stem}.html"

                index_file.write(f'                <li><a href="{doc_path}">{file_path.name}</a> <span class="file-type">(Test Suite)</span></li>\n')

            index_file.write("            </ul>\n")

        index_file.write("""
        </div>
    </div>
</body>
</html>
""")

    print(f"Index file created: {index_path}")

def main():
    """
    Main function to generate documentation for resources, libraries, and test suites.
    """
    global project_root

    # Determine project root (assuming this script is in the project root)
    project_root = Path(__file__).parent

    # Get project name from the root directory name
    project_name = project_root.name.replace('_', ' ').title()
    print(f"Generating documentation for project: {project_name}")

    # Define paths
    resources_dir = project_root / 'resources'
    tests_dir = project_root / 'tests'
    doc_dir = project_root / 'documentation'

    # Check if directories exist
    if not resources_dir.exists():
        print(f"Warning: Resources directory not found: {resources_dir}")
        resource_files = set()
    else:
        # Create documentation directory
        create_documentation_directory(doc_dir)
        # Process resources directory
        resource_files = process_resources_directory(resources_dir, doc_dir)
        print(f"Processed {len(resource_files)} resource files")

    if not tests_dir.exists():
        print(f"Warning: Tests directory not found: {tests_dir}")
        test_files = set()
    else:
        # Create documentation directory
        create_documentation_directory(doc_dir)
        # Process tests directory
        test_files = process_tests_directory(tests_dir, doc_dir)
        print(f"Processed {len(test_files)} test files")

    # Create index file with project name
    create_index_file(doc_dir, resource_files, test_files, project_name)

    # Print summary
    print(f"\nDocumentation generation complete!")
    print(f"Total resource files processed: {len(resource_files)}")
    print(f"Total test files processed: {len(test_files)}")
    print(f"Documentation saved to: {doc_dir}")

    return 0

if __name__ == "__main__":
    sys.exit(main())
