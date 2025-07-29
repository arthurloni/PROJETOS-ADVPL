#Include "protheus.ch"

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 19/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function VALOGICO()

    Local cResp
    Local cTexto := "Voce e gay? (sim | nao)"
    Local lOperador

    cResp := FWInputBox(cTexto)

    if cResp == "sim"
        lOperador := .T.
        Alert(lOperador)
    elseif cResp == "nao"
        lOperador := .F.
        Alert(lOperador)
    else
        Alert("APENAS SIM OU NAO")
    endif

Return
