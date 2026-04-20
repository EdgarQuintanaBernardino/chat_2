-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 17, 2026 at 12:29 AM
-- Server version: 8.0.30
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `srme_nov25`
--

-- --------------------------------------------------------

--
-- Table structure for table `preguntas_frecuentes`
--

CREATE TABLE `preguntas_frecuentes` (
  `id_pregunta` int NOT NULL,
  `tema` varchar(75) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `subtema` varchar(75) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `pregunta` varchar(255) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `respuesta` text CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `orden` int DEFAULT NULL,
  `baja_logica` varchar(1) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Dumping data for table `preguntas_frecuentes`
--

INSERT INTO `preguntas_frecuentes` (`id_pregunta`, `tema`, `subtema`, `pregunta`, `respuesta`, `orden`, `baja_logica`) VALUES
(1, 'Protección', 'Documentación', '¿Si pierdo mi pasaporte, puedo tramitar una reposición en alguna representación?', 'Sí es posible. Debe reportar el hecho a la policía local o autoridad correspondiente, o en su defecto, acudir en persona a la oficina consular más cercana para comunicar el hecho y recibir atención.', 1, '0'),
(102, 'Protección', 'Documentación', '¿Qué hago si mi pasaporte ha sido destruido o mutilado?', 'Debe reportar el hecho a la policía local o autoridad correspondiente, o en su defecto, acudir en persona a la oficina consular más cercana para comunicar el hecho y recibir atención.', 2, '0'),
(103, 'Asuntos consulares', 'Asuntos migratorios', '¿Para renovación del pasaporte de menores, debe presentarse el menor de edad?', 'Es obligatoria la presencia del menor de edad en compañía de los padres, madres o tutores. Para mayores detalles comunícate con la Embajada o Consulado de México más cercano.', 3, '0'),
(104, 'Protección', 'Legal', '¿Si me detienen en el extranjero, la SRE puede ayudarme?', 'Si usted es detenido por cualquier autoridad de policía o de migración en el extranjero, tiene derecho a que dicha autoridad notifique sobre su detención a la Embajada o Consulado de México más cercano, si usted así lo desea. Como parte de sus atribuciones, la Representación Diplomática o Consular de México puede ayudarlo a vigilar que las autoridades locales respeten sus derechos.', 4, '0'),
(105, 'Protección', 'Copa Mundial de Futbol Qatar 2022', '¿Deseas conocer más información sobre los requisitos de ingreso y sanitarios, así como usos, costumbres y tradiciones de Qatar?', 'La Secretaría de Relaciones Exteriores pone a tu disposición información confiable y veraz sobre lo que puedes y no puedes hacer durante tu viaje a la Copa Mundial de Futbol - Qatar 2022. Para conocer más detalles, da clic <a href=\'https://www.gob.mx/sre/documentos/copa-mundial-de-futbol-qatar-2022-313979\' target=\'_blank\'>aquí</a>.', 5, '1'),
(106, 'Asuntos consulares', 'Documentación', '¿Se puede llevar a cabo un registro de defunción en una representación consular?', 'El registro de defunción en una representación consular se lleva a cabo solamente cuando el finado es de nacionalidad mexicana y fallece en el extranjero.', 6, '0'),
(107, 'Asuntos consulares', 'Asuntos migratorios', '¿Cuál es el valor de la mercancía que puedo introducir a México?', 'Es competencia de la Secretaría de Hacienda y Crédito Público señalar la cantidad o el valor de una mercancía que una persona mexicana o extranjera puede introducir al país, exenta del pago de impuestos, por lo que le recomendamos consultar la página de internet: <a href=\'http://www.shcp.gob.mx\' target=\'_blank\'>http://www.shcp.gob.mx</a>', 7, '0'),
(108, 'Asuntos consulares', 'Asuntos migratorios', '¿Qué cosas puedo llevarme si salgo a radicar en el extranjero?', 'Ello depende de las leyes del país o territorio donde se quiera radicar, el cual determinará en qué términos se puede introducir pertenencias. En la página de internet de esta Secretaría se encuentran las direcciones y los teléfonos de las embajadas extranjeras acreditadas en México, donde se puede solicitar la información de cada país.', 8, '0'),
(109, 'Protección', 'Asuntos migratorios', '¿Puede cubrir la SRE los costos funerarios en el extranjero?', 'La SRE brinda orientación y no cubre costos funerarios. Cada caso es particular y se evalúa si hay evidente vulnerabilidad económica.', 9, '0'),
(110, 'Protección', 'Asuntos migratorios', '¿Puede la SRE conseguirme un trabajo en el extranjero?', 'No es atribución de la Secretaría de Relaciones Exteriores.', 10, '0'),
(111, 'Protección', 'Asuntos migratorios', '¿Qué hacer en caso de ser víctima de un asalto y quedarse sin recursos?', 'Si usted es víctima de un delito, se recomienda denunciar el hecho ante las autoridades correspondientes. Al mismo tiempo, sus familiares pueden recurrir a la Dirección General de Protección Consular y Planeación Estratégica o bien a las Oficinas de Pasaportes de la Secretaría de Relaciones Exteriores más cercana a su domicilio, en donde se les informará sobre la forma de hacerle llegar ayuda económica.', 11, '0'),
(112, 'Protección', 'Asuntos migratorios', '¿Qué hacer en caso de contraer alguna enfermedad o sufrir algún accidente en el extranjero, por los que tenga que recibir y/o solicitar atención médica?', 'Pida a las autoridades del hospital que notifiquen sobre su situación a la Embajada o Consulado de México más cercano. En todo caso y como parte de los preparativos de viaje, la Secretaría de Relaciones Exteriores recomienda a los interesados que se informen y contraten un seguro de viaje que incluya gastos médicos internacionales con el proveedor de su preferencia.', 12, '0'),
(113, 'Protección', 'Asuntos migratorios', '¿En que países México cuenta con representaciones diplomáticas o consulares?', 'En la página de internet de esta Secretaría se encuentran las direcciones y los teléfonos de las representaciones de México en el exterior:<br><br> <li><a href=\'https://portales.sre.gob.mx/directorio/index.php/consulados-de-mexico-en-el-exterior\' target=\'_blank\'>consulados</a> <br> <li><a href=\'https://portales.sre.gob.mx/directorio/index.php/embajadas-de-mexico-en-el-exterior\' target=\'_blank\'>embajadas</a>', 13, '0'),
(114, 'Sistema de registro', 'Contacto', 'Si tengo dudas, quejas o comentarios, ¿cómo me puedo poner en contacto con la Secretaría?', 'Usted puede enviar sus dudas, quejas, comentarios o sugerencias a la dirección electrónica: <br><a href=\"mailto:dudasSIRME@sre.gob.mx\">dudasSIRME@sre.gob.mx</a>', 14, '0'),
(115, 'Sistema de registro', 'Familiares', '¿Cómo puedo registrar más de un familiar?', 'Para registrar a más de un familiar, capture los datos de su registro con el primer familiar y haga clic en \"Agregar\", repitiendo el proceso para los demás familiares, al finalizar, haga clic en \"Guardar\".', 15, '0'),
(116, 'Protección', 'Asuntos migratorios', '¿Es posible ser repatriado a mi estado de origen en México si me encuentro enfermo, en estado de indigencia o con alguna situación grave o de emergencia?', 'Sí es posible. Para ello puede presentarse en la Embajada o Consulado de México más cercano, o solicitar a las autoridades correspondientes que lo comuniquen con la representación diplomática o consular mexicana para exponer su caso, el cual será evaluado para decidir las acciones de asistencia consular a seguir, mismas que se le comunicarán de manera oportuna.', 16, '0'),
(117, 'Sistema de registro', 'Registro', 'En el campo “fecha de nacimiento” no veo todos los meses, ¿qué debo hacer?', 'Seleccione primero el año de nacimiento y posteriormente el mes y día.', 17, '0'),
(118, 'Sistema de registro', 'Registro', '¿Quién puede registrarse en este sistema?', 'Cualquier persona de nacionalidad mexicana que resida en el exterior del país o realice un viaje al extranjero puede registrarse, sin importar su situación migratoria en el país de destino.', 18, '0'),
(119, 'Sistema de registro', 'Modificación', 'Ya ingresé al sistema para intentar cambiar mi clave temporal y no encuentro en dónde cambiarla.', 'Al ingresar al sistema, en la pestaña <b>\"datos generales\"</b>, debajo del campo <b>\"sexo\"</b> dé clic en la imagen <b>\"actualice aquí su clave de acceso\"</b> para que se desplieguen los campos necesarios.<br> <br>para pasar de un campo a otro del cambio de contraseña, presione la tecla de tabulación del teclado.<br> <br><img src=\"../img/ayuda/cambio_pwd.png\" border=\"0\">', 19, '0'),
(120, 'Sistema de registro', 'Registro', '¿Puedo registrarme sin un documento de identificación?', 'No puede. En el campo “documento de identificación” existen sólo dos opciones: Pasaporte y Matrícula Consular. Una vez que cuente con alguno de estos documentos de identificación, deberá realizar su registro.', 20, '0'),
(121, 'Protección', 'Asuntos migratorios', '¿Puede la SRE regularizar mi situación migratoria (indocumentado) ante las autoridades extranjeras?', 'No es atribución de la Secretaría de Relaciones Exteriores.', 21, '0'),
(122, 'Asuntos consulares', 'Asuntos migratorios', '¿Qué países solicitan visa a los mexicanos?', 'Le recomendamos visitar la página de internet de la \"Guía del Viajero\" para conocer los requisitos migratorios y otras recomendaciones necesarias para viajar al exterior:  <a href=\'http://guiadelviajero.sre.gob.mx/\' target=\'_blank\'>http://guiadelviajero.sre.gob.mx/</a>', 22, '0'),
(123, 'Asuntos consulares', 'Asuntos migratorios', '¿Qué se requiere para efectuar el trámite de certificado de menaje de casa?', 'Es necesario presentar ante el Consulado de México correspondiente una carta solicitud, incluyendo el nombre, intención de obtener el certificado de menaje de casa, lugar de radicación en el extranjero, la temporalidad de esa residencia, lugar donde establecerá su domicilio en territorio nacional y relacionar la documentación que respalda la solicitud. Es recomendable contactar a la oficina consular de México ante la cual pretende tramitar el certificado citado.', 23, '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `preguntas_frecuentes`
--
ALTER TABLE `preguntas_frecuentes`
  ADD PRIMARY KEY (`id_pregunta`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `preguntas_frecuentes`
--
ALTER TABLE `preguntas_frecuentes`
  MODIFY `id_pregunta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
