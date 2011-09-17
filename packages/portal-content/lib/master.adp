<master>
  <property name="title">@title;noquote@</property>
  <property name="header_stuff">
    <link rel="stylesheet" type="text/css" href="/resources/portal-content/portal-content.css" media="all">
  </property>
  <if @signatory@ not nil><property name="signatory">@signatory;noquote@</property></if>
  <if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
  <if @displayed_object_id@ not nil><property name="displayed_object_id">@displayed_object_id;noquote@</property></if>
  <property name="body_start_include">/packages/portal-content/lib/version-bar</property>
  <if @context_bar@ not nil>
    <property name="context_bar">@context_bar;noquote@</property>
  </if>
  <if @context@ not nil>
    <property name="context">@context;noquote@</property>
  </if>

<include src="nav-bar" notification_link="@notification_link;noquote@">
<slave>
<include src="nav-bar" notification_link="@notification_link;noquote@">
