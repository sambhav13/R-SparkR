Sys.setenv(SPARK_HOME="F:\\software\\spark-1.4.1-bin-hadoop2.6\\spark-1.4.1-bin-hadoop2.6")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"),
            .libPaths()))

library(SparkR)
sc <- sparkR.init(master="local")
sqlContext <- sparkRSQL.init(sc)


#create a sparkR DataFrame
DF <- createDataFrame(sqlContext, faithful)
head(DF)

# Create a simple local data.frame
localDF <- data.frame(name=c("John", "Smith", "Sarah"), age=c(19, 23, 18))

# Convert local data frame to a SparkR DataFrame
df <- createDataFrame(sqlContext, localDF)


# Print its schema
printSchema(df)
# root
#  |-- name: string (nullable = true)
#  |-- age: double (nullable = true)

# Create a DataFrame from a JSON file
path <- file.path(Sys.getenv("SPARK_HOME"), "examples/src/main/resources/people.json")
peopleDF <- jsonFile(sqlContext, path)
printSchema(peopleDF)


# Register this DataFrame as a table.
registerTempTable(peopleDF, "people")


# SQL statements can be run by using the sql methods provided by sqlContext
teenagers <- sql(sqlContext, "SELECT name FROM people WHERE age >= 13 AND age <= 19")

# Call collect to get a local data.frame
teenagersLocalDF <- collect(teenagers)

# Print the teenagers in our dataset 
print(teenagersLocalDF)

#Count of teenagers
teenagers_count <- sql(sqlContext, "SELECT count(name) FROM people ")

#collect the teenagers count
cnt <-  collect(teenagers_count)

#print teenagers count
print(cnt)

# Stop the SparkContext now
sparkR.stop()
