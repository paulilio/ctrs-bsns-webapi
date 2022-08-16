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
using SpreadsheetGear;

namespace CtrsBsnsWebAPI.Data
{
    //artigo: https://codewithshadman.com/repository-pattern-csharp/

    public class RelatorioSpreedSheet<T> : IRelatorioSpreedSheet<T> where T : class
    {
        private readonly ApplicationContext _context;

        public RelatorioSpreedSheet(ApplicationContext context){ _context = context; }

        public async Task<Result> calc()
        {

            try
            {
                //int simulacaoCodigo = Convert.ToInt32(sbase.dadosSimulacao.CodigoSimulacao);
               //int projetoCodigo = Convert.ToInt32(sbase.dadosSimulacao.CodigoProjOrigem);

                //MemoryStream oStream = new MemoryStream();
                //SimuladorEntity.Projeto pro = ProjetosService.GetProjetoById(projetoCodigo);

                //string dll = HttpContext.Current.Request.MapPath("bin") + "\\CoreExSim.dll";
                //string dll = Path.Combine(_hostingEnvironment.WebRootPath, "lib\modelo.xslt");
                string path = AppDomain.CurrentDomain.BaseDirectory.Substring(0, AppDomain.CurrentDomain.BaseDirectory.IndexOf("\\bin"));
                string dll = path + "\\lib\\modelo.xlsx";

                SpreadsheetGear.IWorkbook workbook = SpreadsheetGear.Factory.GetWorkbook(dll, System.Globalization.CultureInfo.CurrentCulture);
                workbook.WorkbookSet.Calculation = Calculation.Automatic;

                return new Result() { id = 0, resultValue = null };

            }
            catch (Exception ex)
            {
                throw ex;
            }

            /*
                        Result r = await _context.Set<Result>().FromSql<Result>(
                            "call getRelConfrontoBanco(@jsonParams, @result); SELECT 0 id, @result resultValue;"
                            , new MySqlParameter("@jsonParams", MySqlDbType.LongText) { Value = jsonParams, ParameterName = "@jsonParams" }
                            ).FirstOrDefaultAsync();

                        dynamic obj = JsonConvert.DeserializeObject(r.resultValue);
                        return new Result() { id = obj.status, resultValue = ((obj.result == null && obj.status != 200) ? "Erro não especificado!" : obj.result) };
            */
        }


    }
}