#Include "TOTVS.CH"

/*/{Protheus.doc} LHRVT001 -> localhost relatorio vendas total 001
    RELATORIO DE VENDAS TOTAL, PEGANDO OS VENDEDORES SELECIONADOS PELO CODIGO DO VENDEDOR UTILIZANDO A SC5 -> PEDIDO DE VENDA
    @type  Function
    @author Arthur Loni
    @since 23/07/2025
    @version 12
    @parametros XRELVENDA
    MV_PAR01 - Data Inicial
    MV_PAR02 - Data Final  
    MV_PAR03 - Código Vendedor De
    MV_PAR04 - Código Vendedor Até
/*/

User Function LHRVT001()

    Local cCodIni := ""
    Local cCodFim := ""
    Local dDataIni := Ctod(" / / ")
    Local dDataFim := Ctod(" / / ")

    if Pergunte("XRELVENDA",.T.)
        dDataIni := MV_PAR01
        dDataFim := MV_PAR02
        cCodIni := MV_PAR03
        cCodFim := MV_PAR04
        
        If Empty(dDataIni) .Or. Empty(dDataFim)
            MsgAlert("As datas inicial e final devem ser preenchidas!")
            Return
        EndIf
        
        If dDataIni > dDataFim
            MsgAlert("A data inicial não pode ser maior que a data final!")
            Return
        EndIf
        
        RelVend(dDataIni, dDataFim, cCodIni, cCodFim)
        
    endif

Return

/*/{Protheus.doc} RelVend -> Relatorio venda
    Função para criar a estrutura do relatorio de vendas
    @type  Function
    @author Arthur Loni
    @since 23/07/2025
    @version 12
    @param dDataIni, Date, Data inicial
    @param dDataFim, Date, Data final
    @param cCodIni, Character, Código inicial do vendedor
    @param cCodFim, Character, Código final do vendedor
    /*/

Static Function RelVend(dDataIni, dDataFim, cCodIni, cCodFim)

    Local cQuery := ""
    Local cAlias := GetNextAlias()
    Public nTotal := 0
    
    cQuery := QueryRelVend(dDataIni, dDataFim, cCodIni, cCodFim)
    
    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
    
    If (cAlias)->(EOF())
        MsgInfo("Nenhum registro encontrado para os parâmetros informados!")
        (cAlias)->(DbCloseArea())
        Return
    EndIf
    
    MontaTela(cAlias, dDataIni, dDataFim, cCodIni, cCodFim)
    
    (cAlias)->(DbCloseArea())

Return

/*/{Protheus.doc} QueryRelVend -> Query do Relatorio de Vendas
    Função para criar a query utilizada para trazer os dados do relatorio como
    Nome do vendedor, quantidade dos pedidos de venda, codigo do vendedor, valor total dos pedidos de vendas realizados
    tabelas -> SC5990 and SA3990
    @type  Function
    @author Arthur Loni
    @since 23/07/2025
    @version 12
    @param dDataIni, Date, Data inicial
    @param dDataFim, Date, Data final
    @param cCodIni, Character, Código inicial do vendedor
    @param cCodFim, Character, Código final do vendedor
    @return Character, Query SQL montada
    /*/

Static Function QueryRelVend(dDataIni, dDataFim, cCodIni, cCodFim)

    Local cQuery := ""
    
    cQuery := " SELECT " + CRLF
    cQuery += "     SA3.A3_COD AS CODIGO_VENDEDOR, " + CRLF
    cQuery += "     SA3.A3_NOME AS NOME_VENDEDOR, " + CRLF
    cQuery += "     COUNT(SC5.C5_NUM) AS QTD_PEDIDOS, " + CRLF
    cQuery += "     SUM(SC6.C6_VALOR) AS TOTAL_PEDIDOS, " + CRLF
    cQuery += "     MIN(SC5.C5_EMISSAO) AS PRIMEIRA_VENDA, " + CRLF
    cQuery += "     MAX(SC5.C5_EMISSAO) AS ULTIMA_VENDA " + CRLF
    cQuery += " FROM " + RetSqlName("SC5") + " SC5 " + CRLF
    cQuery += "     INNER JOIN " + RetSqlName("SA3") + " SA3 " + CRLF
    cQuery += "         ON SA3.A3_COD = SC5.C5_VEND1 " + CRLF
    cQuery += "         AND SA3.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += "     INNER JOIN " + RetSqlName("SC6") + " SC6 " + CRLF
    cQuery += "         ON SC6.C6_NUM = SC5.C5_NUM " + CRLF
    cQuery += "         AND SC6.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " WHERE " + CRLF
    cQuery += "     SC5.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += "     AND SC6.C6_VALOR > 0 " + CRLF
    cQuery += "     AND SC5.C5_EMISSAO >= '" + DtoS(dDataIni) + "' " + CRLF
    cQuery += "     AND SC5.C5_EMISSAO <= '" + DtoS(dDataFim) + "' " + CRLF
    cQuery += "     AND SA3.A3_COD >= '" + cCodIni + "' " + CRLF
    cQuery += "     AND SA3.A3_COD <= '" + cCodFim + "' " + CRLF
    cQuery += " GROUP BY " + CRLF
    cQuery += "     SA3.A3_COD, " + CRLF
    cQuery += "     SA3.A3_NOME " + CRLF
    cQuery += " ORDER BY " + CRLF
    cQuery += "     TOTAL_PEDIDOS DESC " + CRLF

