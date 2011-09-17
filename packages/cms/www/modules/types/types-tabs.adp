<div id="subnavbar-div">
  <div id="subnavbar-container">
    <div id="subnavbar">

 <if @type_props_tab@ eq attributes>
   <div class="tab" id="subnavbar-here">
     Attributes
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/types/index?content_type=@content_type@&mount_point=types&parent_type=@parent_type@&type_props_tab=attributes" title="" class="subnavbar-unselected">Attributes</a>
   </div>
 </else>

 <if @type_props_tab@ eq relations>
   <div class="tab" id="subnavbar-here">
     Relations
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/types/index?content_type=@content_type@&mount_point=types&parent_type=@parent_type@&type_props_tab=relations" title="" class="subnavbar-unselected">Relations</a>
   </div>
 </else>

 <if @type_props_tab@ eq templates>
   <div class="tab" id="subnavbar-here">
     Templates
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/types/index?content_type=@content_type@&mount_point=types&parent_type=@parent_type@&type_props_tab=templates" title="" class="subnavbar-unselected">Templates</a>
   </div>
 </else>

 <if @type_props_tab@ eq permissions>
   <div class="tab" id="subnavbar-here">
     Permissions
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/types/index?content_type=@content_type@&mount_point=types&parent_type=@parent_type@&type_props_tab=permissions" title="" class="subnavbar-unselected">Permissions</a>
   </div>
 </else>

 <if @type_props_tab@ eq subtypes>
   <div class="tab" id="subnavbar-here">
     Subtypes
   </div>
 </if>
 <else>
   <div class="tab">
     <a href="@package_url@modules/types/index?content_type=@content_type@&mount_point=types&parent_type=@parent_type@&type_props_tab=subtypes" title="" class="subnavbar-unselected">Subtypes</a>
   </div>
 </else>

  </div>
 </div>
</div>