library('rvest')

Rank<-NULL
Title<-NULL
Description<-NULL
Runtime<-NULL
Genre<-NULL
Rating<-NULL
Votes<-NULL
Directors<-NULL
Actors<-NULL
Metascore<-NULL
Gross<-NULL
Released_Year<-NULL
Certificate<-NULL

for (i in seq(1,3000,50)){
  for (y in seq(2000,2020,1)){
    base_url<-paste('http://www.imdb.com/search/title/?&release_date=',toString(y),'&start=',sep = "")
    url<-paste(base_url,toString(i),sep="")
    webpage<-read_html(url)
    
    #### Released Year
    Released_Year<-append(Released_Year,rep(y,50))
    
    #### Rank
    rank_data_html <- html_node(html_nodes(webpage, '.lister-item-content'),'.text-primary')
    rank_data<-html_text(rank_data_html) #Convert ke text
    #Data Cleaning
    rank_data<-gsub(',','',rank_data)
    rank_data<-as.numeric(rank_data)
    Rank<-append(Rank,rank_data)
    
    #### Title
    title_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.lister-item-header a')
    title_data<-html_text(title_data_html)
    Title<-append(Title,title_data)
    
    ### Description
    #description_data_html<-html_nodes(webpage, '.ratings-bar+ .text-muted)
    description_data_html<-html_node(html_nodes(webpage, '.lister-item-content'),'.ratings-bar+ .text-muted')
    description_data<-html_text(description_data_html)
    #Data Cleaning
    description_data<-gsub("\n    ","",description_data)
    Description<-append(Description, description_data)
    
    ### Runtime
    #runtime_data_html<-html_nodes(webpage,'.text-muted .runtime')
    runtime_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.text-muted .runtime')
    runtime_data<-html_text(runtime_data_html)
    #Data Cleaning (Remove 'min')
    runtime_data<-gsub(" min","",runtime_data)
    runtime_data<-as.numeric(runtime_data)
    Runtime<-append(Runtime,runtime_data)
    
    ### Genre
    #genre_data_html<-html_nodes(webpage,'.genre')
    genre_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.text-muted .genre')
    genre_data<-html_text(genre_data_html)
    #Data Cleaning
    genre_data<-gsub("\n","",genre_data) #removing \n
    genre_data<-gsub(" ","",genre_data) #removing White Space
    #genre_data<-as.factor(genre_data) #Convert as Factor
    Genre<-append(Genre,genre_data)
    
    ### Rating
    #rating_data_html<-html_nodes(webpage,'.ratings-imdb-rating strong')
    rating_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.ratings-imdb-rating strong')
    rating_data<-html_text(rating_data_html)
    rating_data<-as.numeric(rating_data)
    Rating<-append(Rating,rating_data)
    
    ### Votes
    #votes_data_html<-html_nodes(webpage,'.sort-num_votes-visible span:nth-child(2)')
    votes_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.sort-num_votes-visible span:nth-child(2)')
    votes_data<-html_text(votes_data_html)
    # Data Cleaning
    votes_data<-gsub(",","",votes_data) #removing ','
    votes_data<-as.numeric(votes_data) #convert  to numeric
    Votes<-append(Votes,votes_data)
    
    ### Directors
    directors_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.text-muted+ p a:nth-child(1)')
    directors_data<-html_text(directors_data_html)
    # Data Cleaning
    #directors_data<-as.factor(directors_data)
    Directors<-append(Directors,directors_data)
    
    ### Actors
    #actors_data_html<-html_nodes(webpage,'.lister-item-content .ghost+ a')
    actors_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.ghost+ a')
    actors_data<-html_text(actors_data_html)
    Actors<-append(Actors,actors_data)
    
    ### Metascore
    metascore_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.ratings-metascore span')
    metascore_data<-html_text(metascore_data_html)
    # Data Cleaning
    metascore_data<-gsub(" ","",metascore_data)
    metascore_data<-as.numeric(metascore_data)
    Metascore<-append(Metascore,metascore_data)
    
    
    ### Certificate
    certificate_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.text-muted .certificate')
    certificate_data<-html_text(certificate_data_html)
    Certificate<-append(Certificate,certificate_data)
    
    ### Gross in Million
    #gross_data_html<-html_nodes(webpage,'.ghost~ .text-muted+ span')
    gross_data_html<-html_node(html_nodes(webpage,'.lister-item-content'),'.ghost~ .text-muted+ span')
    gross_data<-html_text(gross_data_html)
    # Data Cleaning
    gross_data<-gsub("M","",gross_data)
    gross_data<-substring(gross_data,2)
    gross_data<-as.numeric(gross_data)
    Gross<-append(Gross,gross_data)
  }
}  


##Combining All the list
df_movie<-data.frame(
                     Released_Year=Released_Year,
                     Certificate=Certificate,
                     Rank=Rank,
                     Title=Title,
                     Description=Description,
                     Runtime=Runtime,
                     Genre=Genre,
                     Rating=Rating,
                     Metascore=Metascore,
                     Gross_Earning=Gross,
                     Director=Directors,
                     Actor=Actors
                     )
nrow(df_movie)

genre_1<-NULL
genre_2<-NULL
genre_3<-NULL
for (i in df_movie$Genre){
  genre_1<-append(genre_1,strsplit(i,",")[[1]][1])
  genre_2<-append(genre_2,strsplit(i,",")[[1]][2])
  genre_3<-append(genre_3,strsplit(i,",")[[1]][3])
}
df_movie$genre_1<-genre_1
df_movie$genre_2<-genre_2
df_movie$genre_3<-genre_3
head(df_movie)

write.csv(df_movie,'df_movie.csv',row.names = FALSE)
