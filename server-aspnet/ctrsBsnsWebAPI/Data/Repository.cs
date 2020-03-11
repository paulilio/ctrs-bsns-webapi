using System;
using System.Collections.Generic;
//using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using CtrsBsnsWebAPI.Model;

namespace CtrsBsnsWebAPI.Data
{
    //artigo: https://codewithshadman.com/repository-pattern-csharp/

    public class Repository<T> : IRepository<T> where T : class
    {
        private readonly ApplicationContext _context;
        private DbSet<T> _dbSet;

        public Repository(ApplicationContext context)
        {
            _context = context;
            _dbSet = _context.Set<T>();
        }

        public virtual IEnumerable<T> GetWithRawSql(string query,
            params object[] parameters)
        {
            return _dbSet.FromSql(query, parameters).ToList();
        }

        public virtual IEnumerable<T> Get(
            Expression<Func<T, bool>> filter = null,
            Func<IQueryable<T>, IOrderedQueryable<T>> orderBy = null,
            string includeProperties = "")
        {
            IQueryable<T> query = _dbSet;

            if (filter != null)
            {
                query = query.Where(filter);
            }

            if (includeProperties != null)
            {
                foreach (var includeProperty in includeProperties.Split
                (new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    query = query.Include(includeProperty);
                }
            }


            if (orderBy != null)
            {
                return orderBy(query).ToList();
            }
            else
            {
                return query.ToList();
            }
        }

        public virtual T GetByID(object id)
        {
            return _dbSet.Find(id);
        }

        public virtual void Add(T entity)
        {
            _dbSet.Add(entity);
        }

        public virtual void Delete(object id)
        {
            T entityToDelete = _dbSet.Find(id);
            Delete(entityToDelete);
        }

        public virtual void Delete(T entityToDelete)
        {
            if (_context.Entry(entityToDelete).State == EntityState.Detached)
            {
                _dbSet.Attach(entityToDelete);
            }
            _dbSet.Remove(entityToDelete);
        }

        public virtual void Update(T entityToUpdate)
        {
            _dbSet.Attach(entityToUpdate);
            _context.Entry(entityToUpdate).State = EntityState.Modified;
        }

        public async Task<bool> SaveChangesAsync()
        {
            return (await _context.SaveChangesAsync()) > 0;
        }
        
        public Result SaveSalesImport(string json)
        {
            try
            {
                //string conteudo = "[{ \"region\": \"Sub - Saharan Africa\", \"country\": \"Mozambique\", \"itemType\": \"Household\", \"salesChannel\": \"Offline\", \"orderPriority\": \"L\", \"orderDate\": \"2/10/2012\", \"orderID\": \"665095412\", \"shipDate\": \"2/15/2012\", \"unitsSold\": \"5367\", \"unitPrice\": \"668.27\", \"unitCost\": \"502.54\", \"totalRevenue\": \"3586605.09\", \"totalCost\": \"2697132.18\", \"totalProfit\": \"889472.91\" }]";
                Result r = _context.Set<Result>().FromSql<Result>(
                    "call salesInsertImportData(@JsonPayload, @fileName, @result); SELECT 0 id, @result resultValue;"
                    , new MySqlParameter("@JsonPayload", MySqlDbType.LongText) { Value = json, ParameterName = "@JsonPayload" }
                    , new MySqlParameter("@fileName", MySqlDbType.String) { Value = "Teste.csv", ParameterName = "@fileName" }
                    ).FirstOrDefault();
                dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
                return new Result() { id = obj.status, resultValue = ((obj.result == null) ? "Erro não especificado!" : obj.result) };
            }
            catch (Exception ex)
            {
                //code for any other type of exception
                throw;
            }
            finally
            {
                //call this if exception occurs or not
            }
        }
    }
}