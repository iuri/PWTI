<font size="-1">&nbsp;<strong>Path:</strong>&nbsp;

<!-- display the ancestor tree -->
<if @context:rowcount@ gt 0>
  <multiple name=context>
    <if @context.is_folder@ eq "t">
      <a href="../@mount_point@/index?folder_id=@context.parent_id@&mount_point=@mount_point@">
        @context.title@
      </a>
    </if>
    <else>
      <a href="../items/index?item_id=@context.parent_id@&mount_point=@mount_point@">
        @context.title@
      </a>
    </else>
    <if @context.rownum@ lt @context:rowcount@>:</if>
 </multiple>
</if>
<else>
   @root_title@
</else>

</font>

<script language=JavaScript>
  set_marks('@mount_point@', '../../resources/checked');
</script>
