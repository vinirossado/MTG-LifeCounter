using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MTG_Common_Helpers.Migrations
{
    /// <inheritdoc />
    public partial class removinglanguagespokentemp : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "LanguagesSpoken",
                table: "Player");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<List<string>>(
                name: "LanguagesSpoken",
                table: "Player",
                type: "text[]",
                nullable: true);
        }
    }
}
