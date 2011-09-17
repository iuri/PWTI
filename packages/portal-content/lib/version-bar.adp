<if @versions_p@ true>
  <div class="bt_navbar" style="clear: right; float: right; padding: 4px; background-color: #41329c; text-align: center;">

    <if @user_id@ ne 0>
      #portal-content.Your_version# <a href="@user_version_url@" class="bt_navbar" style="font-size: 100%;">@user_version_name@</a>
      <if @user_version_id@ ne @current_version_id@>
        #portal-content.Current_version_1#
      </if>
      <else>
        #portal-content.current#
      </else>
    </if>

    <else>
      #portal-content.Current_version_2#
    </else>

  </div>
</if>


