CREATE OR REPLACE FUNCTION fn_transferir(IN p_cod_cliente_remetente INT, IN p_cod_conta_remetente INT,
										IN p_cod_cliente_destinatario INT, IN p_cod_conta_destinatario INT,
										IN valor_transferencia NUMERIC(10, 2)) RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
DECLARE
	saldo_remetente NUMERIC(10, 2);
	saldo_destinatario NUMERIC(10, 2);
BEGIN
	SELECT saldo FROM tb_conta c WHERE c.cod_cliente = p_cod_cliente_remetente 
	AND c.cod_conta = p_cod_conta_remetente INTO saldo_remetente;
	IF saldo_remetente < valor_transferencia THEN
		RETURN FALSE;
	END IF;
	SELECT saldo FROM tb_conta c WHERE c.cod_cliente = p_cod_cliente_destinatario 
	AND c.cod_conta = p_cod_conta_destinatario INTO saldo_destinatario;
	UPDATE tb_conta c SET saldo = saldo_remetente - valor_transferencia WHERE
	c.cod_cliente = p_cod_cliente_remetente AND c.cod_conta = p_cod_conta_remetente;
	UPDATE tb_conta c SET saldo = saldo_destinatario + valor_transferencia WHERE
	c.cod_cliente = p_cod_cliente_destinatario AND c.cod_conta = p_cod_conta_destinatario;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END; 
$$
DO $$
DECLARE
    p_cod_cliente_remetente INT := 1;
    p_cod_conta_remetente INT := 2;
    p_cod_cliente_destinatario INT := 2;
    p_cod_conta_destinatario INT := 4;
    valor_transferencia NUMERIC := 100;
    resultado BOOLEAN;
BEGIN
    SELECT fn_transferir(p_cod_cliente_remetente, p_cod_conta_remetente, p_cod_cliente_destinatario, p_cod_conta_destinatario, valor_transferencia) INTO resultado;
    RAISE NOTICE '%', resultado;
END; $$

-- DROP ROUTINE IF EXISTS fn_consultar_saldo
-- CREATE OR REPLACE FUNCTION fn_consultar_saldo (IN p_cod_cliente INT, IN p_cod_conta INT) RETURNS NUMERIC(10,2)
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
-- 	v_saldo NUMERIC(10, 2);
-- BEGIN
-- 	SELECT saldo FROM tb_conta c WHERE c.cod_cliente = p_cod_cliente AND c.cod_conta = p_cod_conta INTO v_saldo;
-- RETURN v_saldo;
-- END;
-- $$ 
-- DO $$
-- DECLARE
-- 	v_cod_cliente INT := 2;
-- 	v_cod_conta INT := 4;
-- 	v_saldo NUMERIC(10, 2);
-- BEGIN
-- 	SELECT fn_consultar_saldo (v_cod_cliente, v_cod_conta) INTO v_saldo; 
-- 	RAISE NOTICE 'O saldo da conta % do cliente % é: %', v_cod_conta, v_cod_cliente, v_saldo;
-- END;
-- $$

-- --routine se aplica a funções e procedimentos
-- DROP ROUTINE IF EXISTS fn_depositar;
-- CREATE OR REPLACE FUNCTION fn_depositar (IN p_cod_cliente INT, IN p_cod_conta INT,
-- IN p_valor NUMERIC(10, 2)) RETURNS NUMERIC(10, 2)
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
-- 	v_saldo_resultante NUMERIC(10, 2);
-- BEGIN
-- 	UPDATE tb_conta SET saldo = saldo + p_valor WHERE cod_cliente = p_cod_cliente
-- AND cod_conta = p_cod_conta;
-- 	SELECT saldo FROM tb_conta c WHERE c.cod_cliente = p_cod_cliente AND
-- c.cod_conta = p_cod_conta INTO v_saldo_resultante;
-- 	RETURN v_saldo_resultante;
-- END;
-- $$
-- DO $$
-- DECLARE
-- 	v_cod_cliente INT := 1;
-- 	v_cod_conta INT := 2;
-- 	v_valor NUMERIC(10, 2) := 200;
-- 	v_saldo_resultante NUMERIC (10, 2);
-- BEGIN
-- 	SELECT fn_depositar (v_cod_cliente, v_cod_conta, v_valor) INTO
-- v_saldo_resultante;
-- 	RAISE NOTICE '%', format('Após depositar R$%s, o saldo resultante é de R$%s',
-- v_valor, v_saldo_resultante);
-- END;
-- $$

-- DROP FUNCTION IF EXISTS fn_abrir_conta;
-- CREATE OR REPLACE FUNCTION fn_abrir_conta (IN p_cod_cli INT, IN p_saldo
-- NUMERIC(10, 2), IN p_cod_tipo_conta INT) RETURNS BOOLEAN
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	INSERT INTO tb_conta (cod_cliente, saldo, cod_tipo_conta) VALUES ($1, $2, $3);
-- 	RETURN TRUE;
-- EXCEPTION WHEN OTHERS THEN
-- 	RETURN FALSE;
-- END;
-- $$
-- DO $$
-- DECLARE
-- 	v_cod_cliente INT := 2;
-- 	v_saldo NUMERIC (10, 2) := 700;
-- 	v_cod_tipo_conta INT := 1;
-- 	v_resultado BOOLEAN;
-- BEGIN
-- 	SELECT fn_abrir_conta (v_cod_cliente, v_saldo, v_cod_tipo_conta) INTO
-- v_resultado;
-- 	RAISE NOTICE '%', format('Conta com saldo R$%s%s foi aberta', v_saldo, CASE
-- WHEN v_resultado THEN '' ELSE ' não' END);
-- v_saldo := 1000;
-- 	SELECT fn_abrir_conta (v_cod_cliente, v_saldo, v_cod_tipo_conta) INTO
-- v_resultado;
-- 	RAISE NOTICE '%', format('Conta com saldo R$%s%s foi aberta', v_saldo, CASE
-- WHEN v_resultado THEN '' ELSE ' não' END);
-- END;
-- $$

-- CREATE TABLE tb_cliente(
-- 	cod_cliente SERIAL PRIMARY KEY,
-- 	nome VARCHAR(200) NOT NULL
-- );
-- INSERT INTO tb_cliente (nome) VALUES ('João Santos'), ('Maria Andrade');
-- SELECT * FROM tb_cliente;
-- CREATE TABLE tb_tipo_conta(
-- 	cod_tipo_conta SERIAL PRIMARY KEY,
-- 	descricao VARCHAR(200) NOT NULL
-- );
-- INSERT INTO tb_tipo_conta (descricao) VALUES ('Conta Corrente'), ('Conta Poupança');
-- SELECT * FROM tb_tipo_conta;
-- CREATE TABLE tb_conta (
-- 	cod_conta SERIAL PRIMARY KEY,
-- 	status VARCHAR(200) NOT NULL DEFAULT 'aberta',
-- 	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- 	data_ultima_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- 	saldo NUMERIC(10, 2) NOT NULL DEFAULT 1000 CHECK (saldo >= 1000),
-- 	cod_cliente INT NOT NULL,
-- 	cod_tipo_conta INT NOT NULL,
-- 	CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES
-- tb_cliente(cod_cliente),
-- 	CONSTRAINT fk_tipo_conta FOREIGN KEY (cod_tipo_conta) REFERENCES
-- tb_tipo_conta(cod_tipo_conta)
-- );
SELECT * FROM tb_conta;
