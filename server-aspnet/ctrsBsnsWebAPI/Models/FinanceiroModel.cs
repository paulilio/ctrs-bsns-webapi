using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CtrsBsnsWebAPI.Model
{
    [Table("financeiro")]
    public class Financeiro
    {

        [Column("id")]
        public int id { get; set; }

        [Column("dataLancamento")]
        public DateTime dataLancamento { get; set; }

        [Column("cpfCnpjCliente")]
        public string cpfCnpjCliente { get; set; }

        [Column("nomeCliente")]
        public string nomeCliente { get; set; }

        [Column("valor")]
        public decimal valor { get; set; }

        [Column("dataVencimento")]
        public DateTime dataVencimento { get; set; }

        [Column("dataRecebimento")]
        public DateTime dataRecebimento { get; set; }

        [Column("formaRecebimento")]
        public string formaRecebimento { get; set; }

        [Column("unidadeNegocio")]
        public string unidadeNegocio { get; set; }

        [Column("planoContas")]
        public string planoContas { get; set; }

        [Column("centroReceitas")]
        public string centroReceitas { get; set; }

        [Column("banco")]
        public string banco { get; set; }

        [Column("descricao")]
        public string descricao { get; set; }




    }
}
