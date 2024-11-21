using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MTG_Card_Checker.Migrations
{
    /// <inheritdoc />
    public partial class ChangingCardentity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsCommander",
                table: "Card");

            migrationBuilder.DropColumn(
                name: "ManaCost",
                table: "Card");

            migrationBuilder.AlterColumn<string>(
                name: "Rarity",
                table: "Card",
                type: "text",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AlterColumn<string>(
                name: "Price",
                table: "Card",
                type: "text",
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "numeric");

            migrationBuilder.AlterColumn<double>(
                name: "CMC",
                table: "Card",
                type: "double precision",
                nullable: false,
                oldClrType: typeof(float),
                oldType: "real");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "Rarity",
                table: "Card",
                type: "integer",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<decimal>(
                name: "Price",
                table: "Card",
                type: "numeric",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<string>(
                name: "ColorIdentity",
                table: "Card",
                type: "text",
                nullable: false,
                oldClrType: typeof(string[]),
                oldType: "text[]");

            migrationBuilder.AlterColumn<float>(
                name: "CMC",
                table: "Card",
                type: "real",
                nullable: false,
                oldClrType: typeof(double),
                oldType: "double precision");

            migrationBuilder.AddColumn<bool>(
                name: "IsCommander",
                table: "Card",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "ManaCost",
                table: "Card",
                type: "text",
                nullable: false,
                defaultValue: "");
        }
    }
}
