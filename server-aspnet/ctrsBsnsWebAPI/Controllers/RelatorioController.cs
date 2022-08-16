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
    public class RelatorioController : ControllerBase
    {
        public IRelatorioRepository<ApplicationContext> _repo { get; }
        public IRelatorioSpreedSheet<ApplicationContext> _sheet { get; }
        public RelatorioController(IRelatorioRepository<ApplicationContext> repo, IRelatorioSpreedSheet<ApplicationContext> sheet) {_repo = repo; _sheet = sheet; }

        //CONFRONTO DE DADOS
        [HttpGet("GetRelConfrontoFiltro")]
        [Route("GetRelConfrontoFiltro")]
        public async Task<ActionResult<IEnumerable<string>>> GetRelConfrontoFiltro(string jsonParams)
        {
            try
            {
                Result _result = await _repo.GetRelConfrontoFiltro(jsonParams);

                if (_result.id == 200)
                    return this.Ok(_result.resultValue);
                else
                    throw new System.InvalidOperationException(_result.resultValue);
            }
            catch (InvalidOperationException ex)
            {
                return this.StatusCode(StatusCodes.Status500InternalServerError, "Banco de Dados Falhou: " + ex.Message);
            }

            catch (Exception ex)
            {
                throw;
            }
        }

        [HttpPost("GetRelConfronto")]
        [Route("GetRelConfronto")]
        public async Task<ActionResult<IEnumerable<string>>> GetRelConfronto(dynamic data)
        {
            try
            {
                JsonElement jsonResult = data;
                string jsonParams = JObject.Parse(jsonResult.GetRawText()).SelectToken("$.params").ToString();
                Result _result = await _repo.GetRelConfronto(jsonParams);

                if (_result.id == 200)
                    return this.Ok(_result.resultValue);
                else
                    throw new System.InvalidOperationException(_result.resultValue);
            }
            catch (InvalidOperationException ex)
            {
                return this.StatusCode(StatusCodes.Status500InternalServerError, "Banco de Dados Falhou: " + ex.Message);
            }
            catch (Exception ex)
            {
                throw;
            }
        }


        [HttpPost("GetRelConfrontoBanco")]
        [Route("GetRelConfrontoBanco")]
        public async Task<ActionResult<IEnumerable<string>>> GetRelConfrontoBanco(dynamic data)
        {
            try
            {
                JsonElement jsonResult = data;
                string jsonParams = JObject.Parse(jsonResult.GetRawText()).SelectToken("$.params").ToString();
                Result _result = await _repo.GetRelConfrontoBanco(jsonParams);

                if (_result.id == 200)
                    return this.Ok(_result.resultValue);
                else
                    throw new System.InvalidOperationException(_result.resultValue);
            }
            catch (InvalidOperationException ex)
            {
                return this.StatusCode(StatusCodes.Status500InternalServerError, "Banco de Dados Falhou: " + ex.Message);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        //CONFRONTO DE DADOS
        [HttpGet("GetRelEstoque")]
        [Route("GetRelEstoque")]
        public async Task<ActionResult<IEnumerable<string>>> GetRelEstoque(dynamic data)
        {
            try
            {

                //Result _result = await _sheet.calc();

                JsonElement jsonResult = data;
                string jsonParams = JObject.Parse(jsonResult.GetRawText()).SelectToken("$.params").ToString();
                Result _result = await _repo.GetRelEstoque(jsonParams);

                if (_result.id == 200)
                    return this.Ok(_result.resultValue);
                else
                    throw new System.InvalidOperationException(_result.resultValue);
            }
            catch (InvalidOperationException ex)
            {
                return this.StatusCode(StatusCodes.Status500InternalServerError, "Banco de Dados Falhou: " + ex.Message);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

    }

}