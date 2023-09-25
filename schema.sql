/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attemps INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL NOT NULL,
    PRIMARY KEY(id)
);


ALTER TABLE animals
ADD COLUMN species VARCHAR(250);


-- Vet clinic database: query multiple tables

-- Create a table named owners with the following columns:
CREATE TABLE owners (
    id SERIAL PRIMARY KEY NOT NULL,
    full_name VARCHAR(250) NOT NULL,
    age INT NOT NULL
);

-- Create a table named species with the following columns:
CREATE TABLE species (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(250)
);

-- Modify animals table:

-- Make sure that id is set as autoincremented PRIMARY KEY
-- Id already auto-increment

-- Remove column species
ALTER TABLE animals
DROP COLUMN species;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals
ADD COLUMN species_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_species
FOREIGN KEY (species_id)
REFERENCES species(id);

-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals
ADD COLUMN owner_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_owner
FOREIGN KEY (owner_id)
REFERENCES owners(id);



-- Vet clinic database: add "join table" for visits

CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL,
    PRIMARY KEY(id)
);

-- Species and Vet specialization
CREATE TABLE specializations (
    species_id INT,
    vet_id INT
);

-- Animals and Vets visit
CREATE TABLE visits (
    animals_id INT,
    vet_id INT,
    date_of_visit DATE NOT NULL
);

-- Vet clinic database: database performance audit
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

CREATE INDEX animals_id_asc_visits ON visits(animals_id ASC);
CREATE INDEX vet_id_asc_visit ON visits(vet_id ASC);
CREATE INDEX owners_email_asc ON owners(email ASC);