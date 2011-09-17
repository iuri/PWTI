var Is = function(){
    var _n,a,w;
    var n,o,t,v = 1;
    _n = navigator;
    a = _n.userAgent || _n.vendor;
    w = {};
    n = {
    // pesquisa: nome, identidade, versao 
    'OmniWeb':['OmniWeb','ON','OmniWeb'], // OmniWeb
    'Apple':['Safari','SF'], // Safari
    'Opera':['Opera','OP'], // Opera
    'iCab':['iCab','IC'], // iCab
    'KDE':['Konqueror','KQ'], // Konqueror
    'Firefox':['Firefox','FF','Firefox'], // Firefox
    'Camino':['Camino','CN'], // Camino
    'Netscape':['Netscape','NS'], // Netscape (6+)
    'MSIE':['Internet Explorer','IE','MSIE'],// IExplorer
    'Gecko':['Mozilla','MZ','rv'], // Mozilla
    'Mozilla':['Netscape','NS','Mozilla'] // Netscape (4-)
    };

    o = {
    'win':'Windows',
    'mac':'Mac',
    'linux':'Linux'
    }
    v = 1; //Fix 
    for(var i in n){
        t = n[i];
        w[t[1]] = false;
        if(v && a.indexOf(i) != -1){
            w['appName'] = t[0];
            w['appID'] = t[1];
            w[t[1]] = true;
            if(t[2]){
                v = parseFloat(a.substring(a.indexOf(t[2]) + t[2].length + 1 ));
                w[t[1] + v] = true;
                w['appVersion'] = v;
            }
            v = 0;
        }
    }
    for(var i in o){
        w[i] = false;
        if(a.indexOf(o[i]) != -1){
            w['OSName'] = o[i];
            w['OSID'] = i;
            w[i] = true;
        }
    }
    // Verifica se Java esta ativo 
    w.java = navigator.javaEnabled();
    window.navigator.is = w; // navigator extend is 
    return w;
}();
// Teste
//alert("OS:"+Is.OSName+" ID:"+Is.OSID+"\nBrowser:"+Is.appName+" ID:"+Is.appID+"\nVersion:"+Is.appVersion); 

// Funcao para ser chamada na pagina
function verificarBrowser(){
    // Verificando Browser
    if(Is.appID=="IE" && Is.appVersion<6 ){
        var msg = "Este sistema possui recursos não suportados pelo seu Navegador atual.\n";
        msg += "É necessário fazer uma atualização do browser atual para a versão 6 ou superior,\n";
        msg += "ou poderá instalar o Navegador Firefox.\n";
        //msg += "\nDados do seu Navegador:";
        //msg += "\n Browser:"+Is.appName+"\n ID:"+Is.appID+"\n Versão:"+Is.appVersion;
        msg += "\n Baixar firefox agora?";
        if(confirm(msg)){
            document.location.replace("http://br.mozdev.org/");
            return false;
        }else{
            return false;
        }
    }else{
        return true;
    }
}

function validar_CNPJ(campo)
{
		var strMessage = "";
        vaCharCNPJ = false;
        StrCNPJ = campo.value
        StrCNPJ = StrCNPJ.replace(".","")
        StrCNPJ = StrCNPJ.replace(".","")
        StrCNPJ = StrCNPJ.replace("/","")
        StrCNPJ = StrCNPJ.replace("-","")

        if(StrCNPJ != ""){
                var varFirstChr = StrCNPJ.charAt(0);
                var vlMult,vlControle,s1, s2 = "";
                var i,j,vlDgito,vlSoma = 0;

                for ( var i=0; i<=13; i++ ) {

                        var c = StrCNPJ.charAt(i);
                        if( ! (c>="0")&&(c<="9") ){
                                strMessage += "Número do CNPJ Inválido !\n";
                                showMsg(strMessage);
                                campo.value = "";
                                campo.focus();
                                return false;
                        }
                        if( c!=varFirstChr){
                                vaCharCNPJ = true;
                        }
                }
                if( ! vaCharCNPJ ) {
                        strMessage += "Número do CNPJ Inválido !\n";
                        showMsg(strMessage);
                        campo.value = "";
                        campo.focus();
                        return false ;
                }

                s1 = StrCNPJ.substring(0,12);
                s2 = StrCNPJ.substring(12,15);
                vlMult = "543298765432";
                vlControle = "";

                for ( j=1; j<3; j++ ) {
                vlSoma = 0;
                for ( i=0; i<12; i++ ){
                        vlSoma += eval( s1.charAt(i) )* eval( vlMult.charAt(i) );
                }
                if( j == 2 ){
                        vlSoma += (2 * vlDgito);
                }
                vlDgito = ((vlSoma*10) % 11);
                if( vlDgito == 10 ){ vlDgito = 0; }
                        vlControle = vlControle + vlDgito;
                        vlMult = "654329876543";
                }
                if( vlControle != s2 ) {
                        strMessage += "Número do CNPJ Inválido !\n";
                        showMsg(strMessage);
                        campo.value = "";
                        campo.focus();
                        return false;
                } else {
                // alert("Número do CGC Válido !");
                        return true;
                }
        }
}

function login( objForm )
	{
		var strMessage = "";
		$( "#alerta-texto" ).empty();

		if( objForm.autimagem.value == "")
		{
			strMessage += "Informe número de autenticação (Imagem). \n";
		}

		if( objForm.cnpj.value == "" )
		{
			strMessage += "Informe Número do CNPJ. \n";
		}
		if( objForm.senha.value == "" )
		{
			strMessage += "Informe a Senha. \n";
		}


		validar_CNPJ(objForm.cnpj);

		if( strMessage != "" )
		{
			
			$( "#alerta" ).show("normal");
	    		$( "#alerta" ).css( "display", "block" );
			$( "#alerta-texto" ).append( strMessage);
		}
		else
		{
	        if(verificarBrowser()){
				objForm.target ='_blank';
	            		objForm.submit();
	        }
		}
	}


function showMsg(msg){
	$( "#alerta-texto" ).empty();
	$( "#alerta" ).show("normal");
	$( "#alerta" ).css( "display", "block" );
	$( "#alerta-texto" ).append( msg);
}





function limparCNPJ(StrCNPJ){
        StrCNPJ = StrCNPJ.replace(".","");
        StrCNPJ = StrCNPJ.replace(".","");
        StrCNPJ = StrCNPJ.replace("/","");
        StrCNPJ = StrCNPJ.replace("-","");
        return StrCNPJ;
}




