<if @subtypes:rowcount@ gt 0>
 <div id=section-header>Subtypes of @object_type_pretty@</div>
 <ul>
 <multiple name=subtypes>
   <li><a href="index?content_type=@subtypes.object_type@&parent_type=@content_type@&mount_point=types">
       @subtypes.pretty_name@</a>
   </li>
 </multiple>
 </ul>
</if>
<else>
 <div id=section-header>No subtypes of @object_type_pretty@</div>
</else>
