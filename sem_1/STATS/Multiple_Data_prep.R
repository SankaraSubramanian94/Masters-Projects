# Reading file from local directories for multiple regression

# 1- GDP data which is the target variable
GDP_data <- read.csv("D:/Statistics/project/multiple_regression/GHED_CHEGDP_SHA2011.csv", skip=1, check.names=FALSE)
head(GDP_data)
str(GDP_data)

# 2 - Data about qualified surgeons, obstetricians, anaesthesiologists actively working

SOA_data <- read.csv("D:/Statistics/project/multiple_regression/HRH_41,HRH_42,HRH_43.csv", check.names=FALSE)
head(SOA_data)
str(SOA_data)

# 3 Data about medical doctor, Generalist medical practitioners, Specialist medical practitioners
MGS_data <- read.csv("D:/Statistics/project/multiple_regression/HWF_0001,HWF_0002,HWF_0003,HWF_0004,HWF_0005.csv", check.names=FALSE)
head(MGS_data)

# 4 Data about nursing, Midwifery personnel
NMP_data <- read.csv("D:/Statistics/project/multiple_regression/HWF_0006,HWF_0007,HWF_0008,HWF_0009.csv", check.names=FALSE)
head(NMP_data)

# 5 Data about Dentists, Dental Assistants and Therapists and Dental Prosthetic Technicians
DAPT_data <- read.csv("D:/Statistics/project/multiple_regression/HWF_0010,HWF_0011,HWF_0012,HWF_0013.csv", check.names=FALSE)
head(DAPT_data)

# 6 Data about Pharmacists and Pharmaceutical Technicians and Assistants

PTA_data <- read.csv("D:/Statistics/project/multiple_regression/HWF_0014,HWF_0015,HWF_0016.csv", check.names=FALSE)
head(PTA_data)

# 7 Data about Environmental and Occupational Health and Hygiene Professionals and Environmental and Occupational Health Inspectors and Associates

EHP_data <- read.csv("D:/Statistics/project/multiple_regression/HWF_0017,HWF_0018.csv", check.names=FALSE)
head(EHP_data)

# 8 Data about Physiotherapists and Physiotherapy Technicians and Assistants
PPTA_data <- read.csv("D:/Statistics/project/multiple_regression/HWF_0021,HWF_0022.csv", check.names=FALSE)
head(PPTA_data)

# Combining dataframe 2 to 8 to get master data based on country and year
data_merge_1 = merge(SOA_data, MGS_data,  by= c("Country","Year"), all = TRUE)
data_merge_2 = merge(data_merge_1, NMP_data,  by= c("Country","Year"), all = TRUE)
data_merge_3 = merge(data_merge_2, DAPT_data,  by= c("Country","Year"), all = TRUE)
data_merge_4 = merge(data_merge_3, PTA_data,  by= c("Country","Year"), all = TRUE)
data_merge_5 = merge(data_merge_4, EHP_data,  by= c("Country","Year"), all = TRUE)
data_merge_6 = merge(data_merge_5, PPTA_data,  by= c("Country","Year"), all = TRUE)

# combining dataframe 1 with data_merge_6 to obtain final dataset


library(data.table)

normalized_data = melt(setDF(GDP_data), id.vars = "Country")

colnames(normalized_data)<- c("Country", "Year","GDP")

head(normalized_data)

normalized_data$Year = as.character.numeric_version(normalized_data$Year)
normalized_data$Year = as.numeric(normalized_data$Year)
str(normalized_data)
data_merge_6$Country = as.character(data_merge_6$Country)
str(data_merge_6)


library(plyr)

final_dataset = merge(data_merge_6, normalized_data,  by= c("Country","Year"), all = TRUE)
final_dataset$GDP[final_dataset$GDP == "No data"] <- 0
final_dataset$GDP[is.na(final_dataset$GDP)] <- 0
final_dataset$GDP = as.numeric(final_dataset$GDP)

library(stringi)
final_dataset$`Number of licensed qualified surgeons actively working`=stri_replace_all_fixed(final_dataset$`Number of licensed qualified surgeons actively working`," ","")
final_dataset$`Number of licensed qualified surgeons actively working` =as.integer(final_dataset$`Number of licensed qualified surgeons actively working`)

final_dataset$`Number of licensed qualified anaesthesiologists actively working` =stri_replace_all_fixed(final_dataset$`Number of licensed qualified anaesthesiologists actively working`," ","")
final_dataset$`Number of licensed qualified anaesthesiologists actively working` =as.integer(final_dataset$`Number of licensed qualified anaesthesiologists actively working`)

