CREATE TABLE HERMANAS (
Cedula	int	PRIMARY KEY
,Nombre	varchar(30)	NOT NULL
,Primer_Apellido	varchar(30)	NOT NULL
,Segundo_Apellido	varchar(30)	NOT NULL
,Fecha_Nacimiento	Date NOT NULL
,Nacionalidad	varchar(50)	NOT NULL
,Numero_Pasaporte	int	
,Lugar_Nacimiento	varchar(50)	NOT NULL
,Nombre_Padre	varchar(90)	NOT NULL
,Nombre_Madre	varchar(90)	NOT NULL
,Numero_Hermanos	int	NOT NULL
,Telefono_familiar	varchar(20)	
,Telefono_Personal	varchar(20)	
,Domicilio	varchar(50)	NOT NULL
,Provincia_Madre_Rafols	varchar(50)
,Fecha_bautismo	Date
,Fecha_Confirmacion	Date
,Fecha_Proceso_Acompanamiento	Date 
,Fecha_Ingreso_Aspirantado	Date	
,Fecha_Ingreso_Postulantado	Date	
,Fecha_Ingreso_Noviciado	Date	
,Fecha_Primeros_Votos	Date	
,Fecha_Votos_Perpetuos	Date	
,Numero_Estadistica_Provincial	int	
,Numero_Estadistica_General	int	
,Cambios_Comunidades	varchar(1000)	
,Estudios_Primarios	varchar(1)	
,Estudios_Secundarios	varchar(1)	
,Estudios_Universitarios	varchar(1)	
,Reingreso	Date	
,Experiencia_Otra_Provincia	varchar(1000)	
,Salida_Definitiva_Congregacion	Date	
,Indulto_Secularizacion	varchar(1)	
,Lugar_juniorado	varchar(1)	
,Antecedentes_Clinicos	varchar(1000)	
,Antecedentes_Psicologicos	varchar(1000)	
,Limitaciones_Fisicas	varchar(1000)
,Comodin_01 varchar(100)
,Comodin_02 varchar(100)
,Comodin_03 varchar(100)
,Comodin_04 varchar(100)
,Comodin_05 varchar(100)
,Comodin_06 varchar(100)
,Comodin_07 varchar(100)
,Comodin_08 varchar(100)
,Comodin_09 varchar(100)
,Comodin_10 varchar(100)
,Comodin_11 varchar(100)
,Comodin_12 varchar(100)
,Comodin_13 varchar(100)
,Comodin_14 varchar(100)
,Comodin_15 varchar(100)
,Comodin_16 varchar(100)
,Comodin_17 varchar(100)
,Comodin_18 varchar(100)
,Comodin_19 varchar(100)
,Comodin_20 varchar(100)
,Creado_Usuario varchar(15)
,Creado_fecha DATETIME
,Modificado_Usuario varchar(15)
,Modificado_Fecha  DATETIME
);

create table documentos
(
Documento_ID	int	AUTO_INCREMENT PRIMARY KEY
,Cedula	int
,Descripcion_documento varchar(50)
,Documento	BLOB
,Creado_Usuario varchar(15)
,Creado_fecha DATETIME
,Modificado_Usuario varchar(15)
,Modificado_Fecha  DATETIME
,FOREIGN KEY(cedula) REFERENCES hermanas(cedula)
);

create table usuarios
(
usuario varchar(15) PRIMARY KEY
,Nombre varchar(30)
,estado varchar(1)
,clave varchar(15)
,Creado_Usuario varchar(15)
,Creado_fecha DATETIME
,Modificado_Usuario varchar(15)
,Modificado_Fecha  DATETIME
);

insert into usuarios values ('admin','Administrador','A','IwSsVm01','admin', now(),'admin',now());

DELIMITER //
create procedure Autenticar_Usuario (in pUsuario varchar(15), in pClave varchar(15), OUT pResultado int, OUT pError varchar(100)) 
begin 

	DECLARE vClave varchar(15);
	DECLARE vUsuario varchar(15);
	DECLARE vEstado varchar(15);
	
	select usuario, clave, estado into vUsuario, vClave, vEstado from usuaros where usuario=pUsuario; 
	
	if (vUsuario = pUsuario) then
		if (vEstado = 'A') then
			if (vClave = pClave) then
			  set pResultado = 1;
			  set pError = 'Usuario autenticado satisfactoriamente';
			else 
			  set pResultado = 0;
			  set pError = 'La contraseña es incorrecta';
			end if;
		else
			set pResultado = 0;
			set pError = 'El usuario está bloqueado';
		end if;
	else 
	  set pResultado = 0;
	  set pError = 'El usuario no existe o es incorrecto';
	end if;
	
