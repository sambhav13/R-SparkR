#Loading dataset
sampleTestDataSet <- data.frame(LATITUDE=c(),LONGITUDE=c(),ALERT_HISTORY_ID=c(),FIX_SAMPLE_TS=c())

sample_previous <- c(6,6) 
sample_current <- c(4,5) 
sample_future <- c(-1,-2)

temp_dataset1 <- data.frame(LATITUDE=c(sample_previous[1]),LONGITUDE=c(sample_previous[2]),ALERT_HISTORY_ID=c(121656132),
                            FIX_SAMPLE_TS=c("01-SEP-15 04.44.57.000000000 PM"))

temp_dataset2 <- data.frame(LATITUDE=c(sample_current[1]),LONGITUDE=c(sample_current[2]),ALERT_HISTORY_ID=c(121656132),
                            FIX_SAMPLE_TS=c("01-SEP-15 04.47.51.000000000 PM"))

temp_dataset3 <- data.frame(LATITUDE=c(sample_future[1]),LONGITUDE=c(sample_future[2]),ALERT_HISTORY_ID=c(121656132),
                            FIX_SAMPLE_TS=c("01-SEP-15 04.50.35.000000000 PM"))

temp_dataset4 <- data.frame(LATITUDE=-2,LONGITUDE=-2,ALERT_HISTORY_ID=c(121656132),
                            FIX_SAMPLE_TS=c("01-SEP-15 04.53.59.000000000 PM"))


finalTestSample <- rbind(sampleTestDataSet,temp_dataset1,temp_dataset2,temp_dataset3)

finalTestSample <- rbind(sampleTestDataSet,temp_dataset1,temp_dataset2,temp_dataset3,
                         temp_dataset4)

rad2deg <- function(rad) {(rad * 180) / (pi)}
deg2rad <- function(deg) {(deg * pi) / (180)}



