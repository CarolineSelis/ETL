SELECT    
unique r.ch_produto AS COD_PRODUTO,
pr.ds_titulo_produto AS PRODUTO,
r.ch_agente AS COD_AGENTE,
cb.ds_razao_social AS RAZAO_SOCIAL,
cb.ds_localidade AS CIDADE,
cb.ds_territorio AS TERRITORIO,
cb.cd_latitude AS LATITUDE,
cb.cd_longitude AS LONGITUDE,
cb.ds_regional AS REGIONAL,
CASE WHEN CB.TP_RELACAO = 'Credenciado' THEN 'Equipe Técnica' ELSE CB.TP_RELACAO END AS TIPO_REALIZADOR
FROM BI_DW.D_CLIENTE_BASE CB
JOIN BI_DW.F_PROD_REALIZADOR R ON r.ch_agente = cb.ch_agente
AND CB.FG_ATIVO = 1
JOIN BI_DW.d_produto PR ON pr.cd_produto = r.ch_produto
WHERE R.FG_ATIVO = 1  
AND R.ch_produto IN (SELECT CODIGO FROM TEMP_CODIGOS)



