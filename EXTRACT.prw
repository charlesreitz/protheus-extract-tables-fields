#include 'protheus.ch'
#INCLUDE "FileIO.CH"
/*/

Gera um JSON com o dicionario de dados

@author CHARLES REITZ
@since 10/03/2022

/*/
User Function Extract()
	Local oJSon	 	:= JsonObject():New()
	Local aDic      := { }
	Local cDir  := getTempPath()
	Local cParq := tFileDialog( "All Text Json (*.json) ","Salvar",, cDir, .T., GETF_NETWORKDRIVE+GETF_LOCALHARD   )

	RpcSetEnv("99","01")
	nHandle := FCREATE(cParq)

	If nHandle = -1
		MsgAlert("Não foi possivel criar o arquivo" + Str(Ferror()))
		rETURN
	Endif


	SX2->(dbGotop())
	While SX2->(!eof())
		conout(SX2->X2_ARQUIVO)

		oJSonSX2	:= JsonObject():New()
		oJSonSX2['X2_CHAVE']    := Alltrim(SX2->X2_CHAVE)
		oJSonSX2['X2_ARQUIVO']  := Alltrim(SX2->X2_ARQUIVO)
		oJSonSX2['X2_NOME']     := EncodeUTF8(Alltrim(SX2->X2_NOME))
		oJSonSX2['X2_UNICO']    := Alltrim(SX2->X2_UNICO)

		SX3->(dbSetORder(1))
		SX3->(dbSeek(SX2->X2_CHAVE))
        aSX3 := {}
		While SX3->(!eof()) .AND. SX3->X3_ARQUIVO == SX2->X2_CHAVE
			conout(SX2->X2_ARQUIVO + " " +SX3->X3_CAMPO)
			oJSonSX3	    := JsonObject():New()
			oJSonSX3['X3_ARQUIVO']      := Alltrim(SX3->X3_ARQUIVO)
			oJSonSX3['X3_ARQUIVO']      := Alltrim(SX3->X3_ARQUIVO)

			oJSonSX3['X3_ORDEM']        := Alltrim(SX3->X3_ORDEM)
			oJSonSX3['X3_CAMPO']        := Alltrim(SX3->X3_CAMPO)
			oJSonSX3['X3_TIPO']         := Alltrim(SX3->X3_TIPO)
			oJSonSX3['X3_TAMANHO']      := Alltrim(SX3->X3_TAMANHO)
			oJSonSX3['X3_DECIMAL']      := Alltrim(SX3->X3_DECIMAL)
			oJSonSX3['X3_TITULO']       := EncodeUTF8(Alltrim(SX3->X3_TITULO))
			oJSonSX3['X3_DESCRIC']       := EncodeUTF8(Alltrim(SX3->X3_DESCRIC))
			oJSonSX3['X3_F3']           := Alltrim(SX3->X3_F3)
			oJSonSX3['X3_CONTEXT']      := Alltrim(SX3->X3_CONTEXT)
			oJSonSX3['X3_VLDUSER']      := Alltrim(SX3->X3_VLDUSER)
			oJSonSX3['X3_CBOX']         := EncodeUTF8(Alltrim(SX3->X3_CBOX))
			oJSonSX3['X3_WHEN']         := Alltrim(SX3->X3_WHEN)
			oJSonSX3['X3_INIBRW']       := Alltrim(SX3->X3_INIBRW)
			oJSonSX3['X3_GRPSXG']       := Alltrim(SX3->X3_GRPSXG)
            aadd(aSX3, oJSonSX3)
			SX3->(dbSkip())
		EndDo
		oJSonSX2['SX3']    := aSX3

		aadd(aDic,oJSonSX2)


		SX2->(dbSkip())
	EndDo
	oJSon:Set(aDic)
	FWrite(nHandle, oJSon:toJson() )
	FClose(nHandle)
	lRet := .T.
	If File(cParq)
		MsgInfo("Arquivo Criado "+cParq)
	EndIf

	RpcClearEnv()
Return nil

