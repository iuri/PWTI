	
			jQuery(document).ready(function(){
				var already_loaded = 0; 
			
				$('#convenio').load(function(){
						//var newurl = document.getElementById('convenio').url;
						//var newurl = $('convenio').contents().get(0).location.href;
						//var newurl = document.getElementById("convenio").url; 
						//var newurl = document.getElementById('convenio').getAttribute('link'); 
						//alert(newurl);
						/* if (newurl != 'http://www.mda.gov.br/portal/index/show/index/cod/1914') {
							window.location = newurl;
						} else {
							alert(newurl);
						} */
						already_loaded++;
						if (already_loaded == 2) {
							window.location = 'http://www.mda.gov.br/sys/sicofin2.0/';
						}
				 });


			});

			/**
			 * Realiza o login da entidade
			 */
			function loginEntidade()
			{
				$( "#erro" ).hide();
				//$( "#sicofin-login" ).hide();
			 	$( "#loading" )
					.ajaxStart
					(
						function()
						{
							$( this ).fadeIn();
						}
					)
					.ajaxStop
					(
						function()
						{
							$( this ).fadeOut();
						}
					);

				var strParameters = "cnpj=" + $( "input[name=cnpj]" ).val();
				strParameters += "&senha=" + $( "input[name=senha]" ).val();
				strParameters += "&autimagem=" + $( "input[name=autimagem]" ).val();
				strParameters += "&etapa=1";
				var strResult = "";
				$.ajax(
					{
						type: "POST",
						url: "/portal/institucional/portlets/sicofin/acesso-mda",
						cache: false,
						async: false,
						success: function( data ) { strResult = data;},
						data: strParameters
					}
				);
	
				processResult( strResult, "/portal/institucional/portlets/sicofin/acesso-mda" );
			}
			
			/**
			 * Realiza o login do responsÃ¡vel
			 */
			function loginResponsavel()
			{
				$( "#erro" ).hide();
				var strParameters = "cpf=" + $( "input[name=cpf]" ).val();
				strParameters += "&cod=" + $( "input[name=cod]" ).val();
				strParameters += "&senha=" + $( "input[name=senha]" ).val();
				strParameters += "&autimagem=" + $( "input[name=autimagem]" ).val();
				var strResult = "";
				$.ajax(
					{
						type: "POST",
						url: "http://www.mda.gov.br/sys/sicofin2.0/login/responsavel/",
						cache: false,
						async: false,
						dataType: "xml",
						success: function( data ) { strResult = data; },
						data: strParameters
					}
				);
				processResult( strResult, 'http://www.mda.gov.br/sys/sicofin2.0/', true );
			}
			
			/**
			 * Processa o resultado do login da entidade e do responsÃ¡vel
			 */
			function processResult( strResult, strUrl, boolRedirect )
			{
				// Caso tenha algum erro o mesmo serÃ¡ mostrado
				if( $( "erro", strResult ).length >= 1 )
				{ 
					var strMessage = "";
					$( "erro", strResult ).each( function()
						{
							strMessage += $( this ).text() + "<br />";
						}
					);
					$( "#sicofin-login" ).show();
					$( "#erro-texto" ).empty().append( strMessage );
					$( "#erro" ).show();
				}
				else if( $( "sucesso", strResult ).length >= 1 )
				{
					if( boolRedirect == undefined )
					{
						// Caso tenha tido sucesso no login da entidade serÃ¡ redirecionado para o login do responsÃ¡vel
						var strParameters = "cod=" + $( "cod", strResult ).text();
						strParameters += "&etapa=2";
						$.ajax(
							{
								type: "POST",
								url: strUrl,
								cache: false,
								async: false,
								dataType: "plain",
								success: function( data ) { $( "#sicofin-login" ).empty().append( data ); },
								data: strParameters
							}
						);
						$( "#sicofin-login" ).show();
					}
					else if( boolRedirect == true )
					{
						document.location = strUrl;
					}
				}
			}

		
IE = document.all ? true : false;
staticIntLastTypeKeyCode 	= "unknown";
staticIntLastKeyCode		= -1;

/**
 * substitui todas as ocorrencias de um string por outro
 *
 * @param  string strText
 * @param  string strFinder
 * @param  string strReplacer
 * @return bool
 */
