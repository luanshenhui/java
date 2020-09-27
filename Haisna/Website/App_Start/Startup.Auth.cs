using Microsoft.AspNet.Identity;
using Microsoft.Owin;
using Microsoft.Owin.Security.OAuth;
using Owin;
using System;
using Website.Providers;

namespace Website
{
    public partial class Startup
    {
        public void ConfigureAuth(IAppBuilder app)
        {
            app.UseOAuthBearerTokens(new OAuthAuthorizationServerOptions()
            {
                AuthenticationType = DefaultAuthenticationTypes.ExternalBearer,
                AllowInsecureHttp = true,
                TokenEndpointPath = new PathString("/api/token"),
                AccessTokenExpireTimeSpan = TimeSpan.FromDays(1),
                Provider = new ApplicationOAuthProvider(),
            });
        }
    }
}
