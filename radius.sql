-- phpMyAdmin SQL Dump
-- version 2.11.11.3
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tempo de Geração: Abr 12, 2011 as 10:35 PM
-- Versão do Servidor: 5.0.75
-- Versão do PHP: 5.2.6-3ubuntu4.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Banco de Dados: `radius`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `acl`
--

CREATE TABLE IF NOT EXISTS `acl` (
  `id` int(5) NOT NULL auto_increment,
  `username` varchar(16) NOT NULL default '',
  `password` varchar(16) NOT NULL default '',
  `staffname` varchar(32) NOT NULL default '',
  `string` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Extraindo dados da tabela `acl`
--

INSERT INTO `acl` (`id`, `username`, `password`, `staffname`, `string`) VALUES
(3, 'julio', 'thR8cQNXHkY4E', '', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `aut_noticias`
--

CREATE TABLE IF NOT EXISTS `aut_noticias` (
  `id` int(11) NOT NULL auto_increment,
  `titulo` varchar(255) NOT NULL default '',
  `conteudo` text NOT NULL,
  `autor_id` int(11) NOT NULL default '0',
  `data` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Extraindo dados da tabela `aut_noticias`
--

INSERT INTO `aut_noticias` (`id`, `titulo`, `conteudo`, `autor_id`, `data`) VALUES
(1, 'Sistema de Usuários', 'bla bla bla\r\n\r\nbla bla bla', 1, 1079449401),
(2, 'Atentado em Madri', 'onono onono onono onono', 1, 1079449430),
(3, 'Kernel 2.6', 'oioioi oioioi oioioi oioioi', 2, 1079449456);

-- --------------------------------------------------------

--
-- Estrutura da tabela `aut_usuarios`
--

CREATE TABLE IF NOT EXISTS `aut_usuarios` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(60) NOT NULL default '',
  `login` varchar(40) NOT NULL default '',
  `senha` varchar(40) NOT NULL default '',
  `postar` enum('S','N') NOT NULL default 'S',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Extraindo dados da tabela `aut_usuarios`
--

INSERT INTO `aut_usuarios` (`id`, `nome`, `login`, `senha`, `postar`) VALUES
(1, 'Albert Einstein', 'einstein', 'e7d80ffeefa212b7c5c55700e4f7193e', 'S'),
(2, 'Usuário Teste', 'admin', '698dc19d489c4e4db73e28a713eab07b', 'N');

-- --------------------------------------------------------

--
-- Estrutura da tabela `login`
--

CREATE TABLE IF NOT EXISTS `login` (
  `id` int(5) NOT NULL auto_increment,
  `usuario` text NOT NULL,
  `senha` text NOT NULL,
  `email` text NOT NULL,
  `nome` text NOT NULL,
  `titulo` text NOT NULL,
  `url` text NOT NULL,
  `time` int(15) NOT NULL,
  `ip` varchar(15) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Extraindo dados da tabela `login`
--

INSERT INTO `login` (`id`, `usuario`, `senha`, `email`, `nome`, `titulo`, `url`, `time`, `ip`) VALUES
(1, 'user', '1234', 'email@email.com', 'user', 'sr', 'www.google.com.br', 1262697392, '127.0.0.1');

-- --------------------------------------------------------

--
-- Estrutura da tabela `nas`
--

CREATE TABLE IF NOT EXISTS `nas` (
  `id` int(10) NOT NULL auto_increment,
  `nasname` varchar(128) NOT NULL,
  `shortname` varchar(32) default NULL,
  `type` varchar(30) default 'other',
  `ports` int(5) default NULL,
  `secret` varchar(60) NOT NULL default 'secret',
  `community` varchar(50) default NULL,
  `description` varchar(200) default 'RADIUS Client',
  PRIMARY KEY  (`id`),
  KEY `nasname` (`nasname`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Extraindo dados da tabela `nas`
--

INSERT INTO `nas` (`id`, `nasname`, `shortname`, `type`, `ports`, `secret`, `community`, `description`) VALUES
(1, '0.0.0.0/0', 'TesteMikrotik', 'other', NULL, 'nassecret', NULL, 'RADIUS Client Teste');

-- --------------------------------------------------------

--
-- Estrutura da tabela `radacct`
--

CREATE TABLE IF NOT EXISTS `radacct` (
  `RadAcctId` bigint(21) NOT NULL auto_increment,
  `AcctSessionId` varchar(32) NOT NULL default '',
  `AcctUniqueId` varchar(32) NOT NULL default '',
  `UserName` varchar(64) NOT NULL default '',
  `Realm` varchar(64) default '',
  `NASIPAddress` varchar(15) NOT NULL default '',
  `NASPortId` varchar(15) default NULL,
  `NASPortType` varchar(32) default NULL,
  `AcctStartTime` datetime NOT NULL default '0000-00-00 00:00:00',
  `AcctStopTime` datetime NOT NULL default '0000-00-00 00:00:00',
  `AcctSessionTime` int(12) default NULL,
  `AcctAuthentic` varchar(32) default NULL,
  `ConnectInfo_start` varchar(50) default NULL,
  `ConnectInfo_stop` varchar(50) default NULL,
  `AcctInputOctets` bigint(12) default NULL,
  `AcctOutputOctets` bigint(12) default NULL,
  `CalledStationId` varchar(50) NOT NULL default '',
  `CallingStationId` varchar(50) NOT NULL default '',
  `AcctTerminateCause` varchar(32) NOT NULL default '',
  `ServiceType` varchar(32) default NULL,
  `FramedProtocol` varchar(32) default NULL,
  `FramedIPAddress` varchar(15) NOT NULL default '',
  `AcctStartDelay` int(12) default NULL,
  `AcctStopDelay` int(12) default NULL,
  PRIMARY KEY  (`RadAcctId`),
  KEY `UserName` (`UserName`),
  KEY `FramedIPAddress` (`FramedIPAddress`),
  KEY `AcctSessionId` (`AcctSessionId`),
  KEY `AcctUniqueId` (`AcctUniqueId`),
  KEY `AcctStartTime` (`AcctStartTime`),
  KEY `AcctStopTime` (`AcctStopTime`),
  KEY `NASIPAddress` (`NASIPAddress`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3366 ;

--
-- Extraindo dados da tabela `radacct`
--



-- --------------------------------------------------------

--
-- Estrutura da tabela `radcheck`
--

CREATE TABLE IF NOT EXISTS `radcheck` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `UserName` varchar(64) NOT NULL default '',
  `Attribute` varchar(32) NOT NULL default '',
  `op` char(2) NOT NULL default '==',
  `Value` varchar(253) NOT NULL default '',
  `NOME_USUARIO` varchar(255) NOT NULL,
  `RG` varchar(20) NOT NULL,
  `CPF` varchar(20) NOT NULL,
  `DDD` varchar(3) default NULL,
  `TELEFONE` varchar(9) default NULL,
  `ENDERECO` varchar(255) default NULL,
  `COMPLEMENTO` varchar(45) default NULL,
  `BAIRRO` varchar(45) default NULL,
  `CIDADE` varchar(45) default NULL,
  `ESTADO` varchar(2) default NULL,
  `DATA_CRIACAO` datetime default NULL,
  `DATA_ATUALIZACAO` datetime default NULL,
  `REMOTE_ADDR` varchar(15) default NULL,
  PRIMARY KEY  (`id`),
  KEY `UserName` (`UserName`(32))
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3293 ;

--
-- Extraindo dados da tabela `radcheck`
--

INSERT INTO `radcheck` (`id`, `UserName`, `Attribute`, `op`, `Value`, `NOME_USUARIO`, `RG`, `CPF`, `DDD`, `TELEFONE`, `ENDERECO`, `COMPLEMENTO`, `BAIRRO`, `CIDADE`, `ESTADO`, `DATA_CRIACAO`, `DATA_ATUALIZACAO`, `REMOTE_ADDR`) VALUES
(1, 'user', 'Password', ':=', '1234', '', '', '', NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL),
(3287, '', 'Password', ':=', '', '', '', '', NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `radgroupcheck`
--

CREATE TABLE IF NOT EXISTS `radgroupcheck` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `GroupName` varchar(64) NOT NULL default '',
  `Attribute` varchar(32) NOT NULL default '',
  `op` char(2) NOT NULL default '==',
  `Value` varchar(253) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `GroupName` (`GroupName`(32))
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Extraindo dados da tabela `radgroupcheck`
--


-- --------------------------------------------------------

--
-- Estrutura da tabela `radgroupreply`
--

CREATE TABLE IF NOT EXISTS `radgroupreply` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `GroupName` varchar(64) NOT NULL default '',
  `Attribute` varchar(32) NOT NULL default '',
  `op` char(2) NOT NULL default '=',
  `Value` varchar(253) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `GroupName` (`GroupName`(32))
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=43 ;

--
-- Extraindo dados da tabela `radgroupreply`
--

INSERT INTO `radgroupreply` (`id`, `GroupName`, `Attribute`, `op`, `Value`) VALUES
(1, 'teste', 'Mikrotik-Rate-Limit', ':=', '964000/548000');

-- --------------------------------------------------------

--
-- Estrutura da tabela `radpostauth`
--

CREATE TABLE IF NOT EXISTS `radpostauth` (
  `id` int(11) NOT NULL auto_increment,
  `user` varchar(64) NOT NULL default '',
  `pass` varchar(64) NOT NULL default '',
  `reply` varchar(32) NOT NULL default '',
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4164 ;

--
-- Extraindo dados da tabela `radpostauth`
--


-- --------------------------------------------------------

--
-- Estrutura da tabela `radreply`
--

CREATE TABLE IF NOT EXISTS `radreply` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `UserName` varchar(64) NOT NULL default '',
  `Attribute` varchar(32) NOT NULL default '',
  `op` char(2) NOT NULL default '=',
  `Value` varchar(253) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `UserName` (`UserName`(32))
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=254 ;

--
-- Extraindo dados da tabela `radreply`
--

INSERT INTO `radreply` (`id`, `UserName`, `Attribute`, `op`, `Value`) VALUES
(1, 'user', 'Auth-Type', '=', 'PAP');

-- --------------------------------------------------------

--
-- Estrutura da tabela `radusergroup`
--

CREATE TABLE IF NOT EXISTS `radusergroup` (
  `UserName` varchar(64) NOT NULL default '',
  `GroupName` varchar(64) NOT NULL default '',
  `priority` int(11) NOT NULL default '1',
  KEY `UserName` (`UserName`(32))
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `radusergroup`
--

INSERT INTO `radusergroup` (`UserName`, `GroupName`, `priority`) VALUES
('user', 'teste', 1);

