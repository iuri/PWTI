<master>
<script type="text/javascript">

        $(document).ready(function() { 
            // bind 'myForm' and provide a simple callback function
	     
	    $("formbutton:ok").click(function() {  
                alert("Thank you for your comment!"); 
            }); 
        }); 

function FormataCnpj(campo, teclapres)
			{
				var tecla = teclapres.keyCode;
				var vr = new String(campo.value);
				vr = vr.replace(".", "");
				vr = vr.replace("/", "");
				vr = vr.replace("-", "");
				tam = vr.length + 1;
				if (tecla != 14)
				{
					if (tam == 3)
						campo.value = vr.substr(0, 2) + '.';
					if (tam == 6)
						campo.value = vr.substr(0, 2) + '.' + vr.substr(2, 5) + '.';
					if (tam == 10)
						campo.value = vr.substr(0, 2) + '.' + vr.substr(2, 3) + '.' + vr.substr(6, 3) + '/';
					if (tam == 15)
						campo.value = vr.substr(0, 2) + '.' + vr.substr(2, 3) + '.' + vr.substr(6, 3) + '/' + vr.substr(9, 4) + '-' + vr.substr(13, 2);
				}
			}

</script> 

<script language="Javascript">
         function validaCNPJ(campo) {
                 CNPJ = campo.value;
                 erro = new String;
                 if (CNPJ.length < 18) erro += "É necessario preencher corretamente o número do CNPJ! \n\n";
                 if ((CNPJ.charAt(2) != ".") || (CNPJ.charAt(6) != ".") || (CNPJ.charAt(10) != "/") || (CNPJ.charAt(15) != "-")){
                if (erro.length == 0) erro += "É necessário preencher corretamente o número do CNPJ! \n\n";
                }
                //substituir os caracteres que não são números
               if(document.layers && parseInt(navigator.appVersion) == 4){
                       x = CNPJ.substring(0,2);
                       x += CNPJ. substring (3,6);
                       x += CNPJ. substring (7,10);
                       x += CNPJ. substring (11,15);
                       x += CNPJ. substring (16,18);
                       CNPJ = x;
               } else {
                      CNPJ = CNPJ. replace (".","");
                       CNPJ = CNPJ. replace (".","");
                       CNPJ = CNPJ. replace ("-","");
                       CNPJ = CNPJ. replace ("/","");
               }
               var nonNumbers = /\D/;
               if (nonNumbers.test(CNPJ)) erro += "A verificação de CNPJ suporta apenas números! \n\n";
               var a = [];
               var b = new Number;
               var c = [6,5,4,3,2,9,8,7,6,5,4,3,2];
               for (i=0; i<12; i++){
                       a[i] = CNPJ.charAt(i);
                       b += a[i] * c[i+1];
 }
               if ((x = b % 11) < 2) { a[12] = 0 } else { a[12] = 11-x }
               b = 0;
               for (y=0; y<13; y++) {
                       b += (a[y] * c[y]);
              }
               if ((x = b % 11) < 2) { a[13] = 0; } else { a[13] = 11-x; }
               if ((CNPJ.charAt(12) != a[12]) || (CNPJ.charAt(13) != a[13])){
                       erro +="CNPJ Inválido";
			campo.value = '';
			campo.focus();
               }
               if (erro.length > 0){
                       alert(erro);
                      return false;
               }
               return true;
       }





	function ValidaEmail(email){
	  exp = /^[\w-]+(\.[\w-]+)*@(([\w-]{2,63}\.)+[A-Za-z]{2,6}|\[\d{1,3}(\.\d{1,3}){3}\])$/
	  if(!exp.test(email.value)) {
	      alert('E-mail Invalido!');
	      setTimeout("document.getElementById('email').focus()", 50); 
	}
}

</script>

<formtemplate id="comment"></formtemplate>

<div id="rebibo" style="display:hidden">
<h1>Recibo</h1>
<form action="recibo">
<input type="hidden" name="empresa" id="recibo_empresa">
<input type="hidden" name="cnpj" id="recibo_cnpj">
<input type="hidden" name="file_id" value="@item_id@">
<input type="submit" value="Download do Recibo">
</form>
</div>
