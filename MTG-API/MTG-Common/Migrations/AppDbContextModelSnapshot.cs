﻿// <auto-generated />
using MTG_Card_Checker;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace MTG_Card_Checker.Migrations
{
    [DbContext(typeof(AppDbContext))]
    partial class AppDbContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "9.0.0-rc.2.24474.1")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("MTG_Card_Checker.Model.Card", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<double?>("CMC")
                        .HasColumnType("double precision");

                    b.Property<string>("ColorIdentity")
                        .HasColumnType("text");

                    b.Property<string>("ImageUri")
                        .HasColumnType("text");

                    b.Property<bool?>("IsCommander")
                        .HasColumnType("boolean");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("OracleId")
                        .HasColumnType("text");

                    b.Property<string>("Price")
                        .HasColumnType("text");

                    b.Property<string>("Rarity")
                        .HasColumnType("text");

                    b.Property<string>("TypeLine")
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.ToTable("Card");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.CardDeck", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<int>("CardId")
                        .HasColumnType("integer");

                    b.Property<int>("DeckId")
                        .HasColumnType("integer");

                    b.HasKey("Id");

                    b.HasIndex("CardId");

                    b.HasIndex("DeckId");

                    b.ToTable("CardDeck");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.Deck", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int>("PlayerId")
                        .HasColumnType("integer");

                    b.Property<short>("PowerLevel")
                        .HasColumnType("smallint");

                    b.Property<string>("Strategy")
                        .IsRequired()
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("PlayerId");

                    b.ToTable("Deck");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.Player", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Nationality")
                        .IsRequired()
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.ToTable("Player");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.CardDeck", b =>
                {
                    b.HasOne("MTG_Card_Checker.Model.Card", "Card")
                        .WithMany("CardDecks")
                        .HasForeignKey("CardId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("MTG_Card_Checker.Model.Deck", "Deck")
                        .WithMany("CardDecks")
                        .HasForeignKey("DeckId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Card");

                    b.Navigation("Deck");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.Deck", b =>
                {
                    b.HasOne("MTG_Card_Checker.Model.Player", "Player")
                        .WithMany("Decks")
                        .HasForeignKey("PlayerId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Player");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.Card", b =>
                {
                    b.Navigation("CardDecks");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.Deck", b =>
                {
                    b.Navigation("CardDecks");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.Player", b =>
                {
                    b.Navigation("Decks");
                });
#pragma warning restore 612, 618
        }
    }
}
