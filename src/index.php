<?php include "config.inc";?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>QuickStart</title>
        <!--
	<link rel="stylesheet" type="text/css" href="style/global.style.css" />
	-->
	<style type="text/css">
	body {
		display: -webkit-box;
		-webkit-box-pack: center;
		background-color:#000;
	}
	a {
		display:block;
		

		border:1px solid #ccc;
		height:50px;
		width:150px;


		margin:10px;
		padding:10px 10px 16px 10px;

		font-family: sans-serif;
		text-decoration:none;
		text-align:center;
		color:#888;

		font-size:10px;
		overflow:hidden;

		-webkit-border-radius: 6px; /* Saf3-4, iOS 1-3.2, Android <e;1.6 */
		-moz-border-radius: 6px; /* FF1-3.6 */
		border-radius: 6px; /* Opera 10.5, IE9, Saf5, Chrome, FF4, iOS 4, Android 2.1+ */

		-webkit-box-shadow: 0px 1px 8px #fff; /* Saf3-4, iOS 4.0.2 - 4.2, Android 2.3+ */
		-moz-box-shadow: 0px 1px 8px #fff; /* FF3.5 - 3.6 */
		box-shadow: 0px 1px 8px #fff; /* Opera 10.5, IE9, FF4+, Chrome 6+, iOS 5 */
	
		background-size:contain, cover;
		background-position:center, center;
		background-repeat:no-repeat, repeat;
		background-origin: content-box, padding-box;

	}

	a:hover {
		-webkit-box-shadow: 0px 1px 16px #fff; /* Saf3-4, iOS 4.0.2 - 4.2, Android 2.3+ */
		-moz-box-shadow: 0px 1px 16px #fff; /* FF3.5 - 3.6 */
		box-shadow: 0px 1px 16px #fff; /* Opera 10.5, IE9, FF4+, Chrome 6+, iOS 5 */
		color:#fff;
	}

	span {
		display:block;
		position:absolute;
		margin-top:52px;
		margin-left:-10px;
		width:170px;

		background-color: rgba(10, 10, 10, 0.5);
		-webkit-border-radius: 0 0 6px 6px; /* Saf3-4, iOS 1-3.2, Android <e;1.6 */
		-moz-border-radius: 0 0 6px 6px; /* FF1-3.6 */
		border-radius: 0 0 6px 6px; /* Opera 10.5, IE9, Saf5, Chrome, FF4, iOS 4, Android 2.1+ */

		text-shadow: rgba(64, 64, 64, 0.5) 2px 2px 8px;
	}
	<?php
	$bg_gradient = "-webkit-linear-gradient(top, #444444, #999999)";
	$bg_gradient_hover = "-webkit-linear-gradient(top, #999, #444)";
 
	foreach($t_links as $k => $v) {
		$id = strtolower($k); 
		echo "#$id {background-image:url(img/$id.png), $bg_gradient}\n";
		echo "#$id:hover {background-image:url(img/$id.png), $bg_gradient_hover}\n";
	}
	?>
	</style>
    </head>
    <body>

	<?php
	foreach($t_links as $label => $url) {
		echo "<a id='".strtolower($label)."' href='$url'><span>$label</span></a>";
	}
	?>	
    </body>
</html>
