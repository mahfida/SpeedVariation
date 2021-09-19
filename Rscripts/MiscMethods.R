# COLLAPSE TIME MINTUES INTO HOURS
SplitTime=function(oldZZ){
  dimensions<-dim(oldZZ)
  T<-array(rep(0,(nrow(oldZZ)*3*317)), dim=c(nrow(oldZZ),3,317))
  
  #time index: every next 60th minute
  index = seq(1,3,317);
  
  for(i in 1:dimensions[1]){             # per node
    for(k in 1:317){                   # per hour
      for(j in 1:3)       # per day
      {
        T[i,j,k]= oldZZ[i,j + (k-1)*3]
        # for all the nodes, every 60 min data accross all days
      }}}
  
  return(T)
}

# COLLAPSE DAYS INTO Month
CollapseDays=function(oldZZ){
  dimensions<-dim(oldZZ)
  split=11
  days = c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 13)
  tempX<-array(rep(0,(dimensions[1]*dimensions[2]*split)), dim=c(dimensions[1],dimensions[2],split))
  count<-array(rep(0,(dimensions[1]*dimensions[2]*split)), dim=c(dimensions[1],dimensions[2],split))
  
  #time index: every next 60th minute
  index = cumsum(days)
  index<-c(0,index)
  
  for(i in 1:dimensions[1]){# per node
    for(j in 1: (dimensions[2])){ # per hour
      for(k in 1:split)       # per day
      {
        na_count = which(!is.na(oldZZ[i,j,(index[k]+1):index[k+1]]))
        l = length((index[k]+1):index[k+1])
        count[i,j,k] <- (l-length(na_count))/l
        if(length(na_count) > 4){
          Median = median(oldZZ[i,j,(index[k]+1):index[k+1]],na.rm = TRUE)
          tempX[i,j,k]= IQR(oldZZ[i,j,(index[k]+1):index[k+1]],na.rm = TRUE)/Median
        }else{
          tempX[i,j,k] = NA
        }
        
      }}}
  
  return (list(a=tempX, b=count))
}
#----
CollapseMonths=function(oldZZ){
  dimensions<-dim(oldZZ)
  split=11
  days = c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 13)
  tempX<-array(rep(0,(dimensions[1]*dimensions[2]*split)), dim=c(dimensions[1],dimensions[2],split))
  count<-array(rep(0,(dimensions[1]*dimensions[2]*split)), dim=c(dimensions[1],dimensions[2],split))
  
  #time index: every next 60th minute
  index = cumsum(days)
  index<-c(0,index)
  
  for(i in 1:dimensions[1]){# per node
    for(j in 1: (dimensions[2])){ # per hour
      for(k in 1:split)       # per day
      {
        na_count = which(!is.na(oldZZ[i,j,(index[k]+1):index[k+1]]))
        l = length((index[k]+1):index[k+1])
        count[i,j,k] <- (l-length(na_count))/l
        if(length(na_count) > 4){
          Median = median(oldZZ[i,j,(index[k]+1):index[k+1]],na.rm = TRUE)
          tempX[i,j,k]= Median
        }else{
          tempX[i,j,k] = NA
        }
        
      }}}
  
  return (list(a=tempX, b=count))
}
# Collapse days into weeks
CollapseWeek=function(oldZZ){
  dimensions<-dim(oldZZ)
  split=7
  tempX<-array(rep(0,(dimensions[1]*dimensions[2]*split)), dim=c(dimensions[1],dimensions[2],split))
  index<-seq(1,dimensions[3],by=7)
  count=array(rep(0,(dimensions[1]*dimensions[2]*split)), dim=c(dimensions[1],dimensions[2],split))
  #time index: every next 60th minute
  for(i in 1:dimensions[1]){# per node
    for(j in 1: (dimensions[2])){ # per hour
      for(k in 1:split)# instead of split
      {
        dim3<-index+k-1
        ind<-which(dim3<=dimensions[3])
        na_count = which(!is.na(oldZZ[i,j,dim3[ind]]))
        l = length(dim3[ind])
        count[i,j,k] <- (l-length(na_count))/l
        if(length(na_count) > 4){
          Median = median(oldZZ[i,j,dim3[ind]],na.rm = TRUE)
          tempX[i,j,k]= IQR(oldZZ[i,j,dim3[ind]],na.rm = TRUE)/Median
        }else{
          tempX[i,j,k] = NA 
        }
      }}}
  
  
  return (list(a=tempX, b=count))
}

# Collapse days into weeks
CollapseWeekMonths=function(oldZZ){
  dimensions<-dim(oldZZ)
  tempX<-array(rep(0,(dimensions[1]*7*11)), dim=c(dimensions[1],7,11))
  days = c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 13)
  cs=cumsum(days)
  cs <- c(0,cs)
  #time index: every next 60th minute
  for(i in 1:dimensions[1]){# per node
    for(j in 1:7){ # per hour
      for(k in 1:11)# instead of split
      {
        index<-seq(cs[k]+1,cs[k+1],by=7)
        dim3<-index+j-1
        ind<-which(dim3<=cs[k+1])
        Median = median(oldZZ[i,dim3[ind]],na.rm = TRUE)
        tempX[i,j,k]= IQR(oldZZ[i,dim3[ind]],na.rm = TRUE)/Median
      }}}
  
  
  return (tempX)
}

# Collapse days into weeks
DayWeekMonth=function(oldZZ){
  dimensions<-dim(oldZZ)
  tempX<-array(rep(0,(dimensions[1]*3*7*11)), dim=c(dimensions[1],3,7,11))
  days = c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 13)
  cs=cumsum(days)
  cs <- c(0,cs)
  #time index: every next 60th minute
  for(n in 1:dimensions[1]){# per node
    for(w in 1:7){ # per week day
      for(m in 1:11)# per month
      {
        index<-seq(cs[m]+1,cs[m+1],by=7)
        dim3<-index+w-1
        ind<-which(dim3<=cs[m+1])
        for(d in 1:3 ) # per hour
        {
          # if there is less than 2 speed values turn, it into NaN
          non.na.len =  length(which(!is.na(oldZZ[n,d,dim3[ind]])))
          if(non.na.len>1){
            Median = median(oldZZ[n,d,dim3[ind]],na.rm = TRUE)
            tempX[n,d,w,m]= IQR(oldZZ[n,d,dim3[ind]],na.rm = TRUE)/Median
          }else{
            tempX[n,d,w,m]=NaN }
        }}}} # END OF FOR LOOPS
  
  
  return (tempX)
}


