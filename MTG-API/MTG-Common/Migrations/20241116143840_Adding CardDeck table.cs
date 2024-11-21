using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace MTG_Card_Checker.Migrations
{
    /// <inheritdoc />
    public partial class AddingCardDecktable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DeckName",
                table: "Player");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "Deck",
                newName: "PlayerId");

            migrationBuilder.CreateTable(
                name: "CardDeck",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DeckId = table.Column<int>(type: "integer", nullable: false),
                    CardId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CardDeck", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CardDeck_Card_CardId",
                        column: x => x.CardId,
                        principalTable: "Card",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CardDeck_Deck_DeckId",
                        column: x => x.DeckId,
                        principalTable: "Deck",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Deck_PlayerId",
                table: "Deck",
                column: "PlayerId");

            migrationBuilder.CreateIndex(
                name: "IX_CardDeck_CardId",
                table: "CardDeck",
                column: "CardId");

            migrationBuilder.CreateIndex(
                name: "IX_CardDeck_DeckId",
                table: "CardDeck",
                column: "DeckId");

            migrationBuilder.AddForeignKey(
                name: "FK_Deck_Player_PlayerId",
                table: "Deck",
                column: "PlayerId",
                principalTable: "Player",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deck_Player_PlayerId",
                table: "Deck");

            migrationBuilder.DropTable(
                name: "CardDeck");

            migrationBuilder.DropIndex(
                name: "IX_Deck_PlayerId",
                table: "Deck");

            migrationBuilder.RenameColumn(
                name: "PlayerId",
                table: "Deck",
                newName: "UserId");

            migrationBuilder.AddColumn<string>(
                name: "DeckName",
                table: "Player",
                type: "text",
                nullable: false,
                defaultValue: "");
        }
    }
}
