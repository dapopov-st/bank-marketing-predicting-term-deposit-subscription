## ----setup, include=FALSE-------------------------------------
knitr::opts_chunk$set(echo = TRUE)

#Outline: 
#1. Do some preliminary visualizations 
#(already checked that there are no nas)

#2. Split into training, validation, and test set

#3. Fit a random forest, which performed better than boosted trees

#4. Do visualizations for the features identified as important by
# the random forest

#5. Present the results in a separate document

## -------------------------------------------------------------
library(dplyr)
library(caret)
library(inspectdf)
library(tictoc)
library(MLmetrics)
library(DALEX)
library(DMwR)
library(xgboost)
library(randomForest)
library(vcd) #for mosaic plots
library(forcats)
library(GGally)
library(corrplot)


## -------------------------------------------------------------
df = read.csv('../data/bank-additional-full.csv',sep = ';',stringsAsFactors=TRUE) #trying to override default behavior since need factors for SMOTE

## -------------------------------------------------------------
dfK = read.csv('../data/bankKaggle.csv',sep = ',',stringsAsFactors=TRUE)

## -------------------------------------------------------------
head(df)

## -------------------------------------------------------------
ggplot(df, aes(duration, fill = y)) +
  geom_density(alpha = 0.5) +
  theme_bw()+
    ggtitle("Duration  Vs Deposits ")+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

## -------------------------------------------------------------
ggplot(df, 
       aes(x = y, 
           y = duration),col('blue')) +
  geom_boxplot() +
  labs(title = "Duration distribution by deposit response")


## -------------------------------------------------------------
df %>% group_by(y) %>% summarise(avg=mean(duration),count=n(),total_hrs=mean(duration)*n()/3600,min_cost=total_hrs*8.08)#,count=n(duration))


## -------------------------------------------------------------
df$duration <- NULL
#df$emp.var.rate <-NULL
#df$cons.conf.idx <-NULL
#df$euribor3m <-NULL
#df$nr.employed <-NULL



## -------------------------------------------------------------
df<- df %>% rename(deposit = y)

df$deposit=factor(df$deposit,levels=c('yes','no'))



## -------------------------------------------------------------
df%>%
  group_by(deposit)%>%
  summarize(cnt=n())

## -------------------------------------------------------------
df%>%
  group_by(deposit)%>%
  summarize(avg=mean(campaign))


## -------------------------------------------------------------
dfK$duration <- NULL


## -------------------------------------------------------------
head(dfK)


## -------------------------------------------------------------
x <- inspect_na(df)
show_plot(x)


## -------------------------------------------------------------
x <- inspect_num(df)
show_plot(x)

## -------------------------------------------------------------
prop.table(table(df$y))


## -------------------------------------------------------------
#reduced_general <-df %>%select(job,marital,education)
telephone_type_vs_deposit <- df[,c(8,20)]
mosaicplot(table(telephone_type_vs_deposit), shade = TRUE)


## -------------------------------------------------------------
#reduced_general <-df %>%select(job,marital,education)
housing_vs_deposit <- df[,c(6,20)]
mosaicplot(table(housing_vs_deposit), shade = TRUE)

## -------------------------------------------------------------
#reduced_general <-df %>%select(job,marital,education)
month_vs_deposit <- df[,c(9,20)]
mosaicplot(table(month_vs_deposit ), shade = TRUE,color=TRUE)


## -------------------------------------------------------------
#reduced_general <-df %>%select(job,marital,education)
housing_vs_deposit <- df[,c(6,20)]
mosaicplot(table(housing_vs_deposit ), shade = TRUE,color=TRUE)


## -------------------------------------------------------------
df%>% 
  group_by(month,deposit)%>%
  summarise(cnt=n())%>%
  arrange(cnt)



## -------------------------------------------------------------
set.seed(42)
trainIdx <- createDataPartition(df$deposit,p=0.8,list=FALSE)#90% for trainining, list = FALSE to avoid Error in xj[i] : invalid subscript type 'list'
dfTrain <- df[trainIdx,]
validTest<- df[-trainIdx,]

#For SMOTE, must convert to factor
dfTrain$deposit = as.factor(dfTrain$deposit)

