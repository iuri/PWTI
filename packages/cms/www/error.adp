<master src="./master">

<p/>

<h2>Error</h2>

<form name=error_ok method=post action="@return_url@">
<multiple name=vars>
  <input type=hidden name="@vars.name@" value="@vars.value@">
</multiple>

@message@

<p/>

<input type=submit name=submit value="Ok">
</form>
