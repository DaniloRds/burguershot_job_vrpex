-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.27-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Copiando estrutura para tabela vrp.vrp_burguershot
DROP TABLE IF EXISTS `vrp_burguershot`;
CREATE TABLE IF NOT EXISTS `vrp_burguershot` (
  `hamburguer` int(100) NOT NULL DEFAULT 0,
  `pizza` int(100) NOT NULL DEFAULT 0,
  `hotdog` int(100) NOT NULL DEFAULT 0,
  `frango` int(100) NOT NULL DEFAULT 0,
  `bebidas` int(100) NOT NULL DEFAULT 0,
  `ingredientes` int(255) NOT NULL DEFAULT 0,
  `dinheiro` int(255) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela vrp.vrp_burguershot: ~1 rows (aproximadamente)
INSERT INTO `vrp_burguershot` (`hamburguer`, `pizza`, `hotdog`, `frango`, `bebidas`, `ingredientes`, `dinheiro`) VALUES
	(46, 27, 45, 20, 30, 35193, 745500);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
