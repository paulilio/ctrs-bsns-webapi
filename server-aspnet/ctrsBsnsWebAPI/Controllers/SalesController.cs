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
    public class SalesController : ControllerBase
    {
        public IRepository<ApplicationContext> _repo { get; }
        public SalesController(IRepository<ApplicationContext> repo)
        {
            _repo = repo;
        }

        // GET api/sales
        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            return new string[] { "valueA", "valueB" };
        }

        [HttpGet("ByProfessor/{ProfessorId}")]
        public ActionResult<IEnumerable<string>> GetByProfessorId()
        {
            return new string[] { "valueC", "valueD" };
        }

        // POST: api/Todo
        [HttpPost]
        public ActionResult PostTodoItem()
        {
            return this.Ok();
        }

        [HttpGet("ByFields/{search}")]
        public ActionResult<IEnumerable<string>> GetByFields()
        {
            return new string[] { "valueC", "valueD" };
        }

        // HttpPost: api/sales/ImportCSV?csv=
        [HttpPost]
        [Route("ImportCSV")]
        public ActionResult<IEnumerable<string>> ImportCSV(dynamic data)
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
}
