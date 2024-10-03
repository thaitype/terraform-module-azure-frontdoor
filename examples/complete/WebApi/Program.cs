var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var app_id = Environment.GetEnvironmentVariable("APP_ID") ?? "UNKNOWN";
app.MapGet("/", () => "Hello from " + app_id);

app.Run();
