#INCLUDE "Protheus.ch"

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 10/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function SAUDACAO()

    Local cHora := ""

    cHora := Time()

    if (cHora >= "06:00:00") .And. (cHora <= "12:00:00")
            MsgInfo("Bom Dia!") 
    elseif (cHora > "12:00:00") .And. (cHora <= "18:00:00")
            MsgInfo("Boa Tarde!")
    else
        MsgInfo("Boa noite!")     
    endif

Return
