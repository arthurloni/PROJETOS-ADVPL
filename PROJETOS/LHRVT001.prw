#Include "TOTVS.CH"
#Include "report.ch"

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
    Local oReport

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
        
        oReport := ReportDef(dDataIni, dDataFim, cCodIni, cCodFim)
        oReport:PrintDialog()
        
    endif

Return

/*/{Protheus.doc} ReportDef -> Relatorio venda
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

Static Function ReportDef(dDataIni, dDataFim, cCodIni, cCodFim)

    Local oReport
    Local oSection1
    Local cTitulo := "Relatório de Vendas por Vendedor"

    oReport := TReport():New("LHRVT001", cTitulo, , {|oReport| PrintReport(oReport, dDataIni, dDataFim, cCodIni, cCodFim)}, "Relatório de Vendas por Vendedor no período")

    oSection1 := TRSection():New(oReport, "Vendas por Vendedor", , , .F., .F.)

    TRCell():New(oSection1, "CODIGO_VENDEDOR", , "Cod Vendedor"    , "@!", TamSX3("A3_COD")[1])
    TRCell():New(oSection1, "NOME_VENDEDOR"  , , "Nome Vendedor"   , "@!", TamSX3("A3_NOME")[1])
    TRCell():New(oSection1, "QTD_PEDIDO"     , , "Qtd Pedidos"     , "@E 999,999", 10)
    TRCell():New(oSection1, "DATA_INICIAL"   , , "Data Inicial"    , "@D", 10)
    TRCell():New(oSection1, "DATA_FINAL"     , , "Data Final"      , "@D", 10)
    TRCell():New(oSection1, "VALOR_TOTAL"    , , "Valor Total"     , "@E 999,999,999.99", 15)


Return oReport

/*/{Protheus.doc} PrintReport -> Impressão do Relatorio de Vendas
    Função para executar a query e imprimir os dados do relatorio
    @type  Function
    @author Arthur Loni
    @since 23/07/2025
    @version 12
    @param oReport, Object, Objeto do relatório
    @param dDataIni, Date, Data inicial
    @param dDataFim, Date, Data final
    @param cCodIni, Character, Código inicial do vendedor
    @param cCodFim, Character, Código final do vendedor
    /*/

Static Function PrintReport(oReport, dDataIni, dDataFim, cCodIni, cCodFim)

    Local oSection1 := oReport:Section(1)
    Local cAlias := GetNextAlias()

    BeginSQL Alias cAlias
        SELECT
            A3_COD AS CODIGO_VENDEDOR,
            A3_NOME AS NOME_VENDEDOR,
            COUNT(C5_NUM) AS QTD_PEDIDO,
            MIN(C5_EMISSAO) AS DATA_INICIAL,
            MAX(C5_EMISSAO) AS DATA_FINAL,
            SUM(C6_VALOR) AS VALOR_TOTAL
        FROM
            %table:SC5% SC5
        INNER JOIN %table:SA3% SA3
            ON A3_COD = C5_VEND1
            AND SA3.%NotDel%
        INNER JOIN %table:SC6% SC6
            ON C6_NUM = C5_NUM
            AND SC6.%NotDel%
        WHERE 
            SC5.%NotDel%
            AND C5_EMISSAO BETWEEN %Exp:dDataIni% AND %Exp:dDataFim%
            AND A3_COD BETWEEN %Exp:cCodIni% AND %Exp:cCodFim%
        GROUP BY 
            A3_COD,
            A3_NOME
        ORDER BY
            VALOR_TOTAL DESC
    EndSQL

    oSection1:Init()

    While (cAlias)->(!EOF())
        
        If oReport:Cancel()
            Exit
        EndIf

        oSection1:Cell('CODIGO_VENDEDOR'):SetValue((cAlias)->CODIGO_VENDEDOR)
        oSection1:Cell('NOME_VENDEDOR'):SetValue((cAlias)->NOME_VENDEDOR)
        oSection1:Cell('QTD_PEDIDO'):SetValue((cAlias)->QTD_PEDIDO)
        oSection1:Cell('DATA_INICIAL'):SetValue((cAlias)->DATA_INICIAL)
        oSection1:Cell('DATA_FINAL'):SetValue((cAlias)->DATA_FINAL)
        oSection1:Cell('VALOR_TOTAL'):SetValue((cAlias)->VALOR_TOTAL)

        oSection1:PrintLine()
        
        (cAlias)->(DbSkip())
        
    End

    oSection1:Finish()
    
    (cAlias)->(DbCloseArea())

Return
