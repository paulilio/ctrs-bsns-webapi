using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using CtrsBsnsWebAPI.Model;
//using System.Data.Entity;

namespace CtrsBsnsWebAPI.Data
{
    /*
    public static DbConnection GetMySqlConnection(string connectionString)
    {
        var connectionFactory = new MySqlConnectionFactory();

        return connectionFactory.CreateConnection(connectionString);
    }

    public class CodeConfig : DbConfiguration
    {
        public CodeConfig()
        {
            SetDefaultConnectionFactory(new MySql.Data.Entity.MySqlConnectionFactory());
            SetProviderServices("MySql.Data.MySqlClient", new MySql.Data.MySqlClient.MySqlProviderServices());

        }
    }

    */

    public class Result
    {
        [Key]
        public int id { get; set; }
        public string resultValue { get; set; }
    }

    public class ApplicationContext : DbContext
    {
        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    optionsBuilder.UseMySql(@"server=localhost;database=BookStoreDb;uid=root;password=;");
        //}

        public ApplicationContext(DbContextOptions<ApplicationContext> options) : base(options)
        {
       }
       public DbSet<Sales> Sales { get; set; }
       public DbSet<Result> Result { get; set; }

        //public DbSet<SalesModel> Sales { get; set; }

        //public ApplicationContext(string conn) : base(conn)
        //{
        //}
        //public DbSet<SalesModel> Sales { get; set; }
    }

}
