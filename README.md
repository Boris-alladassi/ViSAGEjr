# ViSAGEjr

## 1. About ViSAGEjr

ViSAGEjr is an R shiny app developed to use **Vi**sualization and **S**imulation for **A**dvancing **G**enetics **E**ducation. The app simulates selective breeding scenarios based on user-defined inputs. It runs twenty cycles of selection and produces graphs and cartoons for visualizing phenotypic changes across generations.
This document provides instructions on how to install and run ViSAGEjr. Thanks for using *ViSAGEjr*!

## 2. How to install ViSAGEjr?

### 2.1. First install R and RStudio

Installing and running ViSAGEjr on the local computer requires the installation of R and RStudio.
To install R, go to the official R website: <https://cran.r-project.org>. Click on the appropriate link for your operating system: "Download R for Windows" or "Download R for macOS".
Run the downloaded installer and follow the setup instructions (default options are fine).

To install RStudio, go to the RStudio download page: <https://posit.co/download/rstudio-desktop/>. Scroll down to the RStudio Desktop and click the download link for your operating system (Windows or macOS).
Run the downloaded installer and complete the installation. Finally, open RStudio from your applications, and it should automatically detect R installation.

### 2.2. Installing ViSAGEjr as a package

Run the code below to install the development version of ViSAGEjr from [GitHub](https://github.com/):

```install.packages("devtools")```

```devtools::install_github("Boris-alladassi/ViSAGEjr")```

### 2.3. Running ViSAGEjr

Once **ViSAGEjr** is installed, you can run the app using the code below:

```library(ViSAGEjr)```

```ViSAGEjr::run_visagejr()```

At this point, the app should be up running. Please test the app as thoroughly as you can. Explore both the Standard and Fun panels. Record any abnormal behavior and share your feedback and suggestions with us at [**aboris@illinois.edu**](mailto:aboris@illinois.edu) or [**alipka@illinois.edu**](mailto:alipka@illinois.edu).

### 2.4. Alternative access to ViSAGE

If a user is not able to install and run the app on their local computer, they can access it at <https://borisalladassi.shinyapps.io/visagejr/>. Simply copy and paste the URL in your browser, and it will start running. **It is worth noting that due to memory limitation, running the app from a the URL is much slower than running it locally.**  

## 3. Authors

Boris M.E. Alladassi [aboris@illinois.edu](mailto:aboris@illinois.edu)
Alex E. Lipka [alipka@illinois.edu](mailto:alipka@illinois.edu)
