(: XPATH
	doc("videos.xml")/*/result
	doc("BookstoreQ.xml")/Bookstore/(Book|Magazine)/title
	doc("BookstoreQ.xml")/
	return $x/title/text()
	return $x/result/videos/video/genre
:)	

(: LAB3 - XQUERY - HTML-FORMATED OUTPUT :)

<results>
(:------------- UPPG.1 ---------------:)
(: 	- get all movies where $movie/genre
:)
		
	{
		for $x in doc("videos.xml")/result/videos/video
		let $n1 := "&#10;"
		where $x/genre = "special"
		return (concat($n1, '  '), $x/title)
	}
	

(:------------- UPPG.2 ---------------:)
(: 	- for loop - loop over distinct directors
	- count for each distinct director how many ie count
:)

	{
		let $n1 := "&#10;"
		let $path := doc("videos.xml")/result

		let $dir :=
			for $director in distinct-values($path/videos/video/director)
				let $count := count($path/videos/video/director[. eq $director])
				where $count > 2
				return ($director)

			let $titles :=
				for $video in $path/videos/video
					let $theTitle := $video/title
					where $video/director = $dir
					return ($n1, $theTitle)
			
		return ($n1,<movie director="{$dir}"> {$titles} </movie>)

	}

(:------------- UPPG.3 ---------------:)
(:Top ten recommended movies:)

	{
		(
		let $n1 := "&#10;"
		let $path := doc("videos.xml")/result/videos

		for $video in $path/video
			let $u_rating := $video/user_rating
			let $video_title := $video/title
			order by $u_rating descending

		return(concat($n1, ' '), data($video_title))
		)[position() = 1 to 10]
	}


(:------------- UPPG.4 ---------------:)
(:Actors that have starred in the most movies
	Look at actorRef in movies - matching with actor id="" attribute:)
	
	{
		(
		let $n1 := "&#10;"
		let $path := doc("videos.xml")/result/videos
		let $actorpath :=doc("videos.xml")/result/actors
		for $ref in distinct-values($path/video/actorRef)
			let $countRef := count($path/video/actorRef[. eq $ref])
			let $actor := $actorpath/actor[@id eq $ref]  
			order by $countRef descending

		return(concat($n1, ' ', 'actor="',$actor,'"'))
		)[position() = 1 to 2]
	}
	


(:------------- UPPG.5 ---------------:)
(:Highest rating movie starring both Brad Pritt and Morgan Freeman
 	- Create list actorids with id for brad pitt and morgan freeman
 	- loop through all videos where both actorRef is in movie i.e. count is 2  
 :)
	
	{
			let $actor_names := doc("videos.xml")/result/actors/actor
			let $videos := doc("videos.xml")/result/videos/video

			let $actorids :=
			for $actor in $actor_names
			where $actor = "Pitt, Brad" or $actor = "Freeman, Morgan"
			return data($actor/@id)

			for $video in $videos
			where 2 = count(for $aName in $video/actorRef where $aName=$actorids return 1) 
			return <title>{data($video/title)}</title>
	}		
	

(:------------- UPPG.6 ---------------:)
(:Which actors have starred in a PG-13 movie between 1997 and 2006 (including 1997 and 2006)?
	- Get all movies rated as 'PG-13' AND in range 1997-2006
	- Select actor_id:s of these => moviesR
	- Select actor names from these id's
	- Loop over output - to present as a list
:)
	
	{
		let $n1 := "&#10;"
		let $movies := doc("videos.xml")/result/videos/video
		let $actor_names := doc("videos.xml")/result/actors/actor

		let $moviesR :=
			for $movie in $movies
			where $movie/rating = 'PG-13' and $movie/year>=1997 and $movie/year <=2006
			return $movie/actorRef

		let $actorName :=
			for $actor in $actor_names
			where data($actor/@id) = $moviesR
			return $actor

		for $actor in $actorName
			return (concat($n1, ' ', data($actor)))
	}
	

(:------------- UPPG.7 ---------------:)
(:Who have starred in the most distinct types of genre?
	- Look at distinct list of actor_id:s 
	- Loop through all movies, looking at actorRef and genre, and count distinct genres
		- for ALL movies
	- Then sum these per actor

:)

	
	{
		(
		let $n1 := "&#10;"
		let $movies := doc("videos.xml")/result/videos/video
		let $actors := doc("videos.xml")/result/actors/actor

		let $actorMostDistinct :=
			for $actor in $actors
				let $distinctCount :=
					count(distinct-values(
						for $movie in $movies
						where data($actor/@id) = $movie/actorRef
						order by $actor/@id   
							return ($movie/genre)))
				
				let $totGenreCount := sum($distinctCount)
				order by $totGenreCount descending
				return ($actor)

			for $actor in $actorMostDistinct
				return (concat('actor="',data($actor),'"'))
		)[position() = 1]
	}



(:------------- UPPG.8 ---------------:)
(:Which director have the highest sum of user ratings?
	- Retrieve distinct list w. all directors
	- Go through all movies
	- Add user_rating onto the correct director - inner loop
	- outer loop summing all user_ratings for director and sorting
	- Limit 1 to get max of summed user_ratings - get name
:)

	{
		(
		let $n1 := "&#10;"
		let $movies := doc("videos.xml")/result/videos/video
		let $actors := doc("videos.xml")/result/actors/actor

		let $directList :=
			for $director in distinct-values($movies/director)

				let $distinctCount :=
						for $movie in $movies
						where $director = $movie/director
						return ($movie/user_rating)

				let $totCountDir := sum($distinctCount)
				order by $totCountDir descending
				return ($director)

		for $dir in $directList
			return $dir
			
		)[position() = 1]

	}


(:------------- UPPG.9 ---------------:)
(:Which movie should you recommend to a customer if they want to see a horror movie and
	do not have a laserdisk?
		- go through all movies
		- correct genre
		- AND having stock of either of the other disk-types
:)


	{
		(
		let $n1 := "&#10;"
		let $movies := doc("videos.xml")/result/videos/video


		for $movie in $movies
			where data($movie/genre) = "horror" 
			and (data($movie/vhs_stock) > 0 
			or data($movie/dvd_stock) > 0
			or data($movie/beta_stock) > 0)
			order by $movie/user_rating descending
			return (<title>{data(($movie/title))}</title>)

		)[position() = 1]

	}



(:------------- UPPG.10 ---------------:)
(:Group the movies by genre and sort them by user rating within each genre
:)
	{
		let $n1 := "&#10;"
		let $genres := doc("videos.xml")/result/video_template/genre/choice
		let $movies := doc("videos.xml")/result/videos/video

		for $genre in distinct-values($movies/genre)
			let $genreOutput :=
			for $movie in $movies
			where $movie/genre = $genre
			order by $movie/user_rating descending
				return (concat($n1,' '), '    ', $movie/title)
			
			return (concat($n1, ' '), <genre genre='{$genre}'>{$genre}</genre>, $genreOutput)
	}


</results>

