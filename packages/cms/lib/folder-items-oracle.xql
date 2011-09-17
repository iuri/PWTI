<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_folder_contents_paginate">      
      <querytext>
      
  select
    r.item_id, v.title, last_modified
  from 
    cr_resolved_items r, cr_items i, cr_folders f, cr_revisions v, 
    cr_revisions u, acs_objects o
  where
    r.parent_id = :parent_id
  and
    r.resolved_id = i.item_id
  and
    i.item_id = o.object_id
  and
    i.latest_revision = v.revision_id (+)
  and
    i.live_revision = u.revision_id (+)
  and
    i.item_id = f.folder_id (+)
   [template::list::orderby_clause -name folder_items -orderby]  

      </querytext>
</fullquery>

<partialquery name="get_folder_contents">      
      <querytext>

  select
    r.item_id, r.item_id as id, v.revision_id, r.resolved_id, r.is_symlink,
    r.name, i.parent_id, i.content_type, i.publish_status, u.publish_date,
    NVL(trim(
      decode(o.object_type, 'content_symlink', r.label,
			  'content_folder', f.label,
			  nvl(v.title, i.name))),
      '-') title,
    o.object_type, t.pretty_name as pretty_content_type, last_modified, 
    v.content_length
  from 
    cr_resolved_items r, cr_items i, cr_folders f, cr_revisions v, 
    cr_revisions u, acs_objects o, acs_object_types t
  where
    r.parent_id = :parent_id
  and
    r.resolved_id = i.item_id
  and
    i.item_id = o.object_id
  and
    i.content_type = t.object_type
  and
    i.latest_revision = v.revision_id (+)
  and
    i.live_revision = u.revision_id (+)
  and
    i.item_id = f.folder_id (+)
  and
   [template::list::page_where_clause -and -name folder_items -key r.item_id]
   [template::list::orderby_clause -name folder_items -orderby]
  
      </querytext>
</partialquery>
</queryset>