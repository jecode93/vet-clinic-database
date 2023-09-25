/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon%';
SELECT * from animals WHERE date_of_birth BETWEEN '2016-10-01' AND '2019-10-01';
SELECT * from animals WHERE neutered = true AND escape_attemps < 3;
SELECT date_of_birth from animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attemps from animals WHERE weight_kg > 10.5;
SELECT name from animals WHERE neutered = true;
SELECT name from animals WHERE name NOT IN ('Gabumon');
SELECT name from animals WHERE weight_kg = 10.4 AND weight_kg = 17.3 OR weight_kg BETWEEN 10.4 AND 17.3;


-- TODAY PROJECT --

--REQUEST 1: 
--Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.

-- start transaction
BEGIN;

-- UPDATE
UPDATE animals
SET species = 'unspecified'; 

-- verify that change was made
SELECT species FROM animals;

-- Rollback from unspecified to species
ROLLBACK;

-- verify that change was undone
SELECT species from animals;

-- REQUEST 2: 
--Inside a transaction:
-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
-- Verify that changes were made.
-- Commit the transaction.
-- Verify that changes persist after commit.

BEGIN;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon%';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

-- verify that changes were made
SELECT species FROM animals;

-- commit transaction
COMMIT;

-- verify that change persists after commit
SELECT species FROM animals;


-- REQUEST 3 & 4:
-- Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
--After the rollback verify if all records in the animals table still exists. After that, you can start breathing as usual ;)

BEGIN;

DELETE FROM animals;

-- Rollback all the records
ROLLBACK;


-- REQUEST 5:
--Inside a transaction:
BEGIN;

-- Delete all animals born after Jan 1st, 2022.
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint for the transaction.
SAVEPOINT sp1;

-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * (-1);

-- Rollback to the savepoint
ROLLBACK TO sp1;

-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

-- Commit transaction
COMMIT;


-- REQUEST 6:
-- Write queries to answer the following questions:

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attemps = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attemps) AS Most_Escape FROM animals GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attemps) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


-- Vet clinic database: query multiple tables

-- Write queries (using JOIN) to answer the following questions

-- What animals belong to Melody Pond?
SELECT owners.full_name AS owner, animals.name AS "animal name"
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond'; 

-- List of all animals that are pokemon (their type is Pokemon).
SELECT species.name AS species, animals.name AS "animal name"
FROM animals
INNER JOIN species
ON animals.species_id = species.id
WHERE species.name = 'Pokemon'; 

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name AS owner, animals.name AS "animal name"
FROM animals
RIGHT JOIN owners
ON animals.owner_id = owners.id; 

-- How many animals are there per species?
SELECT species, COUNT(*) FROM
  (SELECT species.name AS species, animals.name
  FROM animals
  INNER JOIN species
  ON animals.species_id = species.id) AS animal_per_species
GROUP BY species;

-- List all Digimon owned by Jennifer Orwell.
SELECT owners.full_name AS owner, animals.name AS "animal name", species.name AS species
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id
INNER JOIN species
ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon'; 

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT owners.full_name AS owner, animals.name AS "animal name", animals.escape_attemps
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attemps = 0; 

-- Who owns the most animals?
SELECT full_name, count
FROM (SELECT full_name, COUNT(*)
  FROM animals
  INNER JOIN owners
  ON animals.owner_id = owners.id
  GROUP BY full_name
) AS full_name
WHERE count = (SELECT MAX(count) FROM (
  SELECT full_name, COUNT(*)
  FROM animals
  INNER JOIN owners
  ON animals.owner_id = owners.id
  GROUP BY full_name
) AS max_count);



-- Vet clinic database: add "join table" for visits

-- Who was the last animal seen by William Tatcher?
SELECT animals.name AS last_animal, date_of_visit AS last_visit, vets.name AS vet_name
FROM visits
INNER JOIN animals
ON animals.id = visits.animals_id
INNER JOIN vets
ON vet_id = vets.id
WHERE date_of_visit = (
  SELECT MAX(date_of_visit) 
  FROM visits 
  WHERE vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
);

