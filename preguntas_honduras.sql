-- phpMyAdmin SQL Dump
-- Embajada de México en Honduras 2026
--

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

CREATE TABLE IF NOT EXISTS `preguntas_frecuentes` (
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
(124, 'Asuntos consulares', 'Visas', '¿Puedo ingresar a México con una visa vigente de Estados Unidos sin tramitar una visa mexicana?', 'Sí. Las personas que cuentan con una visa vigente de Estados Unidos pueden ingresar a México sin necesidad de tramitar una visa mexicana, siempre que la visa se encuentre vigente y sea de entradas múltiples. Igualmente, podrán ingresar a México, sin la visa mexicana, las personas que cuenten con visa de Canadá, Estados Unidos, Japón, Reino Unido de la Gran Bretaña e Irlanda del Norte y países dentro del Espacio Schengen o los países miembros de la Alianza del Pacífico (Colombia, Chile y Perú).', 1, '0'),
(125, 'Asuntos consulares', 'Citas', '¿Los menores de edad necesitan una cita consular propia o se pueden incluir en una cita familiar?', 'Las citas consulares son individuales. Cada miembro de la familia, incluidos a los menores de edad, a quienes se le debe programar su propia cita.', 2, '0'),
(126, 'Asuntos consulares', 'Citas', '¿Cómo se agenda una cita?', 'La programación de citas es a través de la plataforma <a href=\'https://citas.sre.gob.mx/\' target=\'_blank\'>https://citas.sre.gob.mx/</a>, debe crear una cuenta y seguir los pasos del portal web para agendar una cita consular.', 3, '0'),
(127, 'Asuntos consulares', 'Visas', '¿Cuáles son los requisitos para gestionar una visa mexicana?', 'Los requisitos son: Formulario de solicitud de visa debidamente llenado. Pasaporte en original y copia con una vigencia mínima de seis meses. Una fotografía tamaño carnet a color y fondo blanco. Constancia laboral en original en la que se indique salario mensual, antigüedad y cargo. Comprobación de solvencia económica: copia de los comprobantes de pago (váuchers) de los últimos 6 meses, constancia de cuenta bancaria en la que se indique saldo actual, saldo promedio y fecha de apertura de cuenta, estado de cuenta bancario desglosado de los últimos 6 meses. En caso de contar con títulos de propiedad presentar original y copia. En caso de ser comerciante individual, presentar: escritura de comerciante individual, permisos de operación de los últimos 2 años y estado financiero de los últimos 6 meses. Se recomienda descargar el formulario en <a href=\'https://embamex.sre.gob.mx/honduras/\' target=\'_blank\'>https://embamex.sre.gob.mx/honduras/</a> o en <a href=\'https://consulmex.sre.gob.mx/sanpedrosula/\' target=\'_blank\'>https://consulmex.sre.gob.mx/sanpedrosula/</a>', 4, '0'),
(128, 'Asuntos consulares', 'Citas', '¿Perdí mi cita, no pude presentarme. ¿Puedo reprogramarla?', 'El único medio para agendar una cita nuevamente es en el portal web <a href=\'https://citas.sre.gob.mx/\' target=\'_blank\'>https://citas.sre.gob.mx/</a>. Si usted no se presentó el día correspondiente automáticamente pierde su cita consular.', 5, '0'),
(129, 'Asuntos consulares', 'Citas', '¿Ya cuento con mi autorización NUT del INAMI, pueden agendarme una cita?', 'Embamex Honduras: Se recomienda enviar un correo a la dirección <a href=\'mailto:visasembhon@sre.gob.mx\'>visasembhon@sre.gob.mx</a>, agradecemos adjuntar al correo su autorización del INAMI. Consulado de México en San Pedro Sula: el único medio para obtener una cita es en línea.', 6, '0'),
(130, 'Asuntos consulares', 'Citas', '¿Ya cuento con mi carta de aceptación de la universidad, pueden agendarme una cita?', 'Embamex Honduras: Se recomienda enviar un correo a la dirección <a href=\'mailto:visasembhon@sre.gob.mx\'>visasembhon@sre.gob.mx</a>, agradecemos adjuntar al correo su carta de aceptación y copia de su pasaporte. Consulado de México en San Pedro Sula: el único medio para obtener una cita es en línea.', 7, '0'),
(131, 'Asuntos consulares', 'Citas', '¿Ya cuento con autorización NUT del INAMI por unificación familiar, pueden agendarme una cita?', 'Embamex Honduras: Se recomienda enviar un correo a la dirección <a href=\'mailto:visasembhon@sre.gob.mx\'>visasembhon@sre.gob.mx</a>, agradecemos adjuntar al correo autorización del INAMI y copia de su pasaporte. Consulado de México en San Pedro Sula: el único medio para obtener una cita es en línea.', 8, '0'),
(132, 'Asuntos consulares', 'Citas', '¿Ya cuento con autorización NUT del INAMI por oferta de empleo, pueden agendarme una cita?', 'Embamex Honduras: Se recomienda enviar un correo a la dirección <a href=\'mailto:visasembhon@sre.gob.mx\'>visasembhon@sre.gob.mx</a>, agradecemos adjuntar al correo autorización del INAMI y copia de su pasaporte. Consulado de México en San Pedro Sula: el único medio para obtener una cita es en línea.', 9, '0'),
(133, 'Asuntos consulares', 'Visas', '¿No puedo presentarme a recoger mi visa, puede ir alguien más?', 'No, se recomienda recoger el pasaporte en otra fecha posterior a la misma hora solicitada. Los trámites son personales.', 10, '0'),
(134, 'Asuntos consulares', 'Documentación', '¿Cuánto tiempo de vigencia debe tener el pasaporte para poder agendar una cita?', 'Se recomienda tener una vigencia superior a 6 meses.', 11, '0'),
(135, 'Asuntos consulares', 'Visas', '¿Cuánto tiempo es el indicado para poder viajar con una visa mexicana vigente?', 'Se recomienda viajar dentro de la vigencia de su visa y no exceder su estadía si su visa está próxima a vencer.', 12, '0'),
(136, 'Asuntos consulares', 'Visas', '¿Qué visas extranjeras permiten el ingreso a México sin requerir una visa mexicana adicional?', 'Las siguientes visas permiten el ingreso a México sin visa mexicana adicional: Estados Unidos, Japón, Canadá, Reino Unido y países dentro del Espacio Schengen.', 13, '0'),
(137, 'Asuntos consulares', 'Visas', '¿Qué nacionalidades pueden ingresar a México sin requerir una visa mexicana?', 'Entre los pasaportes que no requieren visa mexicana se encuentran: Estados Unidos, Canadá, España, Francia, Alemania, Italia, Reino Unido, Japón, Corea del Sur, Chile, Argentina, Uruguay, entre otras.', 14, '0'),
(138, 'Asuntos consulares', 'Citas', '¿Tiene costo la cita para entrevista consular?', 'La cita consular es gratuita.', 15, '0'),
(139, 'Asuntos consulares', 'Citas', '¿Puedo programar una cita consular en las oficinas consulares de Tegucigalpa o San Pedro Sula siendo extranjero?', 'Sí, siempre que la persona pueda comprobar su estancia legal en el país, ya sea con un carné de residencia o con el sello migratorio en su pasaporte que indique que se encuentra dentro del tiempo de permanencia autorizado por la autoridad migratoria.', 16, '0'),
(140, 'Asuntos consulares', 'Visas', '¿Si una solicitud de visa es denegada, cuándo se puede volver a presentar una nueva solicitud?', 'Se recomienda una espera de seis (6) meses.', 17, '0'),
(141, 'Asuntos consulares', 'Visas', '¿Necesito visa para viajar a México?', 'Todo ciudadano hondureño requiere visa para ingresar a México. Sin embargo, las personas que cuentan con una visa vigente de Estados Unidos pueden ingresar a México sin necesidad de tramitar una visa mexicana, siempre que la visa se encuentre vigente y sea de entradas múltiples. Igualmente, podrán ingresar a México, sin la visa mexicana, las personas que cuenten con visa de Canadá, Estados Unidos, Japón, Reino Unido de la Gran Bretaña e Irlanda del Norte y países dentro del Espacio Schengen.', 18, '0'),
(142, 'Asuntos consulares', 'Visas', '¿Cuánto tiempo tarda el proceso de solicitud de visa?', 'Un máximo de 10 días hábiles después que se realiza la entrevista.', 19, '0'),
(143, 'Asuntos consulares', 'Asuntos migratorios', '¿Cuánto tiempo puedo permanecer en México como visitante?', 'El tiempo de estancia lo determina la autoridad migratoria al momento de su ingreso a México. Sin embargo, si el viaje es por motivos turísticos, la permanencia generalmente no debe exceder los seis meses.', 20, '0'),
(144, 'Asuntos consulares', 'Asuntos migratorios', '¿Puedo trabajar en México con una visa de visitante?', 'No. Para trabajar en México es necesario contar con una autorización del Instituto Nacional de Migración (INM), la cual debe ser solicitada por el empleador en México.', 21, '0');

--
-- Indexes for table `preguntas_frecuentes`
--

ALTER TABLE `preguntas_frecuentes`
  ADD PRIMARY KEY (`id_pregunta`);

--
-- AUTO_INCREMENT for table `preguntas_frecuentes`
--

ALTER TABLE `preguntas_frecuentes`
  MODIFY `id_pregunta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=145;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
