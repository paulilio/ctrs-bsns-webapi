using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using CtrsBsnsWebAPI.Model;

namespace CtrsBsnsWebAPI.Data
{
    public interface IRepository<T> where T : class
    {
        //ENTIDADE DIVERSA
        //void Add(T entity);
        //void Update(T entity);
        //void Delete(T entity);
        //Task<bool> SaveChangesAsync();

        //ENTIDADE SITUACAO ATUAL
        Task<Result> GetFiltros(string jsonParams);
        Task<Result> GetAllSituacaoAtualAsync(string jsonParams);
        public Result ImportCSV(string json, string dsNomeArquivo, int idUsuario, int idEmpresa, char cdTipo);

    }
}