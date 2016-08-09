test<-cbind(read.table("./test/subject_test.txt"),read.table("./test/y_test.txt"),read.table("./test/X_test.txt"))
train<-cbind(read.table("./train/subject_train.txt"),read.table("./train/y_train.txt"),read.table("./train/X_train.txt"))

features<-read.table("features.txt")
colnames(test)<-c("subject","activity",as.character(features$V2))
colnames(train)<-c("subject","activity",as.character(features$V2))

merged<-rbind(test,train)
mergedData<-merged[order(merged$subject),]

extracted<-mergedData[,grepl(c("subject|activity|mean|std"),colnames(mergedData))]

activity_labels<-read.table("activity_labels.txt")
act_labeled<-merge(extracted,activity_labels,by.x="activity",by.y="V1")

colnames(act_labeled)[82]<-"act"
Final<-act_labeled[,c(2,82,3:81)]
Final1<-Final[order(Final$subject),]

Final2<-{Final1 %>% group_by(act,subject) %>% summarise_each(funs(mean))}
Final2$act<-factor(Final2$act,levels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
Final3<-Final2[order(Final2$act),]
