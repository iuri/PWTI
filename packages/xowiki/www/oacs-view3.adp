<!-- Generated by ::xowiki::ADP_Generator on Mon Sep 19 20:32:06 BRT 2011 -->
<master>
  <property name="title">@title;noquote@</property>
  <property name="context">@context;noquote@</property>
  <property name="&body">property_body</property>
  <property name="&doc">property_doc</property>
  <property name="header_stuff">
  <link rel="stylesheet" type="text/css" href="/resources/xowiki/xowiki.css" media="all" >
  
      <style type='text/css'>
         table.mini-calendar {width: 227px ! important;font-size: 80%;}
         div.tags h3 {font-size: 80%;}
         div.tags blockquote {font-size: 80%; margin-left: 20px; margin-right: 20px;}
      </style>
      <link rel='stylesheet' href='/resources/xowiki/cattree.css' media='all' />
      <link rel='stylesheet' href='/resources/calendar/calendar.css' media='all' />
      <script language='javascript' src='/resources/acs-templating/mktree.js' type='text/javascript'></script>
    @header_stuff;noquote@
  <script type="text/javascript">
function get_popular_tags(popular_tags_link, prefix) {
  var http = getHttpObject();
  http.open('GET', popular_tags_link, true);
  http.onreadystatechange = function() {
    if (http.readyState == 4) {
      if (http.status != 200) {
	alert('Something wrong in HTTP request, status code = ' + http.status);
      } else {
       var e = document.getElementById(prefix + '-popular_tags');
       e.innerHTML = http.responseText;
       e.style.display = 'block';
      }
    }
  };
  http.send(null);
}
</script>
  </property>
  <property name="head">
  <link rel="stylesheet" type="text/css" href="/resources/xowiki/xowiki.css" media="all" >
  
      <style type='text/css'>
         table.mini-calendar {width: 227px ! important;font-size: 80%;}
         div.tags h3 {font-size: 80%;}
         div.tags blockquote {font-size: 80%; margin-left: 20px; margin-right: 20px;}
      </style>
      <link rel='stylesheet' href='/resources/xowiki/cattree.css' media='all' />
      <link rel='stylesheet' href='/resources/calendar/calendar.css' media='all' />
      <script language='javascript' src='/resources/acs-templating/mktree.js' type='text/javascript'></script>
    @header_stuff;noquote@
  <script type="text/javascript">
function get_popular_tags(popular_tags_link, prefix) {
  var http = getHttpObject();
  http.open('GET', popular_tags_link, true);
  http.onreadystatechange = function() {
    if (http.readyState == 4) {
      if (http.status != 200) {
	alert('Something wrong in HTTP request, status code = ' + http.status);
      } else {
       var e = document.getElementById(prefix + '-popular_tags');
       e.innerHTML = http.responseText;
       e.style.display = 'block';
      }
    }
  };
  http.send(null);
}
</script>
  </property>
<!-- The following DIV is needed for overlib to function! -->
  <div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>	
<div class='xowiki-content'>
<div id='wikicmds'>
  <if @view_link@ not nil><a href="@view_link@" accesskey='v' title='#xowiki.view_title#'>#xowiki.view#</a> &middot; </if>
  <if @edit_link@ not nil><a href="@edit_link@" accesskey='e' title='#xowiki.edit_title#'>#xowiki.edit#</a> &middot; </if>
  <if @rev_link@ not nil><a href="@rev_link@" accesskey='r' title='#xowiki.revisions_title#'>#xotcl-core.revisions#</a> &middot; </if>
  <if @new_link@ not nil><a href="@new_link@" accesskey='n' title='#xowiki.new_title#'>#xowiki.new_page#</a> &middot; </if>
  <if @delete_link@ not nil><a href="@delete_link@" accesskey='d' title='#xowiki.delete_title#'>#xowiki.delete#</a> &middot; </if>
  <if @admin_link@ not nil><a href="@admin_link@" accesskey='a' title='#xowiki.admin_title#'>#xowiki.admin#</a> &middot; </if>
  <if @notification_subscribe_link@ not nil><a href='/notifications/manage' title='#xowiki.notifications_title#'>#xowiki.notifications#</a> 
      <a href="@notification_subscribe_link@">@notification_image;noquote@</a> &middot; </if>  
   <a href='#' onclick='document.getElementById("do_search").style.display="inline";document.getElementById("do_search_q").focus(); return false;'  title='#xowiki.search_title#'>#xowiki.search#</a> &middot;
  <if @index_link@ not nil><a href="@index_link@" accesskey='i' title='#xowiki.index_title#'>#xowiki.index#</a></if>
<div id='do_search' style='display: none'> 
  <FORM action='/search/search'><div><label for='do_search_q'>#xowiki.search#</label><<INPUT id='do_search_q' name='q' type='text'><INPUT type="hidden" name="search_package_id" value="@package_id@" ></div></FORM> 
</div>
</div>
<div style="float:left; width: 245px; font-size: 85%;">


<div style="background: url(/resources/xowiki/bw-shadow.png) no-repeat bottom right;
     margin-left: 2px; margin-top: 2px; padding: 0px 6px 6px 0px;			    
">
<div style="margin-top: -2px; margin-left: -2px; border: 1px solid #a9a9a9; padding: 5px 5px; background: #f8f8f8">
<include src="/packages/xowiki/www/portlets/weblog-mini-calendar" 
	 &__including_page=page 
         summary="0" noparens="0">
<include src="/packages/xowiki/www/portlets/include" 
	 &__including_page=page 
	 portlet="tags -decoration plain">
<include src="/packages/xowiki/www/portlets/include" 
	 &__including_page=page 
	 portlet="tags -popular 1 -limit 30 -decoration plain">
<hr>
<include src="/packages/xowiki/www/portlets/include" 
	 &__including_page=page 
	 portlet="presence -interval {30 minutes} -decoration plain">
<hr>
<a href="contributors" text="Show People contributing to this XoWiki Instance">Contributors</a>
</div>
</div> <!-- background -->

<div style="background: url(/resources/xowiki/bw-shadow.png) no-repeat bottom right;
     margin-left: 2px; margin-top: 2px; padding: 0px 6px 6px 0px;			    
">
<div style="margin-top: -2px; margin-left: -2px; border: 1px solid #a9a9a9; padding: 5px 5px; background: #f8f8f8">

<include src="/packages/xowiki/www/portlets/include" 
	 &__including_page=page 
	 portlet="categories -open_page @name@  -decoration plain">
</div></div>  <!-- background -->
</div>
<div style="float:right; width: 70%;">
@top_includelets;noquote@
<h1>@title@</h1>
@content;noquote@
</div> <!-- right 70% -->

@footer;noquote@
</div> <!-- class='xowiki-content' -->
