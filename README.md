# Simple Businesses File Editor Written in Bash and Awk

The application is implemented in a BASH script, utilizing `awk` for file search. The program consists of a loop that presents options to the user, repeating until the user chooses to exit the application. Once the user selects an action, the program flow is directed through a "case ... in" statement to the corresponding function, where the specified action is performed.

The core idea of the application is that the file the user wants to read/change is copied to a temporary file using the `mktemp` command. All program options operate on this temporary file until the user selects to save it, at which point it is copied back to the "real file."

## Examples of query execution:
- Figure 1: Select Business File
<p align="center">
<img align="center" alt="figure1" width="80%" src="./1.png?raw=true" />
</p>
- Figure 2: View Business Details
<p align="center">
<img align="center" alt="figure2" width="80%" src="./2.png?raw=true" />
</p>
- Figure 3: Change Business Details
<p align="center">
<img align="center" alt="figure3" width="80%" src="./3.png?raw=true" />
</p>
- Figure 4: View File
<p align="center">
<img align="center" alt="figure4" width="80%" src="./4.png?raw=true" />
</p>
- Figure 5: Save File
<p align="center">
<img align="center" alt="figure5" width="80%" src="./5.png?raw=true" />
</p>
- Figure 6: Exit
<p align="center">
<img align="center" alt="figure6" width="80%" src="./6.png?raw=true" />
</p>
