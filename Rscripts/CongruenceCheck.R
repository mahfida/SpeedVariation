library(data.table)

# Congruance check methood----------------
Cong3= function(p1,p2,p3,q1,q2,q3){
  library(psych)
  cong<-array(rep(0,ncol(p1)*ncol(p1)),dim=c(ncol(p1),ncol(p1)))
  for(i in 1: ncol(p1))
  {
    for( j in 1: ncol(p1))
    {
      cong[i,j]<- ( (abs((t(p1[,i])%*%q1[,j])) / (sqrt(sum(p1[,i]^2))*sqrt(sum(q1[,j]^2))))*
                      (abs((t(p2[,i])%*%q2[,j])) / (sqrt(sum(p2[,i]^2))*sqrt(sum(q2[,j]^2))))*
                      (abs((t(p3[,i])%*%q3[,j])) / (sqrt(sum(p3[,i]^2))*sqrt(sum(q3[,j]^2))))) 
    }
  }
  #print ( (abs((t(p1)%*%q1)) / colSums(p1*q1))*(abs((t(p2)%*%q2)) / colSums(p2*q2))*(abs((t(p3)%*%q3)) / colSums(p3*q3)))
  return(cong)
}


# Read loading csv files
node1=read.table("../datasets/loading_files/op2_n_nhm_node_mode3_2_1.csv",sep=",",header=FALSE)
hour1=read.table("../datasets/loading_files/op2_n_nhm_hour_mode3_2_1.csv",sep=",",header=FALSE)
week1=read.table("../datasets/loading_files/op2_n_nhm_week_mode3_2_1.csv",sep=",",header=FALSE)

node2=read.table("../datasets/loading_files/op2_ni_nhm_node_mode3_2_2.csv",sep=",",header=FALSE)
hour2=read.table("../datasets/loading_files/op2_ni_nhm_hour_mode3_2_2.csv",sep=",",header=FALSE)
week2=read.table("../datasets/loading_files/op2_ni_nhm_week_mode3_2_2.csv",sep=",",header=FALSE)
Cong3(node1,hour1,week1,node2,hour2,week2)