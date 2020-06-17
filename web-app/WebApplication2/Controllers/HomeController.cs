using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using WebApplication2.Models;

namespace WebApplication2.Controllers
{
    public class HomeController : Controller
    {
        private static readonly HttpClient client = new HttpClient();
        private readonly IConfiguration Configuration;

        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger, IConfiguration configuration)
        {
            _logger = logger;
            Configuration = configuration;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public async Task<ContentResult> Aci()
        {
            var stringTask = client.GetStringAsync(Configuration["targeturl"]);
            var msg = await stringTask;
            return Content(msg);
        }

        public async Task<ContentResult> WebApp()
        {
            var stringTask = client.GetStringAsync(Configuration["webtargeturl"]);
            var msg = await stringTask;
            return Content(msg);
        }

        public async Task<ContentResult> MyIp()
        {
            var stringTask = client.GetStringAsync(Configuration["externalurl"]);
            var msg = await stringTask;
            return Content(msg);
        }

        public async Task<ContentResult> Blocked()
        {
            var stringTask = client.GetStringAsync(Configuration["blockedurl"]);
            var msg = await stringTask;
            return Content(msg);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
