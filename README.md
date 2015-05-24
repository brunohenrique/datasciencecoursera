# Peer Assessments

## Dependencies
- read.table

### Install dependencies
Open R `console` and run this command.

```r
> install.packages("read.table")
```

### Load dependencies
```r
> library(read.table)
```

## Usage

In the main directory, open R `console` and run this command line:

```r
> source("run_analysis.R")
```

It should create a `UCI HAR Dataset` directory with all data downloaded from this [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
If the directory exist, it will use the data from it.

This script will merge the data, rename some variables to
improve readability and will create a new tidy dataset.
