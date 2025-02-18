insert into teacher (name, surname, middle_name, subject)
values
('Dmytro', 'Bondarenko', 'Volodymyrovych', 'History, Geography'),
('Sofiia', 'Lysenko', 'Yuriiivna', 'Music, Art'),
('Mariia', 'Horbatko', 'Stepanivna', 'Ukrainian Language, Literature');

insert into classes (class_name, academemic_year, teacher)
values
('11-A','2023',9),
('9-B','2023',7),
('1-B','2021',8);

insert into students (name, birth_date, class)
values
('Mykola Kovalenko', '2015-03-11',3),
('Anna Melnyk', '2003-07-30',1),
('Vasyl Tkachenko', '2015-12-05',2);

select * from teacher;
select * from classes;
select * from students;

delete from teacher
where teacher_id = 9;

update classes
set academemic_year = 2022
where class_id = 1;