<master src="../lib/master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @open_contents:rowcount@ not eq 0>
#portal-content.Select_one_or_more_of#
</if>

<p>
#portal-content.Components_component_filter#
</p>

<p>
#portal-content.Bug_status_open_filter#
</p>

<p>
<include src="../lib/pagination" row_count="@content_count;noquote@" offset="@offset;noquote@" interval_size="@interval_size;noquote@" variable_set_to_export="@pagination_export_var_set;noquote@" pretty_plural="@pretty_names.contents;noquote@">
</p>

<blockquote>

<form method="POST" action="map-patch-to-contents">
  <input type="hidden" name="patch_number" value="@patch_number@" />
  <table>
    <if @open_contents:rowcount@ not eq 0>
      <tr>
        <th>&nbsp;</th>
        <th>#portal-content.Bug_Number#</th>
        <th>#portal-content.Summary#</th>
        <th>#portal-content.Creation_Date#</th>
      </tr>
    </if>

    <multiple name="open_contents">
      <tr>
        <td><input type="checkbox" value="@open_contents.content_number@" name="content_number"></td>
        <td align="center">@open_contents.content_number@</td>
        <td><a href="content?content_number=@open_contents.content_number@">@open_contents.summary@</a></td>
        <td align="center">@open_contents.creation_date_pretty@</td>
      </tr>
    </multiple>
  </table>

   <if @open_contents:rowcount@ eq 0>
     <i>#portal-content.There_are_no_open_to_map#</i>

     <p>
     <center>
       <input type="submit" name="cancel" value="Ok" />
     </center>
     </p>
   </if>
   <else>
     <p>
       <center>
          <input type="submit" name="do_map" value="Map @pretty_names.contents@" /> &nbsp; &nbsp;
          <input type="submit" name="cancel" value="Cancel" />
       </center>
     </p>
   </else>
</form>
</blockquote>

