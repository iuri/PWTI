<?php
	//We are going to need a database connection:
//	$db = mysql_connect('localhost', 'twitter_alerts', 'somepasword');

	$bdcon = pg_connect("dbname=mores-11-06-22 user=service0");
	//conecta a um banco de dados chamado "cliente"
	$con_string = "host=localhost dbname=mores-11-06-22 user=service0";
	if(!$dbcon = pg_connect($con_string)) die ("Erro ao conectar ao banco<br>".pg_last_error($dbcon));
	//coneta a um banco de dados chamado "cliente" na máquina "localhost" com um usuário e senha




	//Now, two possibilities: if we don't have a start parameter, we print the last ten tweets.
	//Otherwise, we print all the tweets with IDs bigger than start, if any
	$start = mysql_real_escape_string($_GET['start']);
	if(! $start){
		$query = "SELECT * FROM (SELECT * FROM tweets ORDER BY id DESC LIMIT 0,10) AS last_ten ORDER BY id ASC";
	}else{
		$query = "SELECT * FROM (SELECT * FROM tweets WHERE id>".$start." ORDER BY id DESC LIMIT 0,10) AS new_tweets ORDER BY id ASC";
	}
	$result = pg_query($dbcon, $query);
	if (!$result) {
	  echo "Erro na consulta.<br>";
	  exit;
	}


	$data = array(); //Initializing the results array

	while ($row = pg_fetch_row($result)) {
		array_push($data, $row);
	}
    
	$json = json_encode($data);
	print $json;
?>
