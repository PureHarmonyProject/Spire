using System.IO;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// Health check
app.MapGet("/health", () => Results.Ok());

// Status code helpers
app.MapGet("/ok", () => Results.Text("OK", "text/plain"));
app.MapGet("/created", () => Results.StatusCode(201));
app.MapGet("/nocontent", () => Results.StatusCode(204));
app.MapGet("/status/{code:int}", (int code) => Results.StatusCode(code));

// Response headers endpoint
app.MapGet("/headers", (HttpResponse res) =>
{
	res.Headers["X-Server"] = "TestServer";
	res.Headers["X-Powered-By"] = "SpireNetHttp-Test";
	return Results.Ok();
});

// Echo request headers (e.g., User-Agent)
app.MapPost("/echo/headers", (HttpRequest req) =>
{
	var ua = req.Headers.UserAgent.ToString();
	return Results.Json(new { userAgent = ua });
});

// Content: JSON
app.MapPost("/content/json", async (HttpRequest req) =>
{
	var isJson = req.ContentType?.StartsWith("application/json", StringComparison.OrdinalIgnoreCase) == true;
	if (!isJson) return Results.BadRequest();
	using var reader = new StreamReader(req.Body);
	var body = await reader.ReadToEndAsync();
	return Results.Json(new { ok = true, body });
});

// Content: XML
app.MapPost("/content/xml", async (HttpRequest req) =>
{
	var isXml = req.ContentType?.StartsWith("application/xml", StringComparison.OrdinalIgnoreCase) == true;
	if (!isXml) return Results.BadRequest();
	using var reader = new StreamReader(req.Body);
	var body = await reader.ReadToEndAsync();
	return Results.Text(body, "application/xml");
});

// Content: x-www-form-urlencoded
app.MapPost("/content/form", async (HttpRequest req) =>
{
	var form = await req.ReadFormAsync();
	var dict = form.ToDictionary(kv => kv.Key, kv => kv.Value.ToString());
	return Results.Json(dict);
});

// Content: multipart/form-data
app.MapPost("/content/multipart", async (HttpRequest req) =>
{
	var isMulti = req.ContentType?.StartsWith("multipart/form-data", StringComparison.OrdinalIgnoreCase) == true;
	if (!isMulti) return Results.BadRequest();
	var form = await req.ReadFormAsync();
	var count = form.Files.Count + form.Count;
	return Results.Json(new { count });
});

// Delay endpoint for timeout testing
app.MapGet("/delay/{ms:int}", async (int ms) =>
{
	await Task.Delay(ms);
	return Results.Ok();
});

var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/weatherforecast", () =>
{
    var forecast =  Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
})
.WithName("GetWeatherForecast");

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
