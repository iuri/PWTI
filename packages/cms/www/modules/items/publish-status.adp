
<table cellspacing=0 cellpadding=2 border=0 width=95%>
<tr>
  <td colspan=2>
    <if @can_edit_status_p@>
      <a href="status-edit?item_id=@item_id@&item_props_tab=@item_props_tab@" class="button">Edit Publishing Status</a>
    </if>
    <else>&nbsp;</else>
  </td>
</tr>

<tr>
<td colspan=2>
  <table cellspacing=0 cellpadding=4 width="100%">
  <tr>
    <td align=left>@message@</td>
  </tr>


  <tr>
    <td>
      This item is 
      <if @is_publishable@ eq f><strong>NOT</strong></if> 
      in a publishable state<if @is_publishable@ eq f>:</if><else>.</else>

  <if @is_publishable@ eq f>
  <ul>


  <!-- Revision status -->

  <if @live_revision@ nil>
    <li>This item has no live revision.
  </if>


  <!-- child rel status -->


  <if @unpublishable_child_types@ gt 0>

    <li>This item requires the following number of child items:
      <ul>
      <multiple name="child_types">
      <if @child_types.is_fulfilled@ eq f>
        <li>@child_types.difference@ @child_types.direction@ 
	@child_types.relation_tag@ 
	<if @child_types.difference@ eq 1>@child_types.child_type_pretty@</if>
        <else>@child_types.child_type_plural@</else>
	<br>
      </if>
      </multiple>
      </ul>
  </if>



  <!-- item rel status -->

  <if @unpublishable_rel_types@ gt 0>

    <li>This item requires the following number of related items:
      <ul>
      <multiple name="rel_types">
      <if @rel_types.is_fulfilled@ eq f>
        <li>@rel_types.difference@ @rel_types.direction@ 
	@rel_types.relation_tag@ 
	<if @rel_types.difference@ eq 1>@rel_types.target_type_pretty@</if>
        <else>@rel_types.target_type_plural@</else>
	<br>
      </if>
      </multiple>
      </ul>
  </if>







  </ul>
  </if>
  </td></tr>
</table>

</td></tr></table>
