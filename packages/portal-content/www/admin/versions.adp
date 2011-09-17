<master src="../../lib/master">
<property name="title">@project_name;noquote@ Versions</property>
<property name="context_bar">@context_bar;noquote@</property>

<h3>#portal-content.In_Development#</h3>

<if @current_version:rowcount@ eq 0>
  <i>#portal-content.None#</i>
</if>
<else>
  <table cellspacing="1" cellpadding="3" class="bt_listing">
    <tr class="bt_listing_header">
      <th>#portal-content.Version#</th>
      <th>#portal-content.Planned_Freeze#</th>
      <th>#portal-content.Planned_Release#</th>
      <th>#portal-content.Maintainer_1#</th>
      <th>#portal-content.Assign#</th>
      <th>#acs-kernel.common_edit#</th>
      <th>#acs-kernel.common_delete#</th>
      <th>#portal-content.Release#</th>
    </tr>
    <multiple name="current_version">
      <if @current_version.rownum@ odd>
        <tr class="bt_listing_odd">
      </if>
      <else>
        <tr class="bt_listing_even">
      </else>
        <td class="bt_listing">
          @current_version.version_name@
        </td>
        <td class="bt_listing">
          @current_version.anticipated_freeze_date@
        </td>
        <td class="bt_listing">
          @current_version.anticipated_release_date@
        </td>
        <td class="bt_listing">
          <if @current_version.maintainer@ not nil>
            <a href="@current_version.maintainer_url@" title="Email: @current_version.maintainer_email@">@current_version.maintainer_first_names@ 
            @current_version.maintainer_last_name@</a>
          </if>
          <else><i>#portal-content.None#</i></else>
        </td>
        <td class="bt_listing">
          @current_version.assignable_p_pretty@
        </td>
        <td class="bt_listing" align="center">
          <a href="@current_version.edit_url@"><img src="../graphics/Edit16.gif" width="16" height="16" alt="#acs-kernel.common_edit#" border="0"></a>
        </td>
        <td class="bt_listing" align="center">
          <if @current_version.delete_url@ not nil>
            <a href="@current_version.delete_url@"><img src="../graphics/Delete16.gif" width="16" height="16" alt="#acs-kernel.common_delete#" border="0"></a>
          </if>
        </td>
        <td class="bt_listing">
          <a href="@current_version.release_url@">#portal-content.Release_this_version#</a>
        </td>
      </tr>
    </multiple>
  </table>
</else>



<h3>#portal-content.Future_Versions#</h3>

<if @future_version:rowcount@ eq 0>
  <i>#portal-content.None#</i>
</if>
<else>
  <table cellspacing="1" cellpadding="3" class="bt_listing">
    <tr class="bt_listing_header">
      <th>#portal-content.Version#</th>
      <th>#portal-content.Planned_Freeze#</th>
      <th>#portal-content.Planned_Release#</th>
      <th>#portal-content.Maintainer#</th>
      <th>#portal-content.Assign#</th>
      <th>#acs-kernel.common_edit#</th>
      <th>#acs-kernel.common_delete#</th>
      <th>#portal-content.current#</th>
    </tr>
    <multiple name="future_version">
      <if @future_version.rownum@ odd>
        <tr class="bt_listing_odd">
      </if>
      <else>
        <tr class="bt_listing_even">
      </else>
        <td class="bt_listing">
          @future_version.version_name@
        </td>
        <td class="bt_listing">
          @future_version.anticipated_freeze_date@
        </td>
        <td class="bt_listing">
          @future_version.anticipated_release_date@
        </td>
        <td class="bt_listing">
          <if @future_version.maintainer@ not nil>
            <a href="@future_version.maintainer_url@" title="#portal-content.Email# @future_version.maintainer_email@">@future_version.maintainer_first_names@ 
            @future_version.maintainer_last_name@</a>
          </if>
          <else><i>#portal-content.None#</i></else>
        </td>
        <td class="bt_listing">
          @future_version.assignable_p_pretty@
        </td>
        <td class="bt_listing" align="center">
          <a href="@future_version.edit_url@"><img src="../graphics/Edit16.gif" width="16" height="16" alt="#acs-kernel.common_edit#" border="0"></a>
        </td>
        <td class="bt_listing" align="center">
          <if @future_version.delete_url@ not nil>
            <a href="@future_version.delete_url@"><img src="../graphics/Delete16.gif" width="16" height="16" alt="acs-kernel.common_delete#" border="0"></a>
          </if>
        </td>
        <td class="bt_listing">
          <a href="@future_version.set_active_url@">#portal-content.Set_to_current#</a>
        </td>
      </tr>
    </multiple>
  </table>
</else>

<p>

<a href="@version_add_url@">#portal-content.Add_new_version#</a>

<h3>#portal-content.Already_released_versions#</h3>

<if @past_version:rowcount@ eq 0>
  <i>#portal-content.None#</i>
</if>
<else>
  <table cellspacing="1" cellpadding="3" class="bt_listing">
    <tr class="bt_listing_header">
      <th>#portal-content.Version#</th>
      <th>#portal-content.Planned_Release#</th>
      <th>#portal-content.Actual_Release#</th>
      <th>#portal-content.Maintainer#</th>
      <th>#acs-kernel.common_edit#</th>
      <th>#acs-kernel.common_delete#</th>
    </tr>
    <multiple name="past_version">
      <if @past_version.rownum@ odd>
        <tr class="bt_listing_odd">
      </if>
      <else>
        <tr class="bt_listing_even">
      </else>
        <td class="bt_listing">
          @past_version.version_name@
        </td>
        <td class="bt_listing">
          @past_version.anticipated_release_date@
        </td>
        <td class="bt_listing">
          @past_version.actual_release_date@
        </td>
        <td class="bt_listing">
          <if @past_version.maintainer@ not nil>
            <a href="@past_version.maintainer_url@" title="#portal-content.Email# @past_version.maintainer_email@">@past_version.maintainer_first_names@ 
            @past_version.maintainer_last_name@</a>
          </if>
          <else><i>#portal-content.None#</i></else>
        </td>
        <td class="bt_listing" align="center">
          <a href="@past_version.edit_url@"><img src="../graphics/Edit16.gif" width="16" height="16" alt="#acs-kernel.common_edit#" border="0"></a>
        </td>
        <td class="bt_listing" align="center">
          <if @past_version.delete_url@ not nil>
            <a href="@past_version.delete_url@"><img src="../graphics/Delete16.gif" width="16" height="16" alt="acs-kernel.common_delete#" border="0"></a>
          </if>
        </td>
      </tr>
    </multiple>
  </table>
</else>
