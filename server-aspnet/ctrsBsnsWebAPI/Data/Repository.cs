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
        //private DbSet<T> _dbSet;

        public Repository(ApplicationContext context)
        {
            _context = context;
            //_dbSet = _context.Set<T>();
        }

        //public void Add<T>(T entity) where T : class {_context.Add(entity);}
        //public void Update<T>(T entity) where T : class {_context.Update(entity);}
        //public void Delete<T>(T entity) where T : class {_context.Remove(entity);}
        //public async Task<bool> SaveChangesAsync(){return (await _context.SaveChangesAsync()) > 0;}

        public async Task<Result> GetFiltros(string jsonParams, string cdTipoImport)
        {
            try {
                Result r = await _context.Set<Result>().FromSql<Result>(
                    "call getSituacaoAtualFiltro(@jsonParams,@p_cdTipoImp, @result); SELECT 0 id, @result resultValue;"
                    , new MySqlParameter("@jsonParams", MySqlDbType.LongText) { Value = null, ParameterName = "@jsonParams" }
                    , new MySqlParameter("@p_cdTipoImp", MySqlDbType.String) { Value = cdTipoImport, ParameterName = "@p_cdTipoImp" }
                    ).FirstOrDefaultAsync();

                dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
                return new Result() { id = obj.status, resultValue = ((obj.result == null) ? "Erro não especificado!" : obj.result) };

                //return new Result() { id = 200, resultValue = "Teste!" };
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

        public async Task<Result> GetSituacaoAtualLista(string jsonParams, string cdTipoImport)
        {
            Result r = await _context.Set<Result>().FromSql<Result>(
                "call getSituacaoAtualLista(@jsonParams,@p_cdTipoImp, @result); SELECT 0 id, @result resultValue;"
                , new MySqlParameter("@jsonParams", MySqlDbType.LongText) { Value = jsonParams, ParameterName = "@jsonParams" }
                , new MySqlParameter("@p_cdTipoImp", MySqlDbType.String) { Value = cdTipoImport, ParameterName = "@p_cdTipoImp" }
                ).FirstOrDefaultAsync();

            dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
            return new Result() { id = obj.status, resultValue = ((obj.result == null && obj.status != 200) ? "Erro não especificado!" : obj.result) };
        }
        public async Task<Result> GetAllSituacaoAtualAsync(string jsonParams)
        {
            Result r = await _context.Set<Result>().FromSql<Result>(
                "call getSituacaoAtualByJsonFields(@jsonParams, @result); SELECT 0 id, @result resultValue;"
                , new MySqlParameter("@jsonParams", MySqlDbType.LongText) { Value = jsonParams, ParameterName = "@jsonParams" }
                ).FirstOrDefaultAsync();

            dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
            return new Result() { id = obj.status, resultValue = ((obj.result == null && obj.status != 200) ? "Erro não especificado!" : obj.result) };
        }

        public Result SetImportFaturamento(string json, string dsNomeArquivo, int idUsuario, int idEmpresa)
        {
            try
            {
                Result r = _context.Set<Result>().FromSql<Result>(
                    "call setImportFaturamento(@p_json, @p_dsNomeArquivo, @p_IdEmpresa, @p_idUsuario, @result); SELECT 0 id, @result resultValue;"
                    , new MySqlParameter("@p_json", MySqlDbType.LongText) { Value = json, ParameterName = "@p_json" }
                    , new MySqlParameter("@p_dsNomeArquivo", MySqlDbType.String) { Value = dsNomeArquivo, ParameterName = "@p_dsNomeArquivo" }
                    , new MySqlParameter("@p_IdEmpresa", MySqlDbType.Int32) { Value = idEmpresa, ParameterName = "@p_IdEmpresa" }
                    , new MySqlParameter("@p_idUsuario", MySqlDbType.Int32) { Value = idUsuario, ParameterName = "@p_idUsuario" }
                    ).FirstOrDefault();
                dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
                return new Result() { id = obj.status, resultValue = ((obj.result == null) ? "Erro não especificado!" : obj.result) };

                //return new Result() { id = 200, resultValue = "Teste!" };
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

        public Result ImportCSV(string json, string dsNomeArquivo, int idUsuario, int idEmpresa, string cdTipoImport)
        { 
            try
            {
                Result r;
                switch (cdTipoImport)
                {
                    case "F":
                        r = _context.Set<Result>().FromSql<Result>(
                        "call setImportFaturamento(@p_json, @p_dsNomeArquivo, @p_IdEmpresa, @p_idUsuario, @result); SELECT 0 id, @result resultValue;"
                        , new MySqlParameter("@p_json", MySqlDbType.LongText) { Value = json, ParameterName = "@p_json" }
                        , new MySqlParameter("@p_dsNomeArquivo", MySqlDbType.String) { Value = dsNomeArquivo, ParameterName = "@p_dsNomeArquivo" }
                        , new MySqlParameter("@p_IdEmpresa", MySqlDbType.Int32) { Value = idEmpresa, ParameterName = "@p_IdEmpresa" }
                        , new MySqlParameter("@p_idUsuario", MySqlDbType.Int32) { Value = idUsuario, ParameterName = "@p_idUsuario" }
                        ).FirstOrDefault();
                        break;
                    case "E":
                        r = _context.Set<Result>().FromSql<Result>(
                        "call setImportEstoque(@p_json, @p_dsNomeArquivo, @p_IdEmpresa, @p_idUsuario, @result); SELECT 0 id, @result resultValue;"
                        , new MySqlParameter("@p_json", MySqlDbType.LongText) { Value = json, ParameterName = "@p_json" }
                        , new MySqlParameter("@p_dsNomeArquivo", MySqlDbType.String) { Value = dsNomeArquivo, ParameterName = "@p_dsNomeArquivo" }
                        , new MySqlParameter("@p_IdEmpresa", MySqlDbType.Int32) { Value = idEmpresa, ParameterName = "@p_IdEmpresa" }
                        , new MySqlParameter("@p_idUsuario", MySqlDbType.Int32) { Value = idUsuario, ParameterName = "@p_idUsuario" }
                        ).FirstOrDefault();
                        break;
                    default:
                        r = _context.Set<Result>().FromSql<Result>(
                            "call proc_ImportCSV(@p_json, @p_dsNomeArquivo, @p_IdEmpresa, @p_idUsuario, @p_cdTipoImp, @result); SELECT 0 id, @result resultValue;"
                            , new MySqlParameter("@p_json", MySqlDbType.LongText) { Value = json, ParameterName = "@p_json" }
                            , new MySqlParameter("@p_dsNomeArquivo", MySqlDbType.String) { Value = dsNomeArquivo, ParameterName = "@p_dsNomeArquivo" }
                            , new MySqlParameter("@p_IdEmpresa", MySqlDbType.Int32) { Value = idEmpresa, ParameterName = "@p_IdEmpresa" }
                            , new MySqlParameter("@p_idUsuario", MySqlDbType.Int32) { Value = idUsuario, ParameterName = "@p_idUsuario" }
                            , new MySqlParameter("@p_cdTipoImp", MySqlDbType.String) { Value = cdTipoImport, ParameterName = "@p_cdTipoImp" }
                            ).FirstOrDefault();
                        break;
                }

                dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
                return new Result() { id = obj.status, resultValue = ((obj.result == null) ? "Erro não especificado!" : obj.result) };

                //return new Result() { id = 200, resultValue = "Teste!" };
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