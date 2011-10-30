<?php
	include_once('config.php');
	
	//We're going to store the data in the database, so, let's open a connection:
//	$db = mysql_connect('localhost', 'twitter_alerts', 'somepasword');
//	mysql_select_db('twitter_alerts', $db);

	$dbcon = pg_connect("dbname=mores user=service0");
	//conecta a um banco de dados chamado "cliente"
	$con_string = "host=localhost dbname=mores user=service0";
	if(!$dbcon = pg_connect($con_string)) die ("Erro ao conectar ao banco<br>".pg_last_error($dbcon));
	//coneta a um banco de dados chamado "cliente" na máquina "localhost" com um usuário e senha

	$query = "SELECT query_text FROM mores_acc_query";
	$result_word = pg_query($dbcon, $query);
	if (!$result_word) {
	  echo "Erro na consulta.<br>";
	  exit;
	}
	$text = "pwti";
	while ($row = pg_fetch_array($result_word)) {
		$text = $text.','.$row['query_text'];
	}
	define ('TRACKING', "$text");

	//echo TRACKING;
	$opts = array(
		'http'=>array(
			'method'	=>	"POST",
			'content'	=>	'track='.TRACKING,
		)
	);
	
	$context = stream_context_create($opts);
	//echo 'ok';
	while (1){
		$instream = fopen('http://'.TWITTER_USERNAME.':'.TWITTER_PASSWORD.'@stream.twitter.com/1/statuses/filter.json','r' ,false, $context);

		while(! feof($instream)) {

			if(! ($line = stream_get_line($instream, 20000, "\n"))) {

				continue;
			}else{

				$tweet = json_decode($line);
				//Clean the inputs before storing
				//We store the new post in the database, to be able to read it later
              $post_id = $tweet->{'id_str'};
              if($post_id) {
				  $user_id = pg_escape_string($tweet->{'user'}->{'id_str'});
				  $user_nick  = pg_escape_string($tweet->{'user'}->{'screen_name'});
				  $user_name  = pg_escape_string($tweet->{'user'}->{'name'});
				  $text = pg_escape_string($tweet->{'text'});
				  $lang = pg_escape_string($tweet->{'user'}->{'lang'});
				  $profile_img = pg_escape_string($tweet->{'user'}->{'profile_image_url'});
				  $post_url = "http://twitter.com/".$user_nick."/statuses/".$post_id;
				  $type = "microblog";
				  $followers = pg_escape_string($tweet->{'user'}->{'followers_count'});
				  $following = pg_escape_string($tweet->{'user'}->{'friends_count'});
				  $favorites = pg_escape_string($tweet->{'user'}->{'favourites_count'});
				  $statuses = pg_escape_string($tweet->{'user'}->{'statuses_count'});
				  $verified = pg_escape_string($tweet->{'user'}->{'verified'});
				  
				  if(!$verified) {
				  	$verified = 0;
				  }

		//	 echo "<p>INSERT INTO mores_items_tmp (user_id, user_nick, user_name, profile_img, post_id, created_at, text, lang, post_url, type, followers, following, favorites,  statuses, verified) VALUES ($user_id, $user_nick, $user_name, $profile_img, $post_id, NOW(), $text, $lang, $post_url, $type, $followers, $following, $favorites,  $statuses, $verified) </p> <br />";
			 
					$result = pg_query($dbcon, "INSERT INTO mores_items_tmp (user_id, user_nick, user_name, profile_img, post_id, created_at, text, lang, post_url, type, followers, following, favorites,  statuses, verified) VALUES ($user_id, '$user_nick', '$user_name', '$profile_img', $post_id, NOW(), '$text', '$lang', '$post_url', '$type', $followers, $following, $favorites,  $statuses, $verified)");
				
				}
				flush();
			}
		}
	}
?>