final_dataset$`Number of licensed qualified obstetricians actively working` =stri_replace_all_fixed(final_dataset$`Number of licensed qualified obstetricians actively working`," ","")
final_dataset$`Number of licensed qualified obstetricians actively working` =as.integer(final_dataset$`Number of licensed qualified obstetricians actively working`)

final_dataset = final_dataset[,-3]

final_dataset[is.na(final_dataset)]= 0

str(final_dataset)

write.csv(final_dataset,"D:/Statistics/project/multiple_regression/multilple_regression_dataset.csv", row.names=FALSE)


# Dataset input after preprocessing

LM_model_data = read.csv("D:/Statistics/project/multiple_regression/output_codes/multilple_regression_dataset.csv")

# GDP calculated for data in 2013

str(LM_model_data)


# For 2005- GDP
LM_model_data <- LM_model_data[(LM_model_data$Year==2013),]

write.csv(LM_model_data,"D:/Statistics/project/multiple_regression/output_codes/multilple_regression_model_dataset.csv", row.names=FALSE)

# Over all Regression Model

model <-lm(formula = GDP ~ . -Country -Year, data=LM_model_data)
summary(model)


# Finding correlation between predictor variables

install.packages("psych")
library(psych)
pairs.panels(LM_model_data[c("Number.of.licensed.qualified.surgeons.actively.working",
                             "Number.of.licensed.qualified.obstetricians.actively.working",
                             "Medical.doctors..number.",
                             "Generalist.medical.practitioners..number.",
                             "Specialist.medical.practitioners..number.",
                             "Medical.doctors.not.further.defined..number.",
                             "Nursing.and.midwifery.personnel...number.",
                             "Nursing.personnel..number.",
                             "Midwifery.personnel..number.",
                             "Dentists..number.",
                             "Dental.Assistants.and.Therapists..number.",
                             "Dental.Prosthetic.Technicians..number.",
                             "Pharmacists..number.",
                             "Pharmaceutical.Technicians.and.Assistants..number.",
                             "Environmental.and.Occupational.Health.and.Hygiene.Professionals...number.",
                             "Environmental.and.Occupational.Health.Inspectors.and.Associates..number.",
                             "Physiotherapists..number.",
                             "Physiotherapy.Technicians.and.Assistants..number.")])

# Interaction Correlation Values:

model_new <-lm(formula = GDP ~Number.of.licensed.qualified.surgeons.actively.working+
                 Number.of.licensed.qualified.obstetricians.actively.working+
                 Number.of.licensed.qualified.surgeons.actively.working:Number.of.licensed.qualified.obstetricians.actively.working+
                 Physiotherapists..number.
                 , data=LM_model_data)
summary(model_new)

# Significant Columns:

pairs.panels(LM_model_data[c("Number.of.licensed.qualified.surgeons.actively.working",
                             "Number.of.licensed.qualified.obstetricians.actively.working",
                             "Physiotherapists..number.")])



# Step-Wise Correlation Values:

pairs.panels(LM_model_data[c("Physiotherapists..number.","GDP")])

# Backward Correlation Values

pairs.panels(LM_model_data[c("Number.of.licensed.qualified.surgeons.actively.working",
                             "Physiotherapists..number.",
                             "Number.of.licensed.qualified.obstetricians.actively.working")])

# ggplot Regression and linear model:

library(ggplot2)

install.packages("plotly")
library(plotly)

ggplot(LM_model_data, aes(x=Physiotherapists..number.,y=GDP))+ 
  geom_point()+geom_smooth(method = lm, linetype="dashed",
                           color="darkred",fullrange=TRUE) + 
  labs(title="GDP Vs HealthCare Factors", x="HealthCare_StepWise")+ theme_minimal()

ggplotly(LM_model_data, aes(x=Physiotherapists..number.,y=GDP))+ 
  geom_point()+geom_smooth(method = lm, linetype="dashed",
                           color="darkred",fullrange=TRUE) + 
  labs(title="GDP Vs HealthCare Factors", x="HealthCare_StepWise")+ theme_minimal()


ggplot(LM_model_data, aes(x=Physiotherapists..number.+
                            Number.of.licensed.qualified.surgeons.actively.working+
                            Number.of.licensed.qualified.obstetricians.actively.working,y=GDP))+ 
  geom_point()+geom_smooth(method = lm, linetype="dashed",
                           color="darkred",fullrange=TRUE) + labs(title="GDP Vs HealthCare Factors", x="HealthCare_Backward")+ 
  theme_minimal()
