using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CtrsBsnsWebAPI.Model
{
    [Table("sales")]
    public class Sales
    {

        [Column("id")]
        [Key]
        public int SaleId { get; set; }


    }
}
