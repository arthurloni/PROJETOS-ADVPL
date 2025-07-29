#Include "Protheus.ch"


/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 12/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function VERIFICANDO()

    Local nIdade
    Local cResp
    Local cTexto := "DIGITE SUA IDADE: "

    cResp := FWInputBox(cTexto)
    nIdade := GetDtoVal(cResp)

    if nIdade >= 18
        MsgInfo("MAIOR DE IDADE")
    else
        MsgInfo("MENOR DE IDADE")
    endif

Return
