using System.Web.Mvc;
using System.Web.Routing;

namespace Website
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

			// すべてのURLをHomeコントローラに集約する
			// (実際のルーティングはフロントエンドで行う)
			routes.MapRoute(
				name: "Login",
				url: "login",
				defaults: new { controller = "Home", action = "Login" }
			);
			routes.MapRoute(
                name: "Default",
                url: "{*url}",
                defaults: new { controller = "Home", action = "Index" }
            );
		}
    }
}