-- How many different animals did Stephanie Mendez see?
SELECT vets.name, COUNT(*) AS animal_see
FROM animals
INNER JOIN visits
ON animals.id = visits.animals_id
INNER JOIN vets
ON vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.id AS vet_id, vets.name AS vet_name, species.name AS species_name
FROM vets
LEFT JOIN specializations
ON vets.id = specializations.vet_id
LEFT JOIN species
ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name AS animal, vets.name AS vet, date_of_visit
FROM animals
INNER JOIN visits
ON animals.id = visits.animals_id
INNER JOIN vets
ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez' AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';


-- What animal has the most visits to vets?
SELECT animals.name, animals_id, visits_count
FROM animals
INNER JOIN (
  SELECT animals_id, COUNT(animals_id) AS visits_count
  FROM visits
  GROUP BY animals_id
) AS most_visit
ON animals.id = animals_id
WHERE visits_count = (SELECT MAX(visits_count) FROM (
  SELECT animals_id, COUNT(animals_id) AS visits_count
  FROM visits
  GROUP BY animals_id
) AS visits_count
);


-- Who was Maisy Smith's first visit?
SELECT animals_id, animals.name AS animal_name, vet_id, vets.name AS vet_name, date_of_visit AS latest_visit
FROM visits
INNER JOIN animals
ON animals.id = animals_id
INNER JOIN vets
ON vets.id = vet_id
WHERE date_of_visit = (
  SELECT MIN(date_of_visit) AS latest_visit
  FROM visits
  WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
);


-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals_id, animals.name AS animal, animals.date_of_birth, animals.weight_kg, animals.escape_attemps, animals.neutered, species.name AS species, owners.full_name as owner, vet_id, vets.name AS vet_name, date_of_visit
FROM visits
INNER JOIN animals
ON animals.id = animals_id
INNER JOIN vets
ON vets.id = vet_id
INNER JOIN owners
ON owners.id = animals.owner_id
INNER JOIN species
ON species.id = animals.species_id
WHERE date_of_visit = (
  SELECT MAX(date_of_visit) AS latest_visit
  FROM visits
);


-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT (*) FROM (
  SELECT animals_id, vet_id, animals.species_id AS species
  FROM visits
  INNER JOIN animals
  ON animals.id = visits.animals_id
  WHERE (animals.species_id != (
    SELECT specializations.species_id
    FROM vets
    LEFT JOIN specializations
    ON vets.id = specializations.vet_id
    WHERE specializations.vet_id = visits.vet_id AND specializations.vet_id != 3
  )) OR vet_id = 2
) as most;


-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species_id, species.name AS species_name, sum AS species_visits_count
FROM species
INNER JOIN (
  SELECT species_id, SUM(visits_count) AS sum
  FROM (
    SELECT animals.species_id, visits_count
    FROM animals
    INNER JOIN (
      SELECT animals_id, COUNT(animals_id) AS visits_count
      FROM visits
      WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
      GROUP BY animals_id
    ) AS count
    ON animals.id = animals_id
  ) AS sum
  GROUP BY species_id
) AS sum_all
ON species.id = species_id
WHERE sum = (SELECT MAX(sum) FROM (
  SELECT species_id, SUM(visits_count) AS sum
  FROM (
    SELECT animals.species_id, visits_count
    FROM animals
    INNER JOIN (
      SELECT animals_id, COUNT(animals_id) AS visits_count
      FROM visits
      WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
      GROUP BY animals_id
    ) AS count_all
    ON animals.id = animals_id
  ) AS max
  GROUP BY species_id
) AS max_all
);

-- Vet clinic database: database performance audit
SELECT COUNT(*) FROM visits where animals_id = 4;
SELECT * FROM visits where vet_id = 2;
SELECT * FROM owners where email = 'owner_18327@mail.com';

explain analyze SELECT COUNT(*) FROM visits where animals_id = 4;
explain analyze SELECT * FROM visits where vet_id = 2;
explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';