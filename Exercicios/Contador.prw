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
    

User Function CONTADOR()

    Local nN
    Local cTexto := "Digite o valor de um numero para contar ate ele: "
    Local nI := 1

    nN := Val(FWInputBox(cTexto))

    While nI < nN
        nI += 1
        Alert(nI)
    End

Return
/*/

User Function CONTADOR()

    Local nN     := 0
    Local nI     := 0
    Local cTexto := "Digite o valor de um número para contagem regressiva: "

    nN := Val(FWInputBox(cTexto))

    nI := nN

    While nI >= 0
        Alert("Contando: " + Str(nI))
        nI -= 1
    End

Return
