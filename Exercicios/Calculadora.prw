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

User Function CALC()

    Local nNumeroUm
    Local nNumeroDois
    Local nResult
    Local cTextoNumeroUm := "Digite o valor do numero UM: "
    Local cTextoNumeroDois := "Digite o valor do numero DOIS: "
    Local cTexto := "Deseja escolher qual operação? { * | - | + | / } - (para sair digite [sair])"
    Local cResp

    cResp := FWInputBox(cTexto)

    while cResp <> "sair"
        
        nNumeroUm := Val(FWInputBox(cTextoNumeroUm))
        nNumeroDois := Val(FWInputBox(cTextoNumeroDois))

        if cResp == "*"
            nResult := nNumeroUm * nNumeroDois
            MsgInfo(nResult)
        elseif cResp == "-"
            nResult := nNumeroUm - nNumeroDois
            MsgInfo(nResult)
        elseif cResp == "+"
            nResult := nNumeroUm + nNumeroDois
            MsgInfo(nResult)
        elseif cResp == "/"
            if nNumeroDois == 0 .Or. nNumeroDois == 0
                Alert("Não é possível dividir por zero") 
            endif
            nResult := nNumeroUm / nNumeroDois
            MsgInfo(nResult)
        endif
            
        cResp := FWInputBox(cTexto)

    end

Return
