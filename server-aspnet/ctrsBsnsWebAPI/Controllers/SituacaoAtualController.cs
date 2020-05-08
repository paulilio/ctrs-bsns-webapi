using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using CtrsBsnsWebAPI.Data;
using Newtonsoft.Json.Linq;
using System.Text.Json;

namespace CtrsBsnsWebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SituacaoAtualController : ControllerBase
    {
        public IRepository<ApplicationContext> _repo { get; }
        
        //Test: HttpPost: api/situacaoatual/importcsv?csv=
        [HttpPost]
        [Route("importcsv")]
        public ActionResult<IEnumerable<string>> (dynamic data)
        {
            try
            {
                JsonElement jsonResult = data;
                string json = JObject.Parse(jsonResult.GetRawText()).SelectToken("$.csv").ToString();

                Result _result = _repo.SaveSalesImport(json);

                if (_result.id == 200)
                    return this.Ok();
                else
                    throw new System.InvalidOperationException(_result.resultValue);
            }
            catch (InvalidOperationException ex)
            {
                //code specifically for a ArgumentNullException
                return this.StatusCode(StatusCodes.Status500InternalServerError, "Banco de Dados Falhou: " + ex.Message);
                //return BadRequest();
            }

            catch (Exception ex)
            {
                //return this.StatusCode(StatusCodes.Status400BadRequest);
                throw;
            }

        }
    }