#partition half of the 20% into validation and test sets
testIdx <- createDataPartition(validTest$deposit,p=.5,list=FALSE)
dfValid <- validTest[-testIdx,]
dfTest <- validTest[testIdx,]


## -------------------------------------------------------------
#NOTE: I DON'T THINK I CAN MEANINGFULLY COMPARE THE MODEL FITTED ON 20 VARS WITH KAGGLE'S 17 ONE
set.seed(42)
trainIdxK <- createDataPartition(dfK$deposit,p=0.8,list=FALSE)#90% for trainining, list = FALSE to avoid Error in xj[i] : invalid subscript type 'list'
dfTrainK <- dfK[trainIdxK,]
validTestK<- dfK[-trainIdxK,]

#For SMOTE, must convert to factor
dfTrainK$deposit = as.factor(dfTrainK$deposit)

#partition half of the 20% into validation and test sets
testIdxK <- createDataPartition(validTestK$deposit,p=.5,list=FALSE)
dfValidK <- validTestK[-testIdxK,]
dfTestK <- validTestK[testIdxK,]


## -------------------------------------------------------------
#Special thanks to Rodrigo Barrios for useful suggestions on imbalanced training with caret and ranger on a different dataset
#https://www.kaggle.com/code/rowang/smote-for-imbalanced-dataset-notebook-r-caret/notebook
#In my case, the simplest approach worked better than Smote
tuneGrid <- expand.grid(mtry = c(12,16), 
                        splitrule = c("extratrees"),
                        min.node.size = c(10,20,30,40))
myFolds_full <- createFolds(dfTrain$deposit, k = 10)
trainControl <- trainControl(# Compute Recall, Precision, F-Measure
  summaryFunction = twoClassSummary,
  classProbs = TRUE,
  verboseIter = TRUE,
  savePredictions = TRUE,
  index = myFolds_full)


model_weights <- ifelse(dfTrain$deposit == "yes",
                        (1/table(dfTrain$deposit)[1]) * 0.5,
                        (1/table(dfTrain$deposit)[2]) * 0.5)

model <- train(deposit ~ . , 
                                data = dfTrain, 
                                method = "ranger", 
                                trControl = trainControl,
                                tuneGrid = tuneGrid,
                                metric = "ROC",
                                maximize = TRUE,
                                weights = model_weights,
                                importance = "impurity")


## -------------------------------------------------------------
pred_rf_raw_final <- predict.train(model,
                          newdata = dfValid,
                          type = "raw")
pred_rf_rec_final <- predict.train(model,
                          newdata = dfValid,
                          type = "prob")
dfValid$pred_rf_raw_final<-pred_rf_raw_final



## -------------------------------------------------------------
confusionMatrix(data = pred_rf_raw_final,
                factor(dfValid$deposit),
                positive = "yes")


## -------------------------------------------------------------
pred_rf_raw_test <- predict.train(model,
                          newdata = dfTest,
                          type = "raw")
pred_rf_rec_test <- predict.train(model,
                          newdata = dfTest,
                          type = "prob")


## -------------------------------------------------------------
confusionMatrix(data = pred_rf_raw_test,
                factor(dfTest$deposit),
                positive = "yes")


## -------------------------------------------------------------
#Would be better to use the validation set for this, but the test set has a distribution of nos and yeses more similar to
#training set
predTest<-ifelse(pred_rf_raw_test=='yes',1,0)
trueTest<-ifelse(dfTest$deposit=='yes',1,0)


## -------------------------------------------------------------
library(pROC)
## Type 'citation("pROC")' for a citation.
## 
## Attaching package: 'pROC'
## The following objects are masked from 'package:stats':
## 
##     cov, smooth, var
pROC_obj <- roc(trueTest,predTest,
            smoothed = TRUE,
            # arguments for ci
            ci=TRUE, ci.alpha=0.9, stratified=FALSE,
            # arguments for plot
            plot=TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
            print.auc=TRUE, show.thres=TRUE)


sens.ci <- ci.se(pROC_obj)
plot(sens.ci, type="shape", col="lightblue")
## Warning in plot.ci.se(sens.ci, type = "shape", col = "lightblue"): Low
## definition shape.
plot(sens.ci, type="bars")


