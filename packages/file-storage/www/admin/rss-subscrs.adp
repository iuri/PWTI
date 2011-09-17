<master>
<property name="title">Configure RSS for @folder_name@</property>
<property name="header">Configure RSS for @folder_name@</property>
<property name="context">@context;noquote@</property>

<if @rebuild_short_name@ not nil>
<blockquote>*Rebuilt feed: @rebuild_short_name@</blockquote>
</if>

<p>#file-storage.Configuring_RSS_for# <a href="../?folder_id=@folder_id@">@folder_name@</a></p>

<p><a href="rss-subscr-ae?folder_id=@folder_id@">#file-storage.lt_Create_a_new_RSS_feed#</a> #file-storage.for_this_folder#</p>

<if @subscrs:rowcount@ gt 0>
<h4>#file-storage.lt_Edit_an_existing_feed#</h4>
</if>

<listtemplate name="subscrs"></listtemplate>