end //

create procedure Desactivar_Usuario (in pUsuario varchar(15), OUT pResultado int, OUT pError varchar(100)) 
begin 

	DECLARE vUsuario varchar(15);
	
	select usuario into vUsuario from usuaros where usuario=pUsuario; 
	
	if (vUsuario = pUsuario) then
		update usuarios set estado = 'I' where usuario=pUsuario; 
		set pResultado = 1;
		set pError = 'Usuario desactivado satisfactoriamente';
	else 
	  set pResultado = 0;
	  set pError = 'El usuario no existe o es incorrecto';
	end if;
	
end //

create procedure Nuevo_Usuario (IN pUser varchar(15), IN pUsuario varchar(15), IN pNombre varchar(30), IN pClave varchar(15), OUT pResultado int, OUT pError varchar(100)) 
begin 

	DECLARE vUsuario varchar(15);
	
	select usuario into vUsuario from usuaros where usuario=pUsuario; 
	
	if (vUsuario = pUsuario) then
		set pResultado = 0;
		set pError = 'El usuario ya existe';
	else 
		insert into usuarios (
			usuario,
			nombre,
			estado,
			clave,
			Creado_Usuario,
			Creado_fecha,
			Modificado_Usuario,
			Modificado_Fecha
		) values (
			pUsuario,
			pNombre,
			'A',
			pClave,
			pUser,
			now(),
			pUser,
			now()
		);
		set pResultado = 1;
		set pError = 'Usuario creado satisfactoriamente';
	end if;
	
end //

create procedure Listar_Usuarios (OUT pResultado int, OUT pError varchar(100)) 
begin 

	select 
		Usuario,
		Nombre,
		CASE estado
			WHEN 'A' THEN 'Activo'
			ELSE 'Inactivo'
		END Estado,
		Clave,
		Creado_Usuario,
		Creado_fecha,
		Modificado_Usuario,
		Modificado_Fecha
	from 
		usuarios;

	set pResultado = 1;
	set pError = 'Consulta de usuarios ejecutada';
	
end //

create procedure Nueva_Hermana (IN pUser varchar(15),
	IN pCedula int,
	IN pNombre	varchar(30),
	IN pPrimer_Apellido	varchar(30),
	IN pSegundo_Apellido	varchar(30),
	IN pFecha_Nacimiento	Date,
	IN pNacionalidad	varchar(50),
	IN pNumero_Pasaporte	int,
	IN pLugar_Nacimiento	varchar(50),
	IN pNombre_Padre	varchar(90),
	IN pNombre_Madre	varchar(90),
	IN pNumero_Hermanos	int,
	IN pTelefono_familiar	varchar(20),
	IN pTelefono_Personal	varchar(20),
	IN pDomicilio	varchar(50),
	IN pProvincia_Madre_Rafols	varchar(50),
	IN pFecha_bautismo	Date,
	IN pFecha_Confirmacion	Date,
	IN pFecha_Proceso_Acompanamiento	Date,
	IN pFecha_Ingreso_Aspirantado	Date,	
	IN pFecha_Ingreso_Postulantado	Date,	
	IN pFecha_Ingreso_Noviciado	Date,
	IN pFecha_Primeros_Votos	Date,
	IN pFecha_Votos_Perpetuos	Date,
	IN pNumero_Estadistica_Provincial	int,
	IN pNumero_Estadistica_General	int,
	IN pCambios_Comunidades	varchar(1000),
	IN pEstudios_Primarios	varchar(1),
	IN pEstudios_Secundarios	varchar(1),
	IN pEstudios_Universitarios	varchar(1),
	IN pReingreso	Date,
	IN pExperiencia_Otra_Provincia	varchar(1000),
	IN pSalida_Definitiva_Congregacion	Date,
	IN pIndulto_Secularizacion	varchar(1),
	IN pLugar_juniorado	varchar(1),
	IN pAntecedentes_Clinicos	varchar(1000),
	IN pAntecedentes_Psicologicos	varchar(1000),
	IN pLimitaciones_Fisicas	varchar(1000),
	IN pComodin_01 varchar(100),
	IN pComodin_02 varchar(100),
	IN pComodin_03 varchar(100),
	IN pComodin_04 varchar(100),
	IN pComodin_05 varchar(100),
	IN pComodin_06 varchar(100),
	IN pComodin_07 varchar(100),
	IN pComodin_08 varchar(100),
	IN pComodin_09 varchar(100),
	IN pComodin_10 varchar(100),
	IN pComodin_11 varchar(100),
	IN pComodin_12 varchar(100),
	IN pComodin_13 varchar(100),
	IN pComodin_14 varchar(100),
	IN pComodin_15 varchar(100),
	IN pComodin_16 varchar(100),
	IN pComodin_17 varchar(100),
	IN pComodin_18 varchar(100),
	IN pComodin_19 varchar(100),
	IN pComodin_20 varchar(100),
	OUT pResultado int, OUT pError varchar(100)
	) 
