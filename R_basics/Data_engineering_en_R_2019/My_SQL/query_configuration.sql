 /*  
 -----------------------------------------------------------------------------------------
   ____                    __   _             __  __           ____     ___    _     
  / ___|   ___    _ __    / _| (_)   __ _    |  \/  |  _   _  / ___|   / _ \  | |    
 | |      / _ \  | '_ \  | |_  | |  / _` |   | |\/| | | | | | \___ \  | | | | | |    
 | |___  | (_) | | | | | |  _| | | | (_| |   | |  | | | |_| |  ___) | | |_| | | |___ 
  \____|  \___/  |_| |_| |_|   |_|  \__, |   |_|  |_|  \__, | |____/   \__\_\ |_____|
                                    |___/              |___/                         
-----------------------------------------------------------------------------------------
*/


CREATE DATABASE Kschool CHARACTER SET latin1; #Creamos la base de datos

USE Kschool; #Es necesario indicar la base de datos que se utiliza

/* Las siguientes líneas son necesarias para configurar la base de datos */

ALTER USER 'root'@'localhost' 
IDENTIFIED WITH mysql_native_password BY 'root';

SET GLOBAL local_infile = true;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

DROP TABLE datos_inmuebles_pisoscom; #Tendremos error si existe


CREATE TABLE IF NOT EXISTS datos_inmuebles_pisoscom ( #Creamos la tabla donde insertaremos los datos
	address varchar(256),
    localidad varchar(256),
    provincia varchar(256),
    last_price varchar(256),
    m2 varchar(256),
    fuente varchar(256),
    id varchar(256),
    operacion varchar(256));



SELECT * FROM datos_inmuebles_pisoscom;
