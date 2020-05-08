using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace CtrsBsnsWebAPI.Data
{
    public interface IRepository<T> where T : class
    {
        //FATURAMENTO
        //Task<Faturamento[]> GetFaturamentosAsyncByJsonFields(string jsParam);
        public Result ImportCSV(string json, string dsNomeArquivo, int idEmpresa, int idUsuario, char cdTipo);

    }
}