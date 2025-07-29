#Include "protheus.ch"

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

User Function MENU()

    Local cEscolha
    Local cTexto := "ESCOLHA UMAS DAS OPÇÕES: [1 - Exibir hora atual] - [2 - Nome do Usuario]"
    Local cHora := ""

    cHora := Time()

    cEscolha := FWInputBox(cTexto)

    while cEscolha == '1'
        MsgInfo("-HORA ATUAL-")
        MsgInfo(cHora)

        cEscolha := FWInputBox(cTexto)
        
        if cEscolha = '2'
            MsgInfo("arthur.aiello")
        else
            MsgInfo("Saindo do programa...")
        endif
    end

Return
