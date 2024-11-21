using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MTG_Common_Helpers.Migrations
{
    /// <inheritdoc />
    public partial class Remapingentity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CardNumber",
                table: "Card");

            migrationBuilder.DropColumn(
                name: "Condition",
                table: "Card");

            migrationBuilder.DropColumn(
                name: "ExpansionCode",
                table: "Card");

            migrationBuilder.DropColumn(
                name: "ExpansionName",
                table: "Card");

            migrationBuilder.DropColumn(
                name: "Foil",
                table: "Card");

            migrationBuilder.DropColumn(
                name: "InUse",
                table: "Card");

            migrationBuilder.DropColumn(
                name: "Language",
                table: "Card");

            migrationBuilder.DropColumn(
                name: "Quantity",
                table: "Card");

            migrationBuilder.AddColumn<List<string>>(
                name: "LanguagesSpoken",
                table: "Player",
                type: "text[]",
                nullable: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "LanguagesSpoken",
                table: "Player");

            migrationBuilder.AddColumn<int>(
                name: "CardNumber",
                table: "Card",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Condition",
                table: "Card",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ExpansionCode",
                table: "Card",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ExpansionName",
                table: "Card",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Foil",
                table: "Card",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "InUse",
                table: "Card",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Language",
                table: "Card",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Quantity",
                table: "Card",
                type: "integer",
                nullable: true);
        }
    }
}
