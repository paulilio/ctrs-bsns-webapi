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
        
        public Result ImportCSV(string json, string dsNomeArquivo, int idEmpresa, int idUsuario, char cdTipo)
        {
            try
            {
                Result r = _context.Set<Result>().FromSql<Result>(
                    "call salesInsertImportData(@JsonPayload, @fileName, @result); SELECT 0 id, @result resultValue;"
                    , new MySqlParameter("@JsonPayload", MySqlDbType.LongText) { Value = json, ParameterName = "@JsonPayload" }
                    , new MySqlParameter("@dsNomeArquivo", MySqlDbType.String) { Value = dsNomeArquivo, ParameterName = "@dsNomeArquivo" }
                    , new MySqlParameter("@idEmpresa", MySqlDbType.Int32) { Value = idEmpresa, ParameterName = "@idEmpresa" }
                    , new MySqlParameter("@idUsuario", MySqlDbType.Int32) { Value = idUsuario, ParameterName = "@idUsuario" }
                    , new MySqlParameter("@tipo", MySqlDbType.String) { Value = cdTipo, ParameterName = "@cdTipo" }
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