BEGIN

	insert into hermanas (
		Cedula,
		Nombre,
		Primer_Apellido,
		Segundo_Apellido,
		Fecha_Nacimiento,
		Nacionalidad,
		Numero_Pasaporte,
		Lugar_Nacimiento,
		Nombre_Padre,
		Nombre_Madre,
		Numero_Hermanos,
		Telefono_familiar,
		Telefono_Personal,
		Domicilio,
		Provincia_Madre_Rafols,
		Fecha_bautismo,
		Fecha_Confirmacion,
		Fecha_Proceso_Acompanamiento,
		Fecha_Ingreso_Aspirantado,
		Fecha_Ingreso_Postulantado,
		Fecha_Ingreso_Noviciado,
		Fecha_Primeros_Votos,
		Fecha_Votos_Perpetuos,
		Numero_Estadistica_Provincial,
		Numero_Estadistica_General,
		Cambios_Comunidades,
		Estudios_Primarios,
		Estudios_Secundarios,
		Estudios_Universitarios,
		Reingreso,
		Experiencia_Otra_Provincia,
		Salida_Definitiva_Congregacion,
		Indulto_Secularizacion,
		Lugar_juniorado,
		Antecedentes_Clinicos,
		Antecedentes_Psicologicos,
		Limitaciones_Fisicas,
		Comodin_01,
		Comodin_02,
		Comodin_03,
		Comodin_04,
		Comodin_05,
		Comodin_06,
		Comodin_07,
		Comodin_08,
		Comodin_09,
		Comodin_10,
		Comodin_11,
		Comodin_12,
		Comodin_13,
		Comodin_14,
		Comodin_15,
		Comodin_16,
		Comodin_17,
		Comodin_18,
		Comodin_19,
		Comodin_20,
		Creado_Usuario,
		Creado_fecha,
		Modificado_Usuario,
		Modificado_Fecha
	) values (
		pCedula,
		pNombre,
		pPrimer_Apellido,
		pSegundo_Apellido,
		pFecha_Nacimiento,
		pNacionalidad,
		pNumero_Pasaporte,
		pLugar_Nacimiento,
		pNombre_Padre,
		pNombre_Madre,
		pNumero_Hermanos,
		pTelefono_familiar,
		pTelefono_Personal,
		pDomicilio,
		pProvincia_Madre_Rafols,
		pFecha_bautismo,
		pFecha_Confirmacion,
		pFecha_Proceso_Acompanamiento,
		pFecha_Ingreso_Aspirantado,
		pFecha_Ingreso_Postulantado,
		pFecha_Ingreso_Noviciado,
		pFecha_Primeros_Votos,
		pFecha_Votos_Perpetuos,
		pNumero_Estadistica_Provincial,
		pNumero_Estadistica_General,
		pCambios_Comunidades,
		pEstudios_Primarios,
		pEstudios_Secundarios,
		pEstudios_Universitarios,
		pReingreso,
		pExperiencia_Otra_Provincia,
		pSalida_Definitiva_Congregacion,
		pIndulto_Secularizacion,
		pLugar_juniorado,
		pAntecedentes_Clinicos,
		pAntecedentes_Psicologicos,
		pLimitaciones_Fisicas,
		pComodin_01,
		pComodin_02,
		pComodin_03,
		pComodin_04,
		pComodin_05,
		pComodin_06,
		pComodin_07,
		pComodin_08,
		pComodin_09,
		pComodin_10,
		pComodin_11,
		pComodin_12,
		pComodin_13,
		pComodin_14,
		pComodin_15,
		pComodin_16,
		pComodin_17,
		pComodin_18,
		pComodin_19,
		pComodin_20,
		pUser,
		now(),
		pUser,
		now()
	);

	set pResultado = 1;
	set pError = 'Hermana incluída en los registros satisfactoriamente';
	
