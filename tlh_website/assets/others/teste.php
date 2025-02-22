<html>
    <head>

    </head>
    <body>
    <?php 
$url = "http://localhost/tlh_website/html/store.php?filters=%price=1000%types=+items+pets+skins+decoration";
$components = parse_url($url);
parse_str($components['query'], $results);
echo($results['filters']); 
?> 
    </body>
</html>