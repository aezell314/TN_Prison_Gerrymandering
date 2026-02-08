# TN Prison Gerrymandering Shiny App global.R file
library(shiny)
library(glue)
library(DT)
library(tidyverse)
library(shinydashboard)
library(sf)

# Reading in data
prisons_sldu <- readRDS('../Data/prisons_sldu.rds') 
prisons_sldl <- readRDS('../Data/prisons_sldl.rds') 
sldu_demogr <- readRDS('../Data/sldu_demogr.rds') 
sldl_demogr <- readRDS('../Data/sldl_demogr.rds') 
TN_house_bounds <- readRDS('../Data/TN_house_bounds.rds')
TN_senate_bounds <- readRDS('../Data/TN_senate_bounds.rds')

