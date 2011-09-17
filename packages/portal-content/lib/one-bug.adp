<contract>
  Display one content

  @author Jeff Davis davis@xarg.net
  @cvs-id $Id: one-content.adp,v 1.1 2004/07/26 13:10:21 jeffd Exp $

  @param content array of values as returned from portal_content::content::get
  @param comments html chunk of comments
  @param style string (either "feed" or "display" -- default is display)
  @param base_url url to the package (ok for this to be empty if in the package, trailing / expected)
</contract>
<h1>Bug @content.content_number_display@ - @content.summary@ [@content.component_name@]</h1>
<p>State: @content.pretty_state@</p>
<if @content.found_in_version_name@ not nil><p>Found in version: @content.found_in_version_name@</p></if>
<if @content.fix_for_version_name@ not nil><p>Fix for version: @content.fix_for_version_name@</p></if>
<if @content.fixed_in_version_name@ not nil><p>Fixed in version: @content.fixed_in_version_name@</p></if>

<multiple name="roles"><p>@roles.role_pretty@: <a href="@roles.user_url@">@roles.user_name@</a></p></multiple>

@comments;noquote@
