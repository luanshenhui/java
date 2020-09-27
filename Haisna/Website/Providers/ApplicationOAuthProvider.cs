using Hainsi.Entity;
using Microsoft.Owin.Security.OAuth;
using Newtonsoft.Json.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace Website.Providers
{
    public class ApplicationOAuthProvider : OAuthAuthorizationServerProvider
    {
        public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            context.Validated();
            return Task.FromResult(0);
        }

        public override Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
			// DAOメソッドへ渡す形式を生成
			var token = new JObject
			{
				{ "username", context.UserName },
				{ "password", context.Password },
			};

			var dao = new HainsUserDao();
			// バリデーションチェック
			if (dao.Validate(token) == null)
			{
				context.Rejected();
				return Task.FromResult(0);
			}
			
			// 認証ロジック
			if (dao.CheckIDandPassword(token) != null)
            {
                // context.Options.AuthenticationTypeを使ってClaimsIdentityを作る
                var identity = new ClaimsIdentity(context.Options.AuthenticationType);
                // 必要なClaimを追加しておく。
                identity.AddClaims(new[]
                {
                        new Claim(ClaimTypes.GivenName, context.UserName.Trim()),
                        new Claim(ClaimTypes.Role, "User"),
                        new Claim(ClaimTypes.Role, "Admin")
                    });
                context.Validated(identity);
            }
            else
            {
                context.Rejected();
            }
            return Task.FromResult(0);
        }
    }
}