par(mfrow=c(2,1))
#for(i in 1:nrow(finalTestSample)){
for(i in 2:4){
  #print(i)
  
  
  sample_previous <- finalTestSample[i-1,]
  sample_current <-  finalTestSample[i,]
 # sample_future <-   finalTestSample[i+2,]
  
  
  sample_point = c(sample_current$LATITUDE,sample_current$LONGITUDE)
  min_distance <- 10000000000; 
  min_center <- c(10,10)
  
  
  
  lstMinCenterMatch <- NA
  for(j in 1:boundary_length)
  {
     
  
    temp_lst <- boundaries$getlst();
    min_var <- temp_lst[[j]]$distanceFromCircumference(sample_point)
    print(min_var)
    if(min_var>0){
      if(min_var< min_distance)
      {
        min_distance <- min_var
        min_center <- temp_lst[[j]]$get_Center();
        lstMinCenterMatch <- j
      }
    }
    
  }
  
  slope <- (sample_current[2] -sample_previous[2])/(sample_current[1]-sample_previous[1])
  theta_rad <- atan(slope)
 
  currentDist <- temp_lst[[lstMinCenterMatch]]$distanceFromCircumference(sample_point)
  previousDist <- temp_lst[[lstMinCenterMatch]]$distanceFromCircumference(sample_previous)
  
  
  xc <- temp_lst[[lstMinCenterMatch]]$get_Center()[1]
  yc <- temp_lst[[lstMinCenterMatch]]$get_Center()[2]
  
  
  slope_center_previous <- (yc  - sample_previous$LONGITUDE ) /(xc -sample_previous$LATITUDE)
  slope_center_current <- (yc  - sample_current$LONGITUDE ) /(xc -sample_current$LATITUDE)
 
  sl_prev <- rad2deg(slope_center_previous)
  sl_current <- rad2deg(slope_center_current)
  #if(sl_current <= sl_prev){
  if((sl_current <= sl_prev)& (sl_current> (sl_prev-15))&(sl_current< (sl_prev+15)) ){
   print(paste(xc,yc,"closing angle",sep=","))
  } else{
    print(paste(xc,yc,"opening angle",sep=","))
  }
 
  #print(paste("slope previous"))
  if(currentDist<previousDist)
  {
    print("Moving towards")
    print(sl_prev);
    print(sl_current)
  }
  else{
    print("Moving away")
    print(sl_prev);
    print(sl_current)
  }
 
 
 dist1 <-  sqrt( (sample_current["LATITUDE"]-sample_previous["LATITUDE"])^2 + (sample_current["LONGITUDE"]
                                                                           -sample_previous["LONGITUDE"])^2 )
 
 dist1= (dist1/10000 )
 colnames(dist1) <- ("distance")
 tmp2 <- as.character(sample_current[,c("FIX_SAMPLE_TS")])
 tmp1 <- as.character(sample_previous[,c("FIX_SAMPLE_TS")])
 time2 <- strptime(tmp2,format="%d-%b-%Y %I.%M.%OS %p")
 time1 <- strptime(tmp1,format="%d-%b-%Y %I.%M.%OS %p")
 
 timeWindow1 <-  as.numeric(time2 -time1)
 speed <- (dist1*10000)/timeWindow1
 colnames(speed) <- c("speed")
 print(paste("speed : ",speed,sep=""))
 
 #sample_point current time + time to reach boundary circumference
 startingTime <- as.POSIXct(sample_current[,c("FIX_SAMPLE_TS")],format="%d-%b-%Y %I.%M.%OS %p",tz="UTC")
 startingTime <-  as.POSIXlt(startingTime,tz="UTC")
 #format(startingTime, "%Y-%m-%d %H:%M:%OS6") + 2
 min_distance = min_distance/10000;
 #possibleBreachTime <-  startingTime + ((min_distance*10000)/speed )
 
 print(paste("seconds added : ",as.numeric((min_distance*10000)/speed ),sep=""))
 print(paste("Starting time seconds : ",startingTime$sec,sep=""))
 possibleBreachTime <- startingTime
 possibleBreachTime$sec <- startingTime$sec +   as.numeric((min_distance*10000)/speed )
 print(paste("Starting time : ",startingTime,sep=""))
 print(paste("breach time : ",possibleBreachTime,sep=""))
 
 
  r <- NA
  if(sample_current[2]>sample_previous[2]){
    r <- 1 # This comes from the   
  } else if(sample_current[2]<sample_previous[2]){
    r <- -1
  }
  
  
  
  x <- sample_current[1] + r*cos(theta_rad)
  y <- sample_current[2] + r*sin(theta_rad)
  p <- c(x,y)
  
  
  pt1 <- c(sample_previous[1],sample_current[1],p[1])
  pt2 <- c(sample_previous[2],sample_current[2],p[2])
  plot(pt1,pt2,xlim=c(-6,10),ylim=c(-10,8))
  
  lines(pt1,pt2)
  
  print(paste("for ",i,"th iteration center is ",as.character(min_center[1]),",",
              as.character(min_center[2]),sep=""))
  
  
  
  
}

r=3
nseg=360 
x.cent <- 0
y.cent <- 0 

xx <- x.cent + r*cos( seq(0,2*pi, length.out=nseg) ) 
yy <- y.cent + r*sin( seq(0,2*pi, length.out=nseg) ) 

lines(xx,yy, col='red')


r=1
nseg=360 
x.cent <- -5
y.cent <- 0 

xx <- x.cent + r*cos( seq(0,2*pi, length.out=nseg) ) 
yy <- y.cent + r*sin( seq(0,2*pi, length.out=nseg) ) 

lines(xx,yy, col='red')






# initialize a plot
plot(c(-1, 1), c(-1, 1), type = "n")

# prepare "circle data"
radius <- 1
theta <- seq(0, 2 * pi, length = 200)

# draw the circle
lines(x = radius * cos(theta), y = radius * sin(theta))

x <- rnorm(100, 1, 5) 
y <- rnorm(100, 3, 4)   

plot( x,y, asp=1) 

 


sampleTestDataSet
min_center

min_ditance
