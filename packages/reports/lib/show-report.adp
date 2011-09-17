<h1>Gráficos</h1>
<link type="text/css" rel="stylesheet" href="/resources/reports/css/style.css" ></link>
	<div class="filters">
		<listfilters name="show_list" style="select-report"></listfilters>
	</div>
	<div class="chart">
		<script type="text/javascript" src="/resources/reports/js/@format@_swfobject.js"></script>
		<div id="flashcontent">
			<strong>Ocorreu algum erro na geração do gráfico. Tente novamente</strong>
		</div>
		<script type="text/javascript">
			// <![CDATA[		
				var so = new SWFObject("/resources/reports/swf/@format@.swf", "@format@.swf", "100%", "@report_size@", "8", "#FFFFFF");
				so.addVariable("settings_file", escape("/resources/reports/xml/@format@_settings.xml"));
				so.addVariable("chart_data", "<listtemplate name=show_report></listtemplate>");
				so.addVariable("preloader_color", "#999999");
				so.write("flashcontent");
			// ]]>
		</script>
	</div>
	<div class="table">
		<listtemplate name="show_list"></listtemplate>
	</div>
