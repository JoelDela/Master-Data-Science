* CTRL + l - clear screen
* history
* man <comand> --> help

# Files

Content of file and number of line (-n)
```shell
cat -n requirements.txt 
```
List Files
```shell
ls -a # all files, even hiiden
ls -R # list subdirectories recursively 
ls -d # do not enter inside directories 
ls -S # sort by file size 
ls -t # sort by modification time, newest first 
ls -X # sort alphabetically by entry extension 
ls -r # reverse order while sorting
```
Change permission
```shell
chmod uo-r,g+xw file_name
# ugo = user/group/other (special option a=all)
# rwx= read/write/execute
```
Create
```shell
echo "Hello" > file_name # create file
echo "World" >> file_name # append to file
```
Copy
```shell
mv #move and RENAME
cp source_file/dir destination_file/dir
# -r : recursive mode used for directories
# -i : interactive confirm file overwriting
# -v : verbose see copy progress
# -p: preserve the file permission and other attributes/metadata
```
Delete
```shell
rm 
```
Count
```shell
cat file_name | wc
# -c, --bytes 
# -m, --chars 
# -l, --lines 
# -w, --words 
```

Head and Tail
```shell
cat file_name | head 
# -c K : first K bytes
# -n K : first K lines instead of the first 10; 
# with K negative, print all but the last K 

tail file_name 
```

Find --> The first argument to find is the path where it should start looking. The path . means the current directory.
```python
find . -name "tExt_file*"         # by name
find . -iname "tExt_file*"        # by name ignoring case
find -type d -name "text_file*" # f=file, d=directory
# -maxdepth : max levels of directories below the starting-points
# -mindepth : min levels of directories below the starting-points
# -mmin -N  : modified within N minutes
# -mtime -N : modified within N days

find . -type f -name "text_file*" -exec ls -l {} \; # execute command ls -l on file
find . -type f -name "text_file*" -ok rm -r  {} \;   # prompt before executing the command
find . -type f -name "text_file*" -exec echo "FOUND IT!!!" \;
find . -type f -name "text_file*" -exec ls -l {} \; -exec head -2 {} \;
# -execdir/-okdir 

# Find top 10 files by size in your home directory including the subdirectories. 
# Sort them by size and print the result including the size and the name of the file
find ~ -type f -size +10M -exec ls -sh {} \; | sort -nr | head
```
Grep
```python
grep -v string file_name # select non-matching lines
grep –i string file_name # case insensitive
grep -n string file_name # Prefix each line of output with the 1-based line number within its input file.
```

```python
# Extract all 7x7 airplane from file.csv
cut -f 3 file.csv| grep -E "7[0-9]7"

# Obtain column 8 with prefix “aero” case insensitive
cut -f 8 file.csv| grep -i -E "^Aero"

# How many file.csv columns have “name” as part of their name? 
# What are their numerical positions? 
paste <(seq 50) <(head -n 1 file.csv | tr "^" "\n")|grep name


# Find all files with txt extension inside home directory (including all sub directories) that have word “Science” 
# (case insensitive) inside the content. Print file path and the line containing the (S/s)cience word. 
find ~ -type f -iname "*.txt" -exec grep -iwH "Science" {} \;
```

Unique Lines
```python
sort uniq_example.txt | uniq
sort uniq_example.txt | uniq -d # only print duplicate lines, one for each group
sort uniq_example.txt | uniq -c # prefix lines by the number of occurrences
# -u, : output just unique lines
```
Sort
```python
sort -t"," -k1,2 -k3n,3 file # sort a file based on the 1st and 2nd field, and numerically on 3rd field
sort -t"," -k1,1 -u file # Remove duplicates from the file based on 1st field

# -t “^” : file delimited by “^”, white space is the delimiter by default in sort.
# -k M[,N]=--key=M[,N] : sort field consists of part of line between M and N inclusive (or the end of the line, if N
is omitted)
```
Select columns
```python
cut -d "^" -f 2,5 --output-delimiter "\" file_name  
# select 2nd and 5th columns delimeted by "^" and show them delimeted by "\"
```
Replace
```python
cat file_name | tr "[:lower:]" "[:upper:]“
cat file_name | tr -d sa # delete characters
cat file_name | tr -cd sa # Keep just characters
```
```
# Replace every “line” with new line character (“\n”)
sed 's/line/\n/g' Text_example.txt

# Delete lines that contain the “line” word.
sed '/line/d' Text_example.txt

# Print ONLY the lines that DON’T contain the “line” word
sed -n '/line/!p' Text_example.txt
```

# CSV
__csvlook__ Render a CSV file in the console as a fixed-width table.

__csvstat__ Print descriptive statistics for each column in a CSV file.
  -d = delimiter	-H =csv file has no header row	-l = show line numbers

__csvcut__ Filter and truncate CSV files. Like unix "cut" command with output delimiter ","
  -c = column	-n = Display column names and indices

__csvgrep__ Search CSV files. Like the unix "grep" command with output delimiter ","
  -m = pattern	-i = invert the result
  -a = any listed column must match the search string (by default is all)

__csvsort__ Sort CSV files. Like unix "sort" command with output delimiter ","
	-r = reverse	-n = Display column names and indices

__csvformat__ Convert a CSV file to a custom output format.
	-D = output delimiter

__csvstack__ Stack up the rows from multiple CSV files, optionally adding a grouping value.

__csvjoin__ Execute a SQL-like join to merge CSV files on a specified column or columns. Note that the join operation requires reading all files into memory. Don't try this on very large files.

__csvsql__ Generate SQL statements for one or more CSV files, create execute those statements directly on a database, and execute one or more SQL queries.
	-i {access,sybase,sqlite,informix,firebird,mysql,oracle,maxdb,postgresql,mssql},

# Virtual Enviroment

Create and activate a Virtual Environment
```
python3 -m venv tfmearthquake
source tfmearthquake/bin/activate
```
Instal kernel to run virtual enviroment
```
pip install ipykernel
ipython kernel install --user --name=tfmearthquake
```
Export virtual enviroment characteristics
```
pip freeze > requirements.txt
```
