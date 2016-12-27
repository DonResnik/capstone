library(magrittr)
library(stringr)
library(sets)
library(tm)

ngram_backoff <- function(textInput) {
  
  db <- dbConnect(SQLite(), dbname="NGram")
  if (!dbExistsTable(db,"NGrams")) {
    bitriquaddata <- read.csv2("data/bitriquad.csv")
    bitriquadforingest <- bitriquaddata[-1]
    dbSendQuery(conn=db,
                "CREATE TABLE IF NOT EXISTS NGrams
                (word TEXT,
                freq INTEGER,
                n INTEGER,
                pre TEXT,
                cur TEXT,
                PRIMARY KEY (word))")
    dbWriteTable(db, "NGrams",as.data.frame(bitriquadforingest),overwrite=TRUE, append=FALSE)
  }
  
  max = 3  # max n-gram - 1
  # process textInput
  textInput <- tolower(textInput) 
  textInput <- strsplit(textInput, split=" ")
  textInput <- unlist(textInput)
  
  myResult <- list()
  for (i in min(length(textInput), max):1) {
    gram <- paste(tail(textInput, i), collapse=" ")
    sql <- paste("SELECT word, cur, freq FROM NGrams WHERE pre=='", paste(gram), "'",
                 " AND n==", i + 1," ORDER BY freq DESC LIMIT 5",sep="" )
    print(sql)
    
    res <- dbGetQuery(db, sql)
    if (nrow(res) > 0) {
      myResult[[length(myResult)+1]] <- res
    }
  }
  myResultSet <- set()
  if (length(myResult)==0) {
    myResultSet <- set("No Results")
  }
  else {
    for (i in length(myResult):1) {
      print(myResult[[i]][[2]])
      myResultSet <- append(myResultSet,as.set(myResult[[i]][[2]]))
      print(myResultSet)
    }
  }
  return(toString(myResultSet))
}