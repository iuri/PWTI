<master src="../lib/master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<table cellspacing="1" cellpadding="3" class="bt_listing">
  <tr class="bt_listing_header">
    <th colspan="2">#portal-content.Notifications_for#</th>
    <th>#portal-content.Subscribe#</th>
    <th>#portal-content.Unsubscribe#</th>
  </tr>
  <multiple name="notifications">
    <if @notifications.rownum@ odd>
      <tr class="bt_listing_odd">
    </if>
    <else>
      <tr class="bt_listing_even">
    </else>
      <td align="center" class="bt_listing_narrow">
        <if @notifications.subscribed_p@ true>
          <b>&raquo;</b>
        </if>
        <else>
          &nbsp;
        </else>
      </td>
      <td class="bt_listing">
        @notifications.label@
      </td>
      <td class="bt_listing">
        <if @notifications.subscribed_p@ false>
          <a href="@notifications.url@" title="@notifications.title@">#portal-content.Subscribe#</a>
        </if>
      </td>
      <td class="bt_listing">
        <if @notifications.subscribed_p@ true>
          <a href="@notifications.url@" title="@notifications.title@">#portal-content.Unsubscribe#</a>
        </if>
      </td>
    </tr>
  </multiple>
</table>

<p>
  <a href="@manage_url@">#portal-content.Manage_your_notification#</a>
</p>

