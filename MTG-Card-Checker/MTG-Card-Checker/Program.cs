using Microsoft.EntityFrameworkCore;
using MTG_Card_Checker;
using MTG_Card_Checker.Repository;
using MTG_Card_Checker.Repository.External.Scryfall;

var builder = WebApplication.CreateBuilder(args);

// Register controllers, Swagger, and other services

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSpecificOrigins",
        builder =>
        {
            builder.WithOrigins("http://localhost", "http://riv-jnx3fx2rxy.local", "http://192.168.1.216")
                .AllowAnyHeader()
                .AllowAnyMethod();
        });
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddMemoryCache();

// Register DbContext with DI container
var configuration = builder.Configuration;
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(configuration.GetConnectionString("DefaultConnection")));

// Register ImportRepository with DI container
builder.Services.AddScoped<CardService>();
builder.Services.AddScoped<CardRepository>();
builder.Services.AddScoped<PlayerService>();
builder.Services.AddScoped<ScryfallService>();
builder.Services.AddScoped<PlayerRepository>();
builder.Services.AddScoped<DeckService>();
builder.Services.AddScoped<DeckRepository>();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors("AllowSpecificOrigins");

app.UseHttpsRedirection();
app.MapControllers();

app.Run();