end //

create procedure Modificar_Hermana (IN pUser varchar(15),
	IN pCedula int,
	IN pNombre	varchar(30),
	IN pPrimer_Apellido	varchar(30),
	IN pSegundo_Apellido	varchar(30),
	IN pFecha_Nacimiento	Date,
	IN pNacionalidad	varchar(50),
	IN pNumero_Pasaporte	int,
	IN pLugar_Nacimiento	varchar(50),
	IN pNombre_Padre	varchar(90),
	IN pNombre_Madre	varchar(90),
	IN pNumero_Hermanos	int,
	IN pTelefono_familiar	varchar(20),
	IN pTelefono_Personal	varchar(20),
	IN pDomicilio	varchar(50),
	IN pProvincia_Madre_Rafols	varchar(50),
	IN pFecha_bautismo	Date,
	IN pFecha_Confirmacion	Date,
	IN pFecha_Proceso_Acompanamiento	Date,
	IN pFecha_Ingreso_Aspirantado	Date,	
	IN pFecha_Ingreso_Postulantado	Date,	
	IN pFecha_Ingreso_Noviciado	Date,
	IN pFecha_Primeros_Votos	Date,
	IN pFecha_Votos_Perpetuos	Date,
	IN pNumero_Estadistica_Provincial	int,
	IN pNumero_Estadistica_General	int,
	IN pCambios_Comunidades	varchar(1000),
	IN pEstudios_Primarios	varchar(1),
	IN pEstudios_Secundarios	varchar(1),
	IN pEstudios_Universitarios	varchar(1),
	IN pReingreso	Date,
	IN pExperiencia_Otra_Provincia	varchar(1000),
	IN pSalida_Definitiva_Congregacion	Date,
	IN pIndulto_Secularizacion	varchar(1),
	IN pLugar_juniorado	varchar(1),
	IN pAntecedentes_Clinicos	varchar(1000),
	IN pAntecedentes_Psicologicos	varchar(1000),
	IN pLimitaciones_Fisicas	varchar(1000),
	IN pComodin_01 varchar(100),
	IN pComodin_02 varchar(100),
	IN pComodin_03 varchar(100),
	IN pComodin_04 varchar(100),
	IN pComodin_05 varchar(100),
	IN pComodin_06 varchar(100),
	IN pComodin_07 varchar(100),
	IN pComodin_08 varchar(100),
	IN pComodin_09 varchar(100),
	IN pComodin_10 varchar(100),
	IN pComodin_11 varchar(100),
	IN pComodin_12 varchar(100),
	IN pComodin_13 varchar(100),
	IN pComodin_14 varchar(100),
	IN pComodin_15 varchar(100),
	IN pComodin_16 varchar(100),
	IN pComodin_17 varchar(100),
	IN pComodin_18 varchar(100),
	IN pComodin_19 varchar(100),
	IN pComodin_20 varchar(100),
	OUT pResultado int, OUT pError varchar(100)
	) 
