# Application Description

The application is implemented in a BASH script, utilizing `awk` for file search. The program consists of a loop that presents options to the user, repeating until the user chooses to exit the application. Once the user selects an action, the program flow is directed through a "case ... in" statement to the corresponding function, where the specified action is performed.

The core idea of the application is that the file the user wants to read/change is copied to a temporary file using the `mktemp` command. All program options operate on this temporary file until the user selects to save it, at which point it is copied back to the "real file."

## Examples of query execution:
- Figure 1: Select Business File
- Figure 2: View Business Details
- Figure 3: Change Business Details
- Figure 4: View File
- Figure 5: Save File
- Figure 6: Exit
