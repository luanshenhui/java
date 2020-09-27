using Hainsi.Common.ApiResponse;
using Hainsi.Entity;
using Hainsi.ReportCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.SpaServices.Webpack;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Serialization;
using Oracle.ManagedDataAccess.Client;
using Swashbuckle.AspNetCore.Swagger;
using System;
using System.Data;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using Website;

namespace WebSite
{
    /// <summary>
    /// Startupクラス
    /// </summary>
    public class Startup
    {
        /// <summary>
        /// アプリケーション構成情報を取得します。
        /// </summary>
        public IConfiguration Configuration { get; }

        /// <summary>
        /// コンストラクター
        /// </summary>
        /// <param name="configuration"></param>
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        /// <summary>
        /// コンテナへのサービスの追加
        /// </summary>
        /// <param name="services">サービス情報のコレクション</param>
        public void ConfigureServices(IServiceCollection services)
        {
            // CORSを有効にしてクロスドメインからのアクセスに対応する
            services.AddCors();

            services
                .AddMvc()
                .AddJsonOptions(options =>
                {
                    options.SerializerSettings.ContractResolver = new DefaultContractResolver
                    {
                        NamingStrategy = new LowerCaseNamingStrategy
                        {
                            ProcessDictionaryKeys = true
                        }
                    };
                })
                .AddSessionStateTempDataProvider();

            services.AddSession();

            services.AddSingleton(Configuration);

            services.AddScoped<IDbConnection, OracleConnection>(provider => new OracleConnection(Configuration.GetSection("ConnectionStrings")["DefaultConnection"]));

            // daoのサービスへの登録
            services
                .AddScoped<AbsenceOrgBillDao>()
                .AddScoped<BbsDao>()
                .AddScoped<BillDao>()
                .AddScoped<CalcDao>()
                .AddScoped<CalendarDao>()
                .AddScoped<CheckAuthorityDao>()
                .AddScoped<ClientPostDao>()
                .AddScoped<ConfigDao>()
                .AddScoped<ConsultAllDao>()
                .AddScoped<ConsultDao>()
                .AddScoped<ConsultJnlDao>()
                .AddScoped<ContractControlDao>()
                .AddScoped<ContractDao>()
                .AddScoped<CooperationConsultAllDao>()
                .AddScoped<CooperationDao>()
                .AddScoped<CourseDao>()
                .AddScoped<DecideAllConsultPriceDao>()
                .AddScoped<DemandDao>()
                .AddScoped<DiseaseDao>()
                .AddScoped<DmdAddUpControlDao>()
                .AddScoped<DmdAddUpDao>()
                .AddScoped<DmdClassDao>()
                .AddScoped<ExecDao>()
                .AddScoped<ExternalDeviceResultDao>()
                .AddScoped<FailSafeDao>()
                .AddScoped<FollowDao>()
                .AddScoped<FreeDao>()
                .AddScoped<GrpDao>()
                .AddScoped<GuidanceDao>()
                .AddScoped<HainsLogDao>()
                .AddScoped<HainsUserDao>()
                .AddScoped<ImportCsvDao>()
                .AddScoped<InterviewDao>()
                .AddScoped<ItemClassDao>()
                .AddScoped<ItemDao>()
                .AddScoped<JudClassDao>()
                .AddScoped<JudCmtStcDao>()
                .AddScoped<JudDao>()
                .AddScoped<JudgementControlDao>()
                .AddScoped<JudgementDao>()
                .AddScoped<MailConsultDao>()
                .AddScoped<MngAccuracyDao>()
                .AddScoped<MorningReportDao>()
                .AddScoped<NourishmentDao>()
                .AddScoped<NutritionCalcDao>()
                .AddScoped<OrderedDocDao>()
                .AddScoped<OrderJnlDao>()
                .AddScoped<OrderReportDao>()
                .AddScoped<OrganizationDao>()
                .AddScoped<OrgBillClassDao>()
                .AddScoped<PaymentAutoDao>()
                .AddScoped<PaymentImportCsvDao>()
                .AddScoped<PerAddrDao>()
                .AddScoped<PerBillDao>()
                .AddScoped<PerResultDao>()
                .AddScoped<PersonDao>()
                .AddScoped<PersonJnlDao>()
                .AddScoped<PgmInfoDao>()
                .AddScoped<PrefDao>()
                .AddScoped<PrivacyInfoDao>()
                .AddScoped<ProgressDao>()
                .AddScoped<PubNoteDao>()
                .AddScoped<ReportCtlDao>()
                .AddScoped<ReportDao>()
                .AddScoped<ReportLogDao>()
                .AddScoped<ReportSendDateDao>()
                .AddScoped<ReqSendCheckDao>()
                .AddScoped<ResultDao>()
                .AddScoped<RslCmtDao>()
                .AddScoped<ScheduleDao>()
                .AddScoped<ScreeningDao>()
                .AddScoped<SecondBillDao>()
                .AddScoped<SenderDao>()
                .AddScoped<SendOrderDao>()
                .AddScoped<SentenceDao>()
                .AddScoped<SetClassDao>()
                .AddScoped<SpecialInterviewDao>()
                .AddScoped<StdContactStcDao>()
                .AddScoped<StdJudDao>()
                .AddScoped<StdValueDao>()
                .AddScoped<TemplateDao>()
                .AddScoped<TruncateDao>()
                .AddScoped<WebOrgRsvDao>()
                .AddScoped<WebRsvDao>()
                .AddScoped<WorkStationDao>()
                .AddScoped<YudoDao>()
                .AddScoped<ZipDao>()
                .AddScoped<OrgGrpDao>()
                .AddScoped<RequestCardDao>()
                .AddScoped<QuestionnaireDao>()
                .AddScoped<Questionnaire1Dao>()
                .AddScoped<Questionnaire2Dao>()
                .AddScoped<Questionnaire3Dao>();;

            services
                .AddScoped<ReportManager>();

#if DEBUG
            // SwaggerGenサービスの登録
            services.AddSwaggerGen(option =>
            {
                option.SwaggerDoc("hainsi", new Info { Title = "Hainsi API Specification", Version = "v1" });

                // タグの定義
                option.TagActionsBy(desc =>
                {
                    // 相対パスから最初のリソース名部分を抽出し、タグ名とする
                    var reg = new Regex("api/v1/(?<resourse>[^/]+)");
                    Match match = reg.Match(desc.RelativePath);
                    return match.Success ? match.Groups["resourse"].Value : null;
                });

                // ソート順の定義
                option.OrderActionsBy(desc =>
                {
                    // 相対パス＋リクエストメソッド名とする
                    return desc.RelativePath + "," + desc.HttpMethod;
                });

                // XMLコメント情報を追加
                string basePath = AppContext.BaseDirectory;
                option.IncludeXmlComments(Path.Combine(basePath, "Model.xml"));
                option.IncludeXmlComments(Path.Combine(basePath, "Entity.xml"));
                option.IncludeXmlComments(Path.Combine(basePath, "Website.xml"));
            });
#endif

        }