Return cQuery

/*/{Protheus.doc} MontaTela -> Monta tela com os resultados
    Função para exibir os resultados do relatório em uma tela própria
    @type  Function
    @author Arthur Loni
    @since 27/07/2025
    @version 12
    @param cAlias, Character, Alias da query executada
    @param dDataIni, Date, Data inicial
    @param dDataFim, Date, Data final
    @param cCodIni, Character, Código inicial do vendedor
    @param cCodFim, Character, Código final do vendedor
    /*/

Static Function MontaTela(cAlias, dDataIni, dDataFim, cCodIni, cCodFim)

    Local oDlg
    Local oListBox
    Local aItens := {}
    Local nTotal := 0
    Local nLinha := 1
    Local cTitulo := "Relatório de Vendas por Vendedor"
    Local cSubTitulo := "Período: " + DtoC(dDataIni) + " a " + DtoC(dDataFim) + " | Vendedores: " + cCodIni + " a " + cCodFim
    
    While !(cAlias)->(EOF())
        aAdd(aItens, {;
            AllTrim((cAlias)->CODIGO_VENDEDOR),;
            AllTrim((cAlias)->NOME_VENDEDOR),;
            Transform((cAlias)->QTD_PEDIDOS, "@E 999,999"),;
            Transform((cAlias)->TOTAL_PEDIDOS, "@E 999,999,999.99"),;
            DtoC(StoD((cAlias)->PRIMEIRA_VENDA)),;
            DtoC(StoD((cAlias)->ULTIMA_VENDA));
        })
        
        nTotal += (cAlias)->TOTAL_PEDIDOS
        (cAlias)->(DbSkip())
    EndDo
    
    If Len(aItens) == 0
        aAdd(aItens, {"", "Nenhum registro encontrado", "", "", "", ""})
    EndIf
    
    DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 500,800 PIXEL
    
    @ 010,010 SAY cSubTitulo SIZE 380,010 OF oDlg PIXEL FONT TFont():New("Arial",,-12,.T.)
    
    @ 025,010 SAY "Código"          SIZE 045,010 OF oDlg PIXEL FONT TFont():New("Arial",,-10,.F.)
    @ 025,060 SAY "Nome Vendedor"   SIZE 130,010 OF oDlg PIXEL FONT TFont():New("Arial",,-10,.F.)
    @ 025,120 SAY "Qtd"             SIZE 040,010 OF oDlg PIXEL FONT TFont():New("Arial",,-10,.F.)
    @ 025,180 SAY "Total"           SIZE 060,010 OF oDlg PIXEL FONT TFont():New("Arial",,-10,.F.)
    @ 025,240 SAY "1ª Venda"        SIZE 060,010 OF oDlg PIXEL FONT TFont():New("Arial",,-10,.F.)
    @ 025,300 SAY "Últ. Venda"      SIZE 060,010 OF oDlg PIXEL FONT TFont():New("Arial",,-10,.F.)

    @ 040,010 LISTBOX oListBox VAR nLinha FIELDS HEADER ;
        "Código", "Nome do Vendedor", "Qtd", "Total R$", "Primeira", "Última" ;
        SIZE 370,180 OF oDlg PIXEL
    
    oListBox:SetArray(aItens)
    oListBox:bLine := {|| {;
        aItens[oListBox:nAt][1],;
        aItens[oListBox:nAt][2],;
        aItens[oListBox:nAt][3],;
        aItens[oListBox:nAt][4],;
        aItens[oListBox:nAt][5],;
        aItens[oListBox:nAt][6]; 
    }}
    
    @ 230,010 SAY "TOTAL GERAL: R$ " + Transform(nTotal, "@E 999,999,999.99") SIZE 200,012 OF oDlg PIXEL FONT TFont():New("Arial",,-12,.T.) COLOR CLR_BLUE
    
    @ 230,300 BUTTON "Imprimir" SIZE 040,015 OF oDlg PIXEL ACTION Alert("Funcionalidade de impressão será implementada!")
    @ 230,345 BUTTON "Fechar" SIZE 035,015 OF oDlg PIXEL ACTION oDlg:End()
    
    ACTIVATE MSDIALOG oDlg CENTERED

Return
