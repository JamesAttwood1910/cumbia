###########################################################################

songs_by_artist <- function(.artist = 'Damas Gratis', .results_per_page = 10, .pages = 1, .API_Key = API_Key) {

        if (is.na(.API_Key)) {
                print('API Key Required - Go to https://rapidapi.com/Glavier/api/genius-song-lyrics1/ to subscribe')
        }

        API_Host = 'genius-song-lyrics1.p.rapidapi.com'

        url <- "https://genius-song-lyrics1.p.rapidapi.com/search"

        queryString <- list(
                q = .artist,
                per_page = .results_per_page,
                page = .pages
        )

        json <- url %>%
                httr::GET(add_headers('X-RapidAPI-Key' = .API_Key,
                                      'X-RapidAPI-Host' = API_Host),
                          query = queryString,
                          content_type("application/octet-stream")) %>%
                httr::content()

        dataframe <- tibble()

        for (x in 1:.results_per_page) {

                holding_tibble <- tibble(

                        song_id = json$response$hits[[x]]$result$id, #
                        artist_id = json$response$hits[[x]]$result$primary_artist$id,
                        artist = json$response$hits[[x]]$result$artist_names, #
                        song = json$response$hits[[x]]$result$title, #
                        year = json$response$hits[[x]]$result$release_date_components$year,
                        pageviews = json$response$hits[[x]]$result$stats$pageviews


                )

                holding_tibble <- holding_tibble %>% replace(is.na(.), 0)

                dataframe <- dataframe %>% bind_rows(holding_tibble)


        }

        return(dataframe)


}

#################################################################

song_lyrics <- function(.song_id, .API_Key = API_Key) {

        if (is.na(.API_Key)) {
                print('API Key Required - Go to https://rapidapi.com/Glavier/api/genius-song-lyrics1/ to subscribe')
        }

        API_Host = 'genius-song-lyrics1.p.rapidapi.com'

        url <- glue("https://genius-song-lyrics1.p.rapidapi.com/songs/",.song_id,"/lyrics")

        json <- url %>%
                httr::GET(add_headers('X-RapidAPI-Key' = .API_Key,
                                      'X-RapidAPI-Host' = API_Host),
                          content_type("application/octet-stream")) %>%
                httr::content()

        dataframe <- tibble(
                            lyrics = json$response$lyrics$lyrics$body$plain)

        return(dataframe)

}





