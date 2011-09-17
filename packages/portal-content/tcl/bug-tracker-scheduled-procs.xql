<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Victor Guerra (guerra@galileo.edu) -->
<!-- @creation-date 2005-02-07 -->
<!-- @arch-tag: 8b3c5588-0ebe-43fd-90a8-009e9f223abf -->
<!-- @cvs-id $Id: portal-content-scheduled-procs.xql,v 1.1 2005/02/25 17:08:11 victorg Exp $ -->

<queryset>
  <fullquery name ="portal_content::scheduled::close_contents.open_content">
    <querytext>
      select content_id
      from bt_contents
    </querytext>
  </fullquery>
</queryset>
