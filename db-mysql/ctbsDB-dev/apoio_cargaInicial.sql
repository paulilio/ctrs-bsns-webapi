//USUARIO
INSERT INTO `ctbsdb_dev`.`cb_usuario`
(
`dsLogin`,
`dsSenha`,
`dtUltimoAcesso`,
`dsEmail`,
`chSituacao`,
`chAdmin`)
VALUES
(
'skywalker',
'semsenha',
current_timestamp() ,
'paulilio.ferreira@gmail.com',
'A',
'S');

//EMPRESA
INSERT INTO `ctbsdb_dev`.`cb_empresa`
(
`dsCpfCnpj`,
`dsNomeOficial`,
`dsNomeFicticio`)
VALUES
(
'67957516000108',
'Ideal Construtora LTDA',
'Ideal Construtora');