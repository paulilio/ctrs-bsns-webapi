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
        public SituacaoAtualController(IRepository<ApplicationContext> repo)
        {
            _repo = repo;
        }

        //Test: HttpPost: situacaoatual/GetFiltro jsonParams
        [HttpGet("GetFiltro")]
        [Route("GetFiltro")]
        public async Task<ActionResult<IEnumerable<string>>> GetFiltro(string jsonParams)
        {
            try
            {
                Result _result = await _repo.GetFiltros(jsonParams);

                if (_result.id == 200)
                    return this.Ok(_result.resultValue);
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

        [HttpPost]
        [Route("GetList2")]
        public string GetList2([FromBody] dynamic data)
        {
            JsonElement jsonResult = data;
            return JObject.Parse(jsonResult.GetRawText()).SelectToken("$").ToString();
        }

        //Test: HttpPost: situacaoatual/GetList jsonParams
        [HttpPost("GetList")]
        [Route("GetList")]
        public async Task<ActionResult<IEnumerable<string>>> GetList(dynamic data)
        {
            try
            {
                JsonElement jsonResult = data;
                string jsonParams = JObject.Parse(jsonResult.GetRawText()).SelectToken("$.params").ToString();
                Result _result = await _repo.GetAllSituacaoAtualAsync(jsonParams);

                if (_result.id == 200)
                    return this.Ok(_result.resultValue);
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

        //Test: HttpPost: api/situacaoatual/Importcsv?data=
        [HttpPost]
        [Route("Importcsv")]
        public ActionResult<IEnumerable<string>> Importcsv(dynamic data)
        {
            try
            {
                JsonElement jsonResult = data;
                Result _result = _repo.ImportCSV(
                      JObject.Parse(jsonResult.GetRawText()).SelectToken("$.csv").ToString()
                    , JObject.Parse(jsonResult.GetRawText()).SelectToken("$.dsNomeArquivo").ToString()
                    , Convert.ToInt32(JObject.Parse(jsonResult.GetRawText()).SelectToken("$.idUsuario"))
                    , Convert.ToInt32(JObject.Parse(jsonResult.GetRawText()).SelectToken("$.idEmpresa"))
                    , Convert.ToChar(JObject.Parse(jsonResult.GetRawText()).SelectToken("$.cdTipo").ToString())
                    );

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

}