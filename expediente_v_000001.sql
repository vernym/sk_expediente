create table hermanas (cedula int(15) not null, nombre varchar(20), primer_apellido varchar(20), segundo_apellido varchar(20));
insert into hermanas (cedula, nombre, primer_apellido, segundo_apellido) values (1,"Ismaela","Arce","Arce");
DELIMITER // 
create procedure prueba (OUT pError varchar(100)) begin select cedula, nombre, primer_apellido, segundo_apellido from hermanas; select "Exitos Totales" into pError; end// 
DELIMITER ;
