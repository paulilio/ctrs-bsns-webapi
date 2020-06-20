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
        Task<Result> GetFiltros(string jsonParams, string cdTipoImport);
        Task<Result> GetAllSituacaoAtualAsync(string jsonParams);
        Task<Result> GetSituacaoAtualLista(string jsonParams, string cdTipoImport);
        public Result ImportCSV(string json, string dsNomeArquivo, int idUsuario, int idEmpresa, string cdTipoImport);

        public Result SetImportFaturamento(string json, string dsNomeArquivo, int idUsuario, int idEmpresa);

    }
}