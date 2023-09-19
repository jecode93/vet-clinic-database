/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon%';
SELECT * from animals WHERE date_of_birth BETWEEN '2016-10-01' AND '2019-10-01';
SELECT * from animals WHERE neutered = true AND escape_attemps < 3;
SELECT date_of_birth from animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attemps from animals WHERE weight_kg > 10.5;
SELECT name from animals WHERE neutered = true;
SELECT name from animals WHERE name NOT IN ('Gabumon');
SELECT name from animals WHERE weight_kg = 10.4 AND weight_kg = 17.3 OR weight_kg BETWEEN 10.4 AND 17.3;
