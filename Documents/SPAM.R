# SPAM 
library(kernlab)

# loading the data
data(spam)

str(spam)

#subsampling
set.seed(1)
train=rbinom(4601,size=1,prob=0.5)

# no of observations with 0s and 1s
table(train)

#Assigning train and test datasets

trainSpam=spam[train==1,]
testSpam=spam[train==0,]

#EDA on trainSpam dataset

#Summary gives spam:867, nonspam:1350
summary(trainSpam$type)

#60% prediction ability at base model prediction

#Logistic Regression

mylogit=glm(type~.,data=trainSpam,family="binomial")

summary(mylogit)

#Significant variables: our, over, remove, free, hp, charDollar, charExclamation, capitalTotal
#internet,order,mail,business,you,num000,george,data, technology,project,re,edu,capitalAve


anova(mylogit,test="Chisq")


library(pscl)
pR2(mylogit)

library(ROCR)



results=predict(mylogit,testSpam,type='response')

misClassificError=mean(results!=testSpam$type)




p=predict(mylogit,testSpam,type="response")
pr=prediction(p,testSpam$type)
prf=performance(pr,measure="tpr",x.measure="fpr")
plot(prf)
auc=performance(pr,measure="auc")
auc=auc@y.values[[1]]
auc


#Confusion Matrix

p=predict(mylogit,testSpam,type="response")
predictedSpam=rep("nonspam",dim(testSpam)[1])

predictedSpam[mylogit$fitted>0.5]="spam"

table(predictedSpam,testSpam$type)



mylogit1=glm(type~our+over+remove+free+hp+charDollar+charExclamation+capitalTotal+
               +              internet+order+mail+business+you+num000+george+data+technology+project+re+edu+capitalAve,data=trainSpam,family="binomial")


#Hierarchical Clustering
clusters=hclust(dist(trainSpam[,1:57]))
plot(clusters)

#Cutting trees
clusterCut=cutree(clusters,3)
plot(clusterCut)





