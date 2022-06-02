# linear regression
data = read.table('weatherstats_vancouver_daily.csv', sep = ',', header = T)
temps = data$avg_hourly_temperature
days = 1:14
plot(days, temps)

df = data.frame(
  days = 1:14,
  temps = data$avg_hourly_temperature)

model = lm(temps ~ days, df)
model
model$coefficients

day = 15
prediction = day * model$coefficients[2] + model$coefficients[1]

predict(model, newdata = data.frame(days = c(15, 16, 17)))

plot(days, temps)
abline(model$coefficients[1], model$coefficients[2])


library(jsonlite)
baseURL = "http://www.sfu.ca/bin/wcm/course-outlines?"
for(year in fromJSON(baseURL)$value){
  URLthisYear = paste(baseURL,year,sep="")
  TermsthisYear = fromJSON(URLthisYear)
  for(term in TermsthisYear$value){
    DeptsThisTerm = fromJSON(paste(URLthisYear,term,sep="/"))
    for(Dept in DeptsThisTerm$value){
      CoursesThisTerm = fromJSON(paste(URLthisYear,term,Dept,sep="/"))
      for(Course in CoursesThisTerm $value){
        SectionThisTerm = fromJSON(paste(URLthisYear,term,Dept,Course,sep="/"))
        for(Section in SectionThisTerm $value){
          CourseOutline= (fromJSON(paste(URLthisYear,term,Dept,Course,Section,sep="/")))
        }
      }
    }
  }
}



