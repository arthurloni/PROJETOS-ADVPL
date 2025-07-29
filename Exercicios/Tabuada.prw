#INCLUDE "protheus.ch"

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

User Function TABUADA()

    Local cTexto := "DIGITE UM NUMERO PARA SABER A TABUADA: "
    Local cResp
    Local nNumero
    Local nResult
    Local nI

    cResp := FWInputBox(cTexto)
    nNumero := GetDtoVal(cResp)

    For nI := 1 to 10
        nResult := nNumero * nI
        MsgInfo(nResult)
    Next


Return