BEGIN

	update hermanas
	set
		Nombre = pNombre,
		Primer_Apellido = pPrimer_Apellido,
		Segundo_Apellido = pSegundo_Apellido,
		Fecha_Nacimiento = pFecha_Nacimiento,
		Nacionalidad = pNacionalidad,
		Numero_Pasaporte = pNumero_Pasaporte,
		Lugar_Nacimiento = pLugar_Nacimiento,
		Nombre_Padre = pNombre_Padre,
		Nombre_Madre = pNombre_Madre,
		Numero_Hermanos = pNumero_Hermanos,
		Telefono_familiar = pTelefono_familiar,
		Telefono_Personal = pTelefono_Personal,
		Domicilio = pDomicilio,
		Provincia_Madre_Rafols = pProvincia_Madre_Rafols,
		Fecha_bautismo = pFecha_bautismo,
		Fecha_Confirmacion = pFecha_Confirmacion,
		Fecha_Proceso_Acompanamiento = pFecha_Proceso_Acompanamiento,
		Fecha_Ingreso_Aspirantado = pFecha_Ingreso_Aspirantado,
		Fecha_Ingreso_Postulantado = pFecha_Ingreso_Postulantado,
		Fecha_Ingreso_Noviciado = pFecha_Ingreso_Noviciado,
		Fecha_Primeros_Votos = pFecha_Primeros_Votos,
		Fecha_Votos_Perpetuos = pFecha_Votos_Perpetuos,
		Numero_Estadistica_Provincial = pNumero_Estadistica_Provincial,
		Numero_Estadistica_General = pNumero_Estadistica_General,
		Cambios_Comunidades = pCambios_Comunidades,
		Estudios_Primarios = pEstudios_Primarios,
		Estudios_Secundarios = pEstudios_Secundarios,
		Estudios_Universitarios = pEstudios_Universitarios,
		Reingreso = pReingreso,
		Experiencia_Otra_Provincia = pExperiencia_Otra_Provincia,
		Salida_Definitiva_Congregacion = pSalida_Definitiva_Congregacion,
		Indulto_Secularizacion = pIndulto_Secularizacion,
		Lugar_juniorado = pLugar_juniorado,
		Antecedentes_Clinicos = pAntecedentes_Clinicos,
		Antecedentes_Psicologicos = pAntecedentes_Psicologicos,
		Limitaciones_Fisicas = pLimitaciones_Fisicas,
		Comodin_01 = pComodin_01,
		Comodin_02 = pComodin_02,
		Comodin_03 = pComodin_03,
		Comodin_04 = pComodin_04,
		Comodin_05 = pComodin_05,
		Comodin_06 = pComodin_06,
		Comodin_07 = pComodin_07,
		Comodin_08 = pComodin_08,
		Comodin_09 = pComodin_09,
		Comodin_10 = pComodin_10,
		Comodin_11 = pComodin_11,
		Comodin_12 = pComodin_12,
		Comodin_13 = pComodin_13,
		Comodin_14 = pComodin_14,
		Comodin_15 = pComodin_15,
		Comodin_16 = pComodin_16,
		Comodin_17 = pComodin_17,
		Comodin_18 = pComodin_18,
		Comodin_19 = pComodin_19,
		Comodin_20 = pComodin_20,
		Modificado_Usuario = pUser,
		Modificado_Fecha = now()
	where
	  cedula = pCedula;

	set pResultado = 1;
	set pError = 'Hermana modificada en los registros satisfactoriamente';	  
end //
	
create procedure Nuevo_Documento (IN pUser varchar(15), IN pCedula int, IN pDescripcion_documento varchar(50), IN pDocumento BLOB, OUT pResultado int, OUT pError varchar(100))
BEGIN
	insert into documentos (
		Cedula,
		Descripcion_documento,
		Documento,
		Creado_Usuario,
		Creado_fecha,
		Modificado_Usuario,
		Modificado_Fecha
	) values (
		pCedula,
		pDescripcion_documento,
		pDocumento,
		pUser,
		now(),
		pUser,
		now()
	);
	
	set pResultado = 1;
	set pError = 'Documento insertado satisfactoriamente';	  
	
end //

create procedure Borrar_Documento (IN pUser varchar(15), IN pDocumento_ID int, OUT pResultado int, OUT pError varchar(100))
begin
	delete from documentos where Documento_ID = pDocumento_ID;
	
	set pResultado = 1;
	set pError = 'Documento eliminado satisfactoriamente';	  
	
end //
	
create procedure Modificar_Desc_Documento (IN pUser, IN pDocumento_ID int, IN pDescripcion_documento varchar(50), OUT pResultado int, OUT pError varchar(100))
begin
	update Documentos set Descripcion_documento = pDescripcion_documento where Documento_ID = pDocumento_ID;
	
	set pResultado = 1;
	set pError = 'Documento modificado satisfactoriamente';	  
	
end //

create procedure Obtener_Documento (IN pDocumento_ID int, OUT pDocumento BLOB, OUT pResultado int, OUT pError varchar(100))
begin
	select Documento into pDocumento from Documentos where Documento_ID = pDocumento_ID;
	
	set pResultado = 1;
	set pError = 'Documento devuelto satisfactoriamente';	  
	
end //

create procedure Listar_Documentos (OUT pResultado int, OUT pError varchar(100))
begin
	select 
		Documento_ID,
		Cedula,
		Descripcion_documento,
		Documento,
		Creado_Usuario,
		Creado_fecha,
		Modificado_Usuario,
		Modificado_Fecha
	from Documentos;
		
	set pResultado = 1;
	set pError = 'Documento devuelto satisfactoriamente';	  
	
end //

DELIMITER ;