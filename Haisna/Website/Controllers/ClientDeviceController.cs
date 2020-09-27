using Microsoft.AspNetCore.Mvc;

#pragma warning disable CS1591

namespace Hainsi.Controllers
{
    public class ClientDeviceController : Controller
    {
        // GET: ClientDevice
        public IActionResult Index()
        {
            return View();
        }
    }
}