using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MTG_Card_Checker.Migrations
{
    /// <inheritdoc />
    public partial class AddingRegixaToDb : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Regixa",
                table: "Card",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Regixa",
                table: "Card");
        }
    }
}
