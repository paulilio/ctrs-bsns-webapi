using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CtrsBsnsWebAPI.Model
{
    public class SituacaoAtual
    {
        [Column("id")]
        public int id { get; set; }

        [Column("idCarga")]
        public int idCarga { get; set; }

        [Column("dsCpfCnpjCliente")]
        public string dsCpfCnpjCliente { get; set; }

        [Column("dsNomeCliente")]
        public string dsNomeCliente { get; set; }

        [Column("dsCodigoInterno")]
        public string dsCodigoInterno { get; set; }

        [Column("dtDataEmissao")]
        public DateTime dtDataEmissao { get; set; }

        [Column("dtDataVencimento")]
        public DateTime dtDataVencimento { get; set; }

        [Column("dtDataRecebimento")]
        public DateTime dtDataRecebimento { get; set; }

        [Column("dsFormaRecebimento")]
        public string dsFormaRecebimento { get; set; }

        [Column("vlValor")]
        public decimal vlValor { get; set; }

        [Column("dsNatureza")]
        public string dsNatureza { get; set; }

        [Column("dsContaContabil")]
        public string dsContaContabil { get; set; }

        [Column("dsUnidadeNegocio")]
        public string dsUnidadeNegocio { get; set; }

        [Column("dsCentroReceita")]
        public string dsCentroReceita { get; set; }

        [Column("dsBanco")]
        public string dsBanco { get; set; }

    }

    /*
    [Table("cb_faturamento")]
    public class Faturamento
    {

        [Column("idFaturamento")]
        public int idFaturamento { get; set; }

        [Column("idCarga")]
        public int idCarga { get; set; }

        [Column("dsCpfCnpjCliente")]
        public string dsCpfCnpjCliente { get; set; }

        [Column("dsNomeCliente")]
        public string dsNomeCliente { get; set; }

        [Column("dsCodigoInterno")]
        public string dsCodigoInterno { get; set; }

        [Column("dtDataEmissao")]
        public DateTime dtDataEmissao { get; set; }

        [Column("dtDataVencimento")]
        public DateTime dtDataVencimento { get; set; }

        [Column("dtDataRecebimento")]
        public DateTime dtDataRecebimento { get; set; }

        [Column("dsFormaRecebimento")]
        public string dsFormaRecebimento { get; set; }

        [Column("vlValor")]
        public decimal vlValor { get; set; }

        [Column("dsNatureza")]
        public string dsNatureza { get; set; }

        [Column("dsContaContabil")]
        public string dsContaContabil { get; set; }

        [Column("dsUnidadeNegocio")]
        public string dsUnidadeNegocio { get; set; }

        [Column("dsCentroReceita")]
        public string dsCentroReceita { get; set; }

    }

    [Table("cb_conta_receber")]
    public class ContaReceber
    {

        [Column("idContaReceber")]
        public int idContaReceber { get; set; }

        [Column("idCarga")]
        public int idCarga { get; set; }

        [Column("dsCpfCnpjCliente")]
        public string dsCpfCnpjCliente { get; set; }

        [Column("dsNomeCliente")]
        public string dsNomeCliente { get; set; }

        [Column("dsCodigoInterno")]
        public string dsCodigoInterno { get; set; }

        [Column("dtDataEmissao")]
        public DateTime dtDataEmissao { get; set; }

        [Column("dtDataVencimento")]
        public DateTime dtDataVencimento { get; set; }

        [Column("dtDataRecebimento")]
        public DateTime dtDataRecebimento { get; set; }

        [Column("dsFormaRecebimento")]
        public string dsFormaRecebimento { get; set; }

        [Column("vlValor")]
        public decimal vlValor { get; set; }

        [Column("dsNatureza")]
        public string dsNatureza { get; set; }

        [Column("dsContaContabil")]
        public string dsContaContabil { get; set; }

        [Column("dsUnidadeNegocio")]
        public string dsUnidadeNegocio { get; set; }

        [Column("dsCentroReceita")]
        public string dsCentroReceita { get; set; }

    }

    [Table("cb_inadimplemnte")]
    public class Inadimplemnte
    {

        [Column("idInadimplemnte")]
        public int idInadimplemnte { get; set; }

        [Column("idCarga")]
        public int idCarga { get; set; }

        [Column("dsCpfCnpjCliente")]
        public string dsCpfCnpjCliente { get; set; }

        [Column("dsNomeCliente")]
        public string dsNomeCliente { get; set; }

        [Column("dsCodigoInterno")]
        public string dsCodigoInterno { get; set; }

        [Column("dtDataEmissao")]
        public DateTime dtDataEmissao { get; set; }

        [Column("dtDataVencimento")]
        public DateTime dtDataVencimento { get; set; }

        [Column("dtDataRecebimento")]
        public DateTime dtDataRecebimento { get; set; }

        [Column("dsFormaRecebimento")]
        public string dsFormaRecebimento { get; set; }

        [Column("vlValor")]
        public decimal vlValor { get; set; }

        [Column("dsNatureza")]
        public string dsNatureza { get; set; }

        [Column("dsContaContabil")]
        public string dsContaContabil { get; set; }

        [Column("dsUnidadeNegocio")]
        public string dsUnidadeNegocio { get; set; }

        [Column("dsCentroReceita")]
        public string dsCentroReceita { get; set; }

    }

    [Table("cb_banco")]
    public class Banco
    {

        [Column("idBanco")]
        public int idBanco { get; set; }

        [Column("idCarga")]
        public int idCarga { get; set; }

        [Column("dsCpfCnpjCliente")]
        public string dsCpfCnpjCliente { get; set; }

        [Column("dsNomeCliente")]
        public string dsNomeCliente { get; set; }

        [Column("dsCodigoInterno")]
        public string dsCodigoInterno { get; set; }

        [Column("dtDataEmissao")]
        public DateTime dtDataEmissao { get; set; }

        [Column("dtDataVencimento")]
        public DateTime dtDataVencimento { get; set; }

        [Column("dtDataRecebimento")]
        public DateTime dtDataRecebimento { get; set; }

        [Column("dsFormaRecebimento")]
        public string dsFormaRecebimento { get; set; }

        [Column("vlValor")]
        public decimal vlValor { get; set; }

        [Column("dsNatureza")]
        public string dsNatureza { get; set; }

        [Column("dsContaContabil")]
        public string dsContaContabil { get; set; }

        [Column("dsUnidadeNegocio")]
        public string dsUnidadeNegocio { get; set; }

        [Column("dsCentroReceita")]
        public string dsCentroReceita { get; set; }

        [Column("dsBanco")]
        public string dsBanco { get; set; }

    }

    */
}
