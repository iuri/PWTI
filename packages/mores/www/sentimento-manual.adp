<if @css@>
	<master src="/packages/openacs-default-theme/lib/mores-master">
</if>
<else> 
	<master>
	<link rel="stylesheet" type="text/css" href="styles.css" />
</else>	
	<link rel="stylesheet" type="text/css" href="styles.css" />
<style type="text/css">
	span {font-size: 12px !important; margin: 0 0 0 !important;}
	@extra_css;noquote@
</style>

<script type="text/javascript">

/***********************************************
* Dynamic Ajax Content- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

var bustcachevar=1 //bust potential caching of external pages after initial request? (1=yes, 0=no)
var loadedobjects=""
var rootdomain="http://"+window.location.hostname
var bustcacheparameter=""

function ajaxpage(url, containerid){
	var page_request = false
	if (window.XMLHttpRequest) // if Mozilla, Safari etc
		page_request = new XMLHttpRequest()
	else if (window.ActiveXObject){ // if IE	
		try {
			page_request = new ActiveXObject("Msxml2.XMLHTTP")
		} 
		catch (e){
			try{
				page_request = new ActiveXObject("Microsoft.XMLHTTP")
			}
			catch (e){}
		}
	}
	else
		return false
	
	page_request.onreadystatechange=function(){
		loadpage(page_request, containerid)
	}
	if (bustcachevar) //if bust caching of external page
		bustcacheparameter=(url.indexOf("?")!=-1)? "&"+new Date().getTime() : "?"+new Date().getTime()
	page_request.open('GET', url+bustcacheparameter, true)
	page_request.send(null)
}

function loadpage(page_request, containerid){
	if (page_request.readyState == 4 && (page_request.status==200 || window.location.href.indexOf("http")==-1))
	document.getElementById(containerid).innerHTML=page_request.responseText
}

function loadobjs(){
	if (!document.getElementById)
		return
	for (i=0; i<arguments.length; i++){
		var file=arguments[i]
		var fileref=""
		if (loadedobjects.indexOf(file)==-1){ //Check to see if this object has not already been added to page before proceeding
			if (file.indexOf(".js")!=-1){ //If object is a js file
				fileref=document.createElement('script')
				fileref.setAttribute("type","text/javascript");
				fileref.setAttribute("src", file);
			}
			else if (file.indexOf(".css")!=-1){ //If object is a css file
				fileref=document.createElement("link")
				fileref.setAttribute("rel", "stylesheet");
				fileref.setAttribute("type", "text/css");
				fileref.setAttribute("href", file);
			}
		}
		if (fileref!=""){
			document.getElementsByTagName("head").item(0).appendChild(fileref)
			loadedobjects+=file+" " //Remember this object as being already added to page
		}
	}
}

</script>
	<link type="text/css" rel="stylesheet" href="/resources/mores/js/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/resources/mores/js/dhtmlgoodies_calendar.js?random=20060118"></script>
	<div class="ctnAll">
	<div class="ctnU">
		<div class="ctnU1">

			<div class="ctnUcontent wuctn">
							
			
					<listfilters name="mentions" style="select-menu"></listfilters>
					<form action=sentimento-manual name=form-filter>
					<table>
						<tr>
							<td>Início: </td>
							<td>
								<input type="text" value="@min_date@" readonly name="datai">
								<input type="button" value="escolha" onclick="displayCalendar(document.forms[0].datai,'yyyy-mm-dd hh:ii',this,true)">
							</td>
							<td>Fim: </td>
							<td>
								<input type="text" value="@max_date@" readonly name="dataf">
								<input type="button" value="escolha" onclick="displayCalendar(document.forms[0].dataf,'yyyy-mm-dd hh:ii',this,true)">
							</td>
							<td>
								<input type="submit" value="Filtrar datas" >
							</td>
						</tr>
					</table>
				   @fields;noquote@
					</form>
					<a href="user-block?account_id=@account_id_p@">Usuários Bloqueados</a>
				</div>

		</div>
	</div>	
</div>
	<div style="font-size: 11px;" class="socialmention-buzz-widget clearfix" id="socialmention_buzz_1942">
<listtemplate name="mentions">
<tr class="od">
	<td headers="mentions_username" class="list-table">
		@username@ 
	</td>
	<td headers="mentions_source" class="list-table">
		@source@
	</td>
	<td headers="mentions_text" class="list-table">
		@text@
	</td>
	<td headers="mentions_created_at" class="list-table">
		@created_at@
	</td>
	<td headers="mentions_sentimento" class="list-table">
		@sentimento@
	</td>            
</tr>
</listtemplate>


</div>
<form action="" style="float:right;">


<div class="buscarmais">
   	<input type="submit" value="Buscar mais termos para analisar">
</div>
	<input type="hidden" value="@min_date@" name="datai">
	<input type="hidden" value="@max_date@" name="dataf">
	@fields;noquote@
</form>
