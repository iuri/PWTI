<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

  <fullquery name="portal_content::content::get.select_content_data">
    <querytext>
      select b.content_id,
             b.project_id,
             b.content_number,
             b.summary,
             b.component_id,
             to_char(b.creation_date,'YYYY-MM-DD HH24:MI:SS') as creation_date,
             to_char(b.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date_pretty,
             b.resolution,
             b.user_agent,
             b.found_in_version,
             b.found_in_version,
             b.fix_for_version,
             b.fixed_in_version,
             to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as now_pretty
      from   bt_contents b
      where  b.content_id = :content_id
    </querytext>
  </fullquery>

  <fullquery name="portal_content::content::update.update_content">
    <querytext>
        select bt_content_revision__new (
            null,
            :content_id,
            :component_id,
            :found_in_version,
            :fix_for_version,
            :fixed_in_version,
            :resolution,
            :user_agent,
            :summary,
            now(),
            :creation_user,
            :creation_ip
        );
    </querytext>
  </fullquery>

  <fullquery name="portal_content::content::insert.select_sysdate">
    <querytext>
        select current_timestamp
    </querytext>
  </fullquery>


<fullquery name="portal_content::content::delete.delete_content_case">
    <querytext> 
        select workflow_case_pkg__delete(:case_id);
    </querytext>
</fullquery>
 
<fullquery name="portal_content::content::delete.delete_notification">
    <querytext>
        select notification__delete(:notification_id);
    </querytext>
</fullquery>

<fullquery name="portal_content::content::delete.delete_cr_item">
    <querytext>
        select content_item__delete(:content_id);
    </querytext>
</fullquery>

  <partialquery name="portal_content::content::get_list.category_where_clause">
      <querytext>
         content_keyword__is_assigned(b.content_id, :f_category_$parent_id, 'none') = 't'
      </querytext>
  </partialquery>

  <partialquery name="portal_content::content::get_query.orderby_category_from_content_clause">
      <querytext>
         left outer join cr_item_keyword_map km_order on (km_order.item_id = b.content_id) 
         join cr_keywords kw_order on (km_order.keyword_id = kw_order.keyword_id and kw_order.parent_id = '[db_quote $orderby_parent_id]')
      </querytext>
  </partialquery>
 
  <partialquery name="portal_content::content::get_query.orderby_category_where_clause">
      <querytext>
      </querytext>
  </partialquery>

<!-- bd: the inline view assign_info returns names
     of assignees as well as pretty_names of assigned actions.
     I'm left-outer-joining against this view.

     WARNING: In the query below I assume there can be at most one
     person assigned to a content.  If more people are assigned you will get
     multiple rows per content in the result set.  Current content tracker
     doesn't have UI for creating such conditions. If you add UI that
     allows user to break this assumption you'll also need to deal with
     this.
-->
<fullquery name="portal_content::content::get_query.contents_pagination">
  <querytext>
    select b.content_id,
           b.project_id,
           b.content_number,
           b.summary,
           lower(b.summary) as lower_summary,
           b.comment_content,
           b.comment_format,
           b.component_id,
           b.creation_date,
           to_char(b.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date_pretty,
           b.creation_user as submitter_user_id,
           submitter.first_names as submitter_first_names,
           submitter.last_name as submitter_last_name,
           submitter.email as submitter_email,
           lower(submitter.first_names) as lower_submitter_first_names,
           lower(submitter.last_name) as lower_submitter_last_name,
           lower(submitter.email) as lower_submitter_email,
           st.pretty_name as pretty_state,
           st.short_name as state_short_name,
           st.state_id,
           st.hide_fields,
           b.resolution,
           b.found_in_version,
           b.fix_for_version,
           b.fixed_in_version,
           cas.case_id
           $more_columns
    from $from_content_clause,
         acs_users_all submitter,
         workflow_cases cas,
         workflow_case_fsm cfsm,
         workflow_fsm_states st 
    where submitter.user_id = b.creation_user
      and cas.workflow_id = :workflow_id
      and cas.object_id = b.content_id
      and cfsm.case_id = cas.case_id
      and cfsm.parent_enabled_action_id is null
      and st.state_id = cfsm.current_state 
      $orderby_category_where_clause
    [template::list::filter_where_clauses -and -name "contents"]
    [template::list::orderby_clause -orderby -name "contents"]
  </querytext>
</fullquery>

<fullquery name="portal_content::content::get_query.contents">
  <querytext>
select q.*,
       km.keyword_id,
       assign_info.*
from (
  select b.content_id,
         b.project_id,
         b.content_number,
         b.summary,
         lower(b.summary) as lower_summary,
         b.comment_content,
         b.comment_format,
         b.component_id,
         to_char(b.creation_date,'YYYY-MM-DD HH24:MI:SS') as creation_date,
         to_char(b.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date_pretty,
         b.creation_user as submitter_user_id,
         submitter.first_names as submitter_first_names,
         submitter.last_name as submitter_last_name,
         submitter.email as submitter_email,
         lower(submitter.first_names) as lower_submitter_first_names,
         lower(submitter.last_name) as lower_submitter_last_name,
         lower(submitter.email) as lower_submitter_email,
         st.pretty_name as pretty_state,
         st.short_name as state_short_name,
         st.state_id,
         st.hide_fields,
         b.resolution,
         b.found_in_version,
         b.fix_for_version,
         b.fixed_in_version,
         cas.case_id
         $more_columns
    from $from_content_clause,
         acs_users_all submitter,
         workflow_cases cas,
         workflow_case_fsm cfsm,
         workflow_fsm_states st 
   where submitter.user_id = b.creation_user
     and cas.workflow_id = :workflow_id
     and cas.object_id = b.content_id
     and cfsm.case_id = cas.case_id
     and cfsm.parent_enabled_action_id is null
     and st.state_id = cfsm.current_state 
   $orderby_category_where_clause
   [template::list::page_where_clause -and -name contents -key content_id]
) q
left outer join
  cr_item_keyword_map km
on (content_id = km.item_id)
left outer join
  (select cru.user_id as assigned_user_id,
          aa.action_id,
          aa.case_id,
          wa.pretty_name as action_pretty_name,
          p.first_names as assignee_first_names,
          p.last_name as assignee_last_name
     from workflow_case_assigned_actions aa,
          workflow_case_role_user_map cru,
          workflow_actions wa,
	  persons p
    where aa.case_id = cru.case_id
      and aa.role_id = cru.role_id
      and cru.user_id = p.person_id
      and wa.action_id = aa.action_id
  ) assign_info
on (q.case_id = assign_info.case_id)
   [template::list::orderby_clause -orderby -name "contents"]
  </querytext>
</fullquery>


  <partialquery name="portal_content::content::get_list.filter_assignee_null_where_clause">
      <querytext>
          exists (select 1
                  from workflow_case_assigned_actions aa left outer join
                    workflow_case_role_party_map wcrpm
                      on (wcrpm.case_id = aa.case_id and wcrpm.role_id = aa.role_id)
                  where aa.case_id = cas.case_id
                    and aa.action_id = $action_id
                    and wcrpm.party_id is null
                 )
      </querytext>
  </partialquery>

 
</queryset>