## -------------------------------------------------------------
model


## -------------------------------------------------------------
saveRDS(model, "model2.rds")


## -------------------------------------------------------------
exp2 <- readRDS("model2.rds")


## -------------------------------------------------------------
print(exp2)


## -------------------------------------------------------------
caret::varImp(model)$importance


## -------------------------------------------------------------
caret::varImp(model)$importance
nrow(varImp(model)$importance) #34 variables extracted


## -------------------------------------------------------------
varImp(model)$importance %>% 
  as.data.frame() %>%
  tibble::rownames_to_column() %>%
  arrange(Overall) %>%
  mutate(rowname = forcats::fct_inorder(rowname )) %>%
  ggplot()+
    geom_col(aes(x = rowname, y = Overall))+
    coord_flip()+
    theme_bw()+
    geom_density(
      aes(x = rowname, y = Overall),
    color="purple",
    fill="#69b3a2",
    size=4
   )



## -------------------------------------------------------------
varImp(model)$importance %>% 
  as.data.frame() %>%
  tibble::rownames_to_column() %>%
  arrange(Overall) %>%
  mutate(rowname = forcats::fct_inorder(rowname )) %>%
  ggplot()+
    geom_col(aes(x = rowname, y = Overall),col="#E5F5F9" ,fill="#99D8C9")+
    coord_flip()+
    theme_bw()



## -------------------------------------------------------------
varImp(model)$importance %>% 
   top_n(20, Overall) %>%
  as.data.frame() %>%
  tibble::rownames_to_column() %>%
  arrange(Overall) %>%
  mutate(rowname = forcats::fct_inorder(rowname )) %>%
 
  ggplot()+
    geom_col(aes(x = rowname, y = Overall),col="#E5F5F9" ,fill="#99D8C9")+
    coord_flip()+
    theme_bw()+
    ggtitle("Most Important Features (top 20)")+
  theme(plot.title = element_text(hjust = 0.5))
    


## -------------------------------------------------------------
# corrplot(cor(dplyr::select_if(df, is.numeric)), method = 'circle',type='lower',addCoef.col = "black", diag = FALSE,col = hcl.colors(
#                           n=10, 
#                           alpha = 0.8
#                           )) # colorful number

corrplot(cor = cor(dplyr::select_if(df, is.numeric)),  addCoef.col = "black",method = "circle", type = "lower", order = "AOE",
         diag = FALSE, number.cex = 0.7
)


## -------------------------------------------------------------
library(inspectdf)
x<-inspectdf::inspect_cat(df)  
show_plot(x)+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))
#show_plot(as.numeric(unlist(x)))




## -------------------------------------------------------------
ggplot(df, aes(age, fill = deposit)) +
  geom_density(alpha = 0.5) +
  theme_bw()

## -------------------------------------------------------------
ggplot(df, aes(euribor3m, fill = deposit)) +
  geom_density(alpha = 0.5) +
  theme_bw()+
    ggtitle("Euribor 3 Month Rate  Vs Deposits ")+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

## -------------------------------------------------------------
ggplot(df, aes(pdays, fill = deposit)) +
  geom_density(alpha = 0.5) +
  theme_bw()+
    ggtitle("Number of Contacts Performed Before This Campaign  Vs Deposits ")+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))


## -------------------------------------------------------------
ggplot(df, aes(campaign, fill = deposit)) +
  geom_density(alpha = 0.5) +
  theme_bw()+
    ggtitle("Number of Contacts Performed Before This Campaign  Vs Deposits ")+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))


## -------------------------------------------------------------
ggplot(df, aes(nr.employed, fill = deposit)) +
  geom_density(alpha = 0.5) +
  theme_bw()+
    ggtitle("Number of Employees  Vs Deposits ")+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))

## -------------------------------------------------------------
ggplot(df, aes(pdays, fill = deposit)) +
  geom_density(alpha = 0.5) +
  theme_bw()+
    ggtitle("Days after the client was contacted from a previous campaign (pdays)  Vs Deposits ")+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))


## -------------------------------------------------------------
knitr::purl("model_with_visualizations.Rmd")

