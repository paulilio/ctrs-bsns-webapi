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

    public class RelatorioRepository<T> : IRelatorioRepository<T> where T : class
    {
        private readonly ApplicationContext _context;

        public RelatorioRepository(ApplicationContext context){ _context = context; }

        //CONFRONTO DE DADOS
        public async Task<Result> GetRelConfrontoFiltro(string jsonParams)
        {
            Result r = await _context.Set<Result>().FromSql<Result>(
                "call getRelConfrontoFiltro(@jsonParams, @result); SELECT 0 id, @result resultValue;"
                , new MySqlParameter("@jsonParams", MySqlDbType.LongText) { Value = jsonParams, ParameterName = "@jsonParams" }
                ).FirstOrDefaultAsync();

            dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
            return new Result() { id = obj.status, resultValue = ((obj.result == null) ? "Erro não especificado!" : obj.result) };
        }

        public async Task<Result> GetRelConfronto(string jsonParams)
        {
            Result r = await _context.Set<Result>().FromSql<Result>(
                "call getRelConfronto(@jsonParams, @result); SELECT 0 id, @result resultValue;"
                , new MySqlParameter("@jsonParams", MySqlDbType.LongText) { Value = jsonParams, ParameterName = "@jsonParams" }
                ).FirstOrDefaultAsync();

            dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
            return new Result() { id = obj.status, resultValue = ((obj.result == null && obj.status != 200) ? "Erro não especificado!" : obj.result) };
        }

        public async Task<Result> GetRelConfrontoBanco(string jsonParams)
        {
            Result r = await _context.Set<Result>().FromSql<Result>(
                "call getRelConfrontoBanco(@jsonParams, @result); SELECT 0 id, @result resultValue;"
                , new MySqlParameter("@jsonParams", MySqlDbType.LongText) { Value = jsonParams, ParameterName = "@jsonParams" }
                ).FirstOrDefaultAsync();

            dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
            return new Result() { id = obj.status, resultValue = ((obj.result == null && obj.status != 200) ? "Erro não especificado!" : obj.result) };
        }

        public async Task<Result> GetRelEstoque(string jsonParams)
        {
            Result r = await _context.Set<Result>().FromSql<Result>(
                "call getRelEstoque(@jsonParams, @result); SELECT 0 id, @result resultValue;"
                , new MySqlParameter("@jsonParams", MySqlDbType.LongText) { Value = jsonParams, ParameterName = "@jsonParams" }
                ).FirstOrDefaultAsync();

            dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
            return new Result() { id = obj.status, resultValue = ((obj.result == null && obj.status != 200) ? "Erro não especificado!" : obj.result) };
        }

    }
}