<master>
  <property name="title">#acs-subsite.Log_In#</property>
  <property name="context">{#acs-subsite.Log_In#}</property>
<style type="text/css">
	#header { margin-bottom: 0px !important;}
#menu ul { display: none;}
.logomarca { height: 5px;	}
.logomarca img {display:none;}
</style>
<include src="@login_template@" return_url="@return_url;noquote@" no_frame_p="1" authority_id="@authority_id@" username="@username;noquote@" email="@email;noquote@" &="__adp_properties">

