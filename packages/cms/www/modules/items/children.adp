<listtemplate name="children"></listtemplate>

<p/>

<if @child_types_registered_p@>
 <formtemplate id=add_child>
  Add a new child item
  <formwidget id=parent_id><formwidget id=content_type> 
  <input type=submit value="Add">
  </formtemplate>
</if>
