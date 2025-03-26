create table countries(
  id_country serial primary key,
  name varchar(50) not null  
);

create table users(
 id_users serial primary key,
 id_country integer not null,
 email varchar(100) not null,
 name varchar (50) not null,
 foreign key (id_country) references countries (id_country)   
);

insert into countries (name) values ('argentina') , ('colombia'),('chile');
select * from countries;

insert into users (id_country, email, name) 
values (2, 'foo@foo.com', 'fooziman'), (3, 'bar@bar.com', 'barziman'); 
select * from users;

delete from users where email = 'bar@bar.com';

update users set email = 'foo@foo.foo', name = 'fooz' where id_users = 1;

select * from users;
select * from users inner join  countries on users.id_country = countries.id_country;
select u.id_users as id, u.email, u.name as fullname, c.name 
from users u inner join  countries c on u.id_country = c.id_country;