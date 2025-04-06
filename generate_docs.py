"""
Documentation Generator Script

This script automatically generates HTML documentation for resource files and Python libraries
using the libdoc tool.

It scans the resources directory for .resource, .robot, and .py files,
then generates documentation for each file in the documentation directory.
"""

import os
import subprocess
import sys
from pathlib import Path
from robot.libdoc import libdoc

# Files to exclude from documentation generation
EXCLUDED_FILES = ['__init__.py', 'config_variables.py', 'test_coverage_validator.py']

def create_documentation_directory(doc_dir):
    """
    Create the documentation directory if it doesn't exist.

    Args:
        doc_dir (Path): Path to the documentation directory
    """
    if not doc_dir.exists():
        print(f"Creating documentation directory: {doc_dir}")
        doc_dir.mkdir(parents=True)

def generate_documentation(source_file, output_file):
    """
    Generate HTML documentation for a resource or Python library.

    Args:
        source_file (Path): Path to the source file
        output_file (Path): Path to the output HTML file
    """
    try:
        print(f"Generating documentation for: {source_file}")
        libdoc(str(source_file), str(output_file))
        print(f"Documentation generated: {output_file}")
        return True
    except Exception as e:
        print(f"Error generating documentation for {source_file}: {e}")
        return False

def process_directory(directory, doc_dir, processed_files=None):
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
                output_dir = doc_dir / parent_dirs

                if not output_dir.exists():
                    output_dir.mkdir(parents=True, exist_ok=True)

                # Generate output filename
                output_file = output_dir / f"{item.stem}.html"

                # Generate documentation
                if generate_documentation(item, output_file):
                    processed_files.add(item)
                    print(f"Successfully processed: {item}")

        elif item.is_dir() and not item.name.startswith('.'):
            # Recursively process subdirectories
            process_directory(item, doc_dir, processed_files)

    return processed_files

def create_index_file(doc_dir, processed_files, project_name):
    """
    Create an index.html file that links to all generated documentation files.

    Args:
        doc_dir (Path): Documentation output directory
        processed_files (set): Set of processed files
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
    </style>
</head>
<body>
    <div class="container">
        <h1>{project_name} Documentation</h1>
        <p>Documentation generated for {project_name} resources and libraries.</p>
""")

        # Group files by directory
        files_by_dir = {}
        for file_path in processed_files:
            relative_path = file_path.relative_to(project_root / 'resources')
            parent_dir = str(relative_path.parent)
            if parent_dir not in files_by_dir:
                files_by_dir[parent_dir] = []
            files_by_dir[parent_dir].append(file_path)

        # Sort directories with libraries first, then keywords, then others
        def dir_sort_key(dir_name):
            if 'libraries' in dir_name.lower():
                return (0, dir_name)
            elif 'keywords' in dir_name.lower():
                return (1, dir_name)
            else:
                return (2, dir_name)

        # Sort directories
        for dir_name in sorted(files_by_dir.keys(), key=dir_sort_key):
            if dir_name == '.':
                index_file.write(f"        <h2>Root Directory</h2>\n")
            else:
                index_file.write(f"        <h2>{dir_name}</h2>\n")

            index_file.write("        <ul>\n")

            # Sort files within each directory
            for file_path in sorted(files_by_dir[dir_name], key=lambda x: x.name):
                relative_path = file_path.relative_to(project_root / 'resources')
                doc_path = relative_path.parent / f"{file_path.stem}.html"

                file_type = ""
                if file_path.suffix.lower() == '.resource':
                    file_type = "Resource"
                elif file_path.suffix.lower() == '.robot':
                    file_type = "Robot"
                elif file_path.suffix.lower() == '.py':
                    file_type = "Python Library"

                index_file.write(f'            <li><a href="{doc_path}">{file_path.name}</a> <span class="file-type">({file_type})</span></li>\n')

            index_file.write("        </ul>\n")

        index_file.write("""    </div>
</body>
</html>
""")

    print(f"Index file created: {index_path}")

def main():
    """
    Main function to generate documentation for all resources and Python libraries.
    """
    global project_root

    # Determine project root (assuming this script is in the project root)
    project_root = Path(__file__).parent
    
    # Get project name from the root directory name
    project_name = project_root.name.replace('_', ' ').title()
    print(f"Generating documentation for project: {project_name}")

    # Define paths
    resources_dir = project_root / 'resources'
    doc_dir = project_root / 'documentation'

    # Check if resources directory exists
    if not resources_dir.exists():
        print(f"Error: Resources directory not found: {resources_dir}")
        return 1

    # Create documentation directory
    create_documentation_directory(doc_dir)

    # Process resources directory
    processed_files = process_directory(resources_dir, doc_dir)

    # Create index file with project name
    create_index_file(doc_dir, processed_files, project_name)

    # Print summary
    print(f"\nDocumentation generation complete!")
    print(f"Total files processed: {len(processed_files)}")
    print(f"Documentation saved to: {doc_dir}")

    return 0

if __name__ == "__main__":
    sys.exit(main())
