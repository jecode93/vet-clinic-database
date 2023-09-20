/* Populate database with sample data. */

-- FROM LAST DAY PROJECT --
INSERT INTO animals (name, date_of_birth, escape_attemps, neutered, weight_kg)
VALUES
('Agumon', '2020-02-03', 0, true, 10.23),
('Gabumon', '2010-11-15', 2, true, 8),
('Pikachu', '2021-01-07', 1, false, 15.04),
('Devimon', '2017-05-12', 5, true, 11);



-- FOR YESTERDAY PROJECT --
INSERT INTO animals (name, date_of_birth, escape_attemps, neutered, weight_kg)
VALUES
('Charmander', '2020-02-08', 0, false, -11),
('Plantmon', '2021-11-15', 2, true, -5.7),
('Squirtle', '1993-04-02', 3, false, -12.13),
('Angemon', '2005-06-12', 1, true, -45),
('Boarmon', '2005-06-07', 7, true, 20.4),
('Blossom', '1998-10-13', 3, true, 17),
('Ditto', '2022-05-14', 4, true, 22);



-- Vet clinic database: query multiple tables

-- Insert the following data into the owners table:
INSERT INTO owners (full_name, age)
VALUES
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob ', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);


-- Insert the following data into the species table:
INSERT INTO species (name)
VALUES
('Pokemon'),
('Digimon');

-- Verify owner and species
SELECT * FROM owners;
SELECT * FROM species;


-- Modify your inserted animals so it includes the species_id value:

-- If the name ends in "mon" it will be Digimon
UPDATE animals 
SET species_id = (SELECT id from species WHERE name = 'Digimon')
WHERE name LIKE '%mon';

-- All other animals are Pokemon
UPDATE animals 
SET species_id = (SELECT id from species WHERE name = 'Pokemon')
WHERE species_id IS NULL;

-- Verify
SELECT id, name, species_id FROM animals;



-- Modify your inserted animals to include owner information (owner_id):

-- Sam Smith owns Agumon.
UPDATE animals 
SET owner_id = (SELECT id from owners WHERE full_name = 'Sam Smith')
WHERE name = 'Agumon'; 

-- Jennifer Orwell owns Gabumon and Pikachu.
UPDATE animals 
SET owner_id = (SELECT id from owners WHERE full_name = 'Jennifer Orwell')
WHERE name IN ('Gabumon', 'Pikachu'); 

-- Bob owns Devimon and Plantmon.
UPDATE animals 
SET owner_id = (SELECT id from owners WHERE full_name = 'Bob')
WHERE name IN ('Devimon', 'Plantmon'); 

-- Melody Pond owns Charmander, Squirtle, and Blossom.
UPDATE animals 
SET owner_id = (SELECT id from owners WHERE full_name = 'Melody Pond')
WHERE name IN ('Charmander', 'Squirtle', 'Blossom'); 

-- Dean Winchester owns Angemon and Boarmon.
UPDATE animals 
SET owner_id = (SELECT id from owners WHERE full_name = 'Dean Winchester')
WHERE name IN ('Angemon', 'Boarmon'); 

-- Verification
SELECT id, name, owner_id FROM animals;