function replaceAllForMask( strText , strFinder, strReplacer )
{
	strText += "";
	var strSpecials = /(\.|\*|\^|\?|\&|\$|\+|\-|\#|\!|\(|\)|\[|\]|\{|\}|\|)/gi; // :D
	strFinder = strFinder.replace( strSpecials, "\\$1" )

	var objRe = new RegExp( strFinder, "gi" );
	return( strText.replace( objRe, strReplacer ) );
}

/**
 * Funcao que direciona o ponteiro (foco) para o proximo input (atraves do tabindex)
 * 
 * @param Event
 * @param objElement
 * @return boolean
 */
function goToNextHtmlElement( Event , objElement )
{
    // captura qual tecla foi pressionada a partir do evento
	var intKeyCode = getIntKeyCode( Event );
	var strKeyType = getKeyType( intKeyCode );
    
    // captura o tabindex do elemento html atual
	var intActualIndex = objElement.getAttribute( "tabindex" );

    // caso seja o ENTER pressionado
    if( strKeyType == "enter" )
    {
		// capturando o objeto formulario deste respectivo objeto (elemento)
		objForm = getFormByElement( objElement );
		
		// caso encontre algum formulario
		if ( objForm != null )
		{    
	    	return( scanArrChilds( intActualIndex ) );
		}
    }
    // caso nao seja pressionado a tecla ENTER
    else
    {
    	// retorno da funcao
   		return( true );
   	}
}

/**
 * Confere se o elemento enviado é um texto
 *
 * @param mixElement
 * @return bool
 */
function isString( mixElement )
{
	return( typeof mixElement == "string" );
}

/**
 * Confere se o elemento enviado é um objeto
 *
 * @param mixElement
 * @return bool
 */
function isObject( mixElement )
{
	return( mixElement && typeof mixElement == "object" ) || isFunction( mixElement );
}

/**
 * Confere se o parametro enviado é uma função
 *
 * @param mixElement
 * @return bool
 */
function isFunction( mixElement )
{
	return( typeof mixElement == 'function' );
}

// Funcao que realiza um cast array, ou seja, converte um objeto em array
function parseArray( objElement )
{
    // Criando array
    var arrNew = new Array();
    
    // Caso seja uma colecao
    if( objElement.length )
    {
        for( var i = 0; i < objElement.length; ++i )
        {
            arrNew[ i ] = objElement[ i ];
        }
    }
    // Caso nao seja uma colecao
    else
    {
        for( strAttribute in objElement )
        {
            if( isFunction( objElement[ strAttribute ] ) )
            {
                arrNew[ arrNew.length ] = objElement[ strAttribute ];
            }
        }
    }            
    // Retorno da funcao
    return( arrNew );
}

/**
 * Funcao que varre o array de elementos filhos de um formulario (input, select, textarea) e insere o foco no pr?ximo tabindex visivel
 * 
 * @param integer intActualIndex
 * @return boolean
 */
function scanArrChilds( intActualIndex )
{
	// valor padrao (default) para o tabindex
	if( intActualIndex == undefined )
	{
		intActualIndex = 0;	
	}
	
	// incrementa o tabindex atual
	++intActualIndex;

	// captura os arrays de elementos input, select, textarea deste formulario
	var arrChildsInput      = document.body.getElementsByTagName( "input" );
	var arrChildsSelect     = document.body.getElementsByTagName( "select" );
	var arrChildsTextarea   = document.body.getElementsByTagName( "textarea" );
	var arrChildsImage    	= document.body.getElementsByTagName( "img" );
	
	// criacao do novo array contendo todos os arrays de elementos input, select e textarea
	var arrChilds = new Array();
	arrChilds = arrChilds.concat( parseArray( arrChildsInput ) , parseArray( arrChildsSelect ) , parseArray( arrChildsTextarea ) , parseArray( arrChildsImage ) );

	// varrendo este novo array
	for( var i = 0; i < arrChilds.length; ++i )
	{
		// cada objeto (elemento) deste novo array
		var objChild = arrChilds[ i ];				
		if( !objChild )
		{
			continue;
		}

		// caso seja o objeto na qual se deve dar o foco
		if( objChild.getAttribute && objChild.getAttribute( "tabindex" ) == intActualIndex )
		{
			// caso o elemento esteja visivel
			if( iAmVisible( objChild ) )
			{
				// focaliza o input correto
				objChild.focus();
				return( false );
			}
			// caso o elemento nao esteja invis?vel
			else
			{
				// incrementa o tabindex atual (para procurar ate encontrar o proximo elemento visivel)
				scanArrChilds( intActualIndex );
			}
		}
	}
	// retorno da funcao
	return( false );
}

/**
 * Repete uma string o número de vezes informado
 *
 * @param strText String que será repetida
 * @param intRepeat Número de vezes que a string será repetida
 * @return string Retorna a string repetida
 */
function str_repeat( strText, intRepeat )
{
	strReturn = "";
	for( var i = 0; i < intRepeat; ++i )
	{
		strReturn += strText;
	}
	return( strReturn );
}

/**
 * Funcao que retorna qual o formulario algum determinado objeto (elemento) pertence
 * 
 * @param objElement
 * @return objForm
 */
function getFormByElement( objElement )
{
	// iniciando as variaveis internas
	var objForm = null;
	var objActual = objElement;
	
	// capturando o objeto formulario deste respectivo objeto (elemento)
	while( objForm == null && objActual.parentNode != document.body )
	{
		objActual = objActual.parentNode;
		var strTagName = objActual.tagName + '';
		if ( strTagName.toUpperCase() == 'FORM' )
		{
			objForm = objActual;
		}
	}
	
	// retorno da funcao
	return( objForm );
}

/**
 * Return a integer that identify a pressed key
 *
 * @param handler de evento de tecla
 * @return integer
 * @date 2005-02-18 18:00
 */
function getIntKeyCode( keyEvent )
{
	var intKeyCode = ( (keyEvent.which) ? keyEvent.which : keyEvent.keyCode );
	if( keyEvent.shiftKey )
	{
		intKeyCode += 1000;
	}
	return( intKeyCode );
}

/**
 * Return the "type" of the pressed key
 *
 * @require getIntKeyCode
 * @param integer
 * @return string
 * @date 2005-02-18 18:00
 */
function getKeyType( intKeyCode )
{
	var strType = "unknown";

	if( staticIntLastTypeKeyCode == "special" )
	{
		strType = "letter";
	}
 	else if( intKeyCode == 8 )
	{
		strType = "backspace";
	}
	else if( ( intKeyCode == 9 ) || ( intKeyCode == 1009 ) )
	{
		strType = "tab";
	}
 	else if( intKeyCode == 13 )
	{
		strType = "enter";
	}
	else if( intKeyCode == 32 )
	{
		strType = "space";
	}
	else if( ( ( intKeyCode >= 33 ) && ( intKeyCode <= 40 ) )  || ( ( intKeyCode >= 1033 ) && ( intKeyCode <= 1040 ) ) )
	{
		strType = "position";
	}
	else if( intKeyCode == 46 )
	{
		strType = "delete";
	}
	else if( ( ( intKeyCode >= 48 ) && ( intKeyCode <= 57 ) ) || ( ( intKeyCode >= 96 ) && ( intKeyCode <= 105 ) ) )
	{
		strType = "number";
	}
	else if( ( ( intKeyCode >= 59 ) && ( intKeyCode <= 90 ) ) || ( ( intKeyCode >= 1059 ) && ( intKeyCode <= 1090 ) ) )
	{
		strType = "letter";
	}
	else if( ( intKeyCode >= 112 ) && ( intKeyCode <= 123 ) )
	{
		strType = "Fn";
	}
	else if( ( intKeyCode == 219 ) || ( intKeyCode == 1219 ) || ( intKeyCode == 222 ) || ( intKeyCode == 1222 ) )
	{
		strType = "special";
	}
	staticIntLastKeyCode		= intKeyCode;
	staticIntLastTypeKeyCode	= strType;
	return( strType );
}

/**
 * remove from one string all the not numerical (integer) elements
 *
 * @param string Text
 * @return integer
 * @example alert(forceInt("1a2b3c4"))
 */
function forceInt( Text, leftZeros )
{
    Text += '';
	leftZeros = (leftZeros == undefined) ? false : leftZeros;

	Numbers = "1234567890\n";
	NewText = "";
	for( i = 0 ; i < Text.length ; i++ )
	{
		if( Numbers.indexOf( Text.charAt(i) ) != -1 )
		{
			NewText += Text.charAt(i);
		}
	}
	if( NewText == "" )
	{
		return "";
	}

	if( !leftZeros )
	{
		// a base tem de ser forcada para 10
		// porque o default ? base 8 caso NewText comece com 0
		NewText = parseInt(NewText,10);
	}
	return( NewText );
}

/**
 * remove from one string all the not numirical (double) elements
 *
 * @param string Text
 * @param string Dot
 * @return double
 * @example alert(forceInt("1a2b3c4.5aX"))
 */
function forceDouble(Text, Dot)
{
	Text = Text.replace( Dot , "." );
	Numbers = "1234567890.\n";
	NewText = "";
	var i = 0;
	for( i = 0; i < Text.length; i++ )
	{
		if( Numbers.indexOf( Text.charAt( i ) ) != -1 )
		{
			NewText += Text.charAt( i );
		}
	}
	if( NewText == "" )
	{
		return "";
	}
	// a base tem de ser forcada para 10
	// porque o default ? base 8 caso NewText comece com 0
	floatNew = parseFloat( NewText, 10 );
	NewText = floatNew + "";
	Text = Text.replace( ".", Dot );
	return( Text );
}

/**
 * Check if the pressed key is a number or special key, and remove the not numerical elements of the content /
 *
 * @required forceInt
 * @required forceDouble
 * @param object objElement
 * @return boolean
 * @example <input type="text" onkeypress="return numberMask(this, event, false)"  />
 */
function numberMask( objElement, Event, isDouble, Dot )
{
	isDouble = (isDouble == undefined) ? false : isDouble;
	Dot = (Dot == undefined) ? "." : Dot;

	var intKeyCode = getIntKeyCode( Event );
	var strKeyType = getKeyType( intKeyCode );

	switch( Dot )
	{
		case "." :
			intDotCode = 190;
		break;
		case "," :
			intDotCode = 188;
		break;
		case ";" :
			intDotCode = 191;
		break;
		case "/" :
			intDotCode = 191;
		break;
		default:
			intDotCode = -1;
		break;
	}

	if( intDotCode == -1 )
	{
		return false;
	}

	if ( ( isDouble )
	  && ( intKeyCode == intDotCode )
	  && ( array_search( Dot , objElement.value ) == -1 ) )
	{
		// Dot //
		return true;
	}

	if( ( strKeyType == "number" )
	 || ( strKeyType == "position" )
	 || ( strKeyType == "Fn" )
	 || ( strKeyType == "backspace" )
	 || ( strKeyType == "delete" )
	 || ( strKeyType == "tab" ) )
	{
		return true;
	}

	return false;
}

/**
 * integer Mask /
 *
 * @required numberMask
 * @param object objElement
 * @return boolean
 * @example <input type="text" onkeypress="return integerMask(this,event)"  />
 */
function integerMask( objElement, Event, maxlenght )
{
	objElement.value = forceInt( objElement.value, true );
	if( maxlenght == undefined )
	{
		return( numberMask( objElement, Event, false ) );
	} 
	else 
	{
		return( numberMask( objElement, Event, false ) && maxLengthMask( objElement, Event, maxlenght ) );
	}
}

/**
 * double Mask /
 *
 * @required numberMask
 * @param object objElement
 * @return boolean
 * @example <input type="text" />
 */
function doubleMask( objElement, Event, Dot )
{
	return numberMask( objElement, Event, true, Dot );
}

/**
 * put the integerMask in some object
 *
 * @required integerMask
 * @param object objElement
 * @return void
 * @example integerMaksObject( document.getElementById( 'myNode' ) );
 */
function integerMaskObject( objElement )
{
	if (objElement.onkeypress)
	{
		objElement.onkeypress = " return integerMask( this , event ) ";
	}
	else
	{
		objElement.setAttribute( "onkeypress" , " return integerMask( this , event ) " );
	}
}

/**
 * put the doubleMask in some object
 *
 * @required doubleMask
 * @param object objElement
 * @return void
 * @example doubleMaskObject( document.getElementById( 'myNode' ) );
 */
function doubleMaskObject( objElement )
{
	if( objElement.onkeypress )
	{
		objElement.onkeypress = " return doubleMask( this , event ) ";
	}
	else
	{
		objElement.setAttribute( "onkeypress" , " return doubleMask( this , event ) " );
	}
}

/**
 * return the substring from the text since the first while the chars be inside in the group
 *
 * @param string Texto
 * @param string ConjuntoValidos
 * @return string Texto
 * @example alert( filtra( "ExAmPlE WiTh SoMe StRiNg", "abcdefghijklmnoprstuvxz" ) );
 */
function filtra(Texto,ConjuntoValidos)
{
	for( i=0; i < Texto.length; i++ )
	{
		Letra = Texto.charAt(i);
		if( ConjuntoValidos.indexOf(Letra) == -1 )
		{
			if (i == 0)
			{
				return "";
			}
			else
			{
				return Texto.substring(0,i);
			}
		}
	}
	return Texto;
}

/**
 * change the value of some object
 *
 *
 * @required filtra
 * @param string Texto
 * @param string ConjuntoValidos
 * @return void
 * @example filtraObjeto( document.getElementById( 'myNode' , "123456789-" ) );
 */
function filtraObjeto( Obj,ConjuntoValidos )
{
	if( Obj.value )
	{
		TextoNovo = filtra(Obj.value,ConjuntoValidos);
		Obj.value = TextoNovo;
	}
	else if( Obj.text )
	{
		TextoNovo = filtra(Obj.text,ConjuntoValidos);
		Obj.text = TextoNovo;
	}
	else if( Obj.textContent )
	{
		TextoNovo = filtra(Obj.textContent,ConjuntoValidos);
		Obj.textContent = TextoNovo;
	}
}

/**
 * mask to phone [(numbers)]0..1 + [ numbers + ["-"]0..1 ]* to some value of object
 *
 * @required implode
 * @required explode
 * @required filtraObjeto
 * @required strCount
 * @param object <input> Obj
 * @return void
 * @example <input type="text" onkeyup="return ChecaTeclasTelefone(this)"  />
 */
function ChecaTeclasTelefone(Obj)
{
	filtraObjeto(Obj,"01234567890-()");
	if ((strCount(Obj.value,"(")) > 1)
	{
		NovoArray = Explode(Obj.value,"(");
		Obj.value = Implode(NovoArray,"(",2);
	}
	if ((strCount(Obj.value,")")) > 1)
	{
		NovoArray = Explode(Obj.value,")");
		Obj.value = Implode(NovoArray,")",2);
	}
	PosAbre		= Obj.value.indexOf("(");
	PosFecha         = Obj.value.indexOf(")");

	// Parenteses Invalidos {...)(..}  {...)..} //
	if(((PosAbre == -1) && (PosFecha != -1)) || ((PosAbre != -1) && (PosFecha != -1) && (PosAbre > PosFecha)))
	{
		Obj.value = Obj.value.substring(0,PosFecha) + Obj.value.substring(PosFecha+1,Obj.value.length);
	}
}

/*
 * Put the phone mask and a max length in the sended object.
 *
 * @required ChecaTeclasTelefone
 * @param object <input> Obj
 * @param integer Tamanho
 * @return void
 * @example MascaraParaTelefone( document.getElementById( 'myNode' ) , 10 );
 */
function MascaraParaTelefone( Obj, Tamanho )
{
	if( !Obj )
	{
		return;
	}
	Obj.maxlength   = Tamanho;
	Obj.onkeypress = ChecaTeclasTelefone;
	Obj.onkeyup	     = ChecaTeclasTelefone;
}

/**
 * Double numbers mask with limit of size before and after the separator
 *
 * @required explode
 * @param object <input> Obj
 * @param integer AntesDaVirgula
 * @param integer DepoisDaVirgula
 * @param string Separador
 * @example <input type="text" onkeyup="MascaraReal( this , 3 , 4 )" />
 */
function MascaraReal( Obj, AntesDaVirgula, DepoisDaVirgula, Separador )
{
	if( Separador == undefined )
	{
		Separador = ".";
	}

	var ConjuntoValidos = "0123456789" + Separador;

	if( Obj.value == "" )
	{
		return false;
	}

	var Pedacos = explode(Obj.value,Separador);

	if( Pedacos.length > 1 )
	{
		var Texto = Pedacos[0] + Separador + Pedacos[1];
		var TemSeparador = true;
	}
	else
	{
		var TemSeparador = false;
		var Texto = Obj.value;
	}

	for( var i = 0 ; i < Texto.length ; ++i)
	{
		var Letra = Texto.charAt(i);
		if( ConjuntoValidos.indexOf(Letra) == -1 )
		{
			if( i == 0 )
			{
				Texto = "";
			}
			else
			{
				Texto = Texto.substring(0,i);
				break;
			}
		}
	}
	var Pedacos = explode( Texto,Separador );
	var Texto0 = "";
	var Texto1 = "";
	if( Pedacos[0] != undefined )
	{
		Texto0 = Pedacos[0];
		if( Texto0.length > AntesDaVirgula )
		{
			Texto1 = Texto0.substring(AntesDaVirgula,Texto0.length) + Texto1;
			Texto0 = Texto0.substring(0,AntesDaVirgula);
		}
		if( Pedacos[1] != undefined )
		{
			Pedacos[1] = Texto1 + Pedacos[1];
		}
		else
		{
			Pedacos[1] = Texto1;
		}
	}
	if( Pedacos[1] != undefined )
	{
		Texto1 = Pedacos[1];
		if( Texto1.length >= DepoisDaVirgula )
		{
			Texto1 = Texto1.substring(0,DepoisDaVirgula);
		}
	}
	if( TemSeparador || ( Texto1 != "" ) )
	{
		Obj.value = Texto0 + Separador + Texto1;
	}
	else
	{
		Obj.value = Texto0;
	}
	if( Obj.value.length > DepoisDaVirgula + AntesDaVirgula )
	{
		Obj.value = Obj.value.substring( 0, DepoisDaVirgula + AntesDaVirgula );
	}
    return true;
}

/**
 * Apply the double mask in some object
 *
 * @required floatMask
 * @param object <input> Obj
 * @param integer AntesDaVirgula
 * @param integer DepoisDaVirgula
 * @param string Separador
 * @example AplicaMascaraParaReais( document.getElementById( 'MyNode' , 10, 3 , "." ) );
 */
function AplicaMascaraParaReais( Obj, AntesDaVirgula, DepoisDaVirgula, Separador )
{
	if( Separador == undefined )
	{
		Separador = ".";
	}
	Obj.onkeypress = "return FloatMask( this , " +  parseInt( AntesDaVirgula ) + " , " + parseInt(DepoisDaVirgula) + ", '" + Separador + "' );";
}

/**
 * Apply the double mask in some object in one event
 *
 * @required explode
 * @param object <input> Obj
 * @param event Event
 * @param integer intBefore
 * @param integer intAfter
 * @param string Dot
 * @example <input type="text" onkeypress="return floatMask(this, event, 3, 2, '.' )"  />
 */
function floatMask( objElement, event, intBefore, intAfter, Dot )
{
    if( Dot == undefined )
    {
        Dot = ".";
    }

    if( intAfter == undefined )
    {
        intAfter = 2;
    }

    if( doubleMask(objElement,event, Dot) )
    {
        MascaraReal( objElement , intBefore , intAfter, Dot ); return true;
    }
    else
    {
        return false;
    }
}

/**
 * Check if the text has value in most of then sended length
 *
 * @param object objElement
 * @return boolean
 * @example <input type="text" onkeypress="return maxLengthMask(this, event, 10 )"  />
 */
function maxLengthMask( objElement, Event, intLength )
{
	var textContent = "";
	if( objElement.value )
	{
		if( objElement.value.length > intLength )
		{
			objElement.value = objElement.value.substring( 0 , intLength );
			return false;
		}
		textContent = objElement.value;
	}

	if( objElement.textContent )
	{
		if( objElement.textContent.length > intLength )
		{
			objElement.textContent = objElement.textContent.substring( 0 , intLength );
			return false;
		}
		textContent = objElement.textContent;
	}

	if( objElement.text )
	{
		if( objElement.text.length > intLength )
		{
			objElement.text = objElement.text.substring( 0 , intLength );
			return false;
		}
		textContent = objElement.text;
	}

	if( textContent.length < intLength )
	{
		return true;
	}

	var intKeyCode = getIntKeyCode( Event );
	var strKeyType = getKeyType( intKeyCode );

	if(
		( strKeyType == "position" )
	 || ( strKeyType == "Fn" )
	 || ( strKeyType == "backspace" )
	 || ( strKeyType == "delete" )
	 || ( strKeyType == "tab" ) )
	{
		return true;
	}

	Event = false;
	return false;
}

function setCaretToEnd(control)
{
    if( control.createTextRange )
    {
        var range = control.createTextRange();
        range.collapse(false);
        range.select();
    }
    else if( control.setSelectionRange )
    {
        control.focus();
        var len = control.value.length;
        control.setSelectionRange(len,len);
    }
}

function unFormatInput( objElement, format )
{
	switch(format)
	{
		case "percent":
		case "money":
			strOut = "" + forceInt( objElement.value );
			objElement.value = strOut;
		break;
		case "date":
			objElement.value = forceInt( objElement.value, true );
		break;
		case "hour":
			objElement.value = forceInt( objElement.value, true );
		break;
	}

	// o IE mistura alteracoes de valor com alteracoes de foco
	if(IE) setCaretToEnd(objElement);

}

function formatInput( mixElement, format )
{
	if( isObject( mixElement ) )
	{
		var strOut = mixElement.value;
	}
	else
	{
		var strOut = mixElement;
	}

	if( strOut + "" != "" )
	{
		switch(format)
		{
			case "money":
				// strOut vale a string sem zeros a esquerda
				strOut = "" + strOut;
				strOut = "" + forceInt(strOut);

				// coloca virgula
				var regex = /([^,])(\d{2})$/
				if( regex.test( strOut ) )
				{
					strOut = strOut.replace( regex, "$1,$2" );
				} 
				else 
				{
					strOut = "000" . concat( strOut );
					strOut = strOut.replace( /.*(\d)(\d{2})$/, "$1,$2");
				}
				// coloca ponto
				regex = /(\d+)(\d{3})(.|,)/
				while( regex.test( strOut ) ){
					strOut = strOut.replace( regex, "$1.$2$3" );
				}
				// coloca R$
				strOut = "R$ " + strOut;
			break;
			case "date":
//				strOut = ( strOut.length != 8 ) ? "" : strOut.replace( /(\d{2})(\d{2})(\d{4})/, "$1/$2/$3" );
			break;
			case "hour":
				if (
						( strOut.length != 5  )
						||
						( forceInt( strOut.substring(0,2) ) > 23 )
						||
						( forceInt( strOut.substring(3,5) ) > 59 )
					)
				{
					strOut = "";
				}
				else
				{
					strOut = strOut.replace( /(\d{2})(\d{2})/, "$1:$2" );
				}
			break;
			case "percent":
				strOut = "" + strOut;
				if( ( strOut.length >= 4 ) && ( parseInt( strOut ) > 1000 ) )
				{
					strOut = "" + parseInt( strOut );				
				}
				else
				{
					strOut = "" + forceInt( strOut );
				}
				if( strOut.length < 3 )
				{
					for( var n = 3 ; n >= strOut.length; --n )
					{
						strOut = "0" + strOut;
					}
				}
				strOut = strOut.replace( /(\d+)(\d{2})$/, "$1,$2");
				strOut += "%";
			break;
		}
	}

	if( isObject( mixElement ) )
	{
		mixElement.value = strOut;
	}
	else
	{
		return( strOut );
	}

}

function formatKey( objElement, Event, maxlenght, format )
{
	boolCtrl = Event.ctrlKey;
	if( boolCtrl )
	{
		return true;
	}

	switch( format )
	{
		case "percent":
			return percentMask( objElement, Event, maxlenght );
		case "money":
			return moneyMask( objElement, Event, maxlenght );
		break;
		case "date":
		case "hour":
		default:
			return integerMask( objElement, Event, maxlenght );
		break;
	}
}

function percentToFloat( strPercent , nanReturn )
{
	nanReturn = ( nanReturn == undefined ) ? 0 : nanReturn;
	floPercent = forceInt( strPercent );
	if( floPercent == "" )
	{
		floPercent = nanReturn;
	} 
	else 
	{
		floPercent = floPercent / 100;
	}
	return( floPercent );
}

function moneyToFloat( strMoney , nanReturn )
{
	nanReturn = ( nanReturn == undefined ) ? 0 : nanReturn;
	floMoney = forceInt( strMoney );
	if( floMoney == "" )
	{
		floMoney = nanReturn;
	} 
	else 
	{
		floMoney = floMoney / 100;
	}

	return( floMoney );
}

function floatToPercent( floPercent )
{
	floPercent *= 10000;
	floPercent = ( parseInt( floPercent ) / 100 );
	strPercent = formatInput( floPercent , "percent" );
	return( strPercent );
}

function floatToMoney( floMoney )
{
	strMoney = formatInput( Math.round( floMoney*100 ), "money" );
	return( strMoney );
}

function delegateApplyMask( objField, strType, Event, boolAfterWrite, strDecimalSeparator, strThousandSeparator, maxDecimal , intMaxLength )
{
	var boolMaskAfter = false;
	var boolLeftZeros = true;
	
	switch( strType )
	{
		case "percent":
		{
			strMask = '###' + strDecimalSeparator + '##$';
			boolMaskAfter = true;
			boolLeftZeros = false;
			break;
		}
		case "hour":
		{
			strMask = '^##:##';
			break;
		}
		case "float":
		case "money":
		{
			strMask = '###' + strThousandSeparator + '###' + strThousandSeparator + '###' + strThousandSeparator + '###' + strThousandSeparator + '###' + strThousandSeparator + '###' + strDecimalSeparator + '##$';
			boolMaskAfter = true;
			boolLeftZeros = false;
			break;
		}
		case "date":
		{
			strMask = '^##/##/####';
			break;
		}
		case "cpf":
		{
			strMask = '^###.###.###-##';
			break;
		}
		case "cnpj":
		{
			strMask = '^##.###.###/####-##';
			break;
		}
		case "cep":
		{
			strMask = '^##.###-###';
			break;
		}
		case "phone":
		{
			strMask = '^(##) ####-####';
			break;
		}
		case "integer":
		case "cpfcnpj":
		{
			strMask = '^##############################';
			break;
		}
		case "process":
		{
			strMask = '^#####.######/####-##';
			break;
		}
		case "bmpnro":
		{
			strMask = '^###/####';
			break;
		}
		default:
		{
			strMask = '';
			break;
		}
	}

	if( strMask == "" )
	{
		return;
	}
	else
	{
		return applyMask( objField, strMask , Event, boolAfterWrite, boolMaskAfter, maxDecimal, boolLeftZeros, intMaxLength );
	}
}

/**
 * Funcao que aplica a mascara ao input.
 * @param objectHTMLInput objField
 * @param string          strMask
 * @param event           evtKeyPress
 * @param bool           boolAfterWrite
 * @param bool           boolMaskAfter
 */
function applyMask( objField, strMask, Event, boolAfterWrite, boolMaskAfter, intMaxDec, boolLeftZeros, intMaxLength )
{
	var i, intCount, strValue, intFldLen, intMskLen, bolMask, strCod, intTecla, strDirection;
	var intMaskAfter = ( boolMaskAfter ) ? 1 : 0 ;
	if( Event != undefined )
	{
		var intKeyCode = getIntKeyCode( Event );
		var strKeyType = getKeyType( intKeyCode );
	}
	else
	{
		var strKeyType = "number";
	}

	if( ( strKeyType == "backspace" )
	 || ( strKeyType == "position" )
	 || ( strKeyType == "Fn" )
	 || ( strKeyType == "delete" )
	 || ( strKeyType == "tab" )
	 || ( intKeyCode == 116 ) )
	{
		return true;
	}

	if( ( boolAfterWrite == false ) && ( Event.ctrlKey ) )
	{
		return true;
	}

	// detects in which direction the mask will be applied //
	if ( strMask.match( /\$$/ ) )
	{
		strDirection = 'rightToLeft';
	}
	else
	{
		strDirection = 'leftToRight';
	}
	var strOriginalValue = objField.value;

	// stripping mask characters from input value //
	var strValue = forceInt( objField.value, boolLeftZeros ) + "";

	// inserindo os zeros necessários para se demonstrar as casas decimais //
	if( ( intMaxDec > 0 ) && ( intMaxDec >= strValue.length ) )
	{
	 	var intNumRepeat = ( intMaxDec + 1 ) - strValue.length;
	 	var strZeros = str_repeat( "0" , intNumRepeat );
	 	strValue = strZeros + strValue;
	}

	// stripping beggining and end delimiters from mask //
	strMask = replaceAllForMask( strMask, "^" , "" );
	strMask = replaceAllForMask( strMask, "$" , "" );

	var arrChars = Array();

	for( var i = 0 ; i < strMask.length; ++i )
	{
		arrChars[ i ] = strMask.charAt( i );
	}

	strResultValue = "";

	if ( strDirection == 'leftToRight' )
	{
		var intActualCharValue = 0;
		var strKey;
		for( var i = 0 ; i < arrChars.length; ++i )
		{
			if( intActualCharValue > strValue.length - intMaskAfter )
			{
				break;
			}
			else
			{
				strKey = strValue.charAt( intActualCharValue );
			}
			if( arrChars[ i ] == "#" )
			{
				strResultValue += strKey;
				++intActualCharValue;
			}
			else
			{
				strResultValue += arrChars[ i ];
			}
		}
	}
	else
	{
		var intActualCharValue = 0;
		var strKey;
		arrChars = arrChars.reverse();

		var strValueOld = strValue;
		var strValue = "";
		for( var i = strValueOld.length - 1; i >= 0; --i )
		{
			strValue += strValueOld.charAt( i );
		}

		for( var i = 0; i < arrChars.length; ++i )
		{
			if( intActualCharValue > strValue.length - intMaskAfter )
			{
				break;
			}
			else
			{
				strKey = strValue.charAt( intActualCharValue );
			}
			if( arrChars[ i ] == "#" )
			{
				strResultValue = strKey + strResultValue;
				++intActualCharValue;
			}
			else
			{
				strResultValue = arrChars[ i ] + strResultValue ;
			}
		}
	}

	// controle de tamanho maximo lógico //
	if( strValue.length >= intMaxLength )
	{
		// @cat para o cursor permanecer ao final da palavra
		if( ( IE ) && ( Event.type != "blur" ) )
		{
			var objRange = objField.createTextRange();
			objRange.moveStart( "character", strResultValue.length );
			objRange.moveEnd( "character", strResultValue.length );
			objRange.select();
			objField.focus();
		}
		
		if( boolAfterWrite == true )
		{
			objField.value = strResultValue;
		}

		if( Event == undefined )
		{
			return strResultValue;
		}
		return false;
	}

	// caso haja uma altera??o no value //
	// no evento onkeypress, deixa para //
	// o evento onkeyup cuidar			//
	if( ( boolAfterWrite == false ) && ( strOriginalValue != strResultValue ) )
	{
		// nao altera o campo
	}
	else if( strOriginalValue != strResultValue )
	{
		objField.value = strResultValue;
	}
	
	// @cat para o cursor permanecer ao final da palavra
	if( ( IE ) && ( Event.type != "blur" ) )
	{
		var objRange = objField.createTextRange();
		objRange.moveStart( "character", strResultValue.length );
		objRange.moveEnd( "character", strResultValue.length );
		objRange.select();
		objField.focus();
	}
	if( strKeyType == "number" )
	{
		return true;
	}
	else
	{
		return false;
	}
}

/**
 * Testa se o valor de um input do formulario atende ao regex passado como parametro
 * Caso não atenda, o valor do objeto é setado para "".
 *
 * @param objectHTMLInput objField
 * @param string          strType
 */
function checkValue( objField, strType, strReturn )
{
	var mixReturn = objField.onkeyup();

	if ( isString( mixReturn ) )
	{
		objField.value = mixReturn;
	}

	switch( strType )
	{
		case "percent":
		{
			strRegex = /^(?:(?:\d{1,2},)?(\d{1,2})|(100,00))$/;
			break;
		}
		case "hour":
		{
			strRegex = /^\d{2}:\d{2}/;
			break;
		}
		case "date":
		{
			strRegex = /^(?:(?:[0-2]\d|3[0-1])\/(?:01|03|05|07|08|10|12)|(?:[0-2]\d|30)\/(?:04|06|09|11)|(?:[0-1]\d|2[0-9])\/02)\/(?:19[7-9]\d|20\d{2})/;
			break;
		}
		case "cpf":
		{
			strRegex = /\d{3}.\d{3}.\d{3}-\d{2}/;
			break;
		}
		case "cnpj":
		{
			strRegex = /\d\d\.\d\d\d\.\d\d\d\/\d\d\d\d\-\d\d/;
			break;
		}
		case "cpfCnpj":
		{
			strRegex = /^\d+$/;
			break;
		}
		case "cep":
		{
			strRegex = /\d\d\.\d\d\d\-\d\d\d/;
			break;
		}
		case "integer":
		{
			strRegex = /^\d+$/;
			break;
		}
		case "phone":
		{
			strRegex = /^\(\d{2}\)\s\d{4}\-\d{4}$/;
			break;
		}
		case "process":
		{
			strRegex = /^\d{5}\.\d{6}\/(?:19[7-9]\d|20\d{2})\-\d{2}$/;
			break;
		}
		case "bmpnro":
		{
			strRegex = /^\d{3}\/\d{4}$/;
			break;
		}
		default:
		{
			return;
		}
	}

	if( objField.value.match( strRegex ) )
	{
		if( strReturn != undefined && strReturn != "" )
		{
			removeError();
		}
		return;
	}
	else
	{
		objField.value = "";
		if( strReturn != undefined )
		{
			showError( strReturn );
		}
	}
}

function showError( strText )
{
	if( strText != "" )
	{
		$( "#erro-texto" ).empty();
		$( "#erro-texto" ).append( strText );
		$( "#erro-alone" ).show();
	}
}

function removeError()
{
	$( "#erro-texto" ).empty();
	$( "#erro-alone" ).hide();
}

/**
 * Testa se o valor de um input do tipo money atende ao regex passado como parametro
 * Caso não atenda, o valor do objeto é setado para "".
 *
 * @param objectHTMLInput objField
 * @param string          strRegex
 */
function checkMoneyValue( objField, strRegex )
{
	if ( objField.value.match( strRegex ) )
	{
		objField.value = "R$ " + objField.value;
	}
	else
	{
		objField.value = "R$ 0,00";
	}
}

/**
 * Cria máscara de moeda em campo passado no tipo 000.000.000,00
 *
 * @param objectHTMLInput objCampo
 * @param Event
 * @param int maxlength
 * @return bool/void
 */
function moneyMask(objCampo, event, maxlength)
{
	var strValor = objCampo.value;
	strValor = strValor.replace("R$ ","");
	objCampo.value = strValor;

	var intKeyCode = getIntKeyCode( event );
	var strKeyType = getKeyType( intKeyCode );

	if( numberMask( objCampo, event ) && maxLengthMask( objCampo, event, maxlength ) )
	{

		if( strKeyType == "number" ){

			var intTecla = getIntKeyCode(event);

			strValue = objCampo.value;
			strTxt  = "";

			strValue = forceInt( strValue ) + '';

			//deixa com no m?nimo 3 n?meros o algorismo: 0,00
			if( strValue.length <= 2 )
			{
				zeros = 3 - strValue.length;
				for( n = 0; n < zeros; n++ )
				{
					strValue = '0' + strValue;
				}
			}

			//divide string em inteiro e decimo
			pattern = /^(\d*)(\d{1})$/;
			arrSaida = pattern.exec( strValue );
			strInteiro = arrSaida[1];
			strDecimal = arrSaida[2];

			//prepara para colocar pontos
			pattern = /^([^\.]+)(\d{3})/;
			boolTemPonto = true;

			//coloca pontos
			while( boolTemPonto )
			{
				if(	pattern.test( strInteiro ) )
				{
					strInteiro = strInteiro.replace( pattern , '$1.$2' );
					boolTemPonto = true;
				}
				else
				{
					boolTemPonto = false;
				}
			}
			//junta inteiro de decimal com ","
			strSaida = strInteiro + "," + strDecimal;

			//escreve numero formatado
			objCampo.value = strSaida;
		} 
		else 
		{
			return true;
		}
	} 
	else 
	{
		return false;
	}
}

/**
 * Aplica máscara de percentual
 * Caso o campo seja maior que 100,00 retorna ""
 *
 * @param objectHTMLInput objCampo
 * @param Event
 * @param int maxlength
 * return bool/void
 */
function percentMask(objCampo, event, maxlength)
{
	integerMask( objCampo, event, 4 );
	var strValor = objCampo.value;

	var intKeyCode = getIntKeyCode( event );
	var strKeyType = getKeyType( intKeyCode );

	if( numberMask( objCampo, event ) && maxLengthMask( objCampo, event, maxlength ) )
	{

		if( strKeyType == "number" )
		{

			//se tiver s? decimais acrescentar um zero na frente
			if( strValor.length < 3 )
			{
				intZero = 3 - strValor.length;
				for( intCount = 0; intCount < intZero; intCount++ )
				{
					strValor = '0' + strValor;
				}
			}

			if( strValor.length < 5 )
			{
				strRegex = /^(\d{1,3})(\d{1})$/;
				strValor = strValor.replace(strRegex,'$1,$2');
				strValor = trimString( strValor, '0', true, false);
				if( strValor.charAt(0) == ',')
				{
					strValor = '0' + strValor;
				}

				objCampo.value = strValor;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return true;
		}
	}
	else
	{
		return false;
	}
}
