using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MTG_Card_Checker.Migrations
{
    /// <inheritdoc />
    public partial class AddingisCommanderpropert : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsCommander",
                table: "Card",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsCommander",
                table: "Card");
        }
    }
}
