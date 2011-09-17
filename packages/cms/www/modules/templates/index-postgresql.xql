<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_id">      
      <querytext>

        select 
        content_item__get_id(:path, content_template__get_root_folder(), 'f') 

      </querytext>
</fullquery>

 
<fullquery name="get_root_folder_id">      
      <querytext>

        select content_template__get_root_folder()

      </querytext>
</fullquery>

<fullquery name="get_path">      
      <querytext>

        select content_item__get_path(:folder_id, null)

      </querytext>
</fullquery>

<fullquery name="get_items">      
      <querytext>

  select
    t.template_id, t.template_id as item_id, i.name, 
    to_char(o.last_modified, 'MM/DD/YY HH:MI AM') as modified,
    coalesce(round(r.content_length::numeric / 1000,2), 0)::float8::text || ' KB'::text as file_size
  from
    cr_templates t, acs_objects o, 
    cr_revisions r 
      RIGHT OUTER JOIN 
    cr_items i ON i.latest_revision = r.revision_id
  where
    i.parent_id = :folder_id
  and
    i.item_id = t.template_id
  and
    i.item_id = o.object_id
  order by
    upper(i.name)
 
      </querytext>
</fullquery>

<fullquery name="get_info">      
      <querytext>
      
    select
      parent_id, coalesce(label, name) as label, description
    from
      cr_items i, cr_folders f
    where
      i.item_id = f.folder_id
    and
      f.folder_id = :folder_id
  
      </querytext>
</fullquery>

</queryset>
