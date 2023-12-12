# final-project

**Brief description of the app and its purpose:** <br>
The Wine Quality Data Tool is designed to facilitate use of the wine quality data made available by the UC-Irvine Machine Learning Repository at https://archive.ics.uci.edu/dataset/186/wine+quality. Included in these data are (1) a subjective quality rating of each wine, (2) a categorical indicator of wine type (red vs. white), and (3) eleven continuous measures of various physicochemical properties associated with each wine. The measures in question are available for approximately 6,500 red and white variants of the Portuguese "Vinho Verde" wines. A particular focus of this tool is the use of these data to better understand the determinants of wine quality. Users can interact with the data via three primary tabs included within the tool, the second and third of which allow users to drill down to various sub-tabs.

**List of packages needed to run the app:** <br>
shiny<br>
shinyjs<br>
readr<br>
janitor<br>
ggplot2<br>
tidyr<br>
dplyr<br>
stringr<br>
caret<br>
randomForest<br>

**Code to install all the packages used in the app:** <br>
install.packages("shiny")<br>
install.packages("shinyjs")<br>
install.packages("readr")<br>
install.packages("janitor")<br>
install.packages("ggplot2")<br>
install.packages("tidyr")<br>
install.packages("dplyr")<br>
install.packages("stringr")<br>
install.packages("caret")<br>
install.packages("randomForest")<br>

**Code to copy and paste into RStudio to run the app:** <br>
library(shiny)<br>
shiny::runGitHub('final-project', 'terry-mctest', subdir='final-project-app')
