<?php
//localhost

  $dbhost = "localhost";
  $dbuser = "root";
  $dbpass = "";
  $dbname = "tlh_database";


//host

  //$dbhost = "sql300.epizy.com";
  //$dbuser = "epiz_30578554";
  //$dbpass = "bvVd36RzY5iypTO";
  //$dbname = "epiz_30578554_tlh_database";

if(!$con = mysqli_connect($dbhost,$dbuser,$dbpass,$dbname))
{
	die("failed to connect into database!");
}

?>