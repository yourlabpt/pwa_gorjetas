--
-- PostgreSQL database dump
--

\restrict 6uZ1CpAjAhyHjCPi0SWFngauZ2mcv9HnuD8syHQR2G9maYzmnqXdDrQd6UWedZQ

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.11 (Debian 16.11-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.user_restaurant DROP CONSTRAINT IF EXISTS "user_restaurant_userId_fkey";
ALTER TABLE IF EXISTS ONLY public.user_restaurant DROP CONSTRAINT IF EXISTS "user_restaurant_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.transacoes DROP CONSTRAINT IF EXISTS "transacoes_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.transacoes DROP CONSTRAINT IF EXISTS "transacoes_funcID_garcom_fkey";
ALTER TABLE IF EXISTS ONLY public.transacoes DROP CONSTRAINT IF EXISTS transacoes_acerto_periodo_id_fkey;
ALTER TABLE IF EXISTS ONLY public.limpeza DROP CONSTRAINT IF EXISTS "limpeza_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.limpeza_records DROP CONSTRAINT IF EXISTS "limpeza_records_prodID_fkey";
ALTER TABLE IF EXISTS ONLY public.limpeza_records DROP CONSTRAINT IF EXISTS "limpeza_records_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.funcionarios DROP CONSTRAINT IF EXISTS "funcionarios_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.funcionario_restaurante DROP CONSTRAINT IF EXISTS "funcionario_restaurante_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.funcionario_restaurante DROP CONSTRAINT IF EXISTS "funcionario_restaurante_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.faturamento_diario DROP CONSTRAINT IF EXISTS "faturamento_diario_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.faturamento_diario_distribuicao DROP CONSTRAINT IF EXISTS "faturamento_diario_distribuicao_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.faturamento_diario_distribuicao DROP CONSTRAINT IF EXISTS "faturamento_diario_distribuicao_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.distribuicao_gorjetas DROP CONSTRAINT IF EXISTS "distribuicao_gorjetas_tranID_fkey";
ALTER TABLE IF EXISTS ONLY public.distribuicao_gorjetas DROP CONSTRAINT IF EXISTS "distribuicao_gorjetas_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.configuracao_gorjetas DROP CONSTRAINT IF EXISTS "configuracao_gorjetas_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.configuracao_acerto DROP CONSTRAINT IF EXISTS "configuracao_acerto_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.acerto_periodo DROP CONSTRAINT IF EXISTS "acerto_periodo_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.acerto_funcionario DROP CONSTRAINT IF EXISTS "acerto_funcionario_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.acerto_funcionario DROP CONSTRAINT IF EXISTS acerto_funcionario_configuracao_acerto_id_fkey;
ALTER TABLE IF EXISTS ONLY public.acerto_funcionario DROP CONSTRAINT IF EXISTS acerto_funcionario_acerto_periodo_id_fkey;
DROP INDEX IF EXISTS public.users_email_key;
DROP INDEX IF EXISTS public."user_restaurant_userId_restID_key";
DROP INDEX IF EXISTS public."user_restaurant_restID_idx";
DROP INDEX IF EXISTS public."transacoes_restID_idx";
DROP INDEX IF EXISTS public.transacoes_pago_idx;
DROP INDEX IF EXISTS public."transacoes_funcID_garcom_idx";
DROP INDEX IF EXISTS public."transacoes_createdAt_idx";
DROP INDEX IF EXISTS public."limpeza_restID_idx";
DROP INDEX IF EXISTS public."limpeza_records_prodID_idx";
DROP INDEX IF EXISTS public."limpeza_records_funcID_idx";
DROP INDEX IF EXISTS public."funcionarios_restID_idx";
DROP INDEX IF EXISTS public."funcionarios_restID_funcao_idx";
DROP INDEX IF EXISTS public."funcionario_restaurante_restID_idx";
DROP INDEX IF EXISTS public."funcionario_restaurante_funcID_restID_key";
DROP INDEX IF EXISTS public."funcionario_restaurante_funcID_idx";
DROP INDEX IF EXISTS public."faturamento_diario_restID_idx";
DROP INDEX IF EXISTS public."faturamento_diario_restID_data_key";
DROP INDEX IF EXISTS public."faturamento_diario_distribuicao_restID_idx";
DROP INDEX IF EXISTS public."faturamento_diario_distribuicao_restID_data_funcID_role_key";
DROP INDEX IF EXISTS public.faturamento_diario_distribuicao_data_idx;
DROP INDEX IF EXISTS public.faturamento_diario_data_idx;
DROP INDEX IF EXISTS public."distribuicao_gorjetas_tranID_idx";
DROP INDEX IF EXISTS public."distribuicao_gorjetas_funcID_idx";
DROP INDEX IF EXISTS public."configuracao_gorjetas_restID_idx";
DROP INDEX IF EXISTS public."configuracao_gorjetas_restID_funcao_key";
DROP INDEX IF EXISTS public.configuracao_gorjetas_ordem_calculo_idx;
DROP INDEX IF EXISTS public."configuracao_acerto_restID_idx";
DROP INDEX IF EXISTS public."configuracao_acerto_restID_funcao_key";
DROP INDEX IF EXISTS public."acerto_periodo_restID_idx";
DROP INDEX IF EXISTS public.acerto_periodo_periodo_inicio_idx;
DROP INDEX IF EXISTS public.acerto_periodo_pago_idx;
DROP INDEX IF EXISTS public."acerto_funcionario_funcID_idx";
DROP INDEX IF EXISTS public.acerto_funcionario_acerto_periodo_id_idx;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_restaurant DROP CONSTRAINT IF EXISTS user_restaurant_pkey;
ALTER TABLE IF EXISTS ONLY public.transacoes DROP CONSTRAINT IF EXISTS transacoes_pkey;
ALTER TABLE IF EXISTS ONLY public.restaurantes DROP CONSTRAINT IF EXISTS restaurantes_pkey;
ALTER TABLE IF EXISTS ONLY public.limpeza_records DROP CONSTRAINT IF EXISTS limpeza_records_pkey;
ALTER TABLE IF EXISTS ONLY public.limpeza DROP CONSTRAINT IF EXISTS limpeza_pkey;
ALTER TABLE IF EXISTS ONLY public.funcionarios DROP CONSTRAINT IF EXISTS funcionarios_pkey;
ALTER TABLE IF EXISTS ONLY public.funcionario_restaurante DROP CONSTRAINT IF EXISTS funcionario_restaurante_pkey;
ALTER TABLE IF EXISTS ONLY public.faturamento_diario DROP CONSTRAINT IF EXISTS faturamento_diario_pkey;
ALTER TABLE IF EXISTS ONLY public.faturamento_diario_distribuicao DROP CONSTRAINT IF EXISTS faturamento_diario_distribuicao_pkey;
ALTER TABLE IF EXISTS ONLY public.distribuicao_gorjetas DROP CONSTRAINT IF EXISTS distribuicao_gorjetas_pkey;
ALTER TABLE IF EXISTS ONLY public.configuracao_gorjetas DROP CONSTRAINT IF EXISTS configuracao_gorjetas_pkey;
ALTER TABLE IF EXISTS ONLY public.configuracao_acerto DROP CONSTRAINT IF EXISTS configuracao_acerto_pkey;
ALTER TABLE IF EXISTS ONLY public.acerto_periodo DROP CONSTRAINT IF EXISTS acerto_periodo_pkey;
ALTER TABLE IF EXISTS ONLY public.acerto_funcionario DROP CONSTRAINT IF EXISTS acerto_funcionario_pkey;
ALTER TABLE IF EXISTS ONLY public._prisma_migrations DROP CONSTRAINT IF EXISTS _prisma_migrations_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_restaurant ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.transacoes ALTER COLUMN "tranID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.restaurantes ALTER COLUMN "restID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.limpeza_records ALTER COLUMN "recordID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.limpeza ALTER COLUMN "prodID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.funcionarios ALTER COLUMN "funcID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.funcionario_restaurante ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.faturamento_diario_distribuicao ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.faturamento_diario ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.distribuicao_gorjetas ALTER COLUMN "distID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.configuracao_gorjetas ALTER COLUMN "configID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.configuracao_acerto ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acerto_periodo ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acerto_funcionario ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.user_restaurant_id_seq;
DROP TABLE IF EXISTS public.user_restaurant;
DROP SEQUENCE IF EXISTS public."transacoes_tranID_seq";
DROP TABLE IF EXISTS public.transacoes;
DROP SEQUENCE IF EXISTS public."restaurantes_restID_seq";
DROP TABLE IF EXISTS public.restaurantes;
DROP SEQUENCE IF EXISTS public."limpeza_records_recordID_seq";
DROP TABLE IF EXISTS public.limpeza_records;
DROP SEQUENCE IF EXISTS public."limpeza_prodID_seq";
DROP TABLE IF EXISTS public.limpeza;
DROP SEQUENCE IF EXISTS public."funcionarios_funcID_seq";
DROP TABLE IF EXISTS public.funcionarios;
DROP SEQUENCE IF EXISTS public.funcionario_restaurante_id_seq;
DROP TABLE IF EXISTS public.funcionario_restaurante;
DROP SEQUENCE IF EXISTS public.faturamento_diario_id_seq;
DROP SEQUENCE IF EXISTS public.faturamento_diario_distribuicao_id_seq;
DROP TABLE IF EXISTS public.faturamento_diario_distribuicao;
DROP TABLE IF EXISTS public.faturamento_diario;
DROP SEQUENCE IF EXISTS public."distribuicao_gorjetas_distID_seq";
DROP TABLE IF EXISTS public.distribuicao_gorjetas;
DROP SEQUENCE IF EXISTS public."configuracao_gorjetas_configID_seq";
DROP TABLE IF EXISTS public.configuracao_gorjetas;
DROP SEQUENCE IF EXISTS public.configuracao_acerto_id_seq;
DROP TABLE IF EXISTS public.configuracao_acerto;
DROP SEQUENCE IF EXISTS public.acerto_periodo_id_seq;
DROP TABLE IF EXISTS public.acerto_periodo;
DROP SEQUENCE IF EXISTS public.acerto_funcionario_id_seq;
DROP TABLE IF EXISTS public.acerto_funcionario;
DROP TABLE IF EXISTS public._prisma_migrations;
DROP TYPE IF EXISTS public."UserRole";
--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."UserRole" AS ENUM (
    'ADMIN',
    'GESTOR',
    'SUPERVISOR'
);


ALTER TYPE public."UserRole" OWNER TO app;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO app;

--
-- Name: acerto_funcionario; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.acerto_funcionario (
    id integer NOT NULL,
    acerto_periodo_id integer NOT NULL,
    "funcID" integer NOT NULL,
    configuracao_acerto_id integer NOT NULL,
    funcao text NOT NULL,
    valor_base numeric(12,2) NOT NULL,
    percentual_aplicado numeric(5,2),
    valor_absoluto_aplicado numeric(10,2),
    valor_calculado numeric(12,2) NOT NULL,
    pago boolean DEFAULT false NOT NULL,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.acerto_funcionario OWNER TO app;

--
-- Name: acerto_funcionario_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.acerto_funcionario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.acerto_funcionario_id_seq OWNER TO app;

--
-- Name: acerto_funcionario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.acerto_funcionario_id_seq OWNED BY public.acerto_funcionario.id;


--
-- Name: acerto_periodo; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.acerto_periodo (
    id integer NOT NULL,
    "restID" integer NOT NULL,
    periodo_inicio date NOT NULL,
    periodo_fim date NOT NULL,
    tipo_periodo text NOT NULL,
    faturamento_total numeric(12,2) NOT NULL,
    gorjeta_total numeric(12,2) NOT NULL,
    pago boolean DEFAULT false NOT NULL,
    data_pagamento timestamp(3) without time zone,
    usuario_pagamento_id integer,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.acerto_periodo OWNER TO app;

--
-- Name: acerto_periodo_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.acerto_periodo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.acerto_periodo_id_seq OWNER TO app;

--
-- Name: acerto_periodo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.acerto_periodo_id_seq OWNED BY public.acerto_periodo.id;


--
-- Name: configuracao_acerto; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.configuracao_acerto (
    id integer NOT NULL,
    "restID" integer NOT NULL,
    funcao text NOT NULL,
    base_calculo text NOT NULL,
    valor_percentual numeric(5,2),
    valor_absoluto numeric(10,2),
    ativo boolean DEFAULT true NOT NULL,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL,
    ordem_calculo integer DEFAULT 999 NOT NULL
);


ALTER TABLE public.configuracao_acerto OWNER TO app;

--
-- Name: configuracao_acerto_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.configuracao_acerto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.configuracao_acerto_id_seq OWNER TO app;

--
-- Name: configuracao_acerto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.configuracao_acerto_id_seq OWNED BY public.configuracao_acerto.id;


--
-- Name: configuracao_gorjetas; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.configuracao_gorjetas (
    "configID" integer NOT NULL,
    "restID" integer NOT NULL,
    funcao text NOT NULL,
    percentagem numeric(5,2) NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    ordem_calculo integer DEFAULT 0 NOT NULL,
    tipo_calculo text DEFAULT 'percentagem'::text NOT NULL
);


ALTER TABLE public.configuracao_gorjetas OWNER TO app;

--
-- Name: configuracao_gorjetas_configID_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."configuracao_gorjetas_configID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."configuracao_gorjetas_configID_seq" OWNER TO app;

--
-- Name: configuracao_gorjetas_configID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."configuracao_gorjetas_configID_seq" OWNED BY public.configuracao_gorjetas."configID";


--
-- Name: distribuicao_gorjetas; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.distribuicao_gorjetas (
    "distID" integer NOT NULL,
    "tranID" integer NOT NULL,
    "funcID" integer NOT NULL,
    tipo_distribuicao text NOT NULL,
    percentagem_aplicada numeric(5,2) NOT NULL,
    valor_calculado numeric(10,2) NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.distribuicao_gorjetas OWNER TO app;

--
-- Name: distribuicao_gorjetas_distID_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."distribuicao_gorjetas_distID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."distribuicao_gorjetas_distID_seq" OWNER TO app;

--
-- Name: distribuicao_gorjetas_distID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."distribuicao_gorjetas_distID_seq" OWNED BY public.distribuicao_gorjetas."distID";


--
-- Name: faturamento_diario; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.faturamento_diario (
    id integer NOT NULL,
    "restID" integer NOT NULL,
    data date NOT NULL,
    faturamento_inserido numeric(12,2) NOT NULL,
    faturamento_calculado numeric(12,2) DEFAULT 0 NOT NULL,
    diferenca_percentual numeric(5,2) DEFAULT 0 NOT NULL,
    notas text,
    ativo boolean DEFAULT true NOT NULL,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.faturamento_diario OWNER TO app;

--
-- Name: faturamento_diario_distribuicao; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.faturamento_diario_distribuicao (
    id integer NOT NULL,
    "restID" integer NOT NULL,
    data date NOT NULL,
    "funcID" integer,
    role text NOT NULL,
    valor_pool numeric(12,2),
    valor_direto numeric(12,2),
    valor_teorico numeric(12,2),
    valor_pago numeric(12,2) NOT NULL,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.faturamento_diario_distribuicao OWNER TO app;

--
-- Name: faturamento_diario_distribuicao_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.faturamento_diario_distribuicao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faturamento_diario_distribuicao_id_seq OWNER TO app;

--
-- Name: faturamento_diario_distribuicao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.faturamento_diario_distribuicao_id_seq OWNED BY public.faturamento_diario_distribuicao.id;


--
-- Name: faturamento_diario_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.faturamento_diario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faturamento_diario_id_seq OWNER TO app;

--
-- Name: faturamento_diario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.faturamento_diario_id_seq OWNED BY public.faturamento_diario.id;


--
-- Name: funcionario_restaurante; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.funcionario_restaurante (
    id integer NOT NULL,
    "funcID" integer NOT NULL,
    "restID" integer NOT NULL,
    funcao text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.funcionario_restaurante OWNER TO app;

--
-- Name: funcionario_restaurante_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.funcionario_restaurante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.funcionario_restaurante_id_seq OWNER TO app;

--
-- Name: funcionario_restaurante_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.funcionario_restaurante_id_seq OWNED BY public.funcionario_restaurante.id;


--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.funcionarios (
    "funcID" integer NOT NULL,
    name text NOT NULL,
    contacto text,
    photo text,
    funcao text NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    "restID" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.funcionarios OWNER TO app;

--
-- Name: funcionarios_funcID_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."funcionarios_funcID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."funcionarios_funcID_seq" OWNER TO app;

--
-- Name: funcionarios_funcID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."funcionarios_funcID_seq" OWNED BY public.funcionarios."funcID";


--
-- Name: limpeza; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.limpeza (
    "prodID" integer NOT NULL,
    "restID" integer NOT NULL,
    name text NOT NULL,
    quantidade numeric(10,2) NOT NULL,
    unidade text NOT NULL,
    preco_unitario numeric(10,2) NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.limpeza OWNER TO app;

--
-- Name: limpeza_prodID_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."limpeza_prodID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."limpeza_prodID_seq" OWNER TO app;

--
-- Name: limpeza_prodID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."limpeza_prodID_seq" OWNED BY public.limpeza."prodID";


--
-- Name: limpeza_records; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.limpeza_records (
    "recordID" integer NOT NULL,
    "prodID" integer NOT NULL,
    "funcID" integer NOT NULL,
    quantidade_usada numeric(10,2) NOT NULL,
    data timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.limpeza_records OWNER TO app;

--
-- Name: limpeza_records_recordID_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."limpeza_records_recordID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."limpeza_records_recordID_seq" OWNER TO app;

--
-- Name: limpeza_records_recordID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."limpeza_records_recordID_seq" OWNED BY public.limpeza_records."recordID";


--
-- Name: restaurantes; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.restaurantes (
    "restID" integer NOT NULL,
    name text NOT NULL,
    endereco text,
    contacto text,
    percentagem_gorjeta_base numeric(5,2) NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.restaurantes OWNER TO app;

--
-- Name: restaurantes_restID_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."restaurantes_restID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."restaurantes_restID_seq" OWNER TO app;

--
-- Name: restaurantes_restID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."restaurantes_restID_seq" OWNED BY public.restaurantes."restID";


--
-- Name: transacoes; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.transacoes (
    "tranID" integer NOT NULL,
    total numeric(10,2) NOT NULL,
    valor_gorjeta_calculada numeric(10,2) NOT NULL,
    percentagem_aplicada numeric(5,2) NOT NULL,
    mbway numeric(10,2) DEFAULT 0 NOT NULL,
    "funcID_garcom" integer NOT NULL,
    "restID" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    data_transacao timestamp(3) without time zone NOT NULL,
    acerto_periodo_id integer,
    pago boolean DEFAULT false NOT NULL
);


ALTER TABLE public.transacoes OWNER TO app;

--
-- Name: transacoes_tranID_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."transacoes_tranID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."transacoes_tranID_seq" OWNER TO app;

--
-- Name: transacoes_tranID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."transacoes_tranID_seq" OWNED BY public.transacoes."tranID";


--
-- Name: user_restaurant; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.user_restaurant (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "restID" integer NOT NULL,
    "roleOverride" public."UserRole",
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.user_restaurant OWNER TO app;

--
-- Name: user_restaurant_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.user_restaurant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_restaurant_id_seq OWNER TO app;

--
-- Name: user_restaurant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.user_restaurant_id_seq OWNED BY public.user_restaurant.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "passwordHash" text NOT NULL,
    role public."UserRole" DEFAULT 'GESTOR'::public."UserRole" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO app;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO app;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: acerto_funcionario id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.acerto_funcionario ALTER COLUMN id SET DEFAULT nextval('public.acerto_funcionario_id_seq'::regclass);


--
-- Name: acerto_periodo id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.acerto_periodo ALTER COLUMN id SET DEFAULT nextval('public.acerto_periodo_id_seq'::regclass);


--
-- Name: configuracao_acerto id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.configuracao_acerto ALTER COLUMN id SET DEFAULT nextval('public.configuracao_acerto_id_seq'::regclass);


--
-- Name: configuracao_gorjetas configID; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.configuracao_gorjetas ALTER COLUMN "configID" SET DEFAULT nextval('public."configuracao_gorjetas_configID_seq"'::regclass);


--
-- Name: distribuicao_gorjetas distID; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.distribuicao_gorjetas ALTER COLUMN "distID" SET DEFAULT nextval('public."distribuicao_gorjetas_distID_seq"'::regclass);


--
-- Name: faturamento_diario id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.faturamento_diario ALTER COLUMN id SET DEFAULT nextval('public.faturamento_diario_id_seq'::regclass);


--
-- Name: faturamento_diario_distribuicao id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.faturamento_diario_distribuicao ALTER COLUMN id SET DEFAULT nextval('public.faturamento_diario_distribuicao_id_seq'::regclass);


--
-- Name: funcionario_restaurante id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionario_restaurante ALTER COLUMN id SET DEFAULT nextval('public.funcionario_restaurante_id_seq'::regclass);


--
-- Name: funcionarios funcID; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionarios ALTER COLUMN "funcID" SET DEFAULT nextval('public."funcionarios_funcID_seq"'::regclass);


--
-- Name: limpeza prodID; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.limpeza ALTER COLUMN "prodID" SET DEFAULT nextval('public."limpeza_prodID_seq"'::regclass);


--
-- Name: limpeza_records recordID; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.limpeza_records ALTER COLUMN "recordID" SET DEFAULT nextval('public."limpeza_records_recordID_seq"'::regclass);


--
-- Name: restaurantes restID; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.restaurantes ALTER COLUMN "restID" SET DEFAULT nextval('public."restaurantes_restID_seq"'::regclass);


--
-- Name: transacoes tranID; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.transacoes ALTER COLUMN "tranID" SET DEFAULT nextval('public."transacoes_tranID_seq"'::regclass);


--
-- Name: user_restaurant id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.user_restaurant ALTER COLUMN id SET DEFAULT nextval('public.user_restaurant_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
9230f627-4485-4d1e-8522-72acbf22f63c	332d1fd456485053bd78dadec4893a2dead8a0b9cb7a4294390a423ba08cf7c9	2026-01-26 15:03:09.76992+00	20260114115711_init	\N	\N	2026-01-26 15:03:09.65651+00	1
84afe22f-927c-4832-97ed-45be53454193	93176d2b498e80a38da5c41d72b6dc4409b3209d53e1ea486af0cb92e13ccef7	2026-01-26 15:03:09.782913+00	20260114115941_init	\N	\N	2026-01-26 15:03:09.771877+00	1
2a251f68-3118-4c37-9cc8-3f321f5e82a2	1748b705651210d8ab3f774989b99ca761b8ef7ded7e97360af01ce83978ad7f	2026-01-26 15:03:09.791951+00	20260114121044_add_data_transacao	\N	\N	2026-01-26 15:03:09.784903+00	1
55a40565-58cf-40dc-9462-452ed8f84d56	daca35c16bde992f5770192b3316ce9c09e8ca56925541a13dd81fcaacee8418	2026-01-26 15:03:09.824922+00	20260121195508_add_funcionario_restaurante_many_to_many	\N	\N	2026-01-26 15:03:09.794226+00	1
1aa1400f-6631-47f7-a97f-33c5908ba34c	abd75879069e45d699907de07f31bf21cce8bb74ea31c8e1087e0f2f795dc157	2026-01-26 15:03:09.924522+00	20260123200216_add_faturamento_acerto_models	\N	\N	2026-01-26 15:03:09.831519+00	1
27908735-c51a-4162-ab60-ac339bea7dd7	a374bd5680926faac852ff7408d53f4085c643801f02ed14bc3b29907f672416	2026-01-26 15:03:09.934544+00	20260123213005_add_advanced_distribuicao_config	\N	\N	2026-01-26 15:03:09.926755+00	1
d3229a53-62ed-4ece-964c-aabed00ff42b	2e4dea2bd94a3fdf009ea2893a03a5ab3a5872c71ec1bbf8b23414315aa1b159	2026-01-26 15:03:09.948433+00	20260124120059_add_tipo_calculo_to_config	\N	\N	2026-01-26 15:03:09.93712+00	1
5292c682-9632-4a79-8f48-cde9c1822918	ac3842a377e273d9db23a89147bc44770f2ef562fa755627472b3136cca1fe09	2026-01-26 15:03:09.982071+00	20260124210153_add_faturamento_diario_distribuicao	\N	\N	2026-01-26 15:03:09.950964+00	1
a0cc347e-42f3-473b-8229-4353b23783d2	89ad955da5ab107f22013896471bbee8c9c459b03ea38b7a43aa7cfbdfae29e6	2026-01-26 15:03:10.021265+00	20260124214928_add_auth_users	\N	\N	2026-01-26 15:03:09.984711+00	1
\.


--
-- Data for Name: acerto_funcionario; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.acerto_funcionario (id, acerto_periodo_id, "funcID", configuracao_acerto_id, funcao, valor_base, percentual_aplicado, valor_absoluto_aplicado, valor_calculado, pago, "criadoEm", "atualizadoEm") FROM stdin;
\.


--
-- Data for Name: acerto_periodo; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.acerto_periodo (id, "restID", periodo_inicio, periodo_fim, tipo_periodo, faturamento_total, gorjeta_total, pago, data_pagamento, usuario_pagamento_id, "criadoEm", "atualizadoEm") FROM stdin;
\.


--
-- Data for Name: configuracao_acerto; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.configuracao_acerto (id, "restID", funcao, base_calculo, valor_percentual, valor_absoluto, ativo, "criadoEm", "atualizadoEm", ordem_calculo) FROM stdin;
\.


--
-- Data for Name: configuracao_gorjetas; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.configuracao_gorjetas ("configID", "restID", funcao, percentagem, ativo, "createdAt", "updatedAt", ordem_calculo, tipo_calculo) FROM stdin;
2	1	cozinha	3.00	t	2026-01-26 19:00:56.511	2026-01-26 19:14:44.816	0	percentagem
5	1	gestor	1.00	t	2026-01-26 19:01:32.403	2026-01-26 19:14:44.907	0	percentagem
4	1	staff	5.50	t	2026-01-26 19:00:56.61	2026-01-26 19:14:44.988	0	percentagem
3	1	supervisor	0.50	t	2026-01-26 19:00:56.512	2026-01-26 19:14:45.064	0	percentagem
7	2	cozinha	3.00	t	2026-01-26 19:18:50.157	2026-01-26 19:19:10.911	0	percentagem
9	2	staff	7.00	t	2026-01-26 19:18:50.233	2026-01-26 19:19:10.984	0	percentagem
8	2	supervisor	1.00	t	2026-01-26 19:18:50.16	2026-01-26 19:19:11.052	0	percentagem
10	2	gestor	1.00	t	2026-01-26 19:19:11.133	2026-01-26 19:19:11.133	0	percentagem
11	3	garcom	7.00	t	2026-02-10 16:20:03.673	2026-02-10 16:20:03.673	0	percentagem
12	3	cozinha	3.00	t	2026-02-10 16:20:03.676	2026-02-10 16:20:03.676	0	percentagem
13	3	supervisor	1.00	t	2026-02-10 16:20:03.677	2026-02-10 16:20:03.677	0	percentagem
14	3	staff	7.00	t	2026-02-10 16:20:03.791	2026-02-10 16:20:03.791	0	percentagem
16	4	cozinha	3.00	t	2026-02-18 12:22:02.565	2026-02-18 12:23:01.265	0	percentagem
18	4	staff	7.00	t	2026-02-18 12:22:02.734	2026-02-18 12:23:01.406	0	percentagem
17	4	supervisor	1.00	t	2026-02-18 12:22:02.569	2026-02-18 12:23:01.497	0	percentagem
\.


--
-- Data for Name: distribuicao_gorjetas; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.distribuicao_gorjetas ("distID", "tranID", "funcID", tipo_distribuicao, percentagem_aplicada, valor_calculado, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: faturamento_diario; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.faturamento_diario (id, "restID", data, faturamento_inserido, faturamento_calculado, diferenca_percentual, notas, ativo, "criadoEm", "atualizadoEm") FROM stdin;
1	1	2026-01-26	3601.71	3601.71	0.00	\N	t	2026-01-26 19:10:14.976	2026-01-26 19:11:18.311
2	1	2026-02-10	3601.71	3601.71	0.00	\N	t	2026-02-10 16:30:07.07	2026-02-10 16:30:07.07
3	1	2026-02-09	3972.36	3972.36	0.00	\N	t	2026-02-10 16:35:22.998	2026-02-10 16:35:22.998
\.


--
-- Data for Name: faturamento_diario_distribuicao; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.faturamento_diario_distribuicao (id, "restID", data, "funcID", role, valor_pool, valor_direto, valor_teorico, valor_pago, "criadoEm", "atualizadoEm") FROM stdin;
14	1	2026-01-26	9	staff	64.34	35.39	\N	70.78	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
15	1	2026-01-26	8	staff	38.34	21.09	\N	42.18	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
16	1	2026-01-26	7	staff	0.00	0.00	\N	0.00	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
17	1	2026-01-26	6	staff	58.92	32.41	\N	64.82	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
18	1	2026-01-26	5	staff	41.74	22.96	\N	45.92	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
19	1	2026-01-26	4	staff	42.18	23.20	\N	46.40	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
20	1	2026-01-26	3	staff	49.20	27.06	\N	54.12	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
21	1	2026-01-26	2	staff	28.59	15.72	\N	31.44	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
22	1	2026-01-26	1	staff	0.00	0.00	\N	0.00	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
23	1	2026-01-26	11	gestor	\N	\N	32.78	32.78	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
24	1	2026-01-26	10	gestor	\N	\N	32.78	32.78	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
25	1	2026-01-26	12	supervisor	\N	\N	16.39	16.39	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
26	1	2026-01-26	13	chamador	\N	\N	\N	88.00	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
27	1	2026-01-26	\N	cozinha	\N	\N	\N	63.53	2026-01-26 19:11:18.314	2026-01-26 19:11:18.314
28	1	2026-02-10	9	staff	28.59	0.00	\N	15.72	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
29	1	2026-02-10	8	staff	49.20	0.00	\N	27.06	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
30	1	2026-02-10	7	staff	42.18	0.00	\N	23.20	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
31	1	2026-02-10	6	staff	41.74	0.00	\N	22.96	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
32	1	2026-02-10	5	staff	58.92	0.00	\N	32.41	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
33	1	2026-02-10	4	staff	38.34	0.00	\N	21.09	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
34	1	2026-02-10	3	staff	64.34	0.00	\N	35.39	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
35	1	2026-02-10	2	staff	0.00	0.00	\N	0.00	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
36	1	2026-02-10	1	staff	0.00	0.00	\N	0.00	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
37	1	2026-02-10	11	gestor	\N	\N	32.78	32.78	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
38	1	2026-02-10	10	gestor	\N	\N	32.78	32.78	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
39	1	2026-02-10	12	supervisor	\N	\N	16.39	16.39	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
40	1	2026-02-10	13	chamador	\N	\N	\N	88.00	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
41	1	2026-02-10	\N	cozinha	\N	\N	\N	63.53	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
42	1	2026-02-09	9	staff	46.48	0.00	\N	25.56	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
43	1	2026-02-09	8	staff	35.99	0.00	\N	19.79	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
44	1	2026-02-09	7	staff	36.43	0.00	\N	20.04	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
45	1	2026-02-09	6	staff	37.57	0.00	\N	20.66	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
46	1	2026-02-09	5	staff	56.14	0.00	\N	30.88	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
47	1	2026-02-09	4	staff	52.39	0.00	\N	28.81	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
48	1	2026-02-09	3	staff	43.07	0.00	\N	23.69	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
49	1	2026-02-09	2	staff	33.94	0.00	\N	18.67	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
50	1	2026-02-09	1	staff	0.00	0.00	\N	0.00	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
51	1	2026-02-09	11	gestor	\N	\N	36.30	36.30	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
52	1	2026-02-09	10	gestor	\N	\N	36.30	36.30	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
53	1	2026-02-09	12	supervisor	\N	\N	18.15	18.15	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
54	1	2026-02-09	13	chamador	\N	\N	\N	87.00	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
55	1	2026-02-09	\N	cozinha	\N	\N	\N	63.15	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
\.


--
-- Data for Name: funcionario_restaurante; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.funcionario_restaurante (id, "funcID", "restID", funcao, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.funcionarios ("funcID", name, contacto, photo, funcao, ativo, "restID", "createdAt", "updatedAt") FROM stdin;
1	Emylaine Gomes	123456789	\N	staff	t	1	2026-01-26 19:01:57.852	2026-01-26 19:01:57.852
2	Sabrina Zoane Correa	123456789	\N	staff	t	1	2026-01-26 19:04:45.626	2026-01-26 19:04:45.626
3	Atiki Ullah 	123456789	\N	staff	t	1	2026-01-26 19:05:28.258	2026-01-26 19:05:28.258
5	Sabita Tamang Lama	123456789	\N	staff	t	1	2026-01-26 19:05:55.801	2026-01-26 19:05:55.801
6	Md Mehedee Hasan	123456789	\N	staff	t	1	2026-01-26 19:06:14.234	2026-01-26 19:06:14.234
7	Zahidur Rahman	123456789	\N	staff	t	1	2026-01-26 19:06:27.452	2026-01-26 19:06:27.452
8	Deyse Jackeline	123456789	\N	staff	t	1	2026-01-26 19:06:46.555	2026-01-26 19:06:46.555
9	Mohammed	123456789	\N	staff	t	1	2026-01-26 19:07:03.014	2026-01-26 19:07:03.014
10	Brunna Fagundes 	123456789	\N	gestor	t	1	2026-01-26 19:07:29.474	2026-01-26 19:07:29.474
11	Erica Ribeiro	123456789	\N	gestor	t	1	2026-01-26 19:07:43.243	2026-01-26 19:07:43.243
12	Douglas	123456789	\N	supervisor	t	1	2026-01-26 19:07:52.865	2026-01-26 19:07:52.865
4	Dhana Maya Tamang	123456798	\N	staff	t	1	2026-01-26 19:05:40.191	2026-01-26 19:10:43.629
14	Teste 	932156789	\N	staff	f	1	2026-01-26 19:14:24.189	2026-01-26 19:14:28.236
13	Maderson	123456789	\N	chamador	t	1	2026-01-26 19:08:05.112	2026-01-26 19:19:33.959
15	Maderson	123456789	\N	chamador	t	2	2026-01-26 19:19:34.024	2026-01-26 19:19:34.024
16	Bruna Moretti 		\N	supervisor	t	3	2026-02-10 16:20:51.46	2026-02-10 16:20:51.46
17	teste 	5555555555	\N	staff	t	3	2026-02-10 17:02:38.817	2026-02-10 17:02:38.817
18	teste1	444444444444	\N	garcom	t	3	2026-02-10 17:02:59.328	2026-02-10 17:02:59.328
19	teste 3		\N	garcom	t	3	2026-02-10 17:03:38.685	2026-02-10 17:03:38.685
20	t4		\N	cozinha	t	3	2026-02-10 17:03:55.368	2026-02-10 17:03:55.368
21	Andressa 		\N	staff	t	4	2026-02-18 12:23:53.975	2026-02-18 12:23:53.975
22	Diones 		\N	staff	t	4	2026-02-18 12:24:40.854	2026-02-18 12:24:40.854
23	Faisal		\N	staff	t	4	2026-02-18 12:25:07.052	2026-02-18 12:25:07.052
24	Jessie 		\N	staff	t	4	2026-02-18 12:25:27.187	2026-02-18 12:25:27.187
25	João 		\N	staff	t	4	2026-02-18 12:25:43.563	2026-02-18 12:25:43.563
26	Kazi		\N	garcom	t	4	2026-02-18 12:25:56.655	2026-02-18 12:25:56.655
27	Lucas 10%		\N	staff	t	4	2026-02-18 12:26:09.159	2026-02-18 12:26:40.229
28	renan		\N	staff	t	4	2026-02-18 12:26:55.033	2026-02-18 12:26:55.033
29	Ridam		\N	staff	t	4	2026-02-18 12:27:16.981	2026-02-18 12:27:16.981
30	Rony		\N	staff	t	4	2026-02-18 12:27:32.618	2026-02-18 12:27:32.618
31	Siam		\N	staff	t	4	2026-02-18 12:27:55.09	2026-02-18 12:27:55.09
32	Pedro		\N	garcom	t	4	2026-02-18 12:28:17.345	2026-02-18 12:28:17.345
33	Thaís 		\N	staff	t	4	2026-02-18 12:28:36.171	2026-02-18 12:28:36.171
34	Hallyson		\N	staff	t	4	2026-02-18 12:28:58.036	2026-02-18 12:28:58.036
35	Douglas		\N	supervisor	t	4	2026-02-18 12:29:22.789	2026-02-18 12:29:22.789
36	Adrian 		\N	chamador	t	4	2026-02-18 12:29:43.731	2026-02-18 12:29:43.731
37	Marcelo		\N	chamador	t	4	2026-02-18 12:29:56.959	2026-02-18 12:29:56.959
38	Carlos		\N	cozinha	t	4	2026-02-18 12:30:45.662	2026-02-18 12:30:45.662
39	Ana 		\N	cozinha	t	4	2026-02-18 12:30:57.912	2026-02-18 12:30:57.912
40	Nirma		\N	cozinha	t	4	2026-02-18 12:31:07.244	2026-02-18 12:31:07.244
41	Sandhya 		\N	cozinha	t	4	2026-02-18 12:31:24.415	2026-02-18 12:31:24.415
42	Srijana 		\N	cozinha	t	4	2026-02-18 12:31:44.611	2026-02-18 12:31:44.611
43	Amit		\N	cozinha	t	4	2026-02-18 12:31:55.751	2026-02-18 12:31:55.751
44	Ana Paula 		\N	cozinha	t	4	2026-02-18 12:32:06.455	2026-02-18 12:32:06.455
45	Dhruv		\N	cozinha	t	4	2026-02-18 12:32:25.162	2026-02-18 12:32:25.162
46	Satvinder		\N	cozinha	t	4	2026-02-18 12:32:35.651	2026-02-18 12:32:35.651
47	Rajinder		\N	cozinha	t	4	2026-02-18 12:32:53.951	2026-02-18 12:32:53.951
48	Sachin		\N	cozinha	t	4	2026-02-18 12:33:09.62	2026-02-18 12:33:09.62
49	Suman		\N	cozinha	t	4	2026-02-18 12:33:21.321	2026-02-18 12:33:21.321
50	Ilaas 		\N	cozinha	t	4	2026-02-18 12:33:44.023	2026-02-18 12:33:44.023
51	Prince		\N	cozinha	t	4	2026-02-18 12:33:54.745	2026-02-18 12:33:54.745
\.


--
-- Data for Name: limpeza; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.limpeza ("prodID", "restID", name, quantidade, unidade, preco_unitario, ativo, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: limpeza_records; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.limpeza_records ("recordID", "prodID", "funcID", quantidade_usada, data, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: restaurantes; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.restaurantes ("restID", name, endereco, contacto, percentagem_gorjeta_base, ativo, "createdAt", "updatedAt") FROM stdin;
1	LOS CHANETES BY BEHER	R. do Comércio 18 20, 1100-200 Lisboa	968 992 245	10.00	t	2026-01-26 19:00:56.501	2026-01-26 19:13:57.826
2	Teste Restaurante	Teste endereço	123456789	11.00	t	2026-01-26 19:18:50.148	2026-01-26 19:18:50.148
3	Costa Lusitânia 	Rua augusta 158	+351 926 133 138	11.00	t	2026-02-10 16:20:03.671	2026-02-10 16:20:03.671
4	Terrazinno 	R. Augusta 218, 1100-056 Lisboa	\N	11.00	t	2026-02-18 12:22:02.547	2026-02-18 12:22:02.547
\.


--
-- Data for Name: transacoes; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.transacoes ("tranID", total, valor_gorjeta_calculada, percentagem_aplicada, mbway, "funcID_garcom", "restID", "createdAt", "updatedAt", data_transacao, acerto_periodo_id, pago) FROM stdin;
\.


--
-- Data for Name: user_restaurant; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.user_restaurant (id, "userId", "restID", "roleOverride", "createdAt", "updatedAt") FROM stdin;
1	3	2	\N	2026-01-26 19:28:43.555	2026-01-26 19:28:43.555
2	3	1	\N	2026-01-26 19:28:43.555	2026-01-26 19:28:43.555
3	2	1	\N	2026-01-26 19:28:48.764	2026-01-26 19:28:48.764
5	4	3	\N	2026-02-10 17:30:36.26	2026-02-10 17:30:36.26
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.users (id, name, email, "passwordHash", role, "createdAt", "updatedAt") FROM stdin;
1	admin	admin@gmail.com	$2b$10$bEfRFj9/XQ4R2sfHfwROhOAf4uloUvCV3PHDnlMAYATn7c2tgWgEq	ADMIN	2026-01-26 18:59:17.554	2026-01-26 18:59:17.554
3	supervisor	super@gmail.com	$2b$10$cbWEfyE3PxOxVlN3OmJ60.MHKXo9n./DKpbk1L/94TNVz.AOtl7J6	SUPERVISOR	2026-01-26 19:28:04.071	2026-01-26 19:28:43.387
2	gestor	gestor@gmail.com	$2b$10$/cDj7gg61gt9LMCvxFDJOeGWKOsCFggmHnH8B9ehYCRKj2bRoHb8O	GESTOR	2026-01-26 19:27:36.979	2026-01-26 19:28:48.663
5	Dâmaris teste 	grupoferreiraaugusta4@gmail.com	$2b$10$YXxA0DAU7wzrxX9wVKaEHO7doDXBcruIme2IgaJGcmIkrdCqnlEnq	ADMIN	2026-02-10 16:19:14.148	2026-02-10 16:19:14.148
6	teste gestor	gf@gmail.com	$2b$10$41SLgl2HdCHBhTNYXpQ.ku/6WAxbRjsGtIWjEA.byabtUiFX5eIWu	GESTOR	2026-02-10 17:15:19.801	2026-02-10 17:15:19.801
7	teste supervisor 	grupo4@gmail.com	$2b$10$Ll6.aJyA/imDE7aLqNuKOuY8dbbwSQlrCESJMMKSokED/B4jwfUpy	SUPERVISOR	2026-02-10 17:26:49.724	2026-02-10 17:26:49.724
4	Dâmaris Nascimento 	grupoferreiraaugusta@gmail.com	$2b$10$uJaOF3Vqb9gp..RxdciD.eqq7a6tWzv7of9OXQh5e57vmazi9nFpG	GESTOR	2026-02-10 16:17:33.975	2026-02-10 17:30:35.856
8	Rio	terrazinno@gmail.com	$2b$10$HFsCyppj7Jq84y2v/yGgAOXt4qiN4a4Jt6btALAXCuqLCv57oXXyC	GESTOR	2026-02-18 12:34:59.96	2026-02-18 12:34:59.96
9	Rio	terrazinnosupervisor@gmail.com	$2b$10$RR2kgljaivlZzA/oFZTDze18aqwu8KG3yENV.Q4Nvqb8ffGWI3..2	SUPERVISOR	2026-02-18 12:37:48.123	2026-02-18 12:37:48.123
\.


--
-- Name: acerto_funcionario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.acerto_funcionario_id_seq', 1, false);


--
-- Name: acerto_periodo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.acerto_periodo_id_seq', 1, false);


--
-- Name: configuracao_acerto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.configuracao_acerto_id_seq', 1, false);


--
-- Name: configuracao_gorjetas_configID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."configuracao_gorjetas_configID_seq"', 18, true);


--
-- Name: distribuicao_gorjetas_distID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."distribuicao_gorjetas_distID_seq"', 1, false);


--
-- Name: faturamento_diario_distribuicao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.faturamento_diario_distribuicao_id_seq', 55, true);


--
-- Name: faturamento_diario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.faturamento_diario_id_seq', 3, true);


--
-- Name: funcionario_restaurante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.funcionario_restaurante_id_seq', 1, false);


--
-- Name: funcionarios_funcID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."funcionarios_funcID_seq"', 51, true);


--
-- Name: limpeza_prodID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."limpeza_prodID_seq"', 1, false);


--
-- Name: limpeza_records_recordID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."limpeza_records_recordID_seq"', 1, false);


--
-- Name: restaurantes_restID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."restaurantes_restID_seq"', 4, true);


--
-- Name: transacoes_tranID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."transacoes_tranID_seq"', 1, false);


--
-- Name: user_restaurant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.user_restaurant_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: acerto_funcionario acerto_funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.acerto_funcionario
    ADD CONSTRAINT acerto_funcionario_pkey PRIMARY KEY (id);


--
-- Name: acerto_periodo acerto_periodo_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.acerto_periodo
    ADD CONSTRAINT acerto_periodo_pkey PRIMARY KEY (id);


--
-- Name: configuracao_acerto configuracao_acerto_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.configuracao_acerto
    ADD CONSTRAINT configuracao_acerto_pkey PRIMARY KEY (id);


--
-- Name: configuracao_gorjetas configuracao_gorjetas_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.configuracao_gorjetas
    ADD CONSTRAINT configuracao_gorjetas_pkey PRIMARY KEY ("configID");


--
-- Name: distribuicao_gorjetas distribuicao_gorjetas_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.distribuicao_gorjetas
    ADD CONSTRAINT distribuicao_gorjetas_pkey PRIMARY KEY ("distID");


--
-- Name: faturamento_diario_distribuicao faturamento_diario_distribuicao_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.faturamento_diario_distribuicao
    ADD CONSTRAINT faturamento_diario_distribuicao_pkey PRIMARY KEY (id);


--
-- Name: faturamento_diario faturamento_diario_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.faturamento_diario
    ADD CONSTRAINT faturamento_diario_pkey PRIMARY KEY (id);


--
-- Name: funcionario_restaurante funcionario_restaurante_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionario_restaurante
    ADD CONSTRAINT funcionario_restaurante_pkey PRIMARY KEY (id);


--
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY ("funcID");


--
-- Name: limpeza limpeza_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.limpeza
    ADD CONSTRAINT limpeza_pkey PRIMARY KEY ("prodID");


--
-- Name: limpeza_records limpeza_records_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.limpeza_records
    ADD CONSTRAINT limpeza_records_pkey PRIMARY KEY ("recordID");


--
-- Name: restaurantes restaurantes_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.restaurantes
    ADD CONSTRAINT restaurantes_pkey PRIMARY KEY ("restID");


--
-- Name: transacoes transacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.transacoes
    ADD CONSTRAINT transacoes_pkey PRIMARY KEY ("tranID");


--
-- Name: user_restaurant user_restaurant_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.user_restaurant
    ADD CONSTRAINT user_restaurant_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: acerto_funcionario_acerto_periodo_id_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX acerto_funcionario_acerto_periodo_id_idx ON public.acerto_funcionario USING btree (acerto_periodo_id);


--
-- Name: acerto_funcionario_funcID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "acerto_funcionario_funcID_idx" ON public.acerto_funcionario USING btree ("funcID");


--
-- Name: acerto_periodo_pago_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX acerto_periodo_pago_idx ON public.acerto_periodo USING btree (pago);


--
-- Name: acerto_periodo_periodo_inicio_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX acerto_periodo_periodo_inicio_idx ON public.acerto_periodo USING btree (periodo_inicio);


--
-- Name: acerto_periodo_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "acerto_periodo_restID_idx" ON public.acerto_periodo USING btree ("restID");


--
-- Name: configuracao_acerto_restID_funcao_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "configuracao_acerto_restID_funcao_key" ON public.configuracao_acerto USING btree ("restID", funcao);


--
-- Name: configuracao_acerto_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "configuracao_acerto_restID_idx" ON public.configuracao_acerto USING btree ("restID");


--
-- Name: configuracao_gorjetas_ordem_calculo_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX configuracao_gorjetas_ordem_calculo_idx ON public.configuracao_gorjetas USING btree (ordem_calculo);


--
-- Name: configuracao_gorjetas_restID_funcao_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "configuracao_gorjetas_restID_funcao_key" ON public.configuracao_gorjetas USING btree ("restID", funcao);


--
-- Name: configuracao_gorjetas_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "configuracao_gorjetas_restID_idx" ON public.configuracao_gorjetas USING btree ("restID");


--
-- Name: distribuicao_gorjetas_funcID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "distribuicao_gorjetas_funcID_idx" ON public.distribuicao_gorjetas USING btree ("funcID");


--
-- Name: distribuicao_gorjetas_tranID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "distribuicao_gorjetas_tranID_idx" ON public.distribuicao_gorjetas USING btree ("tranID");


--
-- Name: faturamento_diario_data_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX faturamento_diario_data_idx ON public.faturamento_diario USING btree (data);


--
-- Name: faturamento_diario_distribuicao_data_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX faturamento_diario_distribuicao_data_idx ON public.faturamento_diario_distribuicao USING btree (data);


--
-- Name: faturamento_diario_distribuicao_restID_data_funcID_role_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "faturamento_diario_distribuicao_restID_data_funcID_role_key" ON public.faturamento_diario_distribuicao USING btree ("restID", data, "funcID", role);


--
-- Name: faturamento_diario_distribuicao_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "faturamento_diario_distribuicao_restID_idx" ON public.faturamento_diario_distribuicao USING btree ("restID");


--
-- Name: faturamento_diario_restID_data_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "faturamento_diario_restID_data_key" ON public.faturamento_diario USING btree ("restID", data);


--
-- Name: faturamento_diario_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "faturamento_diario_restID_idx" ON public.faturamento_diario USING btree ("restID");


--
-- Name: funcionario_restaurante_funcID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "funcionario_restaurante_funcID_idx" ON public.funcionario_restaurante USING btree ("funcID");


--
-- Name: funcionario_restaurante_funcID_restID_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "funcionario_restaurante_funcID_restID_key" ON public.funcionario_restaurante USING btree ("funcID", "restID");


--
-- Name: funcionario_restaurante_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "funcionario_restaurante_restID_idx" ON public.funcionario_restaurante USING btree ("restID");


--
-- Name: funcionarios_restID_funcao_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "funcionarios_restID_funcao_idx" ON public.funcionarios USING btree ("restID", funcao);


--
-- Name: funcionarios_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "funcionarios_restID_idx" ON public.funcionarios USING btree ("restID");


--
-- Name: limpeza_records_funcID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "limpeza_records_funcID_idx" ON public.limpeza_records USING btree ("funcID");


--
-- Name: limpeza_records_prodID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "limpeza_records_prodID_idx" ON public.limpeza_records USING btree ("prodID");


--
-- Name: limpeza_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "limpeza_restID_idx" ON public.limpeza USING btree ("restID");


--
-- Name: transacoes_createdAt_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "transacoes_createdAt_idx" ON public.transacoes USING btree ("createdAt");


--
-- Name: transacoes_funcID_garcom_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "transacoes_funcID_garcom_idx" ON public.transacoes USING btree ("funcID_garcom");


--
-- Name: transacoes_pago_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX transacoes_pago_idx ON public.transacoes USING btree (pago);


--
-- Name: transacoes_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "transacoes_restID_idx" ON public.transacoes USING btree ("restID");


--
-- Name: user_restaurant_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "user_restaurant_restID_idx" ON public.user_restaurant USING btree ("restID");


--
-- Name: user_restaurant_userId_restID_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "user_restaurant_userId_restID_key" ON public.user_restaurant USING btree ("userId", "restID");


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: acerto_funcionario acerto_funcionario_acerto_periodo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.acerto_funcionario
    ADD CONSTRAINT acerto_funcionario_acerto_periodo_id_fkey FOREIGN KEY (acerto_periodo_id) REFERENCES public.acerto_periodo(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: acerto_funcionario acerto_funcionario_configuracao_acerto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.acerto_funcionario
    ADD CONSTRAINT acerto_funcionario_configuracao_acerto_id_fkey FOREIGN KEY (configuracao_acerto_id) REFERENCES public.configuracao_acerto(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: acerto_funcionario acerto_funcionario_funcID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.acerto_funcionario
    ADD CONSTRAINT "acerto_funcionario_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES public.funcionarios("funcID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: acerto_periodo acerto_periodo_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.acerto_periodo
    ADD CONSTRAINT "acerto_periodo_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: configuracao_acerto configuracao_acerto_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.configuracao_acerto
    ADD CONSTRAINT "configuracao_acerto_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: configuracao_gorjetas configuracao_gorjetas_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.configuracao_gorjetas
    ADD CONSTRAINT "configuracao_gorjetas_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: distribuicao_gorjetas distribuicao_gorjetas_funcID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.distribuicao_gorjetas
    ADD CONSTRAINT "distribuicao_gorjetas_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES public.funcionarios("funcID") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: distribuicao_gorjetas distribuicao_gorjetas_tranID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.distribuicao_gorjetas
    ADD CONSTRAINT "distribuicao_gorjetas_tranID_fkey" FOREIGN KEY ("tranID") REFERENCES public.transacoes("tranID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: faturamento_diario_distribuicao faturamento_diario_distribuicao_funcID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.faturamento_diario_distribuicao
    ADD CONSTRAINT "faturamento_diario_distribuicao_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES public.funcionarios("funcID") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: faturamento_diario_distribuicao faturamento_diario_distribuicao_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.faturamento_diario_distribuicao
    ADD CONSTRAINT "faturamento_diario_distribuicao_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: faturamento_diario faturamento_diario_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.faturamento_diario
    ADD CONSTRAINT "faturamento_diario_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: funcionario_restaurante funcionario_restaurante_funcID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionario_restaurante
    ADD CONSTRAINT "funcionario_restaurante_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES public.funcionarios("funcID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: funcionario_restaurante funcionario_restaurante_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionario_restaurante
    ADD CONSTRAINT "funcionario_restaurante_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: funcionarios funcionarios_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT "funcionarios_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: limpeza_records limpeza_records_funcID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.limpeza_records
    ADD CONSTRAINT "limpeza_records_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES public.funcionarios("funcID") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: limpeza_records limpeza_records_prodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.limpeza_records
    ADD CONSTRAINT "limpeza_records_prodID_fkey" FOREIGN KEY ("prodID") REFERENCES public.limpeza("prodID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: limpeza limpeza_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.limpeza
    ADD CONSTRAINT "limpeza_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: transacoes transacoes_acerto_periodo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.transacoes
    ADD CONSTRAINT transacoes_acerto_periodo_id_fkey FOREIGN KEY (acerto_periodo_id) REFERENCES public.acerto_periodo(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: transacoes transacoes_funcID_garcom_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.transacoes
    ADD CONSTRAINT "transacoes_funcID_garcom_fkey" FOREIGN KEY ("funcID_garcom") REFERENCES public.funcionarios("funcID") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: transacoes transacoes_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.transacoes
    ADD CONSTRAINT "transacoes_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: user_restaurant user_restaurant_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.user_restaurant
    ADD CONSTRAINT "user_restaurant_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_restaurant user_restaurant_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.user_restaurant
    ADD CONSTRAINT "user_restaurant_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 6uZ1CpAjAhyHjCPi0SWFngauZ2mcv9HnuD8syHQR2G9maYzmnqXdDrQd6UWedZQ

