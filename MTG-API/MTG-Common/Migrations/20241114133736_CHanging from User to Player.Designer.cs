﻿// <auto-generated />
using MTG_Card_Checker;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace MTG_Card_Checker.Migrations
{
    [DbContext(typeof(AppDbContext))]
    [Migration("20241114133736_CHanging from User to Player")]
    partial class CHangingfromUsertoPlayer
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
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

                    b.Property<int>("CardNumber")
                        .HasColumnType("integer");

                    b.Property<string>("ColorIdentity")
                        .HasColumnType("text");

                    b.Property<string>("Condition")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("ExpansionCode")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("ExpansionName")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<bool>("Foil")
                        .HasColumnType("boolean");

                    b.Property<string>("ImageUri")
                        .HasColumnType("text");

                    b.Property<int>("InUse")
                        .HasColumnType("integer");

                    b.Property<bool?>("IsCommander")
                        .HasColumnType("boolean");

                    b.Property<string>("Language")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("OracleId")
                        .HasColumnType("text");

                    b.Property<string>("Price")
                        .HasColumnType("text");

                    b.Property<int>("Quantity")
                        .HasColumnType("integer");

                    b.Property<string>("Rarity")
                        .HasColumnType("text");

                    b.Property<string>("TypeLine")
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.ToTable("Card");
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

                    b.Property<short>("PowerLevel")
                        .HasColumnType("smallint");

                    b.Property<string>("Strategy")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int>("UserId")
                        .HasColumnType("integer");

                    b.HasKey("Id");

                    b.ToTable("Deck");
                });

            modelBuilder.Entity("MTG_Card_Checker.Model.Player", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("DeckName")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Nationality")
                        .IsRequired()
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.ToTable("Player");
                });
#pragma warning restore 612, 618
        }
    }
}
