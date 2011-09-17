<if @css@>
	<master src="/packages/openacs-default-theme/lib/mores-master">
</if>
<else> 
	<master>
</else>	

<h3> Você está monitorando:  <b>@query_text@</b></h3>

<frameset>

<frameset>
<script type="text/javascript">
// search phrase (replace this)
var smSearchPhrase = '@query_text@';
var smSearchPhrase2 = '@query_text@';
// title (optional)
var smTitle = 'Twitter';
var smTitle2 = 'Blogs e Outras Mídias';
// items per page
var smItemsPerPage = 50;
// show or hide user profile images
var smShowUserImages = true;
// widget font size in pixels
var smFontSize = 11;
// height of the widget
//var smWidgetHeight = 910;   // 1024
var smWidgetHeight = 805;   // 1280
//var smWidgetHeight = 910;   // 1440
// sources (optional, comment out for "all")
var smSources = ['twitter'];
var smSources2 = ['googleblog2'];


//spy.openmonitor(smSearchPhrase);

</script>

<script type="text/javascript" language="javascript" src="/resources/mores/buzz.js"></script> 

<link href="/resources/mores/buzz.css" type="text/css" rel="stylesheet" />   

<style type="text/css">
.iframe_container {
	  width:49%;
	  height:700px;
	  float:left;
	  margin-left:5px;
}
.socialmention-buzz-widget .item .text {

	margin-left:0;
}
body{
 font:normal 75% normal arial,sans-serif;
} 
ol li{
  padding:10px;
}

pre{
  font-size:160%;
}

</style>
