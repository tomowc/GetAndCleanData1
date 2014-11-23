How the script works
====================

1. It reads all required data.
2. It adds two columns to test and train datasets regarding activities and subjects ids.
3. It binds ("merges") test and train datasets - numbers in brackets in code comments corresponds with points in the project.
4. It searches for variables' names which include "mean" or "std" (their indices are then kept in variable "proper.columns").
5. A new dataset is created only with chosen columns.
6. New column with activities' names is added (and column with their ids is removed).
7. Names of the variables (kept in variable "feat.lab") are slightly changed - "BodyBody" is replaced with single Body, brackets are removed and "-" are changed into ".".
8. Columns in dataset created in 5. are named.
9. Dataset is transformed into "long" format ("melt") and then observations are grouped by subject, activity and variable and for each gruop the average is calculated.
10. This new dataset is written into tidy.txt file.
