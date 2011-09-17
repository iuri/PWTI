<master src="../../master">
<property name="title">@page_title@</property>
<property name="mount_point">@mount_point@</property>

<nobr><p>
<include src="../../bookmark" mount_point="@mount_point@" id="@folder_id@">
@page_title;noquote@ 
</p>
</nobr>
<p/>

Back to <a href="../@mount_point@/index?folder_id=@folder_id@&mount_point=@mount_point@">@folder_name@</a> contents

<p/>

<div id=section>
<div id=section-header>Folder permissions</div>
<include src="/packages/acs-subsite/www/permissions/perm-include" object_id="@folder_id@">
</div>

<p/>

<div id=section>
<div id=section-header>Content types registered to the folder</div>
<p/>
<listtemplate name="content_types"></listtemplate>
</div>

<p/>

<div id=section>
<div id=section-header>Folder options for special types</div>
<p/>
<formtemplate id="special_types"></formtemplate>
</div>
