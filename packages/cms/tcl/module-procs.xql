<?xml version="1.0"?>
<queryset>

<fullquery name="cm::modules::get_module_id.module_get_id">      
      <querytext>
      
        select module_id from cm_modules
          where key = :module_name
            and package_id = :package_id
      
      </querytext>
</fullquery>

 
<fullquery name="cm::modules::getMountPoints.get_list">      
      <querytext>
      select 
         key, name, '' as id, 
         '' as children, 't' as expandable, 'f' as symlink,
         0 as update_time
       from cm_modules 
       order by sort_key
      </querytext>
</fullquery>

 
<fullquery name="cm::modules::clipboard::getChildFolders.clip_get_result">      
      <querytext>
      select
                     :module_name as mount_point,
                     name, key, '' as children,
                     'f' as expandable,
                     'f' as symlink,
                     0 as update_type
                   from cm_modules order by sort_key
      </querytext>
</fullquery>

<fullquery name="cm::modules::install::create_modules.update_module_context">      
      <querytext>
	update acs_objects set context_id = :package_id where object_id = :module_id
      </querytext>
</fullquery>

<fullquery name="cm::modules::install::delete_modules.get_module_ids">      
      <querytext>
        select module_id from cm_modules where package_id = :package_id
      </querytext>
</fullquery>
 
</queryset>
