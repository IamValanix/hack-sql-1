CREATE TABLE countries (
  id_country serial primary KEY,
  name VARCHAR(50) not NULL
  );
  

create table priorities (
  id_priority serial PRIMARY KEY,
  type_name VARCHAR(50) NOT NULL
  )
  
  CREATE TABLE contact_request(
  id_email INTEGER PRIMARY KEY,
  id_country INTEGER NOT NULL,  
  id_priority INTEGER NOT NULL,
  name TEXT NOT NULL,
  detail TEXT NOT NULL,
  physical_address TEXT NOT NULL,
  FOREIGN KEY (id_country) REFERENCES countries(id_country),
  FOREIGN KEY (id_priority) REFERENCES priorities(id_priority)
);

INSERT INTO countries (name) VALUES 
('Estados Unidos'),
('México'),
('España'),
('Argentina'),
('Colombia');

INSERT INTO priorities (type_name) VALUES ('baja'),('media'),('alta');

INSERT INTO contact_request (id_email, id_country, id_priority, name, detail, physical_address) 
VALUES
(1, 1, 3, 'Juan Pérez', 'Consulta sobre productos', 'Calle Principal 123, Ciudad A'),
(2, 2, 2, 'María García', 'Soporte técnico', 'Avenida Central 456, Ciudad B'),
(3, 3, 1, 'Carlos López', 'Información general', 'Plaza Mayor 789, Ciudad C');

DELETE FROM contact_request
WHERE id_email = (SELECT MAX(id_email) FROM contact_request);

UPDATE contact_request
SET 
    name = 'Andres Valverde',
    detail = 'Ingeniero',
    physical_address = 'Calle Principal 456, Ciudad D'
WHERE id_email = (SELECT MIN(id_email) FROM contact_request);

SELECT * from contact_request;