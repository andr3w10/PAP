-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 04-Jul-2022 às 06:55
-- Versão do servidor: 10.4.21-MariaDB
-- versão do PHP: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `tlh_database`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `discount_codes`
--

CREATE TABLE `discount_codes` (
  `code` varchar(19) NOT NULL,
  `discount` int(11) NOT NULL,
  `uses` int(11) NOT NULL DEFAULT 0,
  `creation_date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `discount_codes`
--

INSERT INTO `discount_codes` (`code`, `discount`, `uses`, `creation_date`) VALUES
('renagadgets', 100, 0, '2022-07-04'),
('wishop', 10, 0, '2022-01-30');

-- --------------------------------------------------------

--
-- Estrutura da tabela `gift_codes`
--

CREATE TABLE `gift_codes` (
  `code` varchar(19) NOT NULL,
  `coins` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `creation_date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `purchases`
--

CREATE TABLE `purchases` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_quantity` int(11) NOT NULL,
  `spent_coins` int(11) NOT NULL,
  `purchase_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `purchases`
--

INSERT INTO `purchases` (`id`, `username`, `item_id`, `item_quantity`, `spent_coins`, `purchase_date`) VALUES
(1, 'admin', 4, 1, 10, '2022-07-04'),
(2, 'admin', 3, 3, 300, '2022-07-04'),
(3, 'admin', 3, 1, 100, '2022-07-04'),
(4, 'admin', 4, 2, 20, '2022-07-04'),
(5, 'admin', 6, 1, 15, '2022-07-04'),
(6, 'admin', 7, 2, 40, '2022-07-04'),
(7, 'admin', 5, 1, 150, '2022-07-04'),
(8, 'admin', 5, 5, 750, '2022-07-04');

-- --------------------------------------------------------

--
-- Estrutura da tabela `store`
--

CREATE TABLE `store` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `price` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `pack_quantity` int(11) NOT NULL DEFAULT 1,
  `release_date` date NOT NULL DEFAULT current_timestamp(),
  `is_exclusive` tinyint(1) NOT NULL DEFAULT 0,
  `discount` int(11) NOT NULL DEFAULT 0,
  `img_location` varchar(100) NOT NULL DEFAULT '../assets/img/store/store/.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `store`
--

INSERT INTO `store` (`id`, `name`, `price`, `type`, `pack_quantity`, `release_date`, `is_exclusive`, `discount`, `img_location`) VALUES
(1, 'Goblin', 200, 'skin', 1, '2021-11-09', 0, 0, '../assets/img/store/store/goblin.png'),
(2, 'Fox', 100, 'pet', 1, '2021-11-09', 0, 0, '../assets/img/store/store/fox.png'),
(3, 'Basic Sword', 100, 'item', 1, '2021-11-10', 0, 0, '../assets/img/store/store/iron_sword.png'),
(4, 'Berry', 10, 'item (pack of 5)', 5, '2021-11-10', 0, 0, '../assets/img/store/store/berry.png'),
(5, 'Bow', 150, 'item', 1, '2021-11-10', 0, 0, '../assets/img/store/store/bow.png'),
(6, 'Bread', 15, 'item (pack of 8)', 8, '2021-11-10', 0, 0, '../assets/img/store/store/bread.png'),
(7, 'Chicken', 20, 'item (pack of 4)', 4, '2021-11-10', 0, 0, '../assets/img/store/store/chicken.png'),
(8, 'Chest', 100, 'decoration', 1, '2022-02-23', 0, 0, '../assets/img/store/store/chest.png'),
(9, 'Sign', 50, 'decoration', 1, '2022-02-23', 0, 0, '../assets/img/store/store/sign.png'),
(10, 'Torch', 10, 'item', 1, '2022-02-23', 0, 0, '../assets/img/store/store/torch.png'),
(11, 'Cat', 180, 'pet', 1, '2022-02-23', 0, 0, '../assets/img/store/store/cat.png'),
(12, 'Skeleton', 300, 'skin', 1, '2022-02-23', 0, 0, '../assets/img/store/store/skeleton.png'),
(13, 'Chameleon', 350, 'pet', 1, '2022-02-23', 0, 0, '../assets/img/store/store/chameleon.png'),
(14, 'Falcon', 200, 'pet', 1, '2022-02-23', 0, 0, '../assets/img/store/store/falcon.png');

-- --------------------------------------------------------

--
-- Estrutura da tabela `to_claim`
--

CREATE TABLE `to_claim` (
  `purchase_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `users`
--

CREATE TABLE `users` (
  `name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(80) NOT NULL,
  `coins` int(11) NOT NULL DEFAULT 0,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `logged_in_game` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `users`
--

INSERT INTO `users` (`name`, `username`, `email`, `password`, `coins`, `is_admin`, `logged_in_game`) VALUES
('admin', 'admin', 'andr3w.devpt@gmail.com', '$2y$10$TOKNb4RKESCTXS1f6HSKdeIK7fsEfH.7G0WTCkz3YgcNgideR/FTG', 9102, 1, 1);

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `discount_codes`
--
ALTER TABLE `discount_codes`
  ADD PRIMARY KEY (`code`);

--
-- Índices para tabela `gift_codes`
--
ALTER TABLE `gift_codes`
  ADD PRIMARY KEY (`code`);

--
-- Índices para tabela `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`),
  ADD KEY `item_id` (`item_id`);

--
-- Índices para tabela `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `to_claim`
--
ALTER TABLE `to_claim`
  ADD PRIMARY KEY (`purchase_id`);

--
-- Índices para tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`username`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `store`
--
ALTER TABLE `store`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`),
  ADD CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `store` (`id`);

--
-- Limitadores para a tabela `to_claim`
--
ALTER TABLE `to_claim`
  ADD CONSTRAINT `to_claim_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
