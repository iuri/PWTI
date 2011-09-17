<script language=Javascript src="../clipboard/clipboard.js"></script>

<if @float_p@>
<script language="JavaScript">
  setCookie('content_marks', '');
  document.location = 'floating';
</script>  
</if>
<else>
<script language="JavaScript">
  setCookie('content_marks', '');
  document.location = 'index';
</script>  
</else>