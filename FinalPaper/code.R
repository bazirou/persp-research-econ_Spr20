# load packages and data
library(frequencyConnectedness)
library(BigVAR)
library(devtools)
library(tidyverse)
library(vars)
library(foreach)
library(Hmisc)
library(reshape2)

H = read_csv('high.csv')
L = read_csv('low.csv')
C = read_csv('close.csv')
O = read_csv('open.csv')

industry_name = names(H)
L = select(L, industry_name)
C = select(C, industry_name)
O = select(O, industry_name)

L = L %>% mutate(
  Brokers = if_else(is.na(Brokers), median(Brokers, na.rm = TRUE), Brokers),
  `Commercial Property Management` = if_else(is.na(`Commercial Property Management`), median(`Commercial Property Management`, na.rm = TRUE), `Commercial Property Management`)
)
C = C %>% mutate(
  Brokers = if_else(is.na(Brokers), median(Brokers, na.rm = TRUE), Brokers),
  `Commercial Property Management` = if_else(is.na(`Commercial Property Management`), median(`Commercial Property Management`, na.rm = TRUE), `Commercial Property Management`)
)
H = H %>% mutate(
  Brokers = if_else(is.na(Brokers), median(Brokers, na.rm = TRUE), Brokers),
  `Commercial Property Management` = if_else(is.na(`Commercial Property Management`), median(`Commercial Property Management`, na.rm = TRUE), `Commercial Property Management`)
)
O = O %>% mutate(
  Brokers = if_else(is.na(Brokers), median(Brokers, na.rm = TRUE), Brokers),
  `Commercial Property Management` = if_else(is.na(`Commercial Property Management`), median(`Commercial Property Management`, na.rm = TRUE), `Commercial Property Management`)
)

# calculate volatility
data = 0.511*(H[,-1]-L[,-1])^2-0.019*((C[,-1]-O[,-1])*(H[,-1]+L[,-1]-2*O[,-1])-2*(H[,-1]-O[,-1])*(L[,-1]-O[,-1]))-0.383*(C[,-1]-O[,-1])^2 
data = log(data+0.1)

# construct the model
## define a function
optind = 1
big_var_est = function(data){
  Model = constructModel(as.matrix(data), p = 3, struct = "Basic", gran = c(50, 50))
  result = cv.BigVAR(Model)
}
result = big_var_est(data)
## Perform the estimation
pairwise_data = spilloverDY12(result, n.ahead = 200, no.corr = F)
pairwise_table = as.data.frame(pairwise_data$tables)
pairwise_table$industry = rownames(pairwise_table)
names(pairwise_table) = c(rownames(pairwise_table),'industry')
main = melt(pairwise_table, id = 'industry')
point = main %>% filter(industry == variable)

## export the result
write.csv(main, file = "main.csv")
write.csv(point, file = "point.csv")

# rolling window estimation
sp = spilloverRollingDY12(data, n.ahead=500, no.corr=F, func_est="big_var_est", params_est=list(), window=60)
p = plotOverall(sp)

# compare

data_before = data[1737:1857,]
result_before = big_var_est(data_before)
before = spilloverDY12(result_before, n.ahead = 100, no.corr = F)
before = as.data.frame(before$tables)
before$industry = rownames(before)
names(before) = c(rownames(before),'industry')
before_edge = melt(before, id = 'industry')
before_point = before_edge %>% filter(industry == variable)
write.csv(before_edge, file = "before_edge.csv")
write.csv(before_point, file = 'before_point.csv')


data_after = data[1857:1977,]
result_after = big_var_est(data_after)
after = spilloverDY12(result_after, n.ahead = 100, no.corr = F)
after = as.data.frame(after$tables)
after$industry = rownames(after)
names(after) = c(rownames(after),'industry')
after_edge = melt(after, id = 'industry')
after_point = after_edge %>% filter(industry == variable)
write.csv(after_edge, file = "after_edge.csv")
write.csv(after_point, file = 'after_point.csv')




