using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using CtrsBsnsWebAPI.Model;

namespace CtrsBsnsWebAPI.Data
{
    public interface IRelatorioRepository<T> where T : class
    {
        //CONFRONTO DE DADOS
        Task<Result> GetRelConfrontoFiltro(string jsonParams);
        Task<Result> GetRelConfronto(string jsonParams);
        Task<Result> GetRelConfrontoBanco(string jsonParams);
        Task<Result> GetRelEstoque(string jsonParams);

    }
}