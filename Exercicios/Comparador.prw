#Include "protheus.ch"

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 18/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function COMPARADOR()

    Local nNumeroUm
    Local nNumeroDois
    Local cTexto := "Digite o valor do primeiro numero: "
    Local cTextoUm := "Digite o valor do segundo numero: "

    nNumeroUm := FWInputBox(cTexto)
    nNumeroDois := FWInputBox(cTextoUm) 

    if nNumeroUm > nNumeroDois
        MsgInfo("O numero um e maior que o numero dois")
    elseif nNumeroDois > nNumeroUm
        MsgInfo("O numero dois e maior que o numero um")
    else
        MsgInfo("OS NUMEROS SÃO IGUAIS")
    endif

Return
