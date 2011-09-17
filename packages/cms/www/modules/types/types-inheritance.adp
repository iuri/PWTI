<font size=-1>

 <strong>Inheritance: </strong>&nbsp;
   <if @content_type_tree:rowcount@ eq 1>
    Basic item
   </if>
   <else>
    <multiple name=content_type_tree>
      <if @content_type_tree.object_type@ eq @content_type@>
        @content_type_tree.pretty_name;noquote@
      </if>
          
      <else>
        <a href="index?content_type=@content_type_tree.object_type@&parent_type=@content_type_tree.parent_type@&mount_point=types">
          @content_type_tree.pretty_name;noquote@
        </a>
      </else> 
      <if @content_type_tree.rownum@ lt @content_type_tree:rowcount@> : </if>
    </multiple>
   </else>

</font>