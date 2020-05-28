-- USUARIO
INSERT INTO `ctbsdb_dev`.`co_usuario`
(
`dsLogin`,
`dsSenha`,
`dtUltimoAcesso`,
`dsEmail`,
`chSituacao`,
`chAdmin`)
VALUES
(
'sysadmin',
'#12345',
current_timestamp() ,
'paulilio.ferreira@gmail.com',
'A',
'S');

-- EMPRESA
INSERT INTO `ctbsdb_dev`.`co_empresa`
(
`dsCpfCnpj`,
`dsNomeOficial`,
`dsNomeFicticio`)
VALUES
(
'67957516000108',
'Ideal Construtora LTDA',
'Ideal Construtora');