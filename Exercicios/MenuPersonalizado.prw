#Include "protheus.ch"

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 22/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function MENUPERSO()

    Local cTexto := "Deseja somar dois números?"
    Local lResp := MsgYesNo(cTexto)

    If lResp
        SOMANUMEROS()
    Else
        Alert("BELEZAAA")
    EndIf

Return


Static Function SOMANUMEROS()

    Local nNumeroUm := 10
    Local nNumeroDois := 10
    Local nResult

    nResult := nNumeroUm + nNumeroDois

    MsgAlert("Resultado: " + AllTrim(Str(nResult)))

Return
