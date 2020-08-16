#Loading the rvest package
library('rvest')

#State URL yang akan kita ambil datanya
url <- 'http://www.imdb.com/search/title?count=1000&release_date=2016,2020&title_type=feature'
#Reading the HTML code from the website
webpage <- read_html(url)

##List Feature yang akan di ambil
#1. Rank
#2. Title
#3. Description
#4. Runtime
#5. Genre
#6. Rating
#7. Votes
#8. Director
#9. Actor
#10. Metascore
#11. Gross_Earning_in_Mil

#### Rank
rank_data_html <- html_nodes(webpage,'.text-primary')
rank_data<-html_text(rank_data_html) #Convert ke text
head(rank_data)
length(rank_data)
#Data Cleaning
rank_data<-as.numeric(rank_data)
head(rank_data)
length(rank_data)
#### Title
title_data_html<-html_nodes(webpage,'.lister-item-header a')
title_data<-html_text(title_data_html)
head(title_data)
length(title_data)


### Description
#description_data_html<-html_nodes(webpage, '.ratings-bar+ .text-muted)
description_data_html<-html_node(html_nodes(webpage, '.lister-item-content'),'.ratings-bar+ .text-muted')
description_data<-html_text(description_data_html)
head(description_data)
length(description_data)
#Data Cleaning
description_data<-gsub("\n    ","",description_data)
head(description_data)
length(description_data)

### Runtime
#runtime_data_html<-html_nodes(webpage,'.text-muted .runtime')
runtime_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.text-muted .runtime')
runtime_data<-html_text(runtime_data_html)
head(runtime_data)
#Data Cleaning (Remove 'min')
runtime_data<-gsub(" min","",runtime_data)
runtime_data<-as.numeric(runtime_data)
head(runtime_data)
length(runtime_data)

### Certificate
certificate_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.text-muted .certificate')
certificate_data<-html_text(certificate_data_html)
head(certificate_data)
length(certificate_data)



### Genre
#genre_data_html<-html_nodes(webpage,'.genre')
genre_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.text-muted .genre')
genre_data<-html_text(genre_data_html)
head(genre_data)
#Data Cleaning
genre_data<-gsub("\n","",genre_data) #removing \n
genre_data<-gsub(" ","",genre_data) #removing White Space
#genre_data<-gsub(",.*","",genre_data) #Taking first genre
genre_data<-as.factor(genre_data) #Convert as Factor
head(genre_data)
length(genre_data)

### Rating
#rating_data_html<-html_nodes(webpage,'.ratings-imdb-rating strong')
rating_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.ratings-imdb-rating strong')
rating_data<-html_text(rating_data_html)
rating_data<-as.numeric(rating_data)
length(rating_data)


### Votes
#votes_data_html<-html_nodes(webpage,'.sort-num_votes-visible span:nth-child(2)')
votes_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.sort-num_votes-visible span:nth-child(2)')
votes_data<-html_text(votes_data_html)
# Data Cleaning
votes_data<-gsub(",","",votes_data) #removing ','
votes_data<-as.numeric(votes_data) #convert  to numeric
length(votes_data)


### Directors
directors_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.text-muted+ p a:nth-child(1)')
directors_data<-html_text(directors_data_html)
# Data Cleaning
directors_data<-as.factor(directors_data)
length(directors_data)


### Actors
#actors_data_html<-html_nodes(webpage,'.lister-item-content .ghost+ a')
actors_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.ghost+ a')
actors_data<-html_text(actors_data_html)
length(actors_data)


### Metascore
metascore_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.ratings-metascore span')
metascore_data<-html_text(metascore_data_html)
head(metascore_data)
# Data Cleaning
metascore_data<-gsub(" ","",metascore_data)
length(metascore_data)
metascore_data<-as.numeric(metascore_data)
length(metascore_data)


### Gross in Million
#gross_data_html<-html_nodes(webpage,'.ghost~ .text-muted+ span')
gross_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.ghost~ .text-muted+ span')
gross_data<-html_text(gross_data_html)
head(gross_data)
# Data Cleaning
gross_data<-gsub("M","",gross_data)
gross_data<-substring(gross_data,2)
gross_data<-as.numeric(gross_data)
summary(gross_data)
length(gross_data)

##Combining All the list
df_movie<-data.frame(Rank=rank_data,
                     Title=title_data,
                     Description=description_data,
                     Runtime=runtime_data,
                     Genre=genre_data,
                     Rating=rating_data,
                     Gross_Earning=gross_data,
                     Director=directors_data,
                     Actor=actors_data)
head(df_movie)                      
