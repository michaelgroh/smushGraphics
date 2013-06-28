# Smush Graphics #

## Purpose ##

Removes meta data (smushes) from jpegs in a specified folder and it's subfolders. Will only attempt to smush graphics that have been modified recently and will not touch images that it already smushed. It does this by creating a temp file and comparing the two. If there was any space savings it will overwrite the image with the temp file.

## Usage ##

Just adjust the parameters inside the script and run it. You may want to adjust the -mtime param in the find command.


