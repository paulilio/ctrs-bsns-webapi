using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using CtrsBsnsWebAPI.Model;

namespace CtrsBsnsWebAPI.Data
{
    public interface IRelatorioSpreedSheet<T> where T : class
    {
        Task<Result> calc();

    }
}