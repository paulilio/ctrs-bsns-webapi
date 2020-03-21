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
        //GERAL
        void Add<T>(T entity);
        void Update<T>(T entity);
        void Delete<T>(T entity);
        Task<bool> SaveChangesAsync();

        //FATURAMENTO
        Task<Faturamento[]> GetFaturamentosAsyncByJsonFields(string jsParam);
        public Result SaveSalesImport(string json);


        //EXEMPLOS
        // Exemplos Task<Faturamento[]> GetAllAlunosAsync(bool includeProfessor);
        // Task<Aluno> GetAlunoAsyncById(int AlunoId, bool includeProfessor);

        /*
        void Delete(T entityToDelete);
        void Delete(object id);
        IEnumerable<T> Get(
            Expression<Func<T, bool>> filter = null,
            Func<IQueryable<T>, IOrderedQueryable<T>> orderBy = null,
            string includeProperties = "");
        T GetByID(object id);
        IEnumerable<T> GetWithRawSql(string query,
            params object[] parameters);
        void Add(T entity);
        void Update(T entityToUpdate);

        */



    }
}