        /// <summary>
        /// HTTP Requestのパイプライン構成
        /// </summary>
        /// <param name="app">IApplicationBuilderインスタンス</param>
        /// <param name="env">IHostingEnvironmentインスタンス</param>
        /// <param name="loggerFactory">ILoggerFactoryインスタンス</param>
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            // CORSの設定、全て許可するように設定
            app.UseCors(builder =>
                builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()
            );
            // イベントログにログを出力するように設定
            loggerFactory.AddEventLog(LogLevel.Error);

            // カスタム例外ハンドラの追加
            app.UseExceptionHandler(options =>
            {
                // 例外が発生した際にステータスコードとJSONとをレスポンスで返すための実装
                options.Run(async context =>
                {
                    string responseText = null;
                    // 発生した例外を取得
                    var ex = context.Features.Get<IExceptionHandlerFeature>();
                    // 例外が存在する場合はその内容をJSONシリアライズ
                    if (ex != null)
                    {
                        responseText = ex.Error.Message.ToErrorMessage();
                    }

                    // レスポンスデータの編集
                    context.Response.ContentType = "application/json";
                    context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                    if (responseText != null)
                    {
                        await context.Response.WriteAsync(responseText);
                    }
                });
            });
#if DEBUG
            if (env.IsDevelopment())
            {
                // webpackdevミドルウェアサポートを有効にする
                // (webpackによるバンドル処理が自動で行われるようになる)
                app.UseWebpackDevMiddleware(new WebpackDevMiddlewareOptions
                {
                    HotModuleReplacement = true,
                });

                // Swaggerミドルウェアの登録
                app.UseSwagger();
                app.UseSwaggerUI(option =>
                {
                    option.SwaggerEndpoint("/swagger/hainsi/swagger.json", "Hainsi API");
                });
            }
#endif


            app.UseStaticFiles();

            app.UseSession();

            app.MapWhen(x => !x.Request.Path.Value.StartsWith("/swagger", StringComparison.OrdinalIgnoreCase), builder =>
                builder.UseMvc(routes =>
                {
                    routes.MapRoute(
                        name: "login",
                        template: "login",
                        defaults: new { controller = "Home", action = "Login" });

                    routes.MapSpaFallbackRoute(
                        name: "spa-fallback",
                        defaults: new { controller = "Home", action = "Index" });
                })
            );
        }
    }
}
