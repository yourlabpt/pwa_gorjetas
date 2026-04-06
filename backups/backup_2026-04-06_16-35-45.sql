--
-- PostgreSQL database dump
--

\restrict sCpd8XamdZMm1SildCW6mjP9i0GE7NpoP60jfmavkts3zleT0x8T3F4hTfcmPQ4

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

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
ALTER TABLE IF EXISTS ONLY public.regras_distribuicao DROP CONSTRAINT IF EXISTS "regras_distribuicao_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.limpeza DROP CONSTRAINT IF EXISTS "limpeza_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.limpeza_records DROP CONSTRAINT IF EXISTS "limpeza_records_prodID_fkey";
ALTER TABLE IF EXISTS ONLY public.limpeza_records DROP CONSTRAINT IF EXISTS "limpeza_records_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.funcionarios DROP CONSTRAINT IF EXISTS "funcionarios_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.funcionario_restaurante DROP CONSTRAINT IF EXISTS "funcionario_restaurante_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.funcionario_restaurante DROP CONSTRAINT IF EXISTS "funcionario_restaurante_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.funcionario_presenca_diaria DROP CONSTRAINT IF EXISTS "funcionario_presenca_diaria_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.funcionario_presenca_diaria DROP CONSTRAINT IF EXISTS "funcionario_presenca_diaria_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.fecho_financeiro_template DROP CONSTRAINT IF EXISTS "fecho_financeiro_template_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.fecho_financeiro DROP CONSTRAINT IF EXISTS "fecho_financeiro_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.fecho_financeiro_item DROP CONSTRAINT IF EXISTS "fecho_financeiro_item_templateId_fkey";
ALTER TABLE IF EXISTS ONLY public.fecho_financeiro_item DROP CONSTRAINT IF EXISTS "fecho_financeiro_item_fecID_fkey";
ALTER TABLE IF EXISTS ONLY public.faturamento_diario DROP CONSTRAINT IF EXISTS "faturamento_diario_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.faturamento_diario_distribuicao DROP CONSTRAINT IF EXISTS "faturamento_diario_distribuicao_restID_fkey";
ALTER TABLE IF EXISTS ONLY public.faturamento_diario_distribuicao DROP CONSTRAINT IF EXISTS "faturamento_diario_distribuicao_funcID_fkey";
ALTER TABLE IF EXISTS ONLY public.distribuicao_gorjetas DROP CONSTRAINT IF EXISTS "distribuicao_gorjetas_tranID_fkey";
ALTER TABLE IF EXISTS ONLY public.distribuicao_gorjetas DROP CONSTRAINT IF EXISTS "distribuicao_gorjetas_funcID_fkey";
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
DROP INDEX IF EXISTS public."regras_distribuicao_restID_idx";
DROP INDEX IF EXISTS public."regras_distribuicao_restID_ativo_idx";
DROP INDEX IF EXISTS public."limpeza_restID_idx";
DROP INDEX IF EXISTS public."limpeza_records_prodID_idx";
DROP INDEX IF EXISTS public."limpeza_records_funcID_idx";
DROP INDEX IF EXISTS public."funcionarios_restID_idx";
DROP INDEX IF EXISTS public."funcionarios_restID_funcao_idx";
DROP INDEX IF EXISTS public."funcionario_restaurante_restID_idx";
DROP INDEX IF EXISTS public."funcionario_restaurante_funcID_restID_key";
DROP INDEX IF EXISTS public."funcionario_restaurante_funcID_idx";
DROP INDEX IF EXISTS public."funcionario_presenca_diaria_restID_data_idx";
DROP INDEX IF EXISTS public."funcionario_presenca_diaria_restID_data_funcID_key";
DROP INDEX IF EXISTS public."funcionario_presenca_diaria_funcID_idx";
DROP INDEX IF EXISTS public."fecho_financeiro_template_restID_idx";
DROP INDEX IF EXISTS public."fecho_financeiro_restID_idx";
DROP INDEX IF EXISTS public."fecho_financeiro_restID_data_key";
DROP INDEX IF EXISTS public."fecho_financeiro_item_fecID_idx";
DROP INDEX IF EXISTS public.fecho_financeiro_data_idx;
DROP INDEX IF EXISTS public."faturamento_diario_restID_idx";
DROP INDEX IF EXISTS public."faturamento_diario_restID_data_key";
DROP INDEX IF EXISTS public."faturamento_diario_distribuicao_restID_idx";
DROP INDEX IF EXISTS public."faturamento_diario_distribuicao_restID_data_funcID_role_key";
DROP INDEX IF EXISTS public.faturamento_diario_distribuicao_data_idx;
DROP INDEX IF EXISTS public.faturamento_diario_data_idx;
DROP INDEX IF EXISTS public."distribuicao_gorjetas_tranID_idx";
DROP INDEX IF EXISTS public."distribuicao_gorjetas_funcID_idx";
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
ALTER TABLE IF EXISTS ONLY public.regras_distribuicao DROP CONSTRAINT IF EXISTS regras_distribuicao_pkey;
ALTER TABLE IF EXISTS ONLY public.limpeza_records DROP CONSTRAINT IF EXISTS limpeza_records_pkey;
ALTER TABLE IF EXISTS ONLY public.limpeza DROP CONSTRAINT IF EXISTS limpeza_pkey;
ALTER TABLE IF EXISTS ONLY public.funcionarios DROP CONSTRAINT IF EXISTS funcionarios_pkey;
ALTER TABLE IF EXISTS ONLY public.funcionario_restaurante DROP CONSTRAINT IF EXISTS funcionario_restaurante_pkey;
ALTER TABLE IF EXISTS ONLY public.funcionario_presenca_diaria DROP CONSTRAINT IF EXISTS funcionario_presenca_diaria_pkey;
ALTER TABLE IF EXISTS ONLY public.fecho_financeiro_template DROP CONSTRAINT IF EXISTS fecho_financeiro_template_pkey;
ALTER TABLE IF EXISTS ONLY public.fecho_financeiro DROP CONSTRAINT IF EXISTS fecho_financeiro_pkey;
ALTER TABLE IF EXISTS ONLY public.fecho_financeiro_item DROP CONSTRAINT IF EXISTS fecho_financeiro_item_pkey;
ALTER TABLE IF EXISTS ONLY public.faturamento_diario DROP CONSTRAINT IF EXISTS faturamento_diario_pkey;
ALTER TABLE IF EXISTS ONLY public.faturamento_diario_distribuicao DROP CONSTRAINT IF EXISTS faturamento_diario_distribuicao_pkey;
ALTER TABLE IF EXISTS ONLY public.distribuicao_gorjetas DROP CONSTRAINT IF EXISTS distribuicao_gorjetas_pkey;
ALTER TABLE IF EXISTS ONLY public.configuracao_acerto DROP CONSTRAINT IF EXISTS configuracao_acerto_pkey;
ALTER TABLE IF EXISTS ONLY public.acerto_periodo DROP CONSTRAINT IF EXISTS acerto_periodo_pkey;
ALTER TABLE IF EXISTS ONLY public.acerto_funcionario DROP CONSTRAINT IF EXISTS acerto_funcionario_pkey;
ALTER TABLE IF EXISTS ONLY public._prisma_migrations DROP CONSTRAINT IF EXISTS _prisma_migrations_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_restaurant ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.transacoes ALTER COLUMN "tranID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.restaurantes ALTER COLUMN "restID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.regras_distribuicao ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.limpeza_records ALTER COLUMN "recordID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.limpeza ALTER COLUMN "prodID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.funcionarios ALTER COLUMN "funcID" DROP DEFAULT;
ALTER TABLE IF EXISTS public.funcionario_restaurante ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.funcionario_presenca_diaria ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.fecho_financeiro_template ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.fecho_financeiro_item ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.fecho_financeiro ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.faturamento_diario_distribuicao ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.faturamento_diario ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.distribuicao_gorjetas ALTER COLUMN "distID" DROP DEFAULT;
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
DROP SEQUENCE IF EXISTS public.regras_distribuicao_id_seq;
DROP TABLE IF EXISTS public.regras_distribuicao;
DROP SEQUENCE IF EXISTS public."limpeza_records_recordID_seq";
DROP TABLE IF EXISTS public.limpeza_records;
DROP SEQUENCE IF EXISTS public."limpeza_prodID_seq";
DROP TABLE IF EXISTS public.limpeza;
DROP SEQUENCE IF EXISTS public."funcionarios_funcID_seq";
DROP TABLE IF EXISTS public.funcionarios;
DROP SEQUENCE IF EXISTS public.funcionario_restaurante_id_seq;
DROP TABLE IF EXISTS public.funcionario_restaurante;
DROP SEQUENCE IF EXISTS public.funcionario_presenca_diaria_id_seq;
DROP TABLE IF EXISTS public.funcionario_presenca_diaria;
DROP SEQUENCE IF EXISTS public.fecho_financeiro_template_id_seq;
DROP TABLE IF EXISTS public.fecho_financeiro_template;
DROP SEQUENCE IF EXISTS public.fecho_financeiro_item_id_seq;
DROP TABLE IF EXISTS public.fecho_financeiro_item;
DROP SEQUENCE IF EXISTS public.fecho_financeiro_id_seq;
DROP TABLE IF EXISTS public.fecho_financeiro;
DROP SEQUENCE IF EXISTS public.faturamento_diario_id_seq;
DROP SEQUENCE IF EXISTS public.faturamento_diario_distribuicao_id_seq;
DROP TABLE IF EXISTS public.faturamento_diario_distribuicao;
DROP TABLE IF EXISTS public.faturamento_diario;
DROP SEQUENCE IF EXISTS public."distribuicao_gorjetas_distID_seq";
DROP TABLE IF EXISTS public.distribuicao_gorjetas;
DROP SEQUENCE IF EXISTS public.configuracao_acerto_id_seq;
DROP TABLE IF EXISTS public.configuracao_acerto;
DROP SEQUENCE IF EXISTS public.acerto_periodo_id_seq;
DROP TABLE IF EXISTS public.acerto_periodo;
DROP SEQUENCE IF EXISTS public.acerto_funcionario_id_seq;
DROP TABLE IF EXISTS public.acerto_funcionario;
DROP TABLE IF EXISTS public._prisma_migrations;
DROP TYPE IF EXISTS public."UserRole";
DROP TYPE IF EXISTS public."SettlementType";
DROP TYPE IF EXISTS public."PercentMode";
DROP TYPE IF EXISTS public."PaymentSource";
DROP TYPE IF EXISTS public."EmployeeSplitMode";
DROP TYPE IF EXISTS public."CalculationType";
DROP TYPE IF EXISTS public."CalculationBase";
--
-- Name: CalculationBase; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."CalculationBase" AS ENUM (
    'FATURAMENTO_GLOBAL',
    'FATURAMENTO_COM_GORJETA',
    'FATURAMENTO_SEM_GORJETA',
    'VALOR_TOTAL_GORJETAS'
);


ALTER TYPE public."CalculationBase" OWNER TO app;

--
-- Name: CalculationType; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."CalculationType" AS ENUM (
    'PERCENT',
    'FIXED_AMOUNT'
);


ALTER TYPE public."CalculationType" OWNER TO app;

--
-- Name: EmployeeSplitMode; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."EmployeeSplitMode" AS ENUM (
    'EQUAL_SPLIT',
    'PROPORTIONAL_TO_POOL_INPUT',
    'DIRECT_INPUT_ONLY',
    'FULL_RATE_PER_EMPLOYEE'
);


ALTER TYPE public."EmployeeSplitMode" OWNER TO app;

--
-- Name: PaymentSource; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."PaymentSource" AS ENUM (
    'TIP_POOL',
    'FINANCEIRO',
    'ABSOLUTE_EXTERNAL'
);


ALTER TYPE public."PaymentSource" OWNER TO app;

--
-- Name: PercentMode; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."PercentMode" AS ENUM (
    'ABSOLUTE_PERCENT',
    'BASE_PERCENT_POINTS'
);


ALTER TYPE public."PercentMode" OWNER TO app;

--
-- Name: SettlementType; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."SettlementType" AS ENUM (
    'DIARIO',
    'PERIODO'
);


ALTER TYPE public."SettlementType" OWNER TO app;

--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."UserRole" AS ENUM (
    'ADMIN',
    'GERENTE',
    'SUPERVISOR',
    'SUPER_ADMIN'
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
    "atualizadoEm" timestamp(3) without time zone NOT NULL,
    faturamento_com_gorjeta numeric(12,2),
    faturamento_sem_gorjeta numeric(12,2),
    valor_total_gorjetas numeric(12,2)
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
-- Name: fecho_financeiro; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.fecho_financeiro (
    id integer NOT NULL,
    "restID" integer NOT NULL,
    data date NOT NULL,
    faturamento_global numeric(12,2) DEFAULT 0 NOT NULL,
    dinheiro_a_depositar numeric(12,2) DEFAULT 0 NOT NULL,
    notas text,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.fecho_financeiro OWNER TO app;

--
-- Name: fecho_financeiro_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.fecho_financeiro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fecho_financeiro_id_seq OWNER TO app;

--
-- Name: fecho_financeiro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.fecho_financeiro_id_seq OWNED BY public.fecho_financeiro.id;


--
-- Name: fecho_financeiro_item; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.fecho_financeiro_item (
    id integer NOT NULL,
    "fecID" integer NOT NULL,
    "templateId" integer,
    label text NOT NULL,
    valor numeric(12,2) DEFAULT 0 NOT NULL,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL,
    conta_no_deposito boolean DEFAULT false NOT NULL
);


ALTER TABLE public.fecho_financeiro_item OWNER TO app;

--
-- Name: fecho_financeiro_item_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.fecho_financeiro_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fecho_financeiro_item_id_seq OWNER TO app;

--
-- Name: fecho_financeiro_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.fecho_financeiro_item_id_seq OWNED BY public.fecho_financeiro_item.id;


--
-- Name: fecho_financeiro_template; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.fecho_financeiro_template (
    id integer NOT NULL,
    "restID" integer NOT NULL,
    label text NOT NULL,
    ordem integer DEFAULT 0 NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.fecho_financeiro_template OWNER TO app;

--
-- Name: fecho_financeiro_template_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.fecho_financeiro_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fecho_financeiro_template_id_seq OWNER TO app;

--
-- Name: fecho_financeiro_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.fecho_financeiro_template_id_seq OWNED BY public.fecho_financeiro_template.id;


--
-- Name: funcionario_presenca_diaria; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.funcionario_presenca_diaria (
    id integer NOT NULL,
    "restID" integer NOT NULL,
    data date NOT NULL,
    "funcID" integer NOT NULL,
    presente boolean DEFAULT false NOT NULL,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.funcionario_presenca_diaria OWNER TO app;

--
-- Name: funcionario_presenca_diaria_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.funcionario_presenca_diaria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.funcionario_presenca_diaria_id_seq OWNER TO app;

--
-- Name: funcionario_presenca_diaria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.funcionario_presenca_diaria_id_seq OWNED BY public.funcionario_presenca_diaria.id;


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
    "updatedAt" timestamp(3) without time zone NOT NULL,
    data_admissao date,
    iban text,
    salario numeric(12,2)
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
-- Name: regras_distribuicao; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.regras_distribuicao (
    id integer NOT NULL,
    "restID" integer NOT NULL,
    role_name text NOT NULL,
    calculation_type public."CalculationType" NOT NULL,
    calculation_base public."CalculationBase",
    rate numeric(12,4) NOT NULL,
    payment_source public."PaymentSource" NOT NULL,
    ordem integer DEFAULT 0 NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    "criadoEm" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "atualizadoEm" timestamp(3) without time zone NOT NULL,
    percent_mode public."PercentMode" DEFAULT 'ABSOLUTE_PERCENT'::public."PercentMode" NOT NULL,
    split_mode public."EmployeeSplitMode" DEFAULT 'EQUAL_SPLIT'::public."EmployeeSplitMode" NOT NULL,
    tipo_de_acerto public."SettlementType" DEFAULT 'DIARIO'::public."SettlementType" NOT NULL
);


ALTER TABLE public.regras_distribuicao OWNER TO app;

--
-- Name: regras_distribuicao_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.regras_distribuicao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regras_distribuicao_id_seq OWNER TO app;

--
-- Name: regras_distribuicao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.regras_distribuicao_id_seq OWNED BY public.regras_distribuicao.id;


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
    role public."UserRole" DEFAULT 'GERENTE'::public."UserRole" NOT NULL,
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
-- Name: fecho_financeiro id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro ALTER COLUMN id SET DEFAULT nextval('public.fecho_financeiro_id_seq'::regclass);


--
-- Name: fecho_financeiro_item id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro_item ALTER COLUMN id SET DEFAULT nextval('public.fecho_financeiro_item_id_seq'::regclass);


--
-- Name: fecho_financeiro_template id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro_template ALTER COLUMN id SET DEFAULT nextval('public.fecho_financeiro_template_id_seq'::regclass);


--
-- Name: funcionario_presenca_diaria id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionario_presenca_diaria ALTER COLUMN id SET DEFAULT nextval('public.funcionario_presenca_diaria_id_seq'::regclass);


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
-- Name: regras_distribuicao id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.regras_distribuicao ALTER COLUMN id SET DEFAULT nextval('public.regras_distribuicao_id_seq'::regclass);


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
6c24daf3-995b-4b94-9cdd-51ef4e451a28	36c4e32b9d7dfb2361752104f23690bd48d69cc4a67e0abc3206305408d1ba52	2026-03-05 09:44:49.775381+00	20260305100000_add_split_mode_to_regras_distribuicao	\N	\N	2026-03-05 09:44:49.758338+00	1
2a251f68-3118-4c37-9cc8-3f321f5e82a2	1748b705651210d8ab3f774989b99ca761b8ef7ded7e97360af01ce83978ad7f	2026-01-26 15:03:09.791951+00	20260114121044_add_data_transacao	\N	\N	2026-01-26 15:03:09.784903+00	1
55a40565-58cf-40dc-9462-452ed8f84d56	daca35c16bde992f5770192b3316ce9c09e8ca56925541a13dd81fcaacee8418	2026-01-26 15:03:09.824922+00	20260121195508_add_funcionario_restaurante_many_to_many	\N	\N	2026-01-26 15:03:09.794226+00	1
1aa1400f-6631-47f7-a97f-33c5908ba34c	abd75879069e45d699907de07f31bf21cce8bb74ea31c8e1087e0f2f795dc157	2026-01-26 15:03:09.924522+00	20260123200216_add_faturamento_acerto_models	\N	\N	2026-01-26 15:03:09.831519+00	1
4bf9e8f5-56ff-4d14-978c-29d9466b268f	8f8dd90fb08cc45ce0beaf1780a3084087a55848a3cc7e68f9ccfd3c84228e93	2026-03-05 10:41:39.007431+00	20260305113000_ensure_full_rate_split_mode	\N	\N	2026-03-05 10:41:38.993579+00	1
27908735-c51a-4162-ab60-ac339bea7dd7	a374bd5680926faac852ff7408d53f4085c643801f02ed14bc3b29907f672416	2026-01-26 15:03:09.934544+00	20260123213005_add_advanced_distribuicao_config	\N	\N	2026-01-26 15:03:09.926755+00	1
d3229a53-62ed-4ece-964c-aabed00ff42b	2e4dea2bd94a3fdf009ea2893a03a5ab3a5872c71ec1bbf8b23414315aa1b159	2026-01-26 15:03:09.948433+00	20260124120059_add_tipo_calculo_to_config	\N	\N	2026-01-26 15:03:09.93712+00	1
5292c682-9632-4a79-8f48-cde9c1822918	ac3842a377e273d9db23a89147bc44770f2ef562fa755627472b3136cca1fe09	2026-01-26 15:03:09.982071+00	20260124210153_add_faturamento_diario_distribuicao	\N	\N	2026-01-26 15:03:09.950964+00	1
3d4f5c2d-2ca8-4c6e-b224-aabc2a49ede9	bc756c54b0a1a99f146c1a95c5717528d37acf82705500b3a61842d94b0d33de	2026-03-08 19:32:25.718338+00	20260308120000_add_super_admin_role	\N	\N	2026-03-08 19:32:25.698211+00	1
a0cc347e-42f3-473b-8229-4353b23783d2	89ad955da5ab107f22013896471bbee8c9c459b03ea38b7a43aa7cfbdfae29e6	2026-01-26 15:03:10.021265+00	20260124214928_add_auth_users	\N	\N	2026-01-26 15:03:09.984711+00	1
9f127b12-40a3-4874-85d2-1cee69cf447a	4ebd50304a20a128d880cd5b2bc3db29d4cb4336c55567811123861c804bc813	2026-02-28 22:42:02.99729+00	20260228000000_add_fecho_financeiro	\N	\N	2026-02-28 22:42:02.863137+00	1
6baff5a0-30dd-4103-82e7-d8f772b1c767	824e79c9fc0960d03b28b21037d1998177bfc5395b44a035cb21088dc45e7981	2026-03-03 00:08:46.500921+00	20260302000000_add_regras_distribuicao	\N	\N	2026-03-03 00:08:46.433916+00	1
0909d582-7c32-4b3f-8b23-6ba6848d95b7	b283c509441167ef24bf6924fb7ca78807d7c5deca047c601849ab7b3eee7a82	2026-03-08 19:32:25.814+00	20260308183000_rename_gestor_add_employee_fields_and_attendance	\N	\N	2026-03-08 19:32:25.722317+00	1
159cb011-0566-48e9-a916-6978a017fec1	8446bbe2a3a7684e1023bff16a6ed4c0f71d2375833bab101075717d6769e0c1	2026-03-04 22:02:57.488424+00	20260304120000_drop_legacy_configuracao_gorjetas	\N	\N	2026-03-04 22:02:57.452359+00	1
dd0c4459-d57f-4def-820a-1a12a1cedd2f	ce2147483c9230d7ab6a6e3a8e1ee71c7bd3bf47dbb2ab0a661eb715e7000224	2026-03-05 08:26:52.65418+00	20260304210000_add_percent_mode_to_regras_distribuicao	\N	\N	2026-03-05 08:26:52.630226+00	1
afe82af7-719a-41b0-b6e9-c8790c0239c7	9789dfa04e7ad6415b93e205afa74c5b29a551a9bf8289b8e9023c9d967782c3	2026-03-10 19:44:10.974862+00	20260310150000_add_tipo_acerto_to_regras_distribuicao	\N	\N	2026-03-10 19:44:10.959304+00	1
c784c7c4-be55-4177-a6da-bd7b384942f5	a3e5711a2ccb165854fe2aceb12e744a7a4eab01ef36b05c4f6739b4ad6b0d9a	2026-03-14 16:35:47.86825+00	20260314143000_add_conta_no_deposito_to_fecho_item	\N	\N	2026-03-14 16:35:47.842196+00	1
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
-- Data for Name: distribuicao_gorjetas; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.distribuicao_gorjetas ("distID", "tranID", "funcID", tipo_distribuicao, percentagem_aplicada, valor_calculado, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: faturamento_diario; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.faturamento_diario (id, "restID", data, faturamento_inserido, faturamento_calculado, diferenca_percentual, notas, ativo, "criadoEm", "atualizadoEm", faturamento_com_gorjeta, faturamento_sem_gorjeta, valor_total_gorjetas) FROM stdin;
2	1	2026-02-10	3601.71	3601.71	0.00	\N	t	2026-02-10 16:30:07.07	2026-02-10 16:30:07.07	\N	\N	\N
3	1	2026-02-09	3972.36	3972.36	0.00	\N	t	2026-02-10 16:35:22.998	2026-02-10 16:35:22.998	\N	\N	\N
1	1	2026-01-26	3601.71	3601.71	0.00	\N	t	2026-01-26 19:10:14.976	2026-03-06 16:34:35.99	3233.20	3278.39	323.32
6	4	2026-03-09	4830.43	4830.43	0.00	\N	t	2026-03-10 10:20:08.933	2026-03-10 10:45:23.128	4215.92	4303.44	526.99
7	4	2026-03-02	5050.68	5050.68	0.00	\N	t	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518	3927.20	4559.78	490.90
8	4	2026-03-03	4528.92	4528.92	0.00	\N	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459	3974.00	4032.17	496.75
4	4	2026-03-04	4265.53	4265.53	0.00	\N	t	2026-03-04 22:14:26.359	2026-03-14 11:29:24.466	3143.44	3872.60	392.93
9	4	2026-03-05	4938.38	4938.38	0.00	\N	t	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434	4254.16	4406.61	531.77
10	4	2026-03-06	4947.94	4947.94	0.00	\N	t	2026-03-14 11:39:09.88	2026-03-14 11:43:53.384	4213.76	4421.22	526.72
13	4	2026-03-11	4683.10	4683.10	0.00	\N	t	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427	3968.32	4187.06	496.04
14	4	2026-03-12	7296.62	7296.62	0.00	\N	t	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415	6491.68	6485.16	811.46
15	4	2026-03-13	6870.45	6870.45	0.00	\N	t	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474	5853.36	6138.78	731.67
11	4	2026-03-07	8625.97	8625.97	0.00	\N	t	2026-03-14 12:45:15.261	2026-03-14 14:29:32.886	7638.64	7671.14	954.83
5	4	2026-03-08	6593.16	6593.16	0.00	\N	t	2026-03-09 11:34:57.089	2026-03-14 16:44:54.625	5514.64	5903.83	689.33
29	2	2026-03-30	15333.82	15333.82	0.00	\N	t	2026-04-03 14:41:26.923	2026-04-03 15:32:02.418	13016.88	13706.71	1627.11
30	4	2026-04-02	6016.45	6016.45	0.00	\N	t	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601	4981.36	5393.78	622.67
12	4	2026-03-10	5599.68	5599.68	0.00	\N	t	2026-03-14 12:54:30.388	2026-03-14 17:16:07.472	4954.56	4980.36	619.32
43	6	2026-04-01	8203.10	8203.10	0.00	\N	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499	6042.08	7447.84	755.26
31	6	2026-04-03	15590.19	15590.19	0.00	\N	t	2026-04-04 10:01:18.826	2026-04-04 10:12:04.101	12813.76	13988.47	1601.72
39	5	2026-04-04	9268.46	9268.46	0.00	\N	t	2026-04-05 15:47:58.027	2026-04-06 15:28:47.784	7834.88	8289.10	979.36
38	5	2026-04-03	8924.30	8924.30	0.00	\N	t	2026-04-05 13:02:35.76	2026-04-06 15:36:26.858	7015.20	8047.40	876.90
18	6	2026-04-02	10323.12	10323.12	0.00	\N	t	2026-04-03 09:09:59.087	2026-04-03 10:35:45.655	8677.92	9238.38	1084.74
17	3	2026-04-01	6828.59	6828.59	0.00	\N	t	2026-04-02 17:50:02.757	2026-04-04 12:41:32.309	6058.80	6071.24	757.35
24	3	2026-04-02	10010.02	10010.02	0.00	\N	t	2026-04-03 13:04:06.161	2026-04-04 12:41:54.706	8497.36	8947.85	1062.17
21	11	2026-03-30	5373.28	5373.28	0.00	\N	t	2026-04-03 11:11:57.304	2026-04-03 11:27:16.037	4398.24	4823.50	549.78
22	3	2026-03-30	8190.99	8190.99	0.00	\N	t	2026-04-03 12:20:35.388	2026-04-03 12:25:22.363	7102.72	7303.15	887.84
23	3	2026-03-31	8478.41	8478.41	0.00	\N	t	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816	7437.68	7548.70	929.71
33	3	2026-04-03	11446.64	11446.64	0.00	\N	t	2026-04-04 12:17:05.018	2026-04-04 12:42:08.452	10146.24	10178.36	1268.28
44	4	2026-04-01	5222.03	5222.03	0.00	\N	t	2026-04-06 11:18:48.712	2026-04-06 11:29:02.348	4438.40	4667.23	554.80
25	5	2026-03-30	10117.83	10117.83	0.00	\N	t	2026-04-03 13:21:34.036	2026-04-03 13:49:53.102	8729.04	9026.70	1091.13
20	4	2026-04-03	9289.33	9289.33	0.00	\N	t	2026-04-03 10:09:51.882	2026-04-06 11:48:39.721	8017.68	8287.12	1002.21
26	5	2026-03-31	8572.92	8572.92	0.00	\N	t	2026-04-03 13:52:26.119	2026-04-03 13:57:49.974	7097.76	7685.70	887.22
27	5	2026-04-01	8958.12	8958.12	0.00	\N	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137	7683.20	7997.72	960.40
35	4	2026-04-04	8952.32	8952.32	0.00	\N	t	2026-04-05 09:07:50.824	2026-04-06 11:56:38.626	7643.52	7996.88	955.44
41	4	2026-04-05	9449.39	9449.39	0.00	\N	t	2026-04-06 09:24:41.582	2026-04-06 12:00:23.851	7941.68	8456.68	992.71
28	5	2026-04-02	9649.18	9649.18	0.00	\N	t	2026-04-03 14:13:41.985	2026-04-03 14:21:29.754	8052.56	8642.61	1006.57
34	2	2026-04-03	18138.40	18138.40	0.00	\N	t	2026-04-04 13:11:50.816	2026-04-04 13:49:32.549	15047.52	16257.46	1880.94
36	3	2026-04-04	11253.35	11253.35	0.00	\N	t	2026-04-05 11:29:38.24	2026-04-05 11:39:06.907	9619.84	10050.87	1202.48
46	5	2026-04-05	9077.38	9077.38	0.00	\N	t	2026-04-06 13:19:19.402	2026-04-06 13:36:46.422	7846.24	8096.60	980.78
45	11	2026-03-31	5929.08	5929.08	0.00	\N	t	2026-04-06 12:51:39.969	2026-04-06 15:02:32.39	5073.20	5294.93	634.15
40	11	2026-04-05	7158.16	7158.16	0.00	\N	t	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468	5897.84	6420.93	737.23
42	6	2026-04-05	10451.59	10451.59	0.00	\N	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529	8395.52	9402.15	1049.44
37	6	2026-04-04	14889.12	14889.12	0.00	\N	t	2026-04-05 11:50:53.254	2026-04-06 15:06:34.498	11283.52	13478.68	1410.44
16	6	2026-03-30	9508.48	9508.48	0.00	\N	t	2026-04-02 14:32:13.64	2026-04-06 15:07:11.673	7980.32	8510.94	997.54
47	11	2026-04-01	6059.09	6059.09	0.00	\N	t	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253	4951.44	5440.16	618.93
19	6	2026-03-31	6721.62	6721.62	0.00	\N	t	2026-04-03 09:30:28.144	2026-04-06 15:07:54.355	5274.08	6062.36	659.26
48	11	2026-04-02	7833.75	7833.75	0.00	\N	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704	6882.32	6973.46	860.29
49	11	2026-04-03	6572.32	6572.32	0.00	\N	t	2026-04-06 15:18:55.579	2026-04-06 15:18:59.393	5606.72	5871.48	700.84
32	11	2026-04-04	7536.28	7536.28	0.00	\N	t	2026-04-04 10:16:41.186	2026-04-06 15:25:58.946	5994.16	6787.01	749.27
\.


--
-- Data for Name: faturamento_diario_distribuicao; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.faturamento_diario_distribuicao (id, "restID", data, "funcID", role, valor_pool, valor_direto, valor_teorico, valor_pago, "criadoEm", "atualizadoEm") FROM stdin;
125	1	2026-01-26	1	staff	0.00	0.00	0.00	0.00	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
126	1	2026-01-26	2	staff	28.59	0.00	15.72	15.72	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
127	1	2026-01-26	3	staff	49.20	0.00	27.06	27.06	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
128	1	2026-01-26	4	staff	42.18	0.00	23.20	23.20	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
129	1	2026-01-26	5	staff	41.74	0.00	22.96	22.96	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
130	1	2026-01-26	6	staff	58.92	0.00	32.41	32.41	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
131	1	2026-01-26	7	staff	0.00	0.00	0.00	0.00	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
132	1	2026-01-26	8	staff	38.34	0.00	21.09	21.09	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
133	1	2026-01-26	9	staff	64.35	0.00	35.39	35.39	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
134	1	2026-01-26	12	supervisor	0.00	0.00	16.39	16.39	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
4353	5	2026-04-03	277	staff	153.98	8.87	86.23	86.23	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4354	5	2026-04-03	281	staff	77.14	0.00	43.20	43.20	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
137	1	2026-01-26	\N	cozinha	\N	\N	63.54	63.54	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
135	1	2026-01-26	10	gerente	0.00	0.00	32.78	32.78	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
136	1	2026-01-26	11	gerente	0.00	0.00	32.78	32.78	2026-03-06 16:34:35.998	2026-03-06 16:34:35.998
37	1	2026-02-10	11	gerente	\N	\N	32.78	32.78	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
38	1	2026-02-10	10	gerente	\N	\N	32.78	32.78	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
51	1	2026-02-09	11	gerente	\N	\N	36.30	36.30	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
52	1	2026-02-09	10	gerente	\N	\N	36.30	36.30	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
4355	5	2026-04-03	287	staff	175.08	7.77	98.04	98.04	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4356	5	2026-04-03	288	staff	90.28	0.00	50.56	50.56	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4357	5	2026-04-03	290	staff	0.00	0.00	0.00	0.00	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4358	5	2026-04-03	296	staff	157.54	0.00	88.22	88.22	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4359	5	2026-04-03	336	staff	36.61	0.00	20.50	20.50	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4360	5	2026-04-03	337	staff	0.00	0.00	0.00	0.00	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4361	5	2026-04-03	338	staff	27.27	0.00	15.27	15.27	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4362	5	2026-04-03	339	staff	133.92	15.20	75.00	75.00	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
28	1	2026-02-10	9	staff	28.59	0.00	\N	15.72	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
29	1	2026-02-10	8	staff	49.20	0.00	\N	27.06	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
30	1	2026-02-10	7	staff	42.18	0.00	\N	23.20	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
31	1	2026-02-10	6	staff	41.74	0.00	\N	22.96	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
32	1	2026-02-10	5	staff	58.92	0.00	\N	32.41	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
33	1	2026-02-10	4	staff	38.34	0.00	\N	21.09	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
34	1	2026-02-10	3	staff	64.34	0.00	\N	35.39	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
35	1	2026-02-10	2	staff	0.00	0.00	\N	0.00	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
36	1	2026-02-10	1	staff	0.00	0.00	\N	0.00	2026-02-10 16:30:07.075	2026-02-10 16:30:07.075
4363	5	2026-04-03	340	staff	0.00	0.00	0.00	0.00	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4364	5	2026-04-03	186	gerente	0.00	0.00	133.29	133.29	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
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
4365	5	2026-04-03	118	supervisor	0.00	0.00	91.20	91.20	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4366	5	2026-04-03	294	chefe de turno	25.08	0.00	20.06	20.06	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
53	1	2026-02-09	12	supervisor	\N	\N	18.15	18.15	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
54	1	2026-02-09	13	chamador	\N	\N	\N	87.00	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
55	1	2026-02-09	\N	cozinha	\N	\N	\N	63.15	2026-02-10 16:35:23.004	2026-02-10 16:35:23.004
4367	5	2026-04-03	275	cozinha	0.00	0.00	19.39	19.39	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4368	5	2026-04-03	276	cozinha	0.00	0.00	19.42	19.42	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4369	5	2026-04-03	282	cozinha	0.00	0.00	19.42	19.42	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4370	5	2026-04-03	283	cozinha	0.00	0.00	19.42	19.42	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4371	5	2026-04-03	284	cozinha	0.00	0.00	19.42	19.42	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4372	5	2026-04-03	286	cozinha	0.00	0.00	19.42	19.42	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4373	5	2026-04-03	291	cozinha	0.00	0.00	19.42	19.42	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4374	5	2026-04-03	293	cozinha	0.00	0.00	19.42	19.42	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4182	6	2026-03-31	134	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4183	6	2026-03-31	139	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4184	6	2026-03-31	141	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4185	6	2026-03-31	150	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4186	6	2026-03-31	152	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4187	6	2026-03-31	153	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4188	6	2026-03-31	157	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4189	6	2026-03-31	160	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
861	4	2026-03-10	43	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
862	4	2026-03-10	44	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
863	4	2026-03-10	54	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
864	4	2026-03-10	55	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
865	4	2026-03-10	56	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
866	4	2026-03-10	60	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
867	4	2026-03-10	64	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
868	4	2026-03-10	65	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
869	4	2026-03-10	66	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
870	4	2026-03-10	70	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
871	4	2026-03-10	71	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
872	4	2026-03-10	72	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
873	4	2026-03-10	73	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
874	4	2026-03-10	74	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
209	4	2026-03-09	21	staff	0.00	0.00	0.00	0.00	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
210	4	2026-03-09	26	staff	171.81	1.96	96.21	96.21	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
211	4	2026-03-09	27	staff	0.00	0.00	0.00	0.00	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
212	4	2026-03-09	57	staff	0.00	0.00	0.00	0.00	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
213	4	2026-03-09	58	staff	57.71	3.41	32.32	32.32	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
214	4	2026-03-09	62	staff	55.42	0.00	31.03	31.03	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
215	4	2026-03-09	63	staff	75.62	0.00	42.35	42.35	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
216	4	2026-03-09	67	staff	100.88	0.00	56.49	56.49	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
217	4	2026-03-09	68	staff	65.55	0.00	36.71	36.71	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
218	4	2026-03-09	59	chefe de turno	0.00	0.00	0.00	0.00	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
219	4	2026-03-09	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
220	4	2026-03-09	61	gerente	0.00	0.00	80.10	80.10	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
221	4	2026-03-09	76	supervisor	0.00	0.00	54.81	54.81	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
222	4	2026-03-09	38	cozinha	0.00	0.00	6.07	6.07	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
223	4	2026-03-09	43	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
224	4	2026-03-09	44	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
225	4	2026-03-09	54	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
226	4	2026-03-09	55	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
227	4	2026-03-09	56	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
228	4	2026-03-09	60	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
229	4	2026-03-09	64	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
230	4	2026-03-09	65	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
231	4	2026-03-09	66	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
232	4	2026-03-09	70	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
233	4	2026-03-09	71	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
234	4	2026-03-09	72	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
235	4	2026-03-09	73	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
236	4	2026-03-09	74	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
237	4	2026-03-09	75	cozinha	0.00	0.00	6.06	6.06	2026-03-10 10:45:23.128	2026-03-10 10:45:23.128
383	4	2026-03-02	21	staff	84.69	0.00	47.42	47.42	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
384	4	2026-03-02	26	staff	91.27	0.00	51.11	51.11	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
385	4	2026-03-02	27	staff	0.00	0.00	0.00	0.00	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
386	4	2026-03-02	57	staff	0.00	0.00	0.00	0.00	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
387	4	2026-03-02	58	staff	96.28	0.00	53.92	53.92	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
388	4	2026-03-02	62	staff	9.34	0.00	5.23	5.23	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
389	4	2026-03-02	63	staff	127.91	0.00	71.63	71.63	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
390	4	2026-03-02	67	staff	0.00	0.00	0.00	0.00	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
391	4	2026-03-02	68	staff	81.41	17.00	45.59	45.59	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
392	4	2026-03-02	59	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
393	4	2026-03-02	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
394	4	2026-03-02	61	gerente	0.00	0.00	74.62	74.62	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
395	4	2026-03-02	76	supervisor	0.00	0.00	51.05	51.05	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
396	4	2026-03-02	38	cozinha	0.00	0.00	5.58	5.58	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
397	4	2026-03-02	43	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
398	4	2026-03-02	44	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
399	4	2026-03-02	54	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
400	4	2026-03-02	55	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
401	4	2026-03-02	56	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
402	4	2026-03-02	60	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
403	4	2026-03-02	64	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
404	4	2026-03-02	65	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
405	4	2026-03-02	66	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
406	4	2026-03-02	70	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
407	4	2026-03-02	71	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
408	4	2026-03-02	72	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
409	4	2026-03-02	73	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
410	4	2026-03-02	74	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
411	4	2026-03-02	75	cozinha	0.00	0.00	5.65	5.65	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
412	4	2026-03-03	21	staff	67.64	0.00	37.88	37.88	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
413	4	2026-03-03	26	staff	65.51	5.63	36.69	36.69	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
414	4	2026-03-03	27	staff	0.00	0.00	0.00	0.00	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
415	4	2026-03-03	57	staff	86.04	0.00	48.18	48.18	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
416	4	2026-03-03	58	staff	59.54	2.00	33.34	33.34	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
417	4	2026-03-03	62	staff	0.00	0.00	0.00	0.00	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
418	4	2026-03-03	63	staff	45.54	0.00	25.50	25.50	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
419	4	2026-03-03	67	staff	0.00	0.00	0.00	0.00	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
420	4	2026-03-03	68	staff	132.94	0.00	74.45	74.45	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
421	4	2026-03-03	59	chefe de turno	39.54	0.00	31.63	31.63	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
422	4	2026-03-03	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
423	4	2026-03-03	61	gerente	0.00	0.00	75.51	75.51	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
424	4	2026-03-03	76	supervisor	0.00	0.00	51.66	51.66	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
425	4	2026-03-03	38	cozinha	0.00	0.00	5.75	5.11	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
426	4	2026-03-03	43	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
427	4	2026-03-03	44	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
428	4	2026-03-03	54	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
429	4	2026-03-03	55	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
430	4	2026-03-03	56	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
431	4	2026-03-03	60	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
432	4	2026-03-03	64	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
433	4	2026-03-03	65	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
434	4	2026-03-03	66	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
435	4	2026-03-03	70	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
436	4	2026-03-03	71	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
437	4	2026-03-03	72	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
438	4	2026-03-03	73	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
439	4	2026-03-03	74	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
440	4	2026-03-03	75	cozinha	0.00	0.00	5.71	5.12	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
441	4	2026-03-04	21	staff	30.42	0.00	17.03	17.03	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
442	4	2026-03-04	26	staff	101.35	3.74	56.76	56.76	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
443	4	2026-03-04	27	staff	0.00	0.00	0.00	0.00	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
444	4	2026-03-04	57	staff	35.50	0.00	19.88	19.88	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
445	4	2026-03-04	58	staff	74.57	4.79	41.76	41.76	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
446	4	2026-03-04	62	staff	77.90	11.00	43.62	43.62	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
447	4	2026-03-04	63	staff	0.00	0.00	0.00	0.00	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
448	4	2026-03-04	67	staff	0.00	0.00	0.00	0.00	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
449	4	2026-03-04	68	staff	73.19	0.00	40.99	40.99	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
450	4	2026-03-04	59	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
451	4	2026-03-04	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
452	4	2026-03-04	61	gerente	0.00	0.00	59.73	59.73	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
453	4	2026-03-04	76	supervisor	0.00	0.00	40.86	40.86	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
454	4	2026-03-04	38	cozinha	0.00	0.00	4.50	4.50	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
455	4	2026-03-04	43	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
456	4	2026-03-04	44	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
457	4	2026-03-04	54	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
458	4	2026-03-04	55	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
459	4	2026-03-04	56	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
460	4	2026-03-04	60	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
461	4	2026-03-04	64	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
462	4	2026-03-04	65	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
463	4	2026-03-04	66	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
464	4	2026-03-04	70	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
465	4	2026-03-04	71	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
466	4	2026-03-04	72	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
467	4	2026-03-04	73	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
468	4	2026-03-04	74	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
469	4	2026-03-04	75	cozinha	0.00	0.00	4.52	4.52	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
470	4	2026-03-05	21	staff	42.88	0.00	24.00	24.00	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
471	4	2026-03-05	26	staff	0.00	0.00	0.00	0.00	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
472	4	2026-03-05	27	staff	0.00	0.00	0.00	0.00	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
473	4	2026-03-05	57	staff	89.16	10.00	49.93	49.93	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
474	4	2026-03-05	58	staff	58.60	0.00	32.82	32.82	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
475	4	2026-03-05	62	staff	198.12	6.66	110.95	110.95	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
476	4	2026-03-05	63	staff	99.28	7.22	55.60	55.60	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
477	4	2026-03-05	67	staff	43.73	0.00	24.49	24.49	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
478	4	2026-03-05	68	staff	0.00	0.00	0.00	0.00	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
479	4	2026-03-05	59	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
480	4	2026-03-05	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
481	4	2026-03-05	61	gerente	0.00	0.00	80.83	80.83	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
482	4	2026-03-05	76	supervisor	0.00	0.00	55.30	55.30	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
483	4	2026-03-05	38	cozinha	0.00	0.00	6.05	6.05	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
484	4	2026-03-05	43	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
485	4	2026-03-05	44	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
486	4	2026-03-05	54	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
487	4	2026-03-05	55	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
488	4	2026-03-05	56	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
489	4	2026-03-05	60	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
490	4	2026-03-05	64	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
491	4	2026-03-05	65	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
492	4	2026-03-05	66	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
493	4	2026-03-05	70	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
494	4	2026-03-05	71	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
495	4	2026-03-05	72	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
496	4	2026-03-05	73	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
497	4	2026-03-05	74	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
498	4	2026-03-05	75	cozinha	0.00	0.00	6.12	6.12	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
4375	5	2026-04-03	285	chamador	0.00	0.00	0.00	0.00	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4376	5	2026-04-03	278	chamador	0.00	184.00	0.00	0.00	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4377	5	2026-04-03	274	chamador	0.00	73.00	0.00	0.00	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
1459	3	2026-03-30	171	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1460	3	2026-03-30	174	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1461	3	2026-03-30	176	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1462	3	2026-03-30	177	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1463	3	2026-03-30	329	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1464	3	2026-03-30	330	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1465	3	2026-03-30	331	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1466	3	2026-03-30	333	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1467	3	2026-03-30	334	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
528	4	2026-03-06	21	staff	46.21	0.00	25.88	25.88	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
529	4	2026-03-06	26	staff	0.00	0.00	0.00	0.00	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
530	4	2026-03-06	27	staff	0.00	0.00	0.00	0.00	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
531	4	2026-03-06	57	staff	64.69	6.00	36.23	36.23	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
532	4	2026-03-06	58	staff	214.51	6.00	120.12	120.12	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
533	4	2026-03-06	62	staff	33.68	1.82	18.86	18.86	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
534	4	2026-03-06	63	staff	54.04	0.00	30.26	30.26	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
1468	3	2026-03-30	322	chamador	0.00	133.00	0.00	0.00	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1469	3	2026-03-30	193	chamador	0.00	133.00	0.00	0.00	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
535	4	2026-03-06	67	staff	53.10	0.00	29.74	29.74	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
536	4	2026-03-06	68	staff	60.49	0.00	33.87	33.87	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
537	4	2026-03-06	59	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
538	4	2026-03-06	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
539	4	2026-03-06	61	gerente	0.00	0.00	80.06	80.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
540	4	2026-03-06	76	supervisor	0.00	0.00	54.78	54.78	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
541	4	2026-03-06	38	cozinha	0.00	0.00	6.02	6.02	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
542	4	2026-03-06	43	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
543	4	2026-03-06	44	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
544	4	2026-03-06	54	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
545	4	2026-03-06	55	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
546	4	2026-03-06	56	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
547	4	2026-03-06	60	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
548	4	2026-03-06	64	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
549	4	2026-03-06	65	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
550	4	2026-03-06	66	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
551	4	2026-03-06	70	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
552	4	2026-03-06	71	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
553	4	2026-03-06	72	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
554	4	2026-03-06	73	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
555	4	2026-03-06	74	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
556	4	2026-03-06	75	cozinha	0.00	0.00	6.06	6.06	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
875	4	2026-03-10	75	cozinha	0.00	0.00	7.12	6.48	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
876	4	2026-03-10	77	chamador	0.00	0.01	0.00	0.00	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
877	4	2026-03-10	53	chamador	0.00	0.00	0.00	0.00	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
1769	5	2026-03-31	277	staff	122.70	6.90	68.72	68.72	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1770	5	2026-03-31	281	staff	88.83	2.00	49.74	49.74	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1771	5	2026-03-31	287	staff	105.73	2.02	59.21	59.21	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1772	5	2026-03-31	288	staff	77.53	0.00	43.42	43.42	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
615	4	2026-03-11	21	staff	0.00	0.00	0.00	0.00	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
616	4	2026-03-11	26	staff	113.39	0.00	63.50	63.50	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
617	4	2026-03-11	27	staff	0.00	0.00	0.00	0.00	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
618	4	2026-03-11	57	staff	50.84	6.00	28.47	28.47	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
619	4	2026-03-11	58	staff	76.54	15.00	42.86	42.86	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
620	4	2026-03-11	62	staff	97.10	18.03	54.38	54.38	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
621	4	2026-03-11	63	staff	0.00	0.00	0.00	0.00	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
622	4	2026-03-11	67	staff	61.88	4.57	34.65	34.65	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
623	4	2026-03-11	68	staff	37.10	0.00	20.78	20.78	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
1773	5	2026-03-31	290	staff	110.61	14.61	61.94	61.94	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1774	5	2026-03-31	296	staff	79.08	0.00	44.28	44.28	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1775	5	2026-03-31	336	staff	33.75	5.00	18.90	18.90	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1776	5	2026-03-31	337	staff	139.38	7.00	78.05	78.05	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1777	5	2026-03-31	338	staff	0.00	0.00	0.00	0.00	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1778	5	2026-03-31	339	staff	64.15	0.00	35.92	35.92	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1779	5	2026-03-31	340	staff	65.46	0.00	36.66	36.66	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1780	5	2026-03-31	186	gerente	0.00	0.00	134.86	134.86	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1781	5	2026-03-31	118	supervisor	0.00	0.00	92.27	92.27	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1782	5	2026-03-31	294	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1783	5	2026-03-31	275	cozinha	0.00	0.00	20.38	20.38	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1784	5	2026-03-31	276	cozinha	0.00	0.00	20.41	20.41	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1785	5	2026-03-31	282	cozinha	0.00	0.00	20.41	20.41	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1786	5	2026-03-31	283	cozinha	0.00	0.00	20.41	20.41	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1787	5	2026-03-31	284	cozinha	0.00	0.00	20.41	20.41	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1788	5	2026-03-31	286	cozinha	0.00	0.00	20.41	20.41	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1789	5	2026-03-31	291	cozinha	0.00	0.00	20.41	20.41	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1790	5	2026-03-31	293	cozinha	0.00	0.00	20.41	20.41	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1791	5	2026-03-31	285	chamador	0.00	0.00	0.00	0.00	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1792	5	2026-03-31	278	chamador	0.00	176.00	0.00	0.00	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1793	5	2026-03-31	274	chamador	0.00	0.00	0.00	0.00	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
624	4	2026-03-11	59	chefe de turno	59.19	2.29	47.35	47.35	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
625	4	2026-03-11	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
626	4	2026-03-11	61	gerente	0.00	0.00	75.40	75.40	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
627	4	2026-03-11	76	supervisor	0.00	0.00	51.59	51.59	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
628	4	2026-03-11	38	cozinha	0.00	0.00	5.77	4.76	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
629	4	2026-03-11	43	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
630	4	2026-03-11	44	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
631	4	2026-03-11	54	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
632	4	2026-03-11	55	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
633	4	2026-03-11	56	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
634	4	2026-03-11	60	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
635	4	2026-03-11	64	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
636	4	2026-03-11	65	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
637	4	2026-03-11	66	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
638	4	2026-03-11	70	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
639	4	2026-03-11	71	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
640	4	2026-03-11	72	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
641	4	2026-03-11	73	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
642	4	2026-03-11	74	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
643	4	2026-03-11	75	cozinha	0.00	0.00	5.70	4.82	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
644	4	2026-03-12	21	staff	0.00	0.00	0.00	0.00	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
645	4	2026-03-12	26	staff	163.75	10.22	91.69	91.69	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
646	4	2026-03-12	27	staff	0.00	0.00	0.00	0.00	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
647	4	2026-03-12	57	staff	108.67	19.00	60.86	60.86	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
648	4	2026-03-12	58	staff	200.51	5.00	112.29	112.29	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
649	4	2026-03-12	62	staff	35.01	0.00	19.61	19.61	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
650	4	2026-03-12	63	staff	116.04	14.00	64.98	64.98	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
651	4	2026-03-12	67	staff	100.84	0.00	56.47	56.47	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
652	4	2026-03-12	68	staff	0.00	0.00	0.00	0.00	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
653	4	2026-03-12	59	chefe de turno	86.64	2.57	69.31	69.31	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
654	4	2026-03-12	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
655	4	2026-03-12	61	gerente	0.00	0.00	123.34	123.34	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
656	4	2026-03-12	76	supervisor	0.00	0.00	84.39	84.39	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
657	4	2026-03-12	38	cozinha	0.00	0.00	9.36	8.07	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
658	4	2026-03-12	43	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
659	4	2026-03-12	44	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
660	4	2026-03-12	54	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
661	4	2026-03-12	55	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
662	4	2026-03-12	56	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
663	4	2026-03-12	60	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
664	4	2026-03-12	64	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
665	4	2026-03-12	65	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
666	4	2026-03-12	66	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
667	4	2026-03-12	70	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
668	4	2026-03-12	71	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
669	4	2026-03-12	72	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
670	4	2026-03-12	73	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
671	4	2026-03-12	74	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
672	4	2026-03-12	75	cozinha	0.00	0.00	9.33	8.03	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
673	4	2026-03-13	21	staff	0.00	0.00	0.00	0.00	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
674	4	2026-03-13	26	staff	0.00	0.00	0.00	0.00	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
675	4	2026-03-13	27	staff	0.00	0.00	0.00	0.00	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
676	4	2026-03-13	57	staff	175.80	10.00	98.44	98.44	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
677	4	2026-03-13	58	staff	143.78	0.00	80.52	80.52	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
678	4	2026-03-13	62	staff	0.00	0.00	0.00	0.00	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
679	4	2026-03-13	63	staff	179.75	18.41	100.66	100.66	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
680	4	2026-03-13	67	staff	83.42	15.00	46.72	46.72	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
681	4	2026-03-13	68	staff	47.25	0.00	26.46	26.46	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
682	4	2026-03-13	59	chefe de turno	101.67	0.00	81.34	81.34	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
683	4	2026-03-13	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
684	4	2026-03-13	61	gerente	0.00	0.00	111.21	111.21	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
685	4	2026-03-13	76	supervisor	0.00	0.00	76.09	76.09	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
686	4	2026-03-13	38	cozinha	0.00	0.00	8.48	6.88	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
687	4	2026-03-13	43	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
688	4	2026-03-13	44	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
689	4	2026-03-13	54	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
690	4	2026-03-13	55	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
691	4	2026-03-13	56	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
692	4	2026-03-13	60	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
693	4	2026-03-13	64	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
694	4	2026-03-13	65	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
695	4	2026-03-13	66	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
696	4	2026-03-13	70	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
697	4	2026-03-13	71	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
698	4	2026-03-13	72	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
699	4	2026-03-13	73	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
700	4	2026-03-13	74	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
701	4	2026-03-13	75	cozinha	0.00	0.00	8.41	6.89	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
702	4	2026-03-07	21	staff	0.00	0.00	0.00	0.00	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
703	4	2026-03-07	26	staff	112.43	0.00	62.96	62.96	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
704	4	2026-03-07	57	staff	147.13	7.00	82.39	82.39	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
705	4	2026-03-07	58	staff	0.00	0.00	0.00	0.00	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
706	4	2026-03-07	62	staff	144.53	10.00	80.94	80.94	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
707	4	2026-03-07	63	staff	276.55	5.96	154.87	154.87	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
708	4	2026-03-07	67	staff	131.59	12.37	73.69	73.69	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
709	4	2026-03-07	68	staff	94.49	0.00	52.91	52.91	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
710	4	2026-03-07	59	chefe de turno	48.11	0.00	38.49	38.49	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
711	4	2026-03-07	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
712	4	2026-03-07	61	gerente	0.00	0.00	145.13	145.13	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
713	4	2026-03-07	76	supervisor	0.00	0.00	99.30	99.30	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
714	4	2026-03-07	38	cozinha	0.00	0.00	10.99	10.25	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
715	4	2026-03-07	43	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
716	4	2026-03-07	44	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
717	4	2026-03-07	54	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
718	4	2026-03-07	55	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
719	4	2026-03-07	56	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
720	4	2026-03-07	60	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
721	4	2026-03-07	64	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
722	4	2026-03-07	65	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
723	4	2026-03-07	66	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
724	4	2026-03-07	70	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
725	4	2026-03-07	71	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
726	4	2026-03-07	72	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
727	4	2026-03-07	73	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
728	4	2026-03-07	74	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
729	4	2026-03-07	75	cozinha	0.00	0.00	10.98	10.26	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
730	4	2026-03-08	21	staff	0.00	0.00	0.00	0.00	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
731	4	2026-03-08	26	staff	163.02	10.73	91.29	91.29	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
732	4	2026-03-08	57	staff	168.84	15.00	94.55	94.55	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
733	4	2026-03-08	58	staff	135.55	2.30	75.91	75.91	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
734	4	2026-03-08	62	staff	89.88	0.00	50.33	50.33	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
735	4	2026-03-08	63	staff	0.00	0.00	0.00	0.00	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
736	4	2026-03-08	67	staff	0.00	0.00	0.00	0.00	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
737	4	2026-03-08	68	staff	132.04	5.14	73.94	73.94	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
738	4	2026-03-08	59	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
739	4	2026-03-08	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
740	4	2026-03-08	61	gerente	0.00	0.00	104.78	104.78	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
741	4	2026-03-08	76	supervisor	0.00	0.00	71.69	71.69	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
742	4	2026-03-08	38	cozinha	0.00	0.00	7.89	7.89	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
743	4	2026-03-08	43	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
744	4	2026-03-08	44	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
745	4	2026-03-08	54	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
746	4	2026-03-08	55	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
747	4	2026-03-08	56	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
748	4	2026-03-08	60	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
749	4	2026-03-08	64	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
750	4	2026-03-08	65	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
751	4	2026-03-08	66	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
752	4	2026-03-08	70	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
753	4	2026-03-08	71	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
754	4	2026-03-08	72	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
755	4	2026-03-08	73	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
756	4	2026-03-08	74	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
757	4	2026-03-08	75	cozinha	0.00	0.00	7.93	7.93	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
4190	6	2026-03-31	311	cozinha	0.00	0.00	9.80	9.80	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4191	6	2026-03-31	318	chamador	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4192	6	2026-03-31	140	chamador	0.00	153.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
848	4	2026-03-10	21	staff	0.00	0.00	0.00	0.00	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
849	4	2026-03-10	26	staff	77.04	0.00	43.15	43.15	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
850	4	2026-03-10	57	staff	66.09	0.00	37.01	37.01	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
851	4	2026-03-10	58	staff	45.70	0.00	25.59	25.59	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
852	4	2026-03-10	62	staff	0.00	0.00	0.00	0.00	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
853	4	2026-03-10	63	staff	241.45	0.00	135.21	135.21	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
854	4	2026-03-10	67	staff	66.54	0.00	37.26	37.26	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
855	4	2026-03-10	68	staff	79.68	0.00	44.62	44.62	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
856	4	2026-03-10	59	chefe de turno	42.82	0.00	34.26	34.26	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
857	4	2026-03-10	69	chefe de turno	0.00	0.00	0.00	0.00	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
858	4	2026-03-10	61	gerente	0.00	0.00	94.14	94.14	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
859	4	2026-03-10	76	supervisor	0.00	0.00	64.41	64.41	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
860	4	2026-03-10	38	cozinha	0.00	0.00	7.15	6.47	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
1794	5	2026-04-01	277	staff	0.00	0.00	0.00	0.00	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1795	5	2026-04-01	281	staff	91.51	0.00	51.24	51.24	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1796	5	2026-04-01	287	staff	149.82	22.96	83.90	83.90	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1797	5	2026-04-01	288	staff	0.00	0.00	0.00	0.00	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1798	5	2026-04-01	290	staff	204.85	11.20	114.72	114.72	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1799	5	2026-04-01	296	staff	155.01	2.00	86.80	86.80	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1800	5	2026-04-01	336	staff	0.00	0.00	0.00	0.00	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1801	5	2026-04-01	337	staff	124.98	25.27	69.99	69.99	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1802	5	2026-04-01	338	staff	65.87	0.00	36.89	36.89	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1803	5	2026-04-01	339	staff	168.36	13.07	94.28	94.28	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1804	5	2026-04-01	340	staff	0.00	0.00	0.00	0.00	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1805	5	2026-04-01	186	gerente	0.00	0.00	145.98	145.98	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1806	5	2026-04-01	118	supervisor	0.00	0.00	99.88	99.88	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1807	5	2026-04-01	294	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1808	5	2026-04-01	275	cozinha	0.00	0.00	22.09	22.09	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1388	11	2026-03-30	90	staff	85.19	26.07	47.70	47.70	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1389	11	2026-03-30	92	staff	81.78	8.53	45.80	45.80	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1390	11	2026-03-30	95	staff	0.00	0.00	0.00	0.00	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1391	11	2026-03-30	109	staff	63.06	0.00	35.31	35.31	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1392	11	2026-03-30	113	staff	59.19	9.34	33.15	33.15	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1393	11	2026-03-30	155	staff	94.94	12.44	53.17	53.17	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1394	11	2026-03-30	324	staff	81.33	4.64	45.55	45.55	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1395	11	2026-03-30	326	staff	0.00	0.00	0.00	0.00	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1396	11	2026-03-30	327	staff	53.93	0.00	30.20	30.20	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1397	11	2026-03-30	94	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1398	11	2026-03-30	105	chefe de turno	30.36	0.00	24.29	24.29	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1399	11	2026-03-30	115	supervisor	0.00	0.00	57.18	57.18	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1400	11	2026-03-30	93	gerente	0.00	0.00	83.57	83.57	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1401	11	2026-03-30	107	cozinha	0.00	0.00	13.40	13.40	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1402	11	2026-03-30	108	cozinha	0.00	0.00	13.41	13.41	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1403	11	2026-03-30	111	cozinha	0.00	0.00	13.41	13.41	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1404	11	2026-03-30	112	cozinha	0.00	0.00	13.41	13.41	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1405	11	2026-03-30	269	cozinha	0.00	0.00	13.41	13.41	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1406	11	2026-03-30	319	cozinha	0.00	0.00	13.41	13.41	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1407	11	2026-03-30	320	cozinha	0.00	0.00	13.41	13.41	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1408	11	2026-03-30	328	chamador	0.00	145.00	0.00	0.00	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1809	5	2026-04-01	276	cozinha	0.00	0.00	22.09	22.09	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1810	5	2026-04-01	282	cozinha	0.00	0.00	22.09	22.09	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1811	5	2026-04-01	283	cozinha	0.00	0.00	22.09	22.09	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1812	5	2026-04-01	284	cozinha	0.00	0.00	22.09	22.09	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1813	5	2026-04-01	286	cozinha	0.00	0.00	22.09	22.09	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1814	5	2026-04-01	291	cozinha	0.00	0.00	22.09	22.09	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1815	5	2026-04-01	293	cozinha	0.00	0.00	22.09	22.09	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1816	5	2026-04-01	285	chamador	0.00	153.00	0.00	0.00	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1817	5	2026-04-01	278	chamador	0.00	0.00	0.00	0.00	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1440	3	2026-03-30	81	staff	124.29	0.00	69.60	69.60	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1441	3	2026-03-30	165	staff	0.00	0.00	0.00	0.00	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1442	3	2026-03-30	168	staff	98.82	6.45	55.34	55.34	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1443	3	2026-03-30	172	staff	99.56	4.16	55.75	55.75	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1444	3	2026-03-30	173	staff	197.42	17.00	110.56	110.56	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1445	3	2026-03-30	175	staff	0.00	0.00	0.00	0.00	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1446	3	2026-03-30	178	staff	180.55	5.10	101.11	101.11	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1447	3	2026-03-30	211	staff	100.06	13.90	56.03	56.03	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1448	3	2026-03-30	323	staff	87.14	5.00	48.80	48.80	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1449	3	2026-03-30	80	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1450	3	2026-03-30	191	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1451	3	2026-03-30	122	supervisor	0.00	0.00	92.34	92.34	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1452	3	2026-03-30	164	gerente	0.00	0.00	134.95	134.95	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1453	3	2026-03-30	79	cozinha	0.00	0.00	10.90	10.90	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1454	3	2026-03-30	162	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1455	3	2026-03-30	166	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1456	3	2026-03-30	167	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1457	3	2026-03-30	169	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1458	3	2026-03-30	170	cozinha	0.00	0.00	10.89	10.89	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1818	5	2026-04-01	274	chamador	0.00	117.00	0.00	0.00	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
3537	6	2026-04-05	126	staff	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
1288	6	2026-04-02	126	staff	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1289	6	2026-04-02	128	staff	104.78	30.00	58.67	58.67	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1290	6	2026-04-02	129	staff	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1291	6	2026-04-02	136	staff	96.18	0.00	53.86	53.86	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1292	6	2026-04-02	144	staff	130.76	0.00	73.23	73.23	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1293	6	2026-04-02	148	staff	253.80	18.25	142.13	142.13	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1294	6	2026-04-02	149	staff	157.58	10.00	88.24	88.24	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1295	6	2026-04-02	151	staff	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1296	6	2026-04-02	156	staff	139.22	0.00	77.96	77.96	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1297	6	2026-04-02	158	staff	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1298	6	2026-04-02	159	staff	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1299	6	2026-04-02	273	staff	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1300	6	2026-04-02	317	staff	46.07	0.00	25.80	25.80	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1301	6	2026-04-02	321	staff	46.76	0.00	26.19	26.19	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1302	6	2026-04-02	145	gerente	0.00	0.00	164.88	164.88	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1303	6	2026-04-02	116	supervisor	0.00	0.00	112.81	112.81	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1304	6	2026-04-02	133	chefe de turno	104.30	7.24	83.44	83.44	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1305	6	2026-04-02	147	chefe de turno	5.29	0.00	4.23	4.23	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1306	6	2026-04-02	272	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1307	6	2026-04-02	85	balcao	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1308	6	2026-04-02	132	balcao	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1309	6	2026-04-02	135	balcao	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1310	6	2026-04-02	138	balcao	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1311	6	2026-04-02	143	balcao	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1312	6	2026-04-02	146	balcao	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1313	6	2026-04-02	161	balcao	0.00	0.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1314	6	2026-04-02	131	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1315	6	2026-04-02	134	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1316	6	2026-04-02	139	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1317	6	2026-04-02	141	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1318	6	2026-04-02	150	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1319	6	2026-04-02	152	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1320	6	2026-04-02	153	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1321	6	2026-04-02	157	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1322	6	2026-04-02	160	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1323	6	2026-04-02	311	cozinha	0.00	0.00	17.33	17.33	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1324	6	2026-04-02	318	chamador	0.00	164.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1325	6	2026-04-02	140	chamador	0.00	124.00	0.00	0.00	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1502	3	2026-03-31	81	staff	92.03	34.00	51.55	51.55	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1503	3	2026-03-31	165	staff	0.00	0.00	0.00	0.00	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1504	3	2026-03-31	168	staff	185.95	27.60	104.13	104.13	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1505	3	2026-03-31	172	staff	183.94	2.95	103.01	103.01	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1506	3	2026-03-31	173	staff	129.93	3.00	72.76	72.76	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1507	3	2026-03-31	175	staff	30.08	0.00	16.84	16.84	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1508	3	2026-03-31	178	staff	0.00	0.00	0.00	0.00	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1509	3	2026-03-31	211	staff	131.63	0.00	73.71	73.71	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1510	3	2026-03-31	323	staff	176.15	23.50	98.64	98.64	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1511	3	2026-03-31	80	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1512	3	2026-03-31	191	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1513	3	2026-03-31	122	supervisor	0.00	0.00	96.69	96.69	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1514	3	2026-03-31	164	gerente	0.00	0.00	141.32	141.32	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1515	3	2026-03-31	79	cozinha	0.00	0.00	11.46	11.46	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1516	3	2026-03-31	162	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1517	3	2026-03-31	166	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1518	3	2026-03-31	167	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1519	3	2026-03-31	169	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1520	3	2026-03-31	170	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1521	3	2026-03-31	171	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1522	3	2026-03-31	174	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1523	3	2026-03-31	176	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1524	3	2026-03-31	177	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1525	3	2026-03-31	329	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1526	3	2026-03-31	330	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1527	3	2026-03-31	331	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1528	3	2026-03-31	333	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1529	3	2026-03-31	334	cozinha	0.00	0.00	11.40	11.40	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1530	3	2026-03-31	322	chamador	0.00	133.00	0.00	0.00	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1531	3	2026-03-31	193	chamador	0.00	133.00	0.00	0.00	2026-04-03 12:46:36.816	2026-04-03 12:46:36.816
1694	5	2026-03-30	277	staff	185.05	0.00	103.63	103.63	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1695	5	2026-03-30	281	staff	115.73	3.20	64.81	64.81	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1696	5	2026-03-30	287	staff	0.00	0.00	0.00	0.00	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1697	5	2026-03-30	288	staff	118.17	0.00	66.17	66.17	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1698	5	2026-03-30	290	staff	200.29	0.00	112.16	112.16	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1699	5	2026-03-30	296	staff	0.00	0.00	0.00	0.00	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1700	5	2026-03-30	336	staff	29.41	0.00	16.47	16.47	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1701	5	2026-03-30	337	staff	192.90	5.50	108.02	108.02	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1702	5	2026-03-30	338	staff	24.78	0.00	13.88	13.88	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1703	5	2026-03-30	339	staff	82.25	5.00	46.06	46.06	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1704	5	2026-03-30	340	staff	142.55	14.11	79.83	79.83	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1705	5	2026-03-30	186	gerente	0.00	0.00	165.85	165.85	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1706	5	2026-03-30	118	supervisor	0.00	0.00	113.48	113.48	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1707	5	2026-03-30	294	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1708	5	2026-03-30	275	cozinha	0.00	0.00	25.07	25.07	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1709	5	2026-03-30	276	cozinha	0.00	0.00	25.10	25.10	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1710	5	2026-03-30	282	cozinha	0.00	0.00	25.10	25.10	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1711	5	2026-03-30	283	cozinha	0.00	0.00	25.10	25.10	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1712	5	2026-03-30	284	cozinha	0.00	0.00	25.10	25.10	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1713	5	2026-03-30	286	cozinha	0.00	0.00	25.10	25.10	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1714	5	2026-03-30	291	cozinha	0.00	0.00	25.10	25.10	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1715	5	2026-03-30	293	cozinha	0.00	0.00	25.10	25.10	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1716	5	2026-03-30	285	chamador	0.00	0.00	0.00	0.00	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1717	5	2026-03-30	278	chamador	0.00	0.00	0.00	0.00	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1718	5	2026-03-30	274	chamador	0.00	143.00	0.00	0.00	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
3538	6	2026-04-05	128	staff	242.14	15.00	135.61	135.61	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3539	6	2026-04-05	129	staff	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3540	6	2026-04-05	136	staff	81.46	0.00	45.62	45.62	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3541	6	2026-04-05	144	staff	44.59	5.00	24.97	24.97	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
4193	11	2026-04-02	90	staff	0.00	0.00	0.00	0.00	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4194	11	2026-04-02	92	staff	111.46	13.50	62.42	62.42	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4195	11	2026-04-02	95	staff	136.56	0.00	76.47	76.47	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4196	11	2026-04-02	109	staff	109.19	4.00	61.15	61.15	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4197	11	2026-04-02	113	staff	0.00	0.00	0.00	0.00	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4198	11	2026-04-02	155	staff	177.34	10.45	99.31	99.31	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4199	11	2026-04-02	324	staff	135.77	2.90	76.03	76.03	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4200	11	2026-04-02	326	staff	98.56	5.54	55.19	55.19	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4201	11	2026-04-02	327	staff	44.82	0.00	25.10	25.10	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
3034	2	2026-04-03	182	staff	0.00	0.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3035	2	2026-04-03	183	staff	142.89	16.00	80.00	80.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3036	2	2026-04-03	187	staff	116.27	0.00	65.11	65.11	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3037	2	2026-04-03	190	staff	18.56	0.00	10.39	10.39	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3038	2	2026-04-03	196	staff	26.05	0.00	14.59	14.59	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3039	2	2026-04-03	197	staff	178.37	3.50	99.89	99.89	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3040	2	2026-04-03	199	staff	156.38	0.00	87.57	87.57	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3041	2	2026-04-03	201	staff	31.06	0.00	17.39	17.39	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3042	2	2026-04-03	202	staff	0.00	0.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3043	2	2026-04-03	203	staff	138.64	1.00	77.64	77.64	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3044	2	2026-04-03	204	staff	0.00	0.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3045	2	2026-04-03	205	staff	157.07	0.00	87.96	87.96	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3046	2	2026-04-03	207	staff	0.00	0.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3047	2	2026-04-03	212	staff	210.60	1.10	117.94	117.94	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3048	2	2026-04-03	216	staff	2.43	0.00	1.36	1.36	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3049	2	2026-04-03	218	staff	2.17	0.00	1.22	1.22	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3050	2	2026-04-03	219	staff	13.21	0.00	7.40	7.40	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3051	2	2026-04-03	221	staff	217.96	6.71	122.06	122.06	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3052	2	2026-04-03	314	staff	0.00	0.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3053	2	2026-04-03	341	staff	107.33	7.53	60.11	60.11	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3054	2	2026-04-03	342	staff	95.51	1.42	53.49	53.49	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3055	2	2026-04-03	343	staff	266.44	1.04	149.21	149.21	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3056	2	2026-04-03	280	chefe de turno	0.00	0.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3057	2	2026-04-03	310	chefe de turno	0.00	0.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3058	2	2026-04-03	185	gerente	0.00	0.00	285.90	285.90	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3059	2	2026-04-03	123	supervisor	0.00	0.00	195.62	195.62	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3060	2	2026-04-03	179	cozinha	0.00	0.00	17.39	17.39	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3061	2	2026-04-03	180	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3062	2	2026-04-03	181	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3063	2	2026-04-03	184	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3064	2	2026-04-03	189	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3065	2	2026-04-03	192	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3066	2	2026-04-03	194	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3067	2	2026-04-03	195	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3068	2	2026-04-03	200	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3069	2	2026-04-03	206	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3070	2	2026-04-03	208	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3071	2	2026-04-03	209	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3072	2	2026-04-03	210	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3073	2	2026-04-03	213	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3074	2	2026-04-03	214	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3075	2	2026-04-03	215	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3076	2	2026-04-03	217	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3077	2	2026-04-03	220	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3078	2	2026-04-03	222	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3079	2	2026-04-03	292	cozinha	0.00	0.00	17.30	17.30	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3080	2	2026-04-03	315	chamador	0.00	242.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
1894	5	2026-04-02	277	staff	233.56	23.57	130.79	130.79	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1895	5	2026-04-02	281	staff	0.00	0.00	0.00	0.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1896	5	2026-04-02	287	staff	63.42	0.00	35.52	35.52	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1897	5	2026-04-02	288	staff	91.22	0.00	51.08	51.08	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1898	5	2026-04-02	290	staff	278.98	0.00	156.23	156.23	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1899	5	2026-04-02	296	staff	0.00	0.00	0.00	0.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1900	5	2026-04-02	336	staff	0.00	0.00	0.00	0.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1901	5	2026-04-02	337	staff	179.98	0.00	100.79	100.79	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1902	5	2026-04-02	338	staff	22.36	0.00	12.52	12.52	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1903	5	2026-04-02	339	staff	137.05	11.80	76.75	76.75	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1904	5	2026-04-02	340	staff	0.00	0.00	0.00	0.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1905	5	2026-04-02	186	gerente	0.00	0.00	153.00	153.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1906	5	2026-04-02	118	supervisor	0.00	0.00	104.68	104.68	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1907	5	2026-04-02	294	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1908	5	2026-04-02	275	cozinha	0.00	0.00	23.16	23.16	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1909	5	2026-04-02	276	cozinha	0.00	0.00	23.15	23.15	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1910	5	2026-04-02	282	cozinha	0.00	0.00	23.15	23.15	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1911	5	2026-04-02	283	cozinha	0.00	0.00	23.15	23.15	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1912	5	2026-04-02	284	cozinha	0.00	0.00	23.15	23.15	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1913	5	2026-04-02	286	cozinha	0.00	0.00	23.15	23.15	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1914	5	2026-04-02	291	cozinha	0.00	0.00	23.15	23.15	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1915	5	2026-04-02	293	cozinha	0.00	0.00	23.15	23.15	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1916	5	2026-04-02	285	chamador	0.00	0.00	0.00	0.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1917	5	2026-04-02	278	chamador	0.00	182.00	0.00	0.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1918	5	2026-04-02	274	chamador	0.00	100.00	0.00	0.00	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
2653	3	2026-04-01	81	staff	98.63	15.00	55.24	55.24	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2654	3	2026-04-01	165	staff	0.00	0.00	0.00	0.00	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2655	3	2026-04-01	168	staff	152.66	7.66	85.49	85.49	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2656	3	2026-04-01	172	staff	63.47	4.07	35.54	35.54	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2657	3	2026-04-01	173	staff	0.00	0.00	0.00	0.00	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2658	3	2026-04-01	175	staff	118.68	6.44	66.46	66.46	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2659	3	2026-04-01	178	staff	0.00	0.00	0.00	0.00	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2660	3	2026-04-01	211	staff	120.38	8.20	67.41	67.41	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2661	3	2026-04-01	323	staff	61.60	14.00	34.50	34.50	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2662	3	2026-04-01	335	staff	141.93	25.54	79.48	79.48	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2390	4	2026-04-02	21	staff	0.00	0.00	0.00	0.00	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2391	4	2026-04-02	26	staff	101.24	0.00	56.70	56.70	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2392	4	2026-04-02	57	staff	182.75	10.00	102.34	102.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2393	4	2026-04-02	58	staff	102.20	2.36	57.23	57.23	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2394	4	2026-04-02	62	staff	96.80	4.04	54.21	54.21	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2395	4	2026-04-02	63	staff	111.13	12.00	62.23	62.23	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2396	4	2026-04-02	67	staff	0.00	0.00	0.00	0.00	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2397	4	2026-04-02	68	staff	0.00	0.00	0.00	0.00	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2398	4	2026-04-02	59	chefe de turno	28.55	3.24	22.84	22.84	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2399	4	2026-04-02	69	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2400	4	2026-04-02	61	gerente	0.00	0.00	94.65	94.65	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2401	4	2026-04-02	120	supervisor	0.00	0.00	64.76	64.76	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2402	4	2026-04-02	38	cozinha	0.00	0.00	6.27	6.27	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2403	4	2026-04-02	43	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2404	4	2026-04-02	44	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2405	4	2026-04-02	54	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2406	4	2026-04-02	55	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2407	4	2026-04-02	56	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2408	4	2026-04-02	60	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2409	4	2026-04-02	64	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2410	4	2026-04-02	65	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2411	4	2026-04-02	66	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2412	4	2026-04-02	70	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2413	4	2026-04-02	71	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2414	4	2026-04-02	72	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2415	4	2026-04-02	73	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2416	4	2026-04-02	74	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2417	4	2026-04-02	75	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2418	4	2026-04-02	316	cozinha	0.00	0.00	6.34	6.34	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2419	4	2026-04-02	325	chamador	0.00	29.00	0.00	0.00	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2420	4	2026-04-02	77	chamador	0.00	96.50	0.00	0.00	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2421	4	2026-04-02	53	chamador	0.00	96.50	0.00	0.00	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2663	3	2026-04-01	80	chefe de turno	0.00	0.00	0.00	0.00	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2664	3	2026-04-01	191	chefe de turno	0.00	0.00	0.00	0.00	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2665	3	2026-04-01	122	supervisor	0.00	0.00	78.76	78.76	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2666	3	2026-04-01	164	gerente	0.00	0.00	115.12	115.12	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2667	3	2026-04-01	79	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2668	3	2026-04-01	162	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2669	3	2026-04-01	166	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2670	3	2026-04-01	167	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2671	3	2026-04-01	169	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2672	3	2026-04-01	170	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2673	3	2026-04-01	171	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2674	3	2026-04-01	174	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2675	3	2026-04-01	176	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2676	3	2026-04-01	177	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2677	3	2026-04-01	329	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2678	3	2026-04-01	330	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2679	3	2026-04-01	331	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2680	3	2026-04-01	333	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2681	3	2026-04-01	334	cozinha	0.00	0.00	9.29	9.29	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2682	3	2026-04-01	322	chamador	0.00	111.00	0.00	0.00	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2683	3	2026-04-01	193	chamador	0.00	110.00	0.00	0.00	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2684	3	2026-04-02	81	staff	0.00	0.00	0.00	0.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2685	3	2026-04-02	165	staff	0.00	0.00	0.00	0.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2686	3	2026-04-02	168	staff	148.31	0.00	83.06	83.06	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2687	3	2026-04-02	172	staff	120.49	1.00	67.47	67.47	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2688	3	2026-04-02	173	staff	141.88	16.41	79.45	79.45	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2689	3	2026-04-02	175	staff	127.54	11.67	71.42	71.42	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2690	3	2026-04-02	178	staff	141.19	7.12	79.07	79.07	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2691	3	2026-04-02	211	staff	0.00	0.00	0.00	0.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2692	3	2026-04-02	323	staff	188.89	9.00	105.78	105.78	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2693	3	2026-04-02	335	staff	192.37	0.00	107.73	107.73	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2694	3	2026-04-02	80	chefe de turno	1.50	0.00	1.20	1.20	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2695	3	2026-04-02	191	chefe de turno	0.00	0.00	0.00	0.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2696	3	2026-04-02	122	supervisor	0.00	0.00	110.47	110.47	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2697	3	2026-04-02	164	gerente	0.00	0.00	161.45	161.45	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2698	3	2026-04-02	79	cozinha	0.00	0.00	13.07	13.07	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2699	3	2026-04-02	162	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2700	3	2026-04-02	166	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2701	3	2026-04-02	167	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2702	3	2026-04-02	169	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2703	3	2026-04-02	170	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2704	3	2026-04-02	171	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2705	3	2026-04-02	174	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2706	3	2026-04-02	176	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2707	3	2026-04-02	177	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2708	3	2026-04-02	329	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2709	3	2026-04-02	330	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2710	3	2026-04-02	331	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2711	3	2026-04-02	333	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2712	3	2026-04-02	334	cozinha	0.00	0.00	13.00	13.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2713	3	2026-04-02	322	chamador	0.00	0.00	0.00	0.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2714	3	2026-04-02	193	chamador	0.00	256.00	0.00	0.00	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2715	3	2026-04-03	81	staff	112.23	0.00	62.86	62.86	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2716	3	2026-04-03	165	staff	0.00	0.00	0.00	0.00	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2717	3	2026-04-03	168	staff	152.68	8.14	85.50	85.50	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2718	3	2026-04-03	172	staff	0.00	0.00	0.00	0.00	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2719	3	2026-04-03	173	staff	105.39	0.00	59.02	59.02	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2720	3	2026-04-03	175	staff	131.13	3.54	73.43	73.43	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2721	3	2026-04-03	178	staff	181.61	0.00	101.70	101.70	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2722	3	2026-04-03	211	staff	133.52	18.33	74.77	74.77	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2723	3	2026-04-03	323	staff	151.52	15.00	84.85	84.85	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2724	3	2026-04-03	335	staff	273.79	85.39	153.32	153.32	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2725	3	2026-04-03	80	chefe de turno	26.41	0.00	21.13	21.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2342	2	2026-03-30	182	staff	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2343	2	2026-03-30	183	staff	126.70	5.51	70.95	70.95	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2344	2	2026-03-30	187	staff	113.46	0.00	63.54	63.54	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2345	2	2026-03-30	190	staff	17.42	0.00	9.76	9.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2346	2	2026-03-30	196	staff	26.05	12.26	14.59	14.59	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2347	2	2026-03-30	197	staff	200.18	0.00	112.10	112.10	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2348	2	2026-03-30	199	staff	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2349	2	2026-03-30	201	staff	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2350	2	2026-03-30	202	staff	6.65	0.00	3.72	3.72	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2351	2	2026-03-30	203	staff	179.39	0.00	100.46	100.46	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2352	2	2026-03-30	204	staff	166.52	7.61	93.25	93.25	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2353	2	2026-03-30	205	staff	146.97	6.71	82.30	82.30	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2354	2	2026-03-30	206	staff	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2355	2	2026-03-30	207	staff	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2356	2	2026-03-30	212	staff	187.80	0.00	105.17	105.17	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2357	2	2026-03-30	216	staff	6.34	0.00	3.55	3.55	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2358	2	2026-03-30	218	staff	2.17	0.00	1.22	1.22	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2359	2	2026-03-30	219	staff	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2360	2	2026-03-30	221	staff	75.04	0.00	42.02	42.02	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2361	2	2026-03-30	314	staff	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2362	2	2026-03-30	341	staff	153.56	0.00	85.99	85.99	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2363	2	2026-03-30	342	staff	31.04	0.00	17.38	17.38	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2364	2	2026-03-30	343	staff	187.82	13.75	105.18	105.18	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2365	2	2026-03-30	280	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2366	2	2026-03-30	310	chefe de turno	0.00	0.00	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2367	2	2026-03-30	185	gerente	0.00	0.00	247.32	247.32	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2368	2	2026-03-30	123	supervisor	0.00	0.00	169.22	169.22	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2369	2	2026-03-30	179	cozinha	0.00	0.00	15.71	15.71	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2370	2	2026-03-30	180	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2371	2	2026-03-30	181	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2372	2	2026-03-30	184	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2373	2	2026-03-30	189	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2374	2	2026-03-30	192	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2375	2	2026-03-30	194	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2376	2	2026-03-30	195	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2377	2	2026-03-30	200	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2378	2	2026-03-30	208	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2379	2	2026-03-30	209	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2380	2	2026-03-30	210	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2381	2	2026-03-30	213	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2382	2	2026-03-30	214	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2383	2	2026-03-30	215	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2384	2	2026-03-30	217	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2385	2	2026-03-30	220	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2386	2	2026-03-30	222	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2387	2	2026-03-30	292	cozinha	0.00	0.00	15.76	15.76	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2388	2	2026-03-30	315	chamador	0.00	195.50	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2389	2	2026-03-30	188	chamador	0.00	195.50	0.00	0.00	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2726	3	2026-04-03	191	chefe de turno	0.00	0.00	0.00	0.00	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2727	3	2026-04-03	122	supervisor	0.00	0.00	131.90	131.90	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2728	3	2026-04-03	164	gerente	0.00	0.00	192.78	192.78	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2729	3	2026-04-03	79	cozinha	0.00	0.00	15.20	15.20	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2730	3	2026-04-03	162	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2731	3	2026-04-03	166	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2732	3	2026-04-03	167	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2733	3	2026-04-03	169	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2734	3	2026-04-03	170	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2735	3	2026-04-03	171	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2736	3	2026-04-03	174	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2737	3	2026-04-03	176	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2738	3	2026-04-03	177	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2739	3	2026-04-03	329	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2740	3	2026-04-03	330	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2741	3	2026-04-03	331	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2742	3	2026-04-03	333	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2743	3	2026-04-03	334	cozinha	0.00	0.00	15.13	15.13	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2744	3	2026-04-03	322	chamador	0.00	379.00	0.00	0.00	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2745	3	2026-04-03	193	chamador	0.00	0.00	0.00	0.00	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
3081	2	2026-04-03	188	chamador	0.00	242.00	0.00	0.00	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3968	5	2026-04-05	277	staff	136.43	8.18	76.40	76.40	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3969	5	2026-04-05	281	staff	150.58	0.00	84.33	84.33	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3970	5	2026-04-05	287	staff	49.32	0.00	27.62	27.62	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3971	5	2026-04-05	288	staff	103.43	0.00	57.92	57.92	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3972	5	2026-04-05	290	staff	0.00	0.00	0.00	0.00	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3973	5	2026-04-05	296	staff	127.41	4.00	71.35	71.35	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3974	5	2026-04-05	336	staff	66.32	0.00	37.14	37.14	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3975	5	2026-04-05	337	staff	168.34	0.00	94.27	94.27	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3976	5	2026-04-05	338	staff	31.98	0.00	17.91	17.91	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3977	5	2026-04-05	339	staff	146.97	0.00	82.30	82.30	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3978	5	2026-04-05	340	staff	0.00	0.00	0.00	0.00	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3979	5	2026-04-05	186	gerente	0.00	0.00	149.08	149.08	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3980	5	2026-04-05	118	supervisor	0.00	0.00	102.00	102.00	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3981	5	2026-04-05	294	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3982	5	2026-04-05	275	cozinha	0.00	0.00	22.54	22.54	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3983	5	2026-04-05	276	cozinha	0.00	0.00	22.56	22.56	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3984	5	2026-04-05	282	cozinha	0.00	0.00	22.56	22.56	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3985	5	2026-04-05	283	cozinha	0.00	0.00	22.56	22.56	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3986	5	2026-04-05	284	cozinha	0.00	0.00	22.56	22.56	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3987	5	2026-04-05	286	cozinha	0.00	0.00	22.56	22.56	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3988	5	2026-04-05	291	cozinha	0.00	0.00	22.56	22.56	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3989	5	2026-04-05	293	cozinha	0.00	0.00	22.56	22.56	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3990	5	2026-04-05	285	chamador	0.00	0.00	0.00	0.00	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3991	5	2026-04-05	278	chamador	0.00	110.00	0.00	0.00	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3992	5	2026-04-05	274	chamador	0.00	117.00	0.00	0.00	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
2539	6	2026-04-03	126	staff	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2540	6	2026-04-03	128	staff	301.67	3.00	168.93	168.93	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2541	6	2026-04-03	129	staff	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2542	6	2026-04-03	136	staff	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2543	6	2026-04-03	144	staff	77.97	0.00	43.66	43.66	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2544	6	2026-04-03	148	staff	380.48	29.95	213.07	213.07	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2545	6	2026-04-03	149	staff	275.00	1.00	154.00	154.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2546	6	2026-04-03	151	staff	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2547	6	2026-04-03	156	staff	295.38	20.00	165.41	165.41	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2548	6	2026-04-03	158	staff	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2549	6	2026-04-03	159	staff	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2550	6	2026-04-03	273	staff	92.26	5.30	51.67	51.67	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2551	6	2026-04-03	317	staff	50.85	0.45	28.48	28.48	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2552	6	2026-04-03	321	staff	58.47	0.00	32.74	32.74	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2553	6	2026-04-03	344	staff	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2554	6	2026-04-03	145	gerente	0.00	0.00	243.46	243.46	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2555	6	2026-04-03	116	supervisor	0.00	0.00	166.58	166.58	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2556	6	2026-04-03	133	chefe de turno	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2557	6	2026-04-03	147	chefe de turno	69.64	0.00	55.71	55.71	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2558	6	2026-04-03	272	chefe de turno	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2559	6	2026-04-03	85	balcao	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2560	6	2026-04-03	132	balcao	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2561	6	2026-04-03	135	balcao	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2562	6	2026-04-03	138	balcao	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2563	6	2026-04-03	143	balcao	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2564	6	2026-04-03	146	balcao	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2565	6	2026-04-03	161	balcao	0.00	0.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2566	6	2026-04-03	131	cozinha	0.00	0.00	27.81	27.81	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2567	6	2026-04-03	134	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2568	6	2026-04-03	139	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2569	6	2026-04-03	141	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2570	6	2026-04-03	150	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2571	6	2026-04-03	152	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2572	6	2026-04-03	153	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2573	6	2026-04-03	157	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2574	6	2026-04-03	160	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2575	6	2026-04-03	311	cozinha	0.00	0.00	27.80	27.80	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2576	6	2026-04-03	318	chamador	0.00	273.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2577	6	2026-04-03	140	chamador	0.00	200.00	0.00	0.00	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
4202	11	2026-04-02	94	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4203	11	2026-04-02	105	chefe de turno	46.59	0.00	37.27	37.27	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4204	11	2026-04-02	115	supervisor	0.00	0.00	89.47	89.47	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4205	11	2026-04-02	93	gerente	0.00	0.00	130.76	130.76	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4206	11	2026-04-02	107	cozinha	0.00	0.00	21.00	21.00	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4207	11	2026-04-02	108	cozinha	0.00	0.00	21.02	21.02	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4208	11	2026-04-02	111	cozinha	0.00	0.00	21.02	21.02	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4209	11	2026-04-02	112	cozinha	0.00	0.00	21.02	21.02	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4210	11	2026-04-02	269	cozinha	0.00	0.00	21.02	21.02	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4211	11	2026-04-02	319	cozinha	0.00	0.00	21.02	21.02	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4212	11	2026-04-02	320	cozinha	0.00	0.00	21.02	21.02	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4213	11	2026-04-02	345	chamador	0.00	211.00	0.00	0.00	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4214	11	2026-04-02	328	chamador	0.00	0.00	0.00	0.00	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
3542	6	2026-04-05	148	staff	193.47	20.47	108.34	108.34	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3543	6	2026-04-05	149	staff	140.13	38.60	78.47	78.47	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3544	6	2026-04-05	151	staff	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3545	6	2026-04-05	156	staff	158.02	2.00	88.49	88.49	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3546	6	2026-04-05	158	staff	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3547	6	2026-04-05	159	staff	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3548	6	2026-04-05	273	staff	146.47	0.00	82.02	82.02	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3549	6	2026-04-05	317	staff	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3550	6	2026-04-05	321	staff	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3551	6	2026-04-05	344	staff	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3552	6	2026-04-05	145	gerente	0.00	0.00	159.51	159.51	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3553	6	2026-04-05	116	supervisor	0.00	0.00	109.14	109.14	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3554	6	2026-04-05	133	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3993	11	2026-03-31	90	staff	0.00	0.00	0.00	0.00	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3994	11	2026-03-31	92	staff	0.00	0.00	0.00	0.00	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3995	11	2026-03-31	95	staff	96.23	4.25	53.88	53.88	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3996	11	2026-03-31	109	staff	81.82	0.00	45.82	45.82	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3997	11	2026-03-31	113	staff	101.21	0.00	56.68	56.68	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3998	11	2026-03-31	155	staff	161.51	14.31	90.45	90.45	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3999	11	2026-03-31	324	staff	79.55	1.44	44.55	44.55	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4000	11	2026-03-31	326	staff	0.00	0.00	0.00	0.00	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4001	11	2026-03-31	327	staff	74.03	0.00	41.46	41.46	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4002	11	2026-03-31	94	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4003	11	2026-03-31	105	chefe de turno	39.80	0.00	31.84	31.84	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4004	11	2026-03-31	115	supervisor	0.00	0.00	65.95	65.95	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4005	11	2026-03-31	93	gerente	0.00	0.00	96.39	96.39	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4006	11	2026-03-31	107	cozinha	0.00	0.00	15.33	15.33	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4007	11	2026-03-31	108	cozinha	0.00	0.00	15.30	15.30	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4008	11	2026-03-31	111	cozinha	0.00	0.00	15.30	15.30	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3555	6	2026-04-05	147	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3556	6	2026-04-05	272	chefe de turno	43.16	0.00	34.53	34.53	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3557	6	2026-04-05	85	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3558	6	2026-04-05	132	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3559	6	2026-04-05	135	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3560	6	2026-04-05	138	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3561	6	2026-04-05	143	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3562	6	2026-04-05	146	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3563	6	2026-04-05	161	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3564	6	2026-04-05	131	cozinha	0.00	0.00	18.31	18.31	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3565	6	2026-04-05	134	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3566	6	2026-04-05	139	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3567	6	2026-04-05	141	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3568	6	2026-04-05	150	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3569	6	2026-04-05	152	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3570	6	2026-04-05	153	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3571	6	2026-04-05	157	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3572	6	2026-04-05	160	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3573	6	2026-04-05	311	cozinha	0.00	0.00	18.27	18.27	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3574	6	2026-04-05	318	chamador	0.00	187.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3575	6	2026-04-05	140	chamador	0.00	124.00	0.00	0.00	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3609	6	2026-04-01	126	staff	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3610	6	2026-04-01	128	staff	194.70	3.00	109.03	109.03	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3611	6	2026-04-01	129	staff	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3612	6	2026-04-01	136	staff	117.49	20.00	65.80	65.80	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3613	6	2026-04-01	144	staff	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3614	6	2026-04-01	148	staff	60.28	10.00	33.76	33.76	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3615	6	2026-04-01	149	staff	137.80	8.00	77.17	77.17	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3616	6	2026-04-01	151	staff	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3617	6	2026-04-01	156	staff	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3618	6	2026-04-01	158	staff	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3619	6	2026-04-01	159	staff	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3620	6	2026-04-01	273	staff	26.83	4.70	15.02	15.02	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3621	6	2026-04-01	317	staff	12.79	0.00	7.16	7.16	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3622	6	2026-04-01	321	staff	95.62	15.81	53.55	53.55	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3482	11	2026-04-05	90	staff	0.00	0.00	0.00	0.00	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3483	11	2026-04-05	92	staff	89.86	3.47	50.32	50.32	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3484	11	2026-04-05	95	staff	173.96	5.81	97.42	97.42	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3485	11	2026-04-05	109	staff	93.55	13.84	52.39	52.39	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3486	11	2026-04-05	113	staff	154.20	0.00	86.35	86.35	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3487	11	2026-04-05	155	staff	0.00	0.00	0.00	0.00	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3488	11	2026-04-05	324	staff	91.39	0.00	51.18	51.18	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3489	11	2026-04-05	326	staff	121.74	0.00	68.17	68.17	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3145	3	2026-04-04	81	staff	132.29	4.00	74.09	74.09	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3146	3	2026-04-04	165	staff	0.00	0.00	0.00	0.00	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3147	3	2026-04-04	168	staff	179.23	3.96	100.37	100.37	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3148	3	2026-04-04	172	staff	133.18	1.07	74.58	74.58	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3149	3	2026-04-04	173	staff	127.07	0.00	71.16	71.16	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3150	3	2026-04-04	175	staff	201.61	1.20	112.90	112.90	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3151	3	2026-04-04	178	staff	100.22	0.00	56.12	56.12	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3152	3	2026-04-04	211	staff	133.55	0.00	74.79	74.79	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3153	3	2026-04-04	323	staff	0.00	0.00	0.00	0.00	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3154	3	2026-04-04	335	staff	195.33	1.11	109.38	109.38	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3155	3	2026-04-04	80	chefe de turno	0.00	0.00	0.00	0.00	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3156	3	2026-04-04	191	chefe de turno	0.00	0.00	0.00	0.00	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3157	3	2026-04-04	122	supervisor	0.00	0.00	125.06	125.06	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3158	3	2026-04-04	164	gerente	0.00	0.00	182.78	182.78	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3159	3	2026-04-04	79	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3160	3	2026-04-04	162	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3161	3	2026-04-04	166	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3162	3	2026-04-04	167	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3163	3	2026-04-04	169	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3164	3	2026-04-04	170	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3165	3	2026-04-04	171	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3166	3	2026-04-04	174	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3167	3	2026-04-04	176	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3168	3	2026-04-04	177	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3169	3	2026-04-04	329	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3170	3	2026-04-04	330	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3171	3	2026-04-04	331	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3172	3	2026-04-04	333	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3173	3	2026-04-04	334	cozinha	0.00	0.00	14.75	14.75	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3174	3	2026-04-04	322	chamador	0.00	145.00	0.00	0.00	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3175	3	2026-04-04	193	chamador	0.00	145.00	0.00	0.00	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3490	11	2026-04-05	327	staff	0.00	0.00	0.00	0.00	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3491	11	2026-04-05	94	chefe de turno	12.53	0.00	10.02	10.02	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3492	11	2026-04-05	105	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3493	11	2026-04-05	115	supervisor	0.00	0.00	76.67	76.67	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3494	11	2026-04-05	93	gerente	0.00	0.00	112.06	112.06	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3495	11	2026-04-05	107	cozinha	0.00	0.00	18.95	18.95	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3496	11	2026-04-05	108	cozinha	0.00	0.00	18.95	18.95	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3497	11	2026-04-05	111	cozinha	0.00	0.00	18.95	18.95	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3498	11	2026-04-05	112	cozinha	0.00	0.00	18.95	18.95	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3499	11	2026-04-05	269	cozinha	0.00	0.00	18.95	18.95	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3500	11	2026-04-05	319	cozinha	0.00	0.00	18.95	18.95	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3501	11	2026-04-05	320	cozinha	0.00	0.00	18.95	18.95	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
4009	11	2026-03-31	112	cozinha	0.00	0.00	15.30	15.30	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4010	11	2026-03-31	269	cozinha	0.00	0.00	15.30	15.30	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4011	11	2026-03-31	319	cozinha	0.00	0.00	15.30	15.30	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4012	11	2026-03-31	320	cozinha	0.00	0.00	15.30	15.30	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4013	11	2026-03-31	345	chamador	0.00	0.00	0.00	0.00	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4014	11	2026-03-31	328	chamador	0.00	156.00	0.00	0.00	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
4015	6	2026-04-04	126	staff	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4016	6	2026-04-04	128	staff	226.59	25.00	126.89	126.89	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4017	6	2026-04-04	129	staff	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4018	6	2026-04-04	136	staff	130.01	0.00	72.81	72.81	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4019	6	2026-04-04	144	staff	216.21	50.00	121.08	121.08	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4020	6	2026-04-04	148	staff	252.27	50.22	141.27	141.27	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4021	6	2026-04-04	149	staff	139.02	0.00	77.85	77.85	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4022	6	2026-04-04	151	staff	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4023	6	2026-04-04	156	staff	175.18	0.00	98.10	98.10	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4024	6	2026-04-04	158	staff	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4025	6	2026-04-04	159	staff	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4026	6	2026-04-04	273	staff	78.83	3.44	44.14	44.14	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4027	6	2026-04-04	317	staff	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4028	6	2026-04-04	321	staff	95.11	0.00	53.26	53.26	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4029	6	2026-04-04	344	staff	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4030	6	2026-04-04	133	chefe de turno	94.32	0.00	75.46	75.46	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4031	6	2026-04-04	147	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4032	6	2026-04-04	272	chefe de turno	2.90	0.00	2.32	2.32	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4033	6	2026-04-04	145	gerente	0.00	0.00	214.39	214.39	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4034	6	2026-04-04	116	supervisor	0.00	0.00	146.69	146.69	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4035	6	2026-04-04	85	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4036	6	2026-04-04	132	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4037	6	2026-04-04	135	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4038	6	2026-04-04	138	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4039	6	2026-04-04	143	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4040	6	2026-04-04	146	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4041	6	2026-04-04	161	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4042	6	2026-04-04	131	cozinha	0.00	0.00	23.60	23.60	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4043	6	2026-04-04	134	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4044	6	2026-04-04	139	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4045	6	2026-04-04	141	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4046	6	2026-04-04	150	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4047	6	2026-04-04	152	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4048	6	2026-04-04	153	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4049	6	2026-04-04	157	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4050	6	2026-04-04	160	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4051	6	2026-04-04	311	cozinha	0.00	0.00	23.62	23.62	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4052	6	2026-04-04	318	chamador	0.00	292.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
4053	6	2026-04-04	140	chamador	0.00	207.00	0.00	0.00	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3502	11	2026-04-05	345	chamador	0.00	113.00	0.00	0.00	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
3503	11	2026-04-05	328	chamador	0.00	114.00	0.00	0.00	2026-04-06 08:02:55.468	2026-04-06 08:02:55.468
4237	11	2026-04-03	90	staff	139.89	4.20	78.34	78.34	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4238	11	2026-04-03	92	staff	48.04	0.00	26.90	26.90	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4239	11	2026-04-03	95	staff	0.00	0.00	0.00	0.00	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4240	11	2026-04-03	109	staff	0.00	0.00	0.00	0.00	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4241	11	2026-04-03	113	staff	73.12	0.00	40.95	40.95	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4242	11	2026-04-03	155	staff	95.86	0.00	53.68	53.68	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4243	11	2026-04-03	324	staff	86.81	0.00	48.61	48.61	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4244	11	2026-04-03	326	staff	106.98	2.96	59.91	59.91	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4245	11	2026-04-03	327	staff	81.33	3.09	45.55	45.55	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4246	11	2026-04-03	94	chefe de turno	27.43	0.00	21.94	21.94	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4247	11	2026-04-03	105	chefe de turno	41.38	0.00	33.11	33.11	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4248	11	2026-04-03	115	supervisor	0.00	0.00	72.89	72.89	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4249	11	2026-04-03	93	gerente	0.00	0.00	106.53	106.53	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4250	11	2026-04-03	107	cozinha	0.00	0.00	16.07	16.07	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4251	11	2026-04-03	108	cozinha	0.00	0.00	16.06	16.06	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
3623	6	2026-04-01	344	staff	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3624	6	2026-04-01	145	gerente	0.00	0.00	114.80	114.80	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3625	6	2026-04-01	116	supervisor	0.00	0.00	78.55	78.55	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3626	6	2026-04-01	133	chefe de turno	72.35	6.00	57.88	57.88	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3627	6	2026-04-01	147	chefe de turno	37.40	21.93	29.92	29.92	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3628	6	2026-04-01	272	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3629	6	2026-04-01	85	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3630	6	2026-04-01	132	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3631	6	2026-04-01	135	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3632	6	2026-04-01	138	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3633	6	2026-04-01	143	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3634	6	2026-04-01	146	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3635	6	2026-04-01	161	balcao	0.00	0.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3636	6	2026-04-01	131	cozinha	0.00	0.00	11.28	11.28	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3637	6	2026-04-01	134	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3638	6	2026-04-01	139	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3639	6	2026-04-01	141	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3640	6	2026-04-01	150	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3641	6	2026-04-01	152	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3642	6	2026-04-01	153	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3643	6	2026-04-01	157	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3644	6	2026-04-01	160	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3645	6	2026-04-01	311	cozinha	0.00	0.00	11.26	11.26	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3646	6	2026-04-01	318	chamador	0.00	144.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3647	6	2026-04-01	140	chamador	0.00	92.00	0.00	0.00	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
4252	11	2026-04-03	111	cozinha	0.00	0.00	16.06	16.06	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4253	11	2026-04-03	112	cozinha	0.00	0.00	16.06	16.06	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4254	11	2026-04-03	269	cozinha	0.00	0.00	16.06	16.06	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4255	11	2026-04-03	319	cozinha	0.00	0.00	16.06	16.06	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4256	11	2026-04-03	320	cozinha	0.00	0.00	16.06	16.06	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4257	11	2026-04-03	345	chamador	0.00	32.00	0.00	0.00	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4258	11	2026-04-03	328	chamador	0.00	135.00	0.00	0.00	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4054	6	2026-03-30	126	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4055	6	2026-03-30	128	staff	356.42	16.00	199.59	199.59	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4056	6	2026-03-30	129	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4057	6	2026-03-30	136	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4058	6	2026-03-30	144	staff	97.74	8.00	54.73	54.73	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4059	6	2026-03-30	148	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4060	6	2026-03-30	149	staff	150.19	0.00	84.11	84.11	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4061	6	2026-03-30	151	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4062	6	2026-03-30	156	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4063	6	2026-03-30	158	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4064	6	2026-03-30	159	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4065	6	2026-03-30	273	staff	72.13	8.86	40.39	40.39	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4066	6	2026-03-30	317	staff	11.10	0.00	6.22	6.22	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4067	6	2026-03-30	321	staff	44.26	0.00	24.79	24.79	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4068	6	2026-03-30	344	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3681	4	2026-04-01	21	staff	0.00	0.00	0.00	0.00	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3682	4	2026-04-01	26	staff	98.64	2.31	55.24	55.24	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3683	4	2026-04-01	57	staff	147.17	16.00	82.41	82.41	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3684	4	2026-04-01	58	staff	76.63	7.00	42.91	42.91	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3685	4	2026-04-01	62	staff	70.04	0.00	39.22	39.22	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3686	4	2026-04-01	63	staff	0.00	0.00	0.00	0.00	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3687	4	2026-04-01	67	staff	48.94	7.00	27.41	27.41	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3688	4	2026-04-01	68	staff	65.55	3.16	36.71	36.71	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3689	4	2026-04-01	346	staff	0.00	0.00	0.00	0.00	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3690	4	2026-04-01	59	chefe de turno	47.83	0.00	38.26	38.26	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3691	4	2026-04-01	69	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3692	4	2026-04-01	61	gerente	0.00	0.00	84.33	84.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3693	4	2026-04-01	120	supervisor	0.00	0.00	57.70	57.70	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3694	4	2026-04-01	38	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3695	4	2026-04-01	43	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3696	4	2026-04-01	44	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3697	4	2026-04-01	54	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3698	4	2026-04-01	55	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3699	4	2026-04-01	56	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3700	4	2026-04-01	60	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3701	4	2026-04-01	64	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3702	4	2026-04-01	65	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3703	4	2026-04-01	66	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3704	4	2026-04-01	70	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3705	4	2026-04-01	71	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3706	4	2026-04-01	72	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3707	4	2026-04-01	73	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3708	4	2026-04-01	74	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3709	4	2026-04-01	75	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3710	4	2026-04-01	316	cozinha	0.00	0.00	5.33	5.33	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3711	4	2026-04-01	325	chamador	0.00	10.00	0.00	0.00	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3712	4	2026-04-01	77	chamador	0.00	151.00	0.00	0.00	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3713	4	2026-04-01	53	chamador	0.00	0.00	0.00	0.00	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
4069	6	2026-03-30	133	chefe de turno	184.47	0.00	147.58	147.58	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4070	6	2026-03-30	147	chefe de turno	6.34	0.00	5.07	5.07	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4071	6	2026-03-30	272	chefe de turno	74.89	0.00	59.91	59.91	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4072	6	2026-03-30	145	gerente	0.00	0.00	151.63	151.63	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4073	6	2026-03-30	116	supervisor	0.00	0.00	103.74	103.74	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4074	6	2026-03-30	85	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4075	6	2026-03-30	132	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4076	6	2026-03-30	135	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4077	6	2026-03-30	138	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4078	6	2026-03-30	143	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4079	6	2026-03-30	146	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4080	6	2026-03-30	161	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4081	6	2026-03-30	131	cozinha	0.00	0.00	11.96	11.96	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4082	6	2026-03-30	134	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4083	6	2026-03-30	139	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4084	6	2026-03-30	141	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4085	6	2026-03-30	150	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4086	6	2026-03-30	152	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4087	6	2026-03-30	153	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3747	4	2026-04-03	21	staff	0.00	0.00	0.00	0.00	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3748	4	2026-04-03	26	staff	0.00	0.00	0.00	0.00	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3749	4	2026-04-03	57	staff	182.75	10.00	102.34	102.34	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3750	4	2026-04-03	58	staff	172.55	10.60	96.63	96.63	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3751	4	2026-04-03	62	staff	161.98	27.27	90.71	90.71	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3752	4	2026-04-03	63	staff	248.03	50.00	138.90	138.90	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3753	4	2026-04-03	67	staff	0.00	0.00	0.00	0.00	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3754	4	2026-04-03	68	staff	77.72	0.00	43.52	43.52	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3755	4	2026-04-03	346	staff	53.72	0.00	30.08	30.08	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3756	4	2026-04-03	59	chefe de turno	105.46	0.00	84.37	84.37	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3757	4	2026-04-03	69	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3758	4	2026-04-03	61	gerente	0.00	0.00	152.34	152.34	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3759	4	2026-04-03	120	supervisor	0.00	0.00	104.23	104.23	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3760	4	2026-04-03	38	cozinha	0.00	0.00	9.33	9.33	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3761	4	2026-04-03	43	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3762	4	2026-04-03	44	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3763	4	2026-04-03	54	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3764	4	2026-04-03	55	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3765	4	2026-04-03	56	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3766	4	2026-04-03	60	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3767	4	2026-04-03	64	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3768	4	2026-04-03	65	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3769	4	2026-04-03	66	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3770	4	2026-04-03	70	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3771	4	2026-04-03	71	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3772	4	2026-04-03	72	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3773	4	2026-04-03	73	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3774	4	2026-04-03	74	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3775	4	2026-04-03	75	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3776	4	2026-04-03	316	cozinha	0.00	0.00	9.36	9.36	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3777	4	2026-04-03	325	chamador	0.00	0.00	0.00	0.00	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3778	4	2026-04-03	77	chamador	0.00	167.50	0.00	0.00	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3779	4	2026-04-03	53	chamador	0.00	167.50	0.00	0.00	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3780	4	2026-04-04	21	staff	0.00	0.00	0.00	0.00	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3781	4	2026-04-04	26	staff	190.02	3.29	106.41	106.41	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3782	4	2026-04-04	57	staff	188.16	3.00	105.37	105.37	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3783	4	2026-04-04	58	staff	0.00	0.00	0.00	0.00	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3784	4	2026-04-04	62	staff	120.38	16.04	67.41	67.41	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3785	4	2026-04-04	63	staff	243.20	3.13	136.19	136.19	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3786	4	2026-04-04	67	staff	0.00	0.00	0.00	0.00	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3787	4	2026-04-04	68	staff	130.19	7.66	72.91	72.91	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3788	4	2026-04-04	346	staff	0.00	0.00	0.00	0.00	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3789	4	2026-04-04	59	chefe de turno	83.49	19.50	66.79	66.79	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3790	4	2026-04-04	69	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3791	4	2026-04-04	61	gerente	0.00	0.00	145.23	145.23	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3792	4	2026-04-04	120	supervisor	0.00	0.00	99.37	99.37	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3793	4	2026-04-04	38	cozinha	0.00	0.00	9.20	9.20	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3794	4	2026-04-04	43	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3795	4	2026-04-04	44	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3796	4	2026-04-04	54	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3797	4	2026-04-04	55	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3798	4	2026-04-04	56	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3799	4	2026-04-04	60	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3800	4	2026-04-04	64	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3801	4	2026-04-04	65	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3802	4	2026-04-04	66	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3803	4	2026-04-04	70	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3804	4	2026-04-04	71	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3805	4	2026-04-04	72	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3806	4	2026-04-04	73	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3807	4	2026-04-04	74	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3808	4	2026-04-04	75	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3809	4	2026-04-04	316	cozinha	0.00	0.00	9.16	9.16	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3810	4	2026-04-04	325	chamador	0.00	0.00	0.00	0.00	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3811	4	2026-04-04	77	chamador	0.00	136.50	0.00	0.00	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3812	4	2026-04-04	53	chamador	0.00	136.50	0.00	0.00	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3813	4	2026-04-05	21	staff	0.00	0.00	0.00	0.00	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3814	4	2026-04-05	26	staff	152.50	2.09	85.40	85.40	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3815	4	2026-04-05	57	staff	109.87	0.00	61.53	61.53	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3816	4	2026-04-05	58	staff	145.18	18.60	81.30	81.30	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3817	4	2026-04-05	62	staff	171.93	16.69	96.28	96.28	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3818	4	2026-04-05	63	staff	147.88	4.50	82.81	82.81	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3819	4	2026-04-05	67	staff	0.00	0.00	0.00	0.00	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3820	4	2026-04-05	68	staff	108.50	2.50	60.76	60.76	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3821	4	2026-04-05	346	staff	13.41	0.00	7.51	7.51	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3822	4	2026-04-05	59	chefe de turno	143.44	0.00	114.75	114.75	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3823	4	2026-04-05	69	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3824	4	2026-04-05	61	gerente	0.00	0.00	150.89	150.89	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3825	4	2026-04-05	120	supervisor	0.00	0.00	103.24	103.24	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3826	4	2026-04-05	38	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3827	4	2026-04-05	43	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3828	4	2026-04-05	44	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3829	4	2026-04-05	54	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3830	4	2026-04-05	55	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3831	4	2026-04-05	56	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3832	4	2026-04-05	60	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3833	4	2026-04-05	64	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3834	4	2026-04-05	65	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3835	4	2026-04-05	66	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3836	4	2026-04-05	70	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3837	4	2026-04-05	71	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3838	4	2026-04-05	72	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3839	4	2026-04-05	73	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3840	4	2026-04-05	74	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3841	4	2026-04-05	75	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3842	4	2026-04-05	316	cozinha	0.00	0.00	8.72	8.72	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3843	4	2026-04-05	325	chamador	0.00	0.00	0.00	0.00	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3844	4	2026-04-05	77	chamador	0.00	143.00	0.00	0.00	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
3845	4	2026-04-05	53	chamador	0.00	143.00	0.00	0.00	2026-04-06 12:00:23.851	2026-04-06 12:00:23.851
4088	6	2026-03-30	157	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4089	6	2026-03-30	160	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4090	6	2026-03-30	311	cozinha	0.00	0.00	11.98	11.98	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4091	6	2026-03-30	318	chamador	0.00	0.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4092	6	2026-03-30	140	chamador	0.00	245.00	0.00	0.00	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4132	11	2026-04-01	90	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4133	11	2026-04-01	92	staff	115.06	0.00	64.43	64.43	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4134	11	2026-04-01	95	staff	140.70	1.85	78.79	78.79	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4135	11	2026-04-01	109	staff	92.05	14.00	51.55	51.55	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4136	11	2026-04-01	113	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4137	11	2026-04-01	155	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4138	11	2026-04-01	324	staff	85.18	5.41	47.70	47.70	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4139	11	2026-04-01	326	staff	89.41	19.59	50.07	50.07	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4140	11	2026-04-01	327	staff	74.66	6.86	41.81	41.81	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4141	11	2026-04-01	94	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4142	11	2026-04-01	105	chefe de turno	21.87	0.00	17.50	17.50	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4143	11	2026-04-01	115	supervisor	0.00	0.00	64.37	64.37	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4144	11	2026-04-01	93	gerente	0.00	0.00	94.08	94.08	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4145	11	2026-04-01	107	cozinha	0.00	0.00	15.51	15.51	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4146	11	2026-04-01	108	cozinha	0.00	0.00	15.52	15.52	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4147	11	2026-04-01	111	cozinha	0.00	0.00	15.52	15.52	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4148	11	2026-04-01	112	cozinha	0.00	0.00	15.52	15.52	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4149	11	2026-04-01	269	cozinha	0.00	0.00	15.52	15.52	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4150	11	2026-04-01	319	cozinha	0.00	0.00	15.52	15.52	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4151	11	2026-04-01	320	cozinha	0.00	0.00	15.52	15.52	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4152	11	2026-04-01	345	chamador	0.00	175.00	0.00	0.00	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4153	11	2026-04-01	328	chamador	0.00	0.00	0.00	0.00	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4154	6	2026-03-31	126	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4155	6	2026-03-31	128	staff	78.30	0.00	43.84	43.84	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4156	6	2026-03-31	129	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4157	6	2026-03-31	136	staff	65.57	12.47	36.72	36.72	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4158	6	2026-03-31	144	staff	49.78	0.00	27.88	27.88	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4159	6	2026-03-31	148	staff	139.98	9.99	78.39	78.39	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4160	6	2026-03-31	149	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4161	6	2026-03-31	151	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4162	6	2026-03-31	156	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4163	6	2026-03-31	158	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4164	6	2026-03-31	159	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4165	6	2026-03-31	273	staff	66.22	0.00	37.08	37.08	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4166	6	2026-03-31	317	staff	92.55	0.00	51.83	51.83	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4167	6	2026-03-31	321	staff	69.82	0.00	39.10	39.10	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4168	6	2026-03-31	344	staff	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4169	6	2026-03-31	133	chefe de turno	50.54	0.00	40.43	40.43	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4170	6	2026-03-31	147	chefe de turno	46.50	0.00	37.20	37.20	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4171	6	2026-03-31	272	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4172	6	2026-03-31	145	gerente	0.00	0.00	100.21	100.21	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4173	6	2026-03-31	116	supervisor	0.00	0.00	68.56	68.56	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4174	6	2026-03-31	85	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4175	6	2026-03-31	132	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4176	6	2026-03-31	135	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4177	6	2026-03-31	138	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4178	6	2026-03-31	143	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4179	6	2026-03-31	146	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4180	6	2026-03-31	161	balcao	0.00	0.00	0.00	0.00	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4181	6	2026-03-31	131	cozinha	0.00	0.00	9.82	9.82	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4306	11	2026-04-04	90	staff	90.79	12.71	50.83	50.83	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4307	11	2026-04-04	92	staff	60.91	8.16	34.11	34.11	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4308	11	2026-04-04	95	staff	95.75	0.00	53.62	53.62	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4309	11	2026-04-04	109	staff	98.91	22.50	55.39	55.39	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4310	11	2026-04-04	113	staff	128.76	0.00	72.11	72.11	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4311	11	2026-04-04	155	staff	95.84	18.91	53.67	53.67	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4312	11	2026-04-04	324	staff	0.00	0.00	0.00	0.00	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4313	11	2026-04-04	326	staff	56.03	9.70	31.38	31.38	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4314	11	2026-04-04	327	staff	107.23	0.00	60.05	60.05	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4315	11	2026-04-04	94	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4316	11	2026-04-04	105	chefe de turno	15.05	0.00	12.04	12.04	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4317	11	2026-04-04	115	supervisor	0.00	0.00	77.92	77.92	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4318	11	2026-04-04	93	gerente	0.00	0.00	113.89	113.89	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4319	11	2026-04-04	107	cozinha	0.00	0.00	19.18	19.18	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4320	11	2026-04-04	108	cozinha	0.00	0.00	19.18	19.18	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4321	11	2026-04-04	111	cozinha	0.00	0.00	19.18	19.18	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4322	11	2026-04-04	112	cozinha	0.00	0.00	19.18	19.18	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4323	11	2026-04-04	269	cozinha	0.00	0.00	19.18	19.18	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4324	11	2026-04-04	319	cozinha	0.00	0.00	19.18	19.18	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4325	11	2026-04-04	320	cozinha	0.00	0.00	19.18	19.18	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4326	11	2026-04-04	345	chamador	0.00	24.00	0.00	0.00	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4327	11	2026-04-04	328	chamador	0.00	153.00	0.00	0.00	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4328	5	2026-04-04	277	staff	148.18	5.04	82.98	82.98	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4329	5	2026-04-04	281	staff	172.59	30.38	96.65	96.65	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4330	5	2026-04-04	287	staff	112.76	0.00	63.15	63.15	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4331	5	2026-04-04	288	staff	78.39	0.00	43.90	43.90	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4332	5	2026-04-04	290	staff	0.00	0.00	0.00	0.00	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4333	5	2026-04-04	296	staff	160.22	9.00	89.72	89.72	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4334	5	2026-04-04	336	staff	0.00	0.00	0.00	0.00	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4335	5	2026-04-04	337	staff	155.53	15.00	87.10	87.10	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4336	5	2026-04-04	338	staff	27.58	0.00	15.44	15.44	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4337	5	2026-04-04	339	staff	124.11	19.95	69.50	69.50	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4338	5	2026-04-04	340	staff	0.00	0.00	0.00	0.00	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4339	5	2026-04-04	186	gerente	0.00	0.00	148.86	148.86	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4340	5	2026-04-04	118	supervisor	0.00	0.00	101.85	101.85	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4341	5	2026-04-04	294	chefe de turno	0.00	0.00	0.00	0.00	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4342	5	2026-04-04	275	cozinha	0.00	0.00	22.50	22.50	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4343	5	2026-04-04	276	cozinha	0.00	0.00	22.53	22.53	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4344	5	2026-04-04	282	cozinha	0.00	0.00	22.53	22.53	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4345	5	2026-04-04	283	cozinha	0.00	0.00	22.53	22.53	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4346	5	2026-04-04	284	cozinha	0.00	0.00	22.53	22.53	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4347	5	2026-04-04	286	cozinha	0.00	0.00	22.53	22.53	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4348	5	2026-04-04	291	cozinha	0.00	0.00	22.53	22.53	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4349	5	2026-04-04	293	cozinha	0.00	0.00	22.53	22.53	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4350	5	2026-04-04	285	chamador	0.00	0.00	0.00	0.00	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4351	5	2026-04-04	278	chamador	0.00	120.00	0.00	0.00	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4352	5	2026-04-04	274	chamador	0.00	80.00	0.00	0.00	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
\.


--
-- Data for Name: fecho_financeiro; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.fecho_financeiro (id, "restID", data, faturamento_global, dinheiro_a_depositar, notas, "criadoEm", "atualizadoEm") FROM stdin;
1	4	2026-02-28	0.00	0.00	\N	2026-02-28 22:55:07.357	2026-02-28 22:55:07.357
2	1	2026-01-26	3972.36	429.01	\N	2026-02-28 22:55:35.643	2026-02-28 23:00:08.106
7	4	2026-03-09	4830.43	0.00	\N	2026-03-10 10:27:20.877	2026-03-10 10:28:14.756
10	4	2026-03-08	6593.16	5845.03	\N	2026-03-10 14:50:31.027	2026-03-10 14:51:14.461
14	4	2026-03-02	5050.68	766.60	\N	2026-03-14 11:06:30.555	2026-03-14 11:06:30.555
15	4	2026-03-03	4528.92	696.37	\N	2026-03-14 11:22:32.453	2026-03-14 11:22:32.453
16	4	2026-03-04	4265.53	568.46	\N	2026-03-14 11:29:20.215	2026-03-14 11:29:20.215
17	4	2026-03-05	4938.38	802.75	\N	2026-03-14 11:34:16.159	2026-03-14 11:34:16.159
18	4	2026-03-06	4947.94	920.05	\N	2026-03-14 11:39:02.968	2026-03-14 11:39:02.968
20	4	2026-03-10	5599.68	0.00	\N	2026-03-14 12:54:08.971	2026-03-14 12:54:08.971
21	4	2026-03-11	4683.10	0.00	\N	2026-03-14 13:14:41.16	2026-03-14 13:14:41.16
22	4	2026-03-12	7296.52	0.00	\N	2026-03-14 13:21:02.512	2026-03-14 13:21:02.512
23	4	2026-03-13	6870.45	0.00	\N	2026-03-14 14:14:15.432	2026-03-14 14:14:15.432
19	4	2026-03-07	8625.97	0.00	\N	2026-03-14 12:45:11.926	2026-03-14 14:29:28.989
26	6	2026-03-30	9508.48	0.00	\N	2026-04-02 14:14:51.822	2026-04-03 09:35:48.668
30	6	2026-04-02	10323.12	1533.23	\N	2026-04-03 09:46:00.174	2026-04-03 10:35:41.455
35	11	2026-03-30	5373.28	803.80	\N	2026-04-03 11:23:24.266	2026-04-03 11:23:24.266
36	3	2026-03-30	8190.99	1238.45	\N	2026-04-03 12:25:17.543	2026-04-03 12:25:17.543
37	3	2026-03-31	8478.41	1296.28	\N	2026-04-03 12:46:25.427	2026-04-03 12:46:25.427
40	5	2026-03-30	10117.83	1435.29	O VALOR DO MULTIBANCO É DE 7710.35	2026-04-03 13:49:50.113	2026-04-03 13:49:50.113
41	5	2026-03-31	8572.92	0.00	\N	2026-04-03 13:57:00.095	2026-04-03 13:57:36.674
45	5	2026-04-01	8958.12	1956.77	\N	2026-04-03 14:11:48.905	2026-04-03 14:11:48.905
46	5	2026-04-02	9649.18	1867.99	\N	2026-04-03 14:20:30.887	2026-04-03 14:20:56.698
48	2	2026-03-30	15333.82	2075.75	\N	2026-04-03 15:30:10.127	2026-04-03 15:30:10.127
49	4	2026-04-02	6016.45	1391.73	\N	2026-04-03 18:09:13.047	2026-04-03 18:12:09.996
51	6	2026-04-03	15590.19	0.00	\N	2026-04-04 10:01:31.18	2026-04-04 10:11:57.153
27	3	2026-04-01	6828.59	1087.23	\N	2026-04-02 17:55:48.898	2026-04-04 12:41:27.808
39	3	2026-04-02	10010.02	1364.89	\N	2026-04-03 13:03:58.975	2026-04-04 12:41:52.365
56	3	2026-04-03	11446.64	1782.86	\N	2026-04-04 12:15:48.806	2026-04-04 12:42:05.954
60	2	2026-04-03	18138.40	2422.40	\N	2026-04-04 13:48:22.189	2026-04-04 13:49:27.938
62	4	2026-04-04	8952.32	0.00	\N	2026-04-05 09:03:46.814	2026-04-05 09:03:46.814
63	3	2026-04-04	11253.35	1508.94	\N	2026-04-05 11:29:29.916	2026-04-05 11:39:03.885
68	5	2026-04-03	8924.30	1389.04	\N	2026-04-05 13:50:28.221	2026-04-05 13:50:28.221
69	11	2026-04-05	7158.06	0.00	\N	2026-04-06 08:03:07.916	2026-04-06 08:03:07.916
70	4	2026-04-05	9449.39	1376.59	\N	2026-04-06 09:24:38.158	2026-04-06 09:24:38.158
71	6	2026-04-05	10451.59	1441.51	Houve mais mb que dinheiro .	2026-04-06 09:26:53.128	2026-04-06 09:26:53.128
72	6	2026-04-01	8203.10	1122.48	\N	2026-04-06 09:48:24.742	2026-04-06 09:48:24.742
73	4	2026-04-01	5222.03	0.00	\N	2026-04-06 11:18:39.98	2026-04-06 11:18:39.98
31	4	2026-04-03	6016.45	0.00	\N	2026-04-03 10:09:48.805	2026-04-06 11:41:19.083
77	11	2026-03-31	5929.08	0.00	\N	2026-04-06 15:02:21.993	2026-04-06 15:02:21.993
78	11	2026-04-01	6059.09	0.00	\N	2026-04-06 15:07:05.242	2026-04-06 15:07:05.242
25	11	2026-04-02	7833.75	0.00	\N	2026-04-02 10:53:15.088	2026-04-06 15:13:33.672
80	11	2026-04-03	6572.32	0.00	\N	2026-04-06 15:18:21.915	2026-04-06 15:18:21.915
54	11	2026-04-04	7536.28	0.00	\N	2026-04-04 10:09:48.828	2026-04-06 15:25:48.065
76	5	2026-04-04	9268.46	2098.20	\N	2026-04-06 12:49:24.596	2026-04-06 15:28:45.316
\.


--
-- Data for Name: fecho_financeiro_item; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.fecho_financeiro_item (id, "fecID", "templateId", label, valor, "criadoEm", "atualizadoEm", conta_no_deposito) FROM stdin;
1	1	1	Multibanco	0.00	2026-02-28 22:55:07.364	2026-02-28 22:55:07.364	f
2	1	2	Chamadores	0.00	2026-02-28 22:55:07.364	2026-02-28 22:55:07.364	f
8	2	\N	Multibanco	2844.13	2026-02-28 23:00:08.114	2026-02-28 23:00:08.114	f
9	2	\N	Chamador	87.00	2026-02-28 23:00:08.114	2026-02-28 23:00:08.114	f
10	2	\N	Gorjeta	342.01	2026-02-28 23:00:08.114	2026-02-28 23:00:08.114	f
11	2	\N	Faturas	307.04	2026-02-28 23:00:08.114	2026-02-28 23:00:08.114	f
12	2	\N	Dinheiro	392.51	2026-02-28 23:00:08.114	2026-02-28 23:00:08.114	f
23	7	1	Multibanco	4052.84	2026-03-10 10:28:14.762	2026-03-10 10:28:14.762	f
24	7	2	Chamadores	159.00	2026-03-10 10:28:14.762	2026-03-10 10:28:14.762	f
25	7	7	12,5%	526.99	2026-03-10 10:28:14.762	2026-03-10 10:28:14.762	f
26	7	8	Despesas	80.77	2026-03-10 10:28:14.762	2026-03-10 10:28:14.762	f
27	7	9	Sobra	10.89	2026-03-10 10:28:14.762	2026-03-10 10:28:14.762	f
43	10	7	Gorjetas Percentuais	714.96	2026-03-10 14:51:14.472	2026-03-10 14:51:14.472	f
44	10	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	33.17	2026-03-10 14:51:14.472	2026-03-10 14:51:14.472	f
45	10	2	Chamadores	0.00	2026-03-10 14:51:14.472	2026-03-10 14:51:14.472	f
46	10	1	Multibanco	0.00	2026-03-10 14:51:14.472	2026-03-10 14:51:14.472	f
47	10	9	Sobra	0.00	2026-03-10 14:51:14.472	2026-03-10 14:51:14.472	f
48	14	7	Gorjetas	490.90	2026-03-14 11:06:30.562	2026-03-14 11:06:30.562	f
49	14	2	Chamadores	122.00	2026-03-14 11:06:30.562	2026-03-14 11:06:30.562	f
50	14	\N	Despesas	356.24	2026-03-14 11:06:30.562	2026-03-14 11:06:30.562	f
51	14	1	Multibanco	3948.86	2026-03-14 11:06:30.562	2026-03-14 11:06:30.562	f
52	14	9	Sobra	133.00	2026-03-14 11:06:30.562	2026-03-14 11:06:30.562	f
53	15	1	Multibanco	3689.53	2026-03-14 11:22:32.499	2026-03-14 11:22:32.499	f
54	15	2	Chamadores	116.00	2026-03-14 11:22:32.499	2026-03-14 11:22:32.499	f
55	15	7	Gorjetas	496.75	2026-03-14 11:22:32.499	2026-03-14 11:22:32.499	f
56	15	8	Despesas	160.17	2026-03-14 11:22:32.499	2026-03-14 11:22:32.499	f
57	15	9	Sobra	66.50	2026-03-14 11:22:32.499	2026-03-14 11:22:32.499	f
58	16	1	Multibanco	3419.99	2026-03-14 11:29:20.221	2026-03-14 11:29:20.221	f
59	16	2	Chamadores	122.00	2026-03-14 11:29:20.221	2026-03-14 11:29:20.221	f
60	16	7	Gorjetas Percentuais	392.93	2026-03-14 11:29:20.221	2026-03-14 11:29:20.221	f
61	16	8	Despesas	285.67	2026-03-14 11:29:20.221	2026-03-14 11:29:20.221	f
62	16	9	Sobra	45.00	2026-03-14 11:29:20.221	2026-03-14 11:29:20.221	f
63	17	1	Multibanco	3890.49	2026-03-14 11:34:16.166	2026-03-14 11:34:16.166	f
64	17	2	Chamadores	147.00	2026-03-14 11:34:16.166	2026-03-14 11:34:16.166	f
65	17	7	Gorjetas Percentuais	531.77	2026-03-14 11:34:16.166	2026-03-14 11:34:16.166	f
66	17	8	Despesas	269.03	2026-03-14 11:34:16.166	2026-03-14 11:34:16.166	f
67	17	9	Sobra	100.10	2026-03-14 11:34:16.166	2026-03-14 11:34:16.166	f
68	18	1	Multibanco	3485.94	2026-03-14 11:39:02.977	2026-03-14 11:39:02.977	f
69	18	2	Chamadores	121.00	2026-03-14 11:39:02.977	2026-03-14 11:39:02.977	f
70	18	7	Gorjetas Percentuais	526.73	2026-03-14 11:39:02.977	2026-03-14 11:39:02.977	f
71	18	8	Despesas	555.91	2026-03-14 11:39:02.977	2026-03-14 11:39:02.977	f
72	18	9	Sobra	258.50	2026-03-14 11:39:02.977	2026-03-14 11:39:02.977	f
478	54	24	Multibanco	5772.36	2026-04-06 15:25:48.073	2026-04-06 15:25:48.073	f
479	54	25	Chamador	177.00	2026-04-06 15:25:48.073	2026-04-06 15:25:48.073	t
480	54	26	12,5%	749.27	2026-04-06 15:25:48.073	2026-04-06 15:25:48.073	t
481	54	27	Despesas	62.32	2026-04-06 15:25:48.073	2026-04-06 15:25:48.073	f
482	54	29	MB Tips	0.00	2026-04-06 15:25:48.073	2026-04-06 15:25:48.073	t
78	20	1	Multibanco	4712.37	2026-03-14 12:54:08.978	2026-03-14 12:54:08.978	f
79	20	2	Chamadores	143.00	2026-03-14 12:54:08.978	2026-03-14 12:54:08.978	f
80	20	7	Gorjetas Percentuais	619.32	2026-03-14 12:54:08.978	2026-03-14 12:54:08.978	f
81	20	8	Despesas	123.20	2026-03-14 12:54:08.978	2026-03-14 12:54:08.978	f
82	20	9	Sobra	5.00	2026-03-14 12:54:08.978	2026-03-14 12:54:08.978	f
83	21	1	Multibanco	3191.21	2026-03-14 13:14:41.168	2026-03-14 13:14:41.168	f
84	21	2	Chamadores	146.00	2026-03-14 13:14:41.168	2026-03-14 13:14:41.168	f
85	21	7	Gorjetas Percentuais	496.04	2026-03-14 13:14:41.168	2026-03-14 13:14:41.168	f
86	21	8	Despesas	89.21	2026-03-14 13:14:41.168	2026-03-14 13:14:41.168	f
87	21	9	Sobra	764.00	2026-03-14 13:14:41.168	2026-03-14 13:14:41.168	f
88	22	1	Multibanco	5345.79	2026-03-14 13:21:02.522	2026-03-14 13:21:02.522	f
89	22	2	Chamadores	229.00	2026-03-14 13:21:02.522	2026-03-14 13:21:02.522	f
90	22	7	Gorjetas Percentuais	811.45	2026-03-14 13:21:02.522	2026-03-14 13:21:02.522	f
91	22	8	Despesas	94.74	2026-03-14 13:21:02.522	2026-03-14 13:21:02.522	f
92	22	9	Sobra	815.70	2026-03-14 13:21:02.522	2026-03-14 13:21:02.522	f
93	23	1	Multibanco	4905.02	2026-03-14 14:14:15.477	2026-03-14 14:14:15.477	f
94	23	2	Chamadores	178.00	2026-03-14 14:14:15.477	2026-03-14 14:14:15.477	f
95	23	7	Gorjetas Percentuais	731.67	2026-03-14 14:14:15.477	2026-03-14 14:14:15.477	f
96	23	8	Despesas	33.89	2026-03-14 14:14:15.477	2026-03-14 14:14:15.477	f
97	23	9	Sobra	1023.81	2026-03-14 14:14:15.477	2026-03-14 14:14:15.477	f
98	19	1	Multibanco	7529.51	2026-03-14 14:29:29.019	2026-03-14 14:29:29.019	f
99	19	2	Chamadores	262.00	2026-03-14 14:29:29.019	2026-03-14 14:29:29.019	f
100	19	7	Gorjetas Percentuais	954.83	2026-03-14 14:29:29.019	2026-03-14 14:29:29.019	f
101	19	8	Despesas	0.00	2026-03-14 14:29:29.019	2026-03-14 14:29:29.019	f
102	19	9	Sobra	0.00	2026-03-14 14:29:29.019	2026-03-14 14:29:29.019	f
483	54	30	Sobra	775.00	2026-04-06 15:25:48.073	2026-04-06 15:25:48.073	t
484	76	\N	Gorjeta Percentual (Distribuída)	979.36	2026-04-06 15:28:45.346	2026-04-06 15:28:45.346	t
485	76	\N	Pagamento Chamadores (fora Gorjeta Percentual + Diretas)	200.00	2026-04-06 15:28:45.346	2026-04-06 15:28:45.346	t
486	76	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	79.37	2026-04-06 15:28:45.346	2026-04-06 15:28:45.346	t
487	76	\N	Multibanco	6926.14	2026-04-06 15:28:45.346	2026-04-06 15:28:45.346	f
488	76	40	DESPESA	290.00	2026-04-06 15:28:45.346	2026-04-06 15:28:45.346	f
489	76	41	SOBRA	839.47	2026-04-06 15:28:45.346	2026-04-06 15:28:45.346	t
305	51	14	Baixa hotel	5.00	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	f
306	51	15	Tobook	756.00	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	f
307	51	22	MB TIPS	59.70	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	t
308	51	23	SOBRA	105.65	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	t
309	51	\N	Feriados	1325.00	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	f
310	51	10	Multibanco	10615.97	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	f
311	51	11	Chamador	473.00	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	t
126	26	10	Multibanco	8478.55	2026-04-03 09:35:48.675	2026-04-03 09:35:48.675	f
127	26	11	Chamador	245.00	2026-04-03 09:35:48.675	2026-04-03 09:35:48.675	t
128	26	12	Gorjeta	997.54	2026-04-03 09:35:48.675	2026-04-03 09:35:48.675	t
129	26	13	Despesas	0.00	2026-04-03 09:35:48.675	2026-04-03 09:35:48.675	f
130	26	14	Hotel	0.00	2026-04-03 09:35:48.675	2026-04-03 09:35:48.675	f
131	26	15	Tobook	228.00	2026-04-03 09:35:48.675	2026-04-03 09:35:48.675	f
132	26	22	MB TIPS	32.86	2026-04-03 09:35:48.675	2026-04-03 09:35:48.675	t
133	26	23	SOBRA	0.00	2026-04-03 09:35:48.675	2026-04-03 09:35:48.675	t
312	51	12	Gorjeta	1602.71	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	t
313	51	13	Despesas	739.35	2026-04-04 10:11:57.166	2026-04-04 10:11:57.166	f
164	30	10	Multibanco	6885.32	2026-04-03 10:35:41.461	2026-04-03 10:35:41.461	f
165	30	11	Chamador	288.00	2026-04-03 10:35:41.461	2026-04-03 10:35:41.461	t
166	30	12	Gorjeta	1084.74	2026-04-03 10:35:41.461	2026-04-03 10:35:41.461	t
167	30	13	Despesas	906.72	2026-04-03 10:35:41.461	2026-04-03 10:35:41.461	f
168	30	14	Ordenados	751.66	2026-04-03 10:35:41.461	2026-04-03 10:35:41.461	f
169	30	15	Tobook	324.00	2026-04-03 10:35:41.461	2026-04-03 10:35:41.461	f
170	30	22	MB TIPS	65.49	2026-04-03 10:35:41.461	2026-04-03 10:35:41.461	t
171	30	23	SOBRA	95.00	2026-04-03 10:35:41.461	2026-04-03 10:35:41.461	t
172	35	24	Multibanco	4561.48	2026-04-03 11:23:24.299	2026-04-03 11:23:24.299	f
173	35	25	Chamador	145.00	2026-04-03 11:23:24.299	2026-04-03 11:23:24.299	t
174	35	26	12,5%	549.78	2026-04-03 11:23:24.299	2026-04-03 11:23:24.299	t
175	35	27	Despesas	69.35	2026-04-03 11:23:24.299	2026-04-03 11:23:24.299	f
176	35	29	MB Tips	61.02	2026-04-03 11:23:24.299	2026-04-03 11:23:24.299	t
177	35	30	Sobra	48.00	2026-04-03 11:23:24.299	2026-04-03 11:23:24.299	t
178	36	33	Multibanco	6958.80	2026-04-03 12:25:17.549	2026-04-03 12:25:17.549	f
179	36	34	Chamador	266.00	2026-04-03 12:25:17.549	2026-04-03 12:25:17.549	t
180	36	35	12.5%	887.84	2026-04-03 12:25:17.549	2026-04-03 12:25:17.549	t
181	36	36	Despesas	46.98	2026-04-03 12:25:17.549	2026-04-03 12:25:17.549	f
182	36	38	Mb Tips	51.61	2026-04-03 12:25:17.549	2026-04-03 12:25:17.549	t
183	36	39	Sobra	33.00	2026-04-03 12:25:17.549	2026-04-03 12:25:17.549	t
184	37	\N	Gorjeta Percentual (Distribuída)	929.71	2026-04-03 12:46:25.434	2026-04-03 12:46:25.434	t
185	37	34	Chamador	266.00	2026-04-03 12:46:25.434	2026-04-03 12:46:25.434	t
186	37	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	91.05	2026-04-03 12:46:25.434	2026-04-03 12:46:25.434	t
187	37	33	Multibanco	7057.26	2026-04-03 12:46:25.434	2026-04-03 12:46:25.434	f
188	37	39	Sobra	9.52	2026-04-03 12:46:25.434	2026-04-03 12:46:25.434	t
189	37	\N	Despesa	124.87	2026-04-03 12:46:25.434	2026-04-03 12:46:25.434	f
202	40	\N	Gorjeta Percentual (Distribuída)	1091.13	2026-04-03 13:49:50.138	2026-04-03 13:49:50.138	t
203	40	\N	Pagamento Chamadores (fora Gorjeta Percentual + Diretas)	143.00	2026-04-03 13:49:50.138	2026-04-03 13:49:50.138	t
204	40	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	27.81	2026-04-03 13:49:50.138	2026-04-03 13:49:50.138	t
205	40	40	DESPESA	1000.00	2026-04-03 13:49:50.138	2026-04-03 13:49:50.138	f
206	40	41	SOBRA	173.35	2026-04-03 13:49:50.138	2026-04-03 13:49:50.138	t
207	40	\N	MULTIBANCO	7682.54	2026-04-03 13:49:50.138	2026-04-03 13:49:50.138	f
226	41	40	DESPESA	4.13	2026-04-03 13:57:36.681	2026-04-03 13:57:36.681	f
227	41	41	SOBRA	68.98	2026-04-03 13:57:36.681	2026-04-03 13:57:36.681	t
228	41	\N	MULTBANCO	7436.59	2026-04-03 13:57:36.681	2026-04-03 13:57:36.681	f
229	41	\N	CHAMADOR	176.00	2026-04-03 13:57:36.681	2026-04-03 13:57:36.681	t
230	41	\N	12.5%	887.22	2026-04-03 13:57:36.681	2026-04-03 13:57:36.681	t
231	41	\N	MB TIPS	37.53	2026-04-03 13:57:36.681	2026-04-03 13:57:36.681	t
232	45	\N	Gorjeta Percentual (Distribuída)	960.42	2026-04-03 14:11:48.935	2026-04-03 14:11:48.935	t
233	45	\N	Pagamento Chamadores (fora Gorjeta Percentual + Diretas)	270.00	2026-04-03 14:11:48.935	2026-04-03 14:11:48.935	t
234	45	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	74.50	2026-04-03 14:11:48.935	2026-04-03 14:11:48.935	t
235	45	\N	Multibanco	6629.75	2026-04-03 14:11:48.935	2026-04-03 14:11:48.935	f
236	45	40	DESPESA	371.60	2026-04-03 14:11:48.935	2026-04-03 14:11:48.935	f
237	45	41	SOBRA	651.85	2026-04-03 14:11:48.935	2026-04-03 14:11:48.935	t
244	46	\N	Gorjeta Percentual (Distribuída)	1006.58	2026-04-03 14:20:56.705	2026-04-03 14:20:56.705	t
245	46	\N	Pagamento Chamadores (fora Gorjeta Percentual + Diretas)	282.00	2026-04-03 14:20:56.705	2026-04-03 14:20:56.705	t
246	46	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	35.37	2026-04-03 14:20:56.705	2026-04-03 14:20:56.705	t
247	46	\N	Multibanco	7067.63	2026-04-03 14:20:56.705	2026-04-03 14:20:56.705	f
248	46	40	DESPESA	713.56	2026-04-03 14:20:56.705	2026-04-03 14:20:56.705	f
249	46	41	SOBRA	544.04	2026-04-03 14:20:56.705	2026-04-03 14:20:56.705	t
250	48	\N	Gorjeta Percentual (Distribuída)	1627.11	2026-04-03 15:30:10.133	2026-04-03 15:30:10.133	t
251	48	17	Chamador	391.00	2026-04-03 15:30:10.133	2026-04-03 15:30:10.133	t
252	48	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	45.84	2026-04-03 15:30:10.133	2026-04-03 15:30:10.133	t
253	48	16	Multibanco	12486.11	2026-04-03 15:30:10.133	2026-04-03 15:30:10.133	f
254	48	21	Sobra	11.80	2026-04-03 15:30:10.133	2026-04-03 15:30:10.133	t
255	48	\N	DESPESA	771.96	2026-04-03 15:30:10.133	2026-04-03 15:30:10.133	f
264	49	\N	Gorjeta Percentual (Distribuída)	622.67	2026-04-03 18:12:10.002	2026-04-03 18:12:10.002	t
265	49	2	Chamadores	222.00	2026-04-03 18:12:10.002	2026-04-03 18:12:10.002	t
266	49	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	28.40	2026-04-03 18:12:10.002	2026-04-03 18:12:10.002	t
267	49	\N	Outros Pagamentos (fora Gorjeta Percentual + Diretas)	3.24	2026-04-03 18:12:10.002	2026-04-03 18:12:10.002	t
268	49	1	Multibanco	4494.72	2026-04-03 18:12:10.002	2026-04-03 18:12:10.002	f
269	49	7	12.5%	0.00	2026-04-03 18:12:10.002	2026-04-03 18:12:10.002	f
270	49	31	MB tips	130.00	2026-04-03 18:12:10.002	2026-04-03 18:12:10.002	f
271	49	32	Sobra	515.42	2026-04-03 18:12:10.002	2026-04-03 18:12:10.002	t
320	27	\N	Gorjeta Percentual (Distribuída)	757.35	2026-04-04 12:41:27.815	2026-04-04 12:41:27.815	t
321	27	34	Chamador	221.00	2026-04-04 12:41:27.815	2026-04-04 12:41:27.815	t
322	27	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	80.91	2026-04-04 12:41:27.815	2026-04-04 12:41:27.815	t
323	27	33	Multibanco	5691.12	2026-04-04 12:41:27.815	2026-04-04 12:41:27.815	f
324	27	\N	DESPESAS	50.24	2026-04-04 12:41:27.815	2026-04-04 12:41:27.815	f
325	27	\N	SOBRA	27.97	2026-04-04 12:41:27.815	2026-04-04 12:41:27.815	t
326	39	\N	Gorjeta Percentual (Distribuída)	1062.17	2026-04-04 12:41:52.375	2026-04-04 12:41:52.375	t
327	39	34	Chamador	256.00	2026-04-04 12:41:52.375	2026-04-04 12:41:52.375	t
328	39	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	45.20	2026-04-04 12:41:52.375	2026-04-04 12:41:52.375	t
329	39	33	Multibanco	7613.44	2026-04-04 12:41:52.375	2026-04-04 12:41:52.375	f
330	39	35	DESPESAS	1031.69	2026-04-04 12:41:52.375	2026-04-04 12:41:52.375	f
331	39	39	Sobra	1.52	2026-04-04 12:41:52.375	2026-04-04 12:41:52.375	t
332	56	\N	Gorjeta Percentual (Distribuída)	1268.28	2026-04-04 12:42:05.961	2026-04-04 12:42:05.961	t
333	56	34	Chamador	379.00	2026-04-04 12:42:05.961	2026-04-04 12:42:05.961	t
334	56	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	130.40	2026-04-04 12:42:05.961	2026-04-04 12:42:05.961	t
335	56	33	Multibanco	9163.90	2026-04-04 12:42:05.961	2026-04-04 12:42:05.961	f
336	56	35	Despesas	499.88	2026-04-04 12:42:05.961	2026-04-04 12:42:05.961	f
337	56	39	Sobra	5.18	2026-04-04 12:42:05.961	2026-04-04 12:42:05.961	t
344	60	\N	Gorjeta Percentual (Distribuída)	1880.94	2026-04-04 13:49:27.945	2026-04-04 13:49:27.945	t
345	60	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	38.30	2026-04-04 13:49:27.945	2026-04-04 13:49:27.945	t
346	60	16	Multibanco	13199.90	2026-04-04 13:49:27.945	2026-04-04 13:49:27.945	f
347	60	17	Chamador	484.00	2026-04-04 13:49:27.945	2026-04-04 13:49:27.945	t
348	60	21	Sobra	19.16	2026-04-04 13:49:27.945	2026-04-04 13:49:27.945	t
349	60	\N	Despesas	2516.10	2026-04-04 13:49:27.945	2026-04-04 13:49:27.945	f
350	62	1	Multibanco	6122.92	2026-04-05 09:03:46.841	2026-04-05 09:03:46.841	f
351	62	2	Chamadores	273.00	2026-04-05 09:03:46.841	2026-04-05 09:03:46.841	t
352	62	7	12.5%	955.44	2026-04-05 09:03:46.841	2026-04-05 09:03:46.841	t
353	62	8	Despesas	545.32	2026-04-05 09:03:46.841	2026-04-05 09:03:46.841	f
354	62	31	MB tips	52.62	2026-04-05 09:03:46.841	2026-04-05 09:03:46.841	f
355	62	32	Sobra	1055.64	2026-04-05 09:03:46.841	2026-04-05 09:03:46.841	t
380	63	\N	Gorjeta Percentual (Distribuída)	1202.48	2026-04-05 11:39:03.891	2026-04-05 11:39:03.891	t
381	63	34	Chamador	290.00	2026-04-05 11:39:03.891	2026-04-05 11:39:03.891	t
382	63	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	11.34	2026-04-05 11:39:03.891	2026-04-05 11:39:03.891	t
383	63	33	Multibanco	8804.41	2026-04-05 11:39:03.891	2026-04-05 11:39:03.891	f
384	63	35	Despesa	940.00	2026-04-05 11:39:03.891	2026-04-05 11:39:03.891	f
385	63	39	Sobra	5.12	2026-04-05 11:39:03.891	2026-04-05 11:39:03.891	t
386	68	\N	Gorjeta Percentual (Distribuída)	876.90	2026-04-05 13:50:28.248	2026-04-05 13:50:28.248	t
387	68	\N	Pagamento Chamadores (fora Gorjeta Percentual + Diretas)	257.00	2026-04-05 13:50:28.248	2026-04-05 13:50:28.248	t
388	68	\N	Pagamento Staff (fora Gorjeta Percentual + Diretas)	31.84	2026-04-05 13:50:28.248	2026-04-05 13:50:28.248	t
389	68	\N	Multibanco	6848.42	2026-04-05 13:50:28.248	2026-04-05 13:50:28.248	f
390	68	40	DESPESA	686.84	2026-04-05 13:50:28.248	2026-04-05 13:50:28.248	f
391	68	41	SOBRA	223.30	2026-04-05 13:50:28.248	2026-04-05 13:50:28.248	t
392	69	24	Multibanco	4985.74	2026-04-06 08:03:07.924	2026-04-06 08:03:07.924	f
393	69	25	Chamador	227.00	2026-04-06 08:03:07.924	2026-04-06 08:03:07.924	t
394	69	26	12,5%	737.23	2026-04-06 08:03:07.924	2026-04-06 08:03:07.924	t
395	69	27	Despesas	1161.85	2026-04-06 08:03:07.924	2026-04-06 08:03:07.924	f
396	69	29	MB Tips	23.12	2026-04-06 08:03:07.924	2026-04-06 08:03:07.924	t
397	69	30	Sobra	23.12	2026-04-06 08:03:07.924	2026-04-06 08:03:07.924	t
398	70	1	Multibanco	8105.48	2026-04-06 09:24:38.184	2026-04-06 09:24:38.184	f
399	70	2	Chamadores	286.00	2026-04-06 09:24:38.184	2026-04-06 09:24:38.184	t
400	70	7	12.5%	992.70	2026-04-06 09:24:38.184	2026-04-06 09:24:38.184	t
401	70	8	Despesas	11.69	2026-04-06 09:24:38.184	2026-04-06 09:24:38.184	f
402	70	31	MB tips	44.38	2026-04-06 09:24:38.184	2026-04-06 09:24:38.184	t
403	70	32	Sobra	53.51	2026-04-06 09:24:38.184	2026-04-06 09:24:38.184	t
404	71	10	Multibanco	8690.86	2026-04-06 09:26:53.136	2026-04-06 09:26:53.136	f
405	71	11	Chamador	311.00	2026-04-06 09:26:53.136	2026-04-06 09:26:53.136	t
406	71	12	Gorjeta	1049.44	2026-04-06 09:26:53.136	2026-04-06 09:26:53.136	t
407	71	13	Despesas	0.00	2026-04-06 09:26:53.136	2026-04-06 09:26:53.136	f
408	71	14	Hotel	30.00	2026-04-06 09:26:53.136	2026-04-06 09:26:53.136	f
409	71	15	Tobook	480.00	2026-04-06 09:26:53.136	2026-04-06 09:26:53.136	f
410	71	22	MB TIPS	81.07	2026-04-06 09:26:53.136	2026-04-06 09:26:53.136	t
411	71	23	SOBRA	0.00	2026-04-06 09:26:53.136	2026-04-06 09:26:53.136	f
412	72	10	Multibanco	5609.70	2026-04-06 09:48:24.749	2026-04-06 09:48:24.749	f
413	72	11	Chamador	236.00	2026-04-06 09:48:24.749	2026-04-06 09:48:24.749	t
414	72	12	Gorjeta	755.26	2026-04-06 09:48:24.749	2026-04-06 09:48:24.749	t
415	72	13	Despesas ordenado happy	570.00	2026-04-06 09:48:24.749	2026-04-06 09:48:24.749	f
416	72	14	Mesa Felipe	109.01	2026-04-06 09:48:24.749	2026-04-06 09:48:24.749	f
417	72	15	Tobook	816.00	2026-04-06 09:48:24.749	2026-04-06 09:48:24.749	f
418	72	22	MB TIPS	89.50	2026-04-06 09:48:24.749	2026-04-06 09:48:24.749	t
419	72	23	SOBRA	41.72	2026-04-06 09:48:24.749	2026-04-06 09:48:24.749	t
420	73	1	Multibanco	3913.26	2026-04-06 11:18:39.986	2026-04-06 11:18:39.986	f
421	73	2	Chamadores	161.00	2026-04-06 11:18:39.986	2026-04-06 11:18:39.986	t
422	73	7	12.5%	554.80	2026-04-06 11:18:39.986	2026-04-06 11:18:39.986	t
423	73	8	Despesas	531.07	2026-04-06 11:18:39.986	2026-04-06 11:18:39.986	f
424	73	31	MB tips	36.37	2026-04-06 11:18:39.986	2026-04-06 11:18:39.986	t
425	73	32	Sobra	62.00	2026-04-06 11:18:39.986	2026-04-06 11:18:39.986	t
432	31	1	Multibanco	7442.50	2026-04-06 11:41:19.09	2026-04-06 11:41:19.09	f
433	31	2	Chamadores	335.00	2026-04-06 11:41:19.09	2026-04-06 11:41:19.09	t
434	31	7	12.5%	1003.25	2026-04-06 11:41:19.09	2026-04-06 11:41:19.09	t
435	31	8	Despesas	317.53	2026-04-06 11:41:19.09	2026-04-06 11:41:19.09	f
436	31	31	MB tips	97.87	2026-04-06 11:41:19.09	2026-04-06 11:41:19.09	t
437	31	32	Sobra	191.03	2026-04-06 11:41:19.09	2026-04-06 11:41:19.09	t
444	77	24	Multibanco	4370.60	2026-04-06 15:02:21.999	2026-04-06 15:02:21.999	f
445	77	25	Chamador	156.00	2026-04-06 15:02:21.999	2026-04-06 15:02:21.999	t
446	77	26	12,5%	634.18	2026-04-06 15:02:21.999	2026-04-06 15:02:21.999	t
447	77	27	Despesas	543.96	2026-04-06 15:02:21.999	2026-04-06 15:02:21.999	f
448	77	29	MB Tips	0.00	2026-04-06 15:02:21.999	2026-04-06 15:02:21.999	t
449	77	30	Sobra	224.34	2026-04-06 15:02:21.999	2026-04-06 15:02:21.999	t
450	78	24	Multibanco	4698.16	2026-04-06 15:07:05.247	2026-04-06 15:07:05.247	f
451	78	25	Chamador	175.00	2026-04-06 15:07:05.247	2026-04-06 15:07:05.247	t
452	78	26	12,5%	618.93	2026-04-06 15:07:05.247	2026-04-06 15:07:05.247	t
453	78	27	Despesas	510.00	2026-04-06 15:07:05.247	2026-04-06 15:07:05.247	f
454	78	29	MB Tips	0.00	2026-04-06 15:07:05.247	2026-04-06 15:07:05.247	t
455	78	30	Sobra	57.00	2026-04-06 15:07:05.247	2026-04-06 15:07:05.247	t
456	25	\N	MB	5456.14	2026-04-06 15:13:33.679	2026-04-06 15:13:33.679	f
457	25	\N	Chamador	211.00	2026-04-06 15:13:33.679	2026-04-06 15:13:33.679	t
458	25	\N	Gorjeta 12,5%	860.29	2026-04-06 15:13:33.679	2026-04-06 15:13:33.679	t
459	25	\N	Despesa	677.34	2026-04-06 15:13:33.679	2026-04-06 15:13:33.679	f
460	25	\N	Sobra	628.98	2026-04-06 15:13:33.679	2026-04-06 15:13:33.679	t
461	80	24	Multibanco	4916.79	2026-04-06 15:18:21.923	2026-04-06 15:18:21.923	f
462	80	25	Chamador	164.00	2026-04-06 15:18:21.923	2026-04-06 15:18:21.923	t
463	80	26	12,5%	700.84	2026-04-06 15:18:21.923	2026-04-06 15:18:21.923	t
464	80	27	Despesas	309.03	2026-04-06 15:18:21.923	2026-04-06 15:18:21.923	f
465	80	30	Sobra	478.66	2026-04-06 15:18:21.923	2026-04-06 15:18:21.923	t
\.


--
-- Data for Name: fecho_financeiro_template; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.fecho_financeiro_template (id, "restID", label, ordem, ativo, "criadoEm", "atualizadoEm") FROM stdin;
1	4	Multibanco	0	t	2026-02-28 22:54:41.019	2026-02-28 22:54:41.019
2	4	Chamadores	0	t	2026-02-28 22:54:55.461	2026-02-28 22:54:55.461
4	1	Chamador	0	t	2026-02-28 22:56:35.159	2026-02-28 22:56:35.159
5	1	Faturas	0	t	2026-02-28 22:56:42.011	2026-02-28 22:56:42.011
6	1	Dinheiro	0	t	2026-02-28 22:56:48.626	2026-02-28 22:56:48.626
3	1	Multibanco	0	t	2026-02-28 22:56:30.313	2026-02-28 22:56:59.458
8	4	Despesas	0	t	2026-03-10 10:23:42.059	2026-03-10 10:23:42.059
10	6	Multibanco	0	t	2026-04-02 12:55:30.189	2026-04-02 12:55:30.189
11	6	Chamador	0	t	2026-04-02 12:56:04.456	2026-04-02 12:56:04.456
12	6	Gorjeta	0	t	2026-04-02 12:56:22.056	2026-04-02 12:56:22.056
13	6	Despesas	0	t	2026-04-02 12:56:36.086	2026-04-02 12:56:36.086
14	6	Hotel	0	t	2026-04-02 12:56:50.593	2026-04-02 12:56:50.593
15	6	Tobook	0	t	2026-04-02 12:57:03.947	2026-04-02 12:57:03.947
16	2	Multibanco	0	t	2026-04-02 13:31:24.019	2026-04-02 13:31:24.019
17	2	Chamador	0	t	2026-04-02 13:31:37.933	2026-04-02 13:31:37.933
18	2	12.5%	0	t	2026-04-02 13:31:46.94	2026-04-02 13:31:46.94
19	2	Despesas	0	t	2026-04-02 13:31:59.16	2026-04-02 13:31:59.16
20	2	MB tips	0	t	2026-04-02 13:34:49.801	2026-04-02 13:34:49.801
21	2	Sobra	0	t	2026-04-02 13:34:56.656	2026-04-02 13:34:56.656
22	6	MB TIPS	0	t	2026-04-02 13:56:06.27	2026-04-02 13:56:06.27
23	6	SOBRA	0	t	2026-04-02 13:56:31.32	2026-04-02 13:56:31.32
24	11	Multibanco	0	t	2026-04-02 14:14:56.562	2026-04-02 14:14:56.562
25	11	Chamador	0	t	2026-04-02 14:15:04.487	2026-04-02 14:15:04.487
26	11	12,5%	0	t	2026-04-02 14:15:15.687	2026-04-02 14:15:15.687
27	11	Despesas	0	t	2026-04-02 14:15:26.484	2026-04-02 14:15:26.484
28	11	MB tips	0	f	2026-04-02 14:15:40.021	2026-04-02 14:16:33.798
29	11	MB Tips	0	t	2026-04-02 14:16:44.508	2026-04-02 14:16:44.508
30	11	Sobra	0	t	2026-04-02 14:16:51.65	2026-04-02 14:16:51.65
9	4	Sobra	0	f	2026-03-10 10:23:57.391	2026-04-02 15:19:42.458
31	4	MB tips	0	t	2026-04-02 15:19:49.45	2026-04-02 15:19:49.45
32	4	Sobra	0	t	2026-04-02 15:19:56.416	2026-04-02 15:19:56.416
7	4	12.5%	0	t	2026-03-10 10:23:05.442	2026-04-02 15:32:57.324
33	3	Multibanco	0	t	2026-04-02 17:40:59.063	2026-04-02 17:40:59.063
34	3	Chamador	0	t	2026-04-02 17:41:04.723	2026-04-02 17:41:04.723
35	3	12.5%	0	t	2026-04-02 17:41:11.939	2026-04-02 17:41:11.939
36	3	Despesas	0	t	2026-04-02 17:41:21.695	2026-04-02 17:41:21.695
37	3	Sobra	0	f	2026-04-02 17:41:43.942	2026-04-02 17:42:12.372
38	3	Mb Tips	0	f	2026-04-02 17:43:19.008	2026-04-03 12:43:39.995
39	3	Sobra	0	t	2026-04-02 17:43:30.214	2026-04-03 12:45:05.547
40	5	DESPESA	0	t	2026-04-03 13:42:07.228	2026-04-03 13:42:07.228
41	5	SOBRA	0	t	2026-04-03 13:42:18.546	2026-04-03 13:42:18.546
\.


--
-- Data for Name: funcionario_presenca_diaria; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.funcionario_presenca_diaria (id, "restID", data, "funcID", presente, "criadoEm", "atualizadoEm") FROM stdin;
4245	5	2026-04-04	340	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4246	5	2026-04-04	339	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4247	5	2026-04-04	338	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4248	5	2026-04-04	337	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4249	5	2026-04-04	336	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4250	5	2026-04-04	296	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4251	5	2026-04-04	294	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4252	5	2026-04-04	293	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4253	5	2026-04-04	291	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4254	5	2026-04-04	290	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4255	5	2026-04-04	288	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4256	5	2026-04-04	287	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4257	5	2026-04-04	286	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4258	5	2026-04-04	285	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4259	5	2026-04-04	284	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4260	5	2026-04-04	283	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4261	5	2026-04-04	282	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4262	5	2026-04-04	281	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4263	5	2026-04-04	278	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4264	5	2026-04-04	277	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4265	5	2026-04-04	276	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4266	5	2026-04-04	275	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4267	5	2026-04-04	274	t	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4268	5	2026-04-04	186	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4269	5	2026-04-04	118	f	2026-04-06 15:28:47.784	2026-04-06 15:28:47.784
4270	5	2026-04-03	340	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4271	5	2026-04-03	339	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4272	5	2026-04-03	338	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4273	5	2026-04-03	337	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4274	5	2026-04-03	336	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4275	5	2026-04-03	296	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
91	4	2026-03-09	77	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
92	4	2026-03-09	76	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
93	4	2026-03-09	75	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
94	4	2026-03-09	74	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
95	4	2026-03-09	73	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
96	4	2026-03-09	72	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
97	4	2026-03-09	71	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
98	4	2026-03-09	70	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
99	4	2026-03-09	69	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
100	4	2026-03-09	68	t	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
101	4	2026-03-09	67	t	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
102	4	2026-03-09	66	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
103	4	2026-03-09	65	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
104	4	2026-03-09	64	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
105	4	2026-03-09	63	t	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
106	4	2026-03-09	62	t	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
107	4	2026-03-09	61	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
108	4	2026-03-09	60	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
109	4	2026-03-09	59	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
110	4	2026-03-09	58	t	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
111	4	2026-03-09	57	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
112	4	2026-03-09	56	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
113	4	2026-03-09	55	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
114	4	2026-03-09	54	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
115	4	2026-03-09	53	t	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
116	4	2026-03-09	44	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
117	4	2026-03-09	43	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
118	4	2026-03-09	38	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
119	4	2026-03-09	27	t	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
120	4	2026-03-09	26	t	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
121	4	2026-03-09	21	f	2026-03-10 10:45:23.129	2026-03-10 10:45:23.129
277	4	2026-03-02	77	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
278	4	2026-03-02	76	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
279	4	2026-03-02	75	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
280	4	2026-03-02	74	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
281	4	2026-03-02	73	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
282	4	2026-03-02	72	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
283	4	2026-03-02	71	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
284	4	2026-03-02	70	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
285	4	2026-03-02	69	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
286	4	2026-03-02	68	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
287	4	2026-03-02	67	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
288	4	2026-03-02	66	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
289	4	2026-03-02	65	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
290	4	2026-03-02	64	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
291	4	2026-03-02	63	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
292	4	2026-03-02	62	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
293	4	2026-03-02	61	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
294	4	2026-03-02	60	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
295	4	2026-03-02	59	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
296	4	2026-03-02	58	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
297	4	2026-03-02	57	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
298	4	2026-03-02	56	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
299	4	2026-03-02	55	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
300	4	2026-03-02	54	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
301	4	2026-03-02	53	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
302	4	2026-03-02	44	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
303	4	2026-03-02	43	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
304	4	2026-03-02	38	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
305	4	2026-03-02	27	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
306	4	2026-03-02	26	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
307	4	2026-03-02	21	f	2026-03-14 11:09:53.518	2026-03-14 11:09:53.518
308	4	2026-03-03	77	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
309	4	2026-03-03	76	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
310	4	2026-03-03	75	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
311	4	2026-03-03	74	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
312	4	2026-03-03	73	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
313	4	2026-03-03	72	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
314	4	2026-03-03	71	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
315	4	2026-03-03	70	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
316	4	2026-03-03	69	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
317	4	2026-03-03	68	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
318	4	2026-03-03	67	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
319	4	2026-03-03	66	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
320	4	2026-03-03	65	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
321	4	2026-03-03	64	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
322	4	2026-03-03	63	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
323	4	2026-03-03	62	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
324	4	2026-03-03	61	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
325	4	2026-03-03	60	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
326	4	2026-03-03	59	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
327	4	2026-03-03	58	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
328	4	2026-03-03	57	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
329	4	2026-03-03	56	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
330	4	2026-03-03	55	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
331	4	2026-03-03	54	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
332	4	2026-03-03	53	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
333	4	2026-03-03	44	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
334	4	2026-03-03	43	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
335	4	2026-03-03	38	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
336	4	2026-03-03	27	f	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
337	4	2026-03-03	26	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
338	4	2026-03-03	21	t	2026-03-14 11:22:46.459	2026-03-14 11:22:46.459
339	4	2026-03-04	77	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
340	4	2026-03-04	76	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
341	4	2026-03-04	75	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
342	4	2026-03-04	74	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
343	4	2026-03-04	73	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
344	4	2026-03-04	72	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
345	4	2026-03-04	71	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
346	4	2026-03-04	70	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
347	4	2026-03-04	69	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
348	4	2026-03-04	68	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
349	4	2026-03-04	67	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
350	4	2026-03-04	66	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
351	4	2026-03-04	65	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
352	4	2026-03-04	64	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
353	4	2026-03-04	63	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
354	4	2026-03-04	62	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
355	4	2026-03-04	61	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
356	4	2026-03-04	60	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
357	4	2026-03-04	59	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
358	4	2026-03-04	58	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
359	4	2026-03-04	57	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
360	4	2026-03-04	56	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
361	4	2026-03-04	55	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
362	4	2026-03-04	54	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
363	4	2026-03-04	53	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
364	4	2026-03-04	44	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
365	4	2026-03-04	43	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
366	4	2026-03-04	38	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
367	4	2026-03-04	27	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
368	4	2026-03-04	26	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
369	4	2026-03-04	21	f	2026-03-14 11:29:24.466	2026-03-14 11:29:24.466
370	4	2026-03-05	77	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
371	4	2026-03-05	76	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
372	4	2026-03-05	75	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
373	4	2026-03-05	74	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
374	4	2026-03-05	73	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
375	4	2026-03-05	72	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
376	4	2026-03-05	71	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
377	4	2026-03-05	70	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
378	4	2026-03-05	69	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
379	4	2026-03-05	68	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
380	4	2026-03-05	67	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
381	4	2026-03-05	66	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
382	4	2026-03-05	65	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
383	4	2026-03-05	64	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
384	4	2026-03-05	63	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
385	4	2026-03-05	62	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
386	4	2026-03-05	61	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
387	4	2026-03-05	60	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
388	4	2026-03-05	59	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
389	4	2026-03-05	58	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
390	4	2026-03-05	57	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
391	4	2026-03-05	56	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
392	4	2026-03-05	55	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
393	4	2026-03-05	54	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
394	4	2026-03-05	53	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
395	4	2026-03-05	44	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
396	4	2026-03-05	43	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
397	4	2026-03-05	38	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
398	4	2026-03-05	27	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
399	4	2026-03-05	26	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
400	4	2026-03-05	21	f	2026-03-14 11:34:20.434	2026-03-14 11:34:20.434
769	4	2026-03-10	77	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
770	4	2026-03-10	76	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
771	4	2026-03-10	75	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
772	4	2026-03-10	74	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
773	4	2026-03-10	73	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
774	4	2026-03-10	72	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
775	4	2026-03-10	71	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
776	4	2026-03-10	70	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
777	4	2026-03-10	69	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
778	4	2026-03-10	68	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
779	4	2026-03-10	67	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
780	4	2026-03-10	66	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
781	4	2026-03-10	65	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
782	4	2026-03-10	64	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
783	4	2026-03-10	63	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
784	4	2026-03-10	62	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
785	4	2026-03-10	61	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
786	4	2026-03-10	60	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
787	4	2026-03-10	59	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
788	4	2026-03-10	58	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
789	4	2026-03-10	57	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
790	4	2026-03-10	56	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
791	4	2026-03-10	55	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
792	4	2026-03-10	54	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
793	4	2026-03-10	53	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
794	4	2026-03-10	44	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
795	4	2026-03-10	43	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
796	4	2026-03-10	38	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
797	4	2026-03-10	26	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
798	4	2026-03-10	21	f	2026-03-14 17:16:07.472	2026-03-14 17:16:07.472
4276	5	2026-04-03	294	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
432	4	2026-03-06	77	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
433	4	2026-03-06	76	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
434	4	2026-03-06	75	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
435	4	2026-03-06	74	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
436	4	2026-03-06	73	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
437	4	2026-03-06	72	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
438	4	2026-03-06	71	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
439	4	2026-03-06	70	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
440	4	2026-03-06	69	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
441	4	2026-03-06	68	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
442	4	2026-03-06	67	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
443	4	2026-03-06	66	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
444	4	2026-03-06	65	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
445	4	2026-03-06	64	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
446	4	2026-03-06	63	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
447	4	2026-03-06	62	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
448	4	2026-03-06	61	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
449	4	2026-03-06	60	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
450	4	2026-03-06	59	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
451	4	2026-03-06	58	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
452	4	2026-03-06	57	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
453	4	2026-03-06	56	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
454	4	2026-03-06	55	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
455	4	2026-03-06	54	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
456	4	2026-03-06	53	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
457	4	2026-03-06	44	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
458	4	2026-03-06	43	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
459	4	2026-03-06	38	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
460	4	2026-03-06	27	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
461	4	2026-03-06	26	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
462	4	2026-03-06	21	f	2026-03-14 11:43:53.384	2026-03-14 11:43:53.384
4277	5	2026-04-03	293	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4278	5	2026-04-03	291	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4279	5	2026-04-03	290	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4280	5	2026-04-03	288	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4281	5	2026-04-03	287	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4282	5	2026-04-03	286	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4283	5	2026-04-03	285	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4284	5	2026-04-03	284	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4285	5	2026-04-03	283	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4286	5	2026-04-03	282	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4287	5	2026-04-03	281	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4288	5	2026-04-03	278	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4289	5	2026-04-03	277	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4290	5	2026-04-03	276	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4291	5	2026-04-03	275	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4292	5	2026-04-03	274	t	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4293	5	2026-04-03	186	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
4294	5	2026-04-03	118	f	2026-04-06 15:36:26.858	2026-04-06 15:36:26.858
3906	5	2026-04-05	275	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3907	5	2026-04-05	274	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3908	5	2026-04-05	186	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3909	5	2026-04-05	118	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
4005	6	2026-03-30	129	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4006	6	2026-03-30	128	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
525	4	2026-03-11	77	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
526	4	2026-03-11	76	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
527	4	2026-03-11	75	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
528	4	2026-03-11	74	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
529	4	2026-03-11	73	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
530	4	2026-03-11	72	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
531	4	2026-03-11	71	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
532	4	2026-03-11	70	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
533	4	2026-03-11	69	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
534	4	2026-03-11	68	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
535	4	2026-03-11	67	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
536	4	2026-03-11	66	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
537	4	2026-03-11	65	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
538	4	2026-03-11	64	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
539	4	2026-03-11	63	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
540	4	2026-03-11	62	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
541	4	2026-03-11	61	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
542	4	2026-03-11	60	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
543	4	2026-03-11	59	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
544	4	2026-03-11	58	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
545	4	2026-03-11	57	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
546	4	2026-03-11	56	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
547	4	2026-03-11	55	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
548	4	2026-03-11	54	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
549	4	2026-03-11	53	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
550	4	2026-03-11	44	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
551	4	2026-03-11	43	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
552	4	2026-03-11	38	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
553	4	2026-03-11	27	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
554	4	2026-03-11	26	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
555	4	2026-03-11	21	f	2026-03-14 13:14:54.427	2026-03-14 13:14:54.427
556	4	2026-03-12	77	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
557	4	2026-03-12	76	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
558	4	2026-03-12	75	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
559	4	2026-03-12	74	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
560	4	2026-03-12	73	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
561	4	2026-03-12	72	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
562	4	2026-03-12	71	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
563	4	2026-03-12	70	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
564	4	2026-03-12	69	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
565	4	2026-03-12	68	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
566	4	2026-03-12	67	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
567	4	2026-03-12	66	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
568	4	2026-03-12	65	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
569	4	2026-03-12	64	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
570	4	2026-03-12	63	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
571	4	2026-03-12	62	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
572	4	2026-03-12	61	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
573	4	2026-03-12	60	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
574	4	2026-03-12	59	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
4007	6	2026-03-30	126	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4008	6	2026-03-30	116	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4009	6	2026-03-30	85	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
575	4	2026-03-12	58	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
576	4	2026-03-12	57	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
577	4	2026-03-12	56	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
578	4	2026-03-12	55	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
579	4	2026-03-12	54	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
580	4	2026-03-12	53	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
581	4	2026-03-12	44	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
582	4	2026-03-12	43	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
583	4	2026-03-12	38	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
584	4	2026-03-12	27	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
585	4	2026-03-12	26	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
586	4	2026-03-12	21	f	2026-03-14 13:21:07.415	2026-03-14 13:21:07.415
587	4	2026-03-13	77	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
588	4	2026-03-13	76	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
589	4	2026-03-13	75	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
590	4	2026-03-13	74	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
591	4	2026-03-13	73	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
592	4	2026-03-13	72	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
593	4	2026-03-13	71	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
594	4	2026-03-13	70	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
595	4	2026-03-13	69	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
596	4	2026-03-13	68	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
597	4	2026-03-13	67	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
598	4	2026-03-13	66	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
599	4	2026-03-13	65	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
600	4	2026-03-13	64	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
601	4	2026-03-13	63	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
602	4	2026-03-13	62	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
603	4	2026-03-13	61	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
604	4	2026-03-13	60	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
605	4	2026-03-13	59	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
606	4	2026-03-13	58	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
607	4	2026-03-13	57	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
608	4	2026-03-13	56	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
609	4	2026-03-13	55	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
610	4	2026-03-13	54	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
611	4	2026-03-13	53	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
612	4	2026-03-13	44	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
613	4	2026-03-13	43	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
614	4	2026-03-13	38	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
615	4	2026-03-13	27	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
616	4	2026-03-13	26	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
617	4	2026-03-13	21	f	2026-03-14 14:14:21.474	2026-03-14 14:14:21.474
618	4	2026-03-07	77	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
619	4	2026-03-07	76	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
620	4	2026-03-07	75	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
621	4	2026-03-07	74	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
622	4	2026-03-07	73	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
623	4	2026-03-07	72	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
624	4	2026-03-07	71	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
625	4	2026-03-07	70	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
626	4	2026-03-07	69	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
627	4	2026-03-07	68	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
628	4	2026-03-07	67	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
629	4	2026-03-07	66	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
630	4	2026-03-07	65	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
631	4	2026-03-07	64	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
632	4	2026-03-07	63	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
633	4	2026-03-07	62	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
634	4	2026-03-07	61	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
635	4	2026-03-07	60	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
636	4	2026-03-07	59	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
637	4	2026-03-07	58	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
638	4	2026-03-07	57	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
639	4	2026-03-07	56	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
640	4	2026-03-07	55	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
641	4	2026-03-07	54	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
642	4	2026-03-07	53	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
643	4	2026-03-07	44	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
644	4	2026-03-07	43	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
645	4	2026-03-07	38	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
646	4	2026-03-07	27	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
647	4	2026-03-07	26	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
648	4	2026-03-07	21	f	2026-03-14 14:29:32.886	2026-03-14 14:29:32.886
649	4	2026-03-08	77	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
650	4	2026-03-08	76	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
651	4	2026-03-08	75	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
652	4	2026-03-08	74	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
653	4	2026-03-08	73	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
654	4	2026-03-08	72	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
655	4	2026-03-08	71	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
656	4	2026-03-08	70	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
657	4	2026-03-08	69	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
658	4	2026-03-08	68	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
659	4	2026-03-08	67	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
660	4	2026-03-08	66	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
661	4	2026-03-08	65	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
662	4	2026-03-08	64	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
663	4	2026-03-08	63	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
664	4	2026-03-08	62	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
665	4	2026-03-08	61	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
666	4	2026-03-08	60	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
667	4	2026-03-08	59	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
668	4	2026-03-08	58	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
669	4	2026-03-08	57	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
670	4	2026-03-08	56	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
671	4	2026-03-08	55	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
672	4	2026-03-08	54	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
673	4	2026-03-08	53	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
674	4	2026-03-08	44	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
675	4	2026-03-08	43	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
676	4	2026-03-08	38	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
677	4	2026-03-08	26	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
678	4	2026-03-08	21	f	2026-03-14 16:44:54.625	2026-03-14 16:44:54.625
1614	5	2026-03-30	340	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1615	5	2026-03-30	339	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1616	5	2026-03-30	338	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1617	5	2026-03-30	337	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1618	5	2026-03-30	336	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1619	5	2026-03-30	296	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1620	5	2026-03-30	294	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1621	5	2026-03-30	293	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1622	5	2026-03-30	291	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1623	5	2026-03-30	290	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1308	11	2026-03-30	328	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1309	11	2026-03-30	327	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1310	11	2026-03-30	326	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1624	5	2026-03-30	288	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1625	5	2026-03-30	287	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1626	5	2026-03-30	286	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1627	5	2026-03-30	285	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1628	5	2026-03-30	284	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1629	5	2026-03-30	283	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1630	5	2026-03-30	282	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1631	5	2026-03-30	281	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1632	5	2026-03-30	278	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1633	5	2026-03-30	277	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1634	5	2026-03-30	276	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1311	11	2026-03-30	324	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1312	11	2026-03-30	320	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1313	11	2026-03-30	319	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1635	5	2026-03-30	275	f	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1636	5	2026-03-30	274	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1637	5	2026-03-30	186	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1638	5	2026-03-30	118	t	2026-04-03 13:49:53.102	2026-04-03 13:49:53.102
1689	5	2026-03-31	340	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1690	5	2026-03-31	339	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1691	5	2026-03-31	338	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1692	5	2026-03-31	337	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1693	5	2026-03-31	336	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1694	5	2026-03-31	296	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1695	5	2026-03-31	294	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1696	5	2026-03-31	293	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1697	5	2026-03-31	291	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1698	5	2026-03-31	290	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1699	5	2026-03-31	288	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
3454	6	2026-04-05	344	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3455	6	2026-04-05	321	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
1314	11	2026-03-30	269	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1315	11	2026-03-30	155	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1316	11	2026-03-30	115	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1317	11	2026-03-30	113	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1318	11	2026-03-30	112	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1319	11	2026-03-30	111	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1320	11	2026-03-30	109	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1321	11	2026-03-30	108	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1322	11	2026-03-30	107	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1323	11	2026-03-30	105	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1324	11	2026-03-30	95	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1325	11	2026-03-30	94	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1326	11	2026-03-30	93	f	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1327	11	2026-03-30	92	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1328	11	2026-03-30	90	t	2026-04-03 11:27:16.037	2026-04-03 11:27:16.037
1442	3	2026-03-31	168	t	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1443	3	2026-03-31	167	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1444	3	2026-03-31	166	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1445	3	2026-03-31	165	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1446	3	2026-03-31	164	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1447	3	2026-03-31	162	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1448	3	2026-03-31	122	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1449	3	2026-03-31	81	t	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1450	3	2026-03-31	80	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1451	3	2026-03-31	79	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
3456	6	2026-04-05	318	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3457	6	2026-04-05	317	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3458	6	2026-04-05	311	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3459	6	2026-04-05	273	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3460	6	2026-04-05	272	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3461	6	2026-04-05	161	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3462	6	2026-04-05	160	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3463	6	2026-04-05	159	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
2658	3	2026-04-03	162	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2659	3	2026-04-03	122	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2660	3	2026-04-03	81	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2661	3	2026-04-03	80	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2662	3	2026-04-03	79	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
1360	3	2026-03-30	334	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1361	3	2026-03-30	333	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1362	3	2026-03-30	331	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1363	3	2026-03-30	330	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1364	3	2026-03-30	329	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1365	3	2026-03-30	323	t	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1366	3	2026-03-30	322	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1367	3	2026-03-30	211	t	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1368	3	2026-03-30	193	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1369	3	2026-03-30	191	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1370	3	2026-03-30	178	t	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1371	3	2026-03-30	177	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1372	3	2026-03-30	176	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1373	3	2026-03-30	175	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1374	3	2026-03-30	174	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1375	3	2026-03-30	173	t	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1376	3	2026-03-30	172	t	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1377	3	2026-03-30	171	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1378	3	2026-03-30	170	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1379	3	2026-03-30	169	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1380	3	2026-03-30	168	t	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1381	3	2026-03-30	167	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1382	3	2026-03-30	166	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1383	3	2026-03-30	165	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1384	3	2026-03-30	164	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1385	3	2026-03-30	162	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1386	3	2026-03-30	122	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1387	3	2026-03-30	81	t	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1388	3	2026-03-30	80	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1389	3	2026-03-30	79	f	2026-04-03 12:25:22.363	2026-04-03 12:25:22.363
1422	3	2026-03-31	334	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1423	3	2026-03-31	333	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1424	3	2026-03-31	331	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1425	3	2026-03-31	330	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1426	3	2026-03-31	329	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1427	3	2026-03-31	323	t	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1428	3	2026-03-31	322	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1429	3	2026-03-31	211	t	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1430	3	2026-03-31	193	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1431	3	2026-03-31	191	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1432	3	2026-03-31	178	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1433	3	2026-03-31	177	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1434	3	2026-03-31	176	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1435	3	2026-03-31	175	t	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1436	3	2026-03-31	174	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1437	3	2026-03-31	173	t	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1438	3	2026-03-31	172	t	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1439	3	2026-03-31	171	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1440	3	2026-03-31	170	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1441	3	2026-03-31	169	f	2026-04-03 12:46:36.817	2026-04-03 12:46:36.817
1208	6	2026-04-02	321	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1209	6	2026-04-02	318	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1210	6	2026-04-02	317	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1211	6	2026-04-02	311	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1212	6	2026-04-02	273	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1213	6	2026-04-02	272	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1214	6	2026-04-02	161	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1215	6	2026-04-02	160	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1216	6	2026-04-02	159	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1217	6	2026-04-02	158	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1218	6	2026-04-02	157	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1219	6	2026-04-02	156	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1220	6	2026-04-02	153	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1221	6	2026-04-02	152	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1222	6	2026-04-02	151	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1223	6	2026-04-02	150	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1224	6	2026-04-02	149	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1225	6	2026-04-02	148	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1226	6	2026-04-02	147	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1227	6	2026-04-02	146	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1228	6	2026-04-02	145	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1229	6	2026-04-02	144	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1230	6	2026-04-02	143	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1231	6	2026-04-02	141	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1232	6	2026-04-02	140	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1233	6	2026-04-02	139	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1234	6	2026-04-02	138	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1235	6	2026-04-02	136	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1236	6	2026-04-02	135	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1237	6	2026-04-02	134	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1238	6	2026-04-02	133	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1239	6	2026-04-02	132	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1240	6	2026-04-02	131	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1241	6	2026-04-02	129	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1242	6	2026-04-02	128	t	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1243	6	2026-04-02	126	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1244	6	2026-04-02	116	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
1245	6	2026-04-02	85	f	2026-04-03 10:35:45.655	2026-04-03 10:35:45.655
3464	6	2026-04-05	158	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3465	6	2026-04-05	157	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3466	6	2026-04-05	156	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3467	6	2026-04-05	153	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3468	6	2026-04-05	152	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3469	6	2026-04-05	151	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3470	6	2026-04-05	150	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3471	6	2026-04-05	149	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3472	6	2026-04-05	148	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3473	6	2026-04-05	147	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3474	6	2026-04-05	146	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3475	6	2026-04-05	145	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3476	6	2026-04-05	144	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3477	6	2026-04-05	143	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3478	6	2026-04-05	141	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3479	6	2026-04-05	140	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
1700	5	2026-03-31	287	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1701	5	2026-03-31	286	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1702	5	2026-03-31	285	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1703	5	2026-03-31	284	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1704	5	2026-03-31	283	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1705	5	2026-03-31	282	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1706	5	2026-03-31	281	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1707	5	2026-03-31	278	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1708	5	2026-03-31	277	t	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1709	5	2026-03-31	276	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1710	5	2026-03-31	275	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1711	5	2026-03-31	274	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1712	5	2026-03-31	186	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1713	5	2026-03-31	118	f	2026-04-03 13:57:49.974	2026-04-03 13:57:49.974
1714	5	2026-04-01	340	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1715	5	2026-04-01	339	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1716	5	2026-04-01	338	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1717	5	2026-04-01	337	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1718	5	2026-04-01	336	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1719	5	2026-04-01	296	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1720	5	2026-04-01	294	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1721	5	2026-04-01	293	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1722	5	2026-04-01	291	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1723	5	2026-04-01	290	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1724	5	2026-04-01	288	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1725	5	2026-04-01	287	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1726	5	2026-04-01	286	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1727	5	2026-04-01	285	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1728	5	2026-04-01	284	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1729	5	2026-04-01	283	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1730	5	2026-04-01	282	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1731	5	2026-04-01	281	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1732	5	2026-04-01	278	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1733	5	2026-04-01	277	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1734	5	2026-04-01	276	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1735	5	2026-04-01	275	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1736	5	2026-04-01	274	t	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1737	5	2026-04-01	186	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
1738	5	2026-04-01	118	f	2026-04-03 14:11:52.137	2026-04-03 14:11:52.137
2456	6	2026-04-03	344	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2457	6	2026-04-03	321	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2458	6	2026-04-03	318	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2459	6	2026-04-03	317	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2460	6	2026-04-03	311	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2461	6	2026-04-03	273	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2462	6	2026-04-03	272	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2463	6	2026-04-03	161	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2464	6	2026-04-03	160	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2465	6	2026-04-03	159	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2466	6	2026-04-03	158	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2467	6	2026-04-03	157	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2468	6	2026-04-03	156	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2469	6	2026-04-03	153	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2470	6	2026-04-03	152	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2471	6	2026-04-03	151	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2472	6	2026-04-03	150	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2473	6	2026-04-03	149	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2474	6	2026-04-03	148	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2475	6	2026-04-03	147	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2476	6	2026-04-03	146	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2477	6	2026-04-03	145	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2478	6	2026-04-03	144	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2479	6	2026-04-03	143	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2480	6	2026-04-03	141	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2481	6	2026-04-03	140	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2482	6	2026-04-03	139	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2483	6	2026-04-03	138	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2484	6	2026-04-03	136	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2485	6	2026-04-03	135	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2486	6	2026-04-03	134	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2487	6	2026-04-03	133	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2488	6	2026-04-03	132	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2489	6	2026-04-03	131	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2490	6	2026-04-03	129	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2491	6	2026-04-03	128	t	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2492	6	2026-04-03	126	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2493	6	2026-04-03	116	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2494	6	2026-04-03	85	f	2026-04-04 10:12:04.101	2026-04-04 10:12:04.101
2259	2	2026-03-30	343	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2260	2	2026-03-30	342	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2261	2	2026-03-30	341	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2262	2	2026-03-30	315	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2263	2	2026-03-30	314	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2264	2	2026-03-30	310	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2265	2	2026-03-30	292	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2266	2	2026-03-30	280	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2267	2	2026-03-30	222	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2268	2	2026-03-30	221	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2269	2	2026-03-30	220	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2270	2	2026-03-30	219	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2271	2	2026-03-30	218	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2272	2	2026-03-30	217	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2273	2	2026-03-30	216	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2274	2	2026-03-30	215	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2275	2	2026-03-30	214	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2276	2	2026-03-30	213	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2277	2	2026-03-30	212	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2278	2	2026-03-30	210	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2279	2	2026-03-30	209	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2280	2	2026-03-30	208	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2281	2	2026-03-30	207	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2282	2	2026-03-30	206	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2283	2	2026-03-30	205	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2284	2	2026-03-30	204	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2285	2	2026-03-30	203	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2286	2	2026-03-30	202	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2287	2	2026-03-30	201	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2288	2	2026-03-30	200	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2289	2	2026-03-30	199	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2290	2	2026-03-30	197	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2291	2	2026-03-30	196	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2292	2	2026-03-30	195	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2293	2	2026-03-30	194	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2294	2	2026-03-30	192	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2295	2	2026-03-30	190	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2296	2	2026-03-30	189	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2297	2	2026-03-30	188	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2298	2	2026-03-30	187	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2299	2	2026-03-30	185	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2300	2	2026-03-30	184	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2301	2	2026-03-30	183	t	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2302	2	2026-03-30	182	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2303	2	2026-03-30	181	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2304	2	2026-03-30	180	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2305	2	2026-03-30	179	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
2306	2	2026-03-30	123	f	2026-04-03 15:32:02.418	2026-04-03 15:32:02.418
3910	11	2026-03-31	345	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3911	11	2026-03-31	328	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3912	11	2026-03-31	327	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3913	11	2026-03-31	326	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3914	11	2026-03-31	324	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3915	11	2026-03-31	320	f	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3916	11	2026-03-31	319	f	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3917	11	2026-03-31	269	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3918	11	2026-03-31	155	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3919	11	2026-03-31	115	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3920	11	2026-03-31	113	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3921	11	2026-03-31	112	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3922	11	2026-03-31	111	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3923	11	2026-03-31	109	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3924	11	2026-03-31	108	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3925	11	2026-03-31	107	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
1814	5	2026-04-02	340	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1815	5	2026-04-02	339	t	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1816	5	2026-04-02	338	t	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1817	5	2026-04-02	337	t	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1818	5	2026-04-02	336	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1819	5	2026-04-02	296	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1820	5	2026-04-02	294	t	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1821	5	2026-04-02	293	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1822	5	2026-04-02	291	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1823	5	2026-04-02	290	t	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1824	5	2026-04-02	288	t	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1825	5	2026-04-02	287	t	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1826	5	2026-04-02	286	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1827	5	2026-04-02	285	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1828	5	2026-04-02	284	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1829	5	2026-04-02	283	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1830	5	2026-04-02	282	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1831	5	2026-04-02	281	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1832	5	2026-04-02	278	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1833	5	2026-04-02	277	t	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1834	5	2026-04-02	276	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1835	5	2026-04-02	275	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1836	5	2026-04-02	274	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1837	5	2026-04-02	186	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
1838	5	2026-04-02	118	f	2026-04-03 14:21:29.754	2026-04-03 14:21:29.754
3926	11	2026-03-31	105	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3927	11	2026-03-31	95	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3928	11	2026-03-31	94	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3929	11	2026-03-31	93	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3930	11	2026-03-31	92	f	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3931	11	2026-03-31	90	t	2026-04-06 15:02:32.39	2026-04-06 15:02:32.39
3062	3	2026-04-04	335	t	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3063	3	2026-04-04	334	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3064	3	2026-04-04	333	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3065	3	2026-04-04	331	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
2307	4	2026-04-02	325	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2308	4	2026-04-02	316	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2309	4	2026-04-02	120	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2310	4	2026-04-02	77	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2311	4	2026-04-02	75	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2312	4	2026-04-02	74	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2313	4	2026-04-02	73	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2314	4	2026-04-02	72	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2315	4	2026-04-02	71	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2316	4	2026-04-02	70	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2317	4	2026-04-02	69	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2318	4	2026-04-02	68	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2319	4	2026-04-02	67	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2320	4	2026-04-02	66	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2321	4	2026-04-02	65	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2322	4	2026-04-02	64	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2323	4	2026-04-02	63	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2324	4	2026-04-02	62	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2325	4	2026-04-02	61	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2326	4	2026-04-02	60	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2327	4	2026-04-02	59	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2328	4	2026-04-02	58	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2329	4	2026-04-02	57	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2330	4	2026-04-02	56	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2331	4	2026-04-02	55	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2332	4	2026-04-02	54	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2333	4	2026-04-02	53	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2334	4	2026-04-02	44	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2335	4	2026-04-02	43	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2336	4	2026-04-02	38	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2337	4	2026-04-02	26	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2338	4	2026-04-02	21	f	2026-04-03 17:24:51.601	2026-04-03 17:24:51.601
2570	3	2026-04-01	335	t	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2571	3	2026-04-01	334	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2572	3	2026-04-01	333	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2573	3	2026-04-01	331	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2574	3	2026-04-01	330	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2575	3	2026-04-01	329	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2576	3	2026-04-01	323	t	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2577	3	2026-04-01	322	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2578	3	2026-04-01	211	t	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2579	3	2026-04-01	193	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2580	3	2026-04-01	191	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2581	3	2026-04-01	178	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2582	3	2026-04-01	177	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2583	3	2026-04-01	176	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2584	3	2026-04-01	175	t	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2585	3	2026-04-01	174	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2586	3	2026-04-01	173	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2587	3	2026-04-01	172	t	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2588	3	2026-04-01	171	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2589	3	2026-04-01	170	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2590	3	2026-04-01	169	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2591	3	2026-04-01	168	t	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2592	3	2026-04-01	167	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2593	3	2026-04-01	166	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2594	3	2026-04-01	165	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2595	3	2026-04-01	164	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2596	3	2026-04-01	162	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2597	3	2026-04-01	122	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2598	3	2026-04-01	81	t	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2599	3	2026-04-01	80	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2600	3	2026-04-01	79	f	2026-04-04 12:41:32.309	2026-04-04 12:41:32.309
2601	3	2026-04-02	335	t	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2602	3	2026-04-02	334	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2603	3	2026-04-02	333	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2604	3	2026-04-02	331	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2605	3	2026-04-02	330	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2606	3	2026-04-02	329	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2607	3	2026-04-02	323	t	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2608	3	2026-04-02	322	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2609	3	2026-04-02	211	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2610	3	2026-04-02	193	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2611	3	2026-04-02	191	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2612	3	2026-04-02	178	t	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2613	3	2026-04-02	177	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2614	3	2026-04-02	176	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2615	3	2026-04-02	175	t	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2616	3	2026-04-02	174	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2617	3	2026-04-02	173	t	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2618	3	2026-04-02	172	t	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2619	3	2026-04-02	171	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2620	3	2026-04-02	170	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2621	3	2026-04-02	169	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2622	3	2026-04-02	168	t	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2623	3	2026-04-02	167	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2624	3	2026-04-02	166	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2625	3	2026-04-02	165	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2626	3	2026-04-02	164	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2627	3	2026-04-02	162	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2628	3	2026-04-02	122	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2629	3	2026-04-02	81	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2630	3	2026-04-02	80	t	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2631	3	2026-04-02	79	f	2026-04-04 12:41:54.706	2026-04-04 12:41:54.706
2632	3	2026-04-03	335	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2633	3	2026-04-03	334	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2634	3	2026-04-03	333	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2635	3	2026-04-03	331	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2636	3	2026-04-03	330	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2637	3	2026-04-03	329	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2638	3	2026-04-03	323	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2639	3	2026-04-03	322	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2640	3	2026-04-03	211	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2641	3	2026-04-03	193	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2642	3	2026-04-03	191	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2643	3	2026-04-03	178	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2644	3	2026-04-03	177	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2645	3	2026-04-03	176	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2646	3	2026-04-03	175	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2647	3	2026-04-03	174	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2648	3	2026-04-03	173	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2649	3	2026-04-03	172	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2650	3	2026-04-03	171	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2651	3	2026-04-03	170	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2652	3	2026-04-03	169	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2653	3	2026-04-03	168	t	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2654	3	2026-04-03	167	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2655	3	2026-04-03	166	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2656	3	2026-04-03	165	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2657	3	2026-04-03	164	f	2026-04-04 12:42:08.452	2026-04-04 12:42:08.452
2951	2	2026-04-03	343	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2952	2	2026-04-03	342	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2953	2	2026-04-03	341	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2954	2	2026-04-03	315	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2955	2	2026-04-03	314	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2956	2	2026-04-03	310	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2957	2	2026-04-03	292	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2958	2	2026-04-03	280	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2959	2	2026-04-03	222	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2960	2	2026-04-03	221	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2961	2	2026-04-03	220	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2962	2	2026-04-03	219	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2963	2	2026-04-03	218	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2964	2	2026-04-03	217	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2965	2	2026-04-03	216	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2966	2	2026-04-03	215	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2967	2	2026-04-03	214	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2968	2	2026-04-03	213	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2969	2	2026-04-03	212	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2970	2	2026-04-03	210	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2971	2	2026-04-03	209	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2972	2	2026-04-03	208	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2973	2	2026-04-03	207	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2974	2	2026-04-03	206	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2975	2	2026-04-03	205	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2976	2	2026-04-03	204	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2977	2	2026-04-03	203	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2978	2	2026-04-03	202	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2979	2	2026-04-03	201	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2980	2	2026-04-03	200	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2981	2	2026-04-03	199	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2982	2	2026-04-03	197	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2983	2	2026-04-03	196	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2984	2	2026-04-03	195	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2985	2	2026-04-03	194	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2986	2	2026-04-03	192	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2987	2	2026-04-03	190	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2988	2	2026-04-03	189	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2989	2	2026-04-03	188	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2990	2	2026-04-03	187	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2991	2	2026-04-03	185	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2992	2	2026-04-03	184	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2993	2	2026-04-03	183	t	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2994	2	2026-04-03	182	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2995	2	2026-04-03	181	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2996	2	2026-04-03	180	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2997	2	2026-04-03	179	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
2998	2	2026-04-03	123	f	2026-04-04 13:49:32.549	2026-04-04 13:49:32.549
3480	6	2026-04-05	139	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3481	6	2026-04-05	138	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3482	6	2026-04-05	136	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3483	6	2026-04-05	135	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3484	6	2026-04-05	134	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3485	6	2026-04-05	133	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3486	6	2026-04-05	132	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3487	6	2026-04-05	131	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3488	6	2026-04-05	129	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3489	6	2026-04-05	128	t	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3490	6	2026-04-05	126	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3491	6	2026-04-05	116	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3492	6	2026-04-05	85	f	2026-04-06 09:26:58.529	2026-04-06 09:26:58.529
3526	6	2026-04-01	344	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3527	6	2026-04-01	321	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3528	6	2026-04-01	318	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3529	6	2026-04-01	317	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3530	6	2026-04-01	311	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3531	6	2026-04-01	273	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3532	6	2026-04-01	272	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3533	6	2026-04-01	161	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3534	6	2026-04-01	160	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3535	6	2026-04-01	159	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3536	6	2026-04-01	158	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3537	6	2026-04-01	157	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3538	6	2026-04-01	156	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3539	6	2026-04-01	153	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3540	6	2026-04-01	152	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3541	6	2026-04-01	151	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3542	6	2026-04-01	150	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3543	6	2026-04-01	149	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3544	6	2026-04-01	148	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3545	6	2026-04-01	147	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3546	6	2026-04-01	146	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3547	6	2026-04-01	145	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3548	6	2026-04-01	144	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3549	6	2026-04-01	143	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3550	6	2026-04-01	141	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3551	6	2026-04-01	140	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3552	6	2026-04-01	139	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3553	6	2026-04-01	138	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3554	6	2026-04-01	136	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3555	6	2026-04-01	135	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3556	6	2026-04-01	134	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3557	6	2026-04-01	133	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3558	6	2026-04-01	132	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3559	6	2026-04-01	131	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3560	6	2026-04-01	129	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3561	6	2026-04-01	128	t	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3562	6	2026-04-01	126	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3563	6	2026-04-01	116	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3564	6	2026-04-01	85	f	2026-04-06 09:48:36.499	2026-04-06 09:48:36.499
3598	4	2026-04-01	346	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3599	4	2026-04-01	325	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3600	4	2026-04-01	316	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3601	4	2026-04-01	120	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3602	4	2026-04-01	77	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3066	3	2026-04-04	330	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3067	3	2026-04-04	329	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3068	3	2026-04-04	323	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3069	3	2026-04-04	322	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3070	3	2026-04-04	211	t	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3071	3	2026-04-04	193	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3072	3	2026-04-04	191	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3073	3	2026-04-04	178	t	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3074	3	2026-04-04	177	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3075	3	2026-04-04	176	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3076	3	2026-04-04	175	t	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3077	3	2026-04-04	174	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3078	3	2026-04-04	173	t	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3079	3	2026-04-04	172	t	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3080	3	2026-04-04	171	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3081	3	2026-04-04	170	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3082	3	2026-04-04	169	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3083	3	2026-04-04	168	t	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3084	3	2026-04-04	167	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3085	3	2026-04-04	166	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3086	3	2026-04-04	165	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3087	3	2026-04-04	164	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3088	3	2026-04-04	162	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3089	3	2026-04-04	122	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3090	3	2026-04-04	81	t	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3091	3	2026-04-04	80	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3092	3	2026-04-04	79	f	2026-04-05 11:39:06.907	2026-04-05 11:39:06.907
3932	6	2026-04-04	344	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3933	6	2026-04-04	321	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3934	6	2026-04-04	318	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3935	6	2026-04-04	317	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3936	6	2026-04-04	311	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3937	6	2026-04-04	273	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3938	6	2026-04-04	272	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3939	6	2026-04-04	161	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3940	6	2026-04-04	160	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3941	6	2026-04-04	159	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3942	6	2026-04-04	158	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3943	6	2026-04-04	157	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3944	6	2026-04-04	156	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3945	6	2026-04-04	153	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3946	6	2026-04-04	152	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3947	6	2026-04-04	151	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3948	6	2026-04-04	150	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3949	6	2026-04-04	149	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3950	6	2026-04-04	148	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3951	6	2026-04-04	147	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3952	6	2026-04-04	146	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3953	6	2026-04-04	145	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3954	6	2026-04-04	144	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3955	6	2026-04-04	143	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3956	6	2026-04-04	141	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3957	6	2026-04-04	140	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3958	6	2026-04-04	139	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3959	6	2026-04-04	138	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3960	6	2026-04-04	136	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3399	11	2026-04-05	345	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3400	11	2026-04-05	328	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3401	11	2026-04-05	327	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3402	11	2026-04-05	326	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3403	11	2026-04-05	324	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3404	11	2026-04-05	320	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3405	11	2026-04-05	319	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3406	11	2026-04-05	269	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3407	11	2026-04-05	155	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3408	11	2026-04-05	115	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3409	11	2026-04-05	113	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3410	11	2026-04-05	112	f	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3411	11	2026-04-05	111	f	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3412	11	2026-04-05	109	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3413	11	2026-04-05	108	f	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3414	11	2026-04-05	107	f	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3415	11	2026-04-05	105	f	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3416	11	2026-04-05	95	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3417	11	2026-04-05	94	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3418	11	2026-04-05	93	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3419	11	2026-04-05	92	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3420	11	2026-04-05	90	t	2026-04-06 08:02:55.469	2026-04-06 08:02:55.469
3961	6	2026-04-04	135	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3962	6	2026-04-04	134	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3963	6	2026-04-04	133	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3964	6	2026-04-04	132	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3965	6	2026-04-04	131	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3966	6	2026-04-04	129	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3967	6	2026-04-04	128	t	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3968	6	2026-04-04	126	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3969	6	2026-04-04	116	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3970	6	2026-04-04	85	f	2026-04-06 15:06:34.498	2026-04-06 15:06:34.498
3971	6	2026-03-30	344	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3972	6	2026-03-30	321	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3973	6	2026-03-30	318	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3974	6	2026-03-30	317	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3975	6	2026-03-30	311	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3976	6	2026-03-30	273	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3977	6	2026-03-30	272	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3978	6	2026-03-30	161	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3979	6	2026-03-30	160	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3980	6	2026-03-30	159	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3981	6	2026-03-30	158	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3982	6	2026-03-30	157	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3983	6	2026-03-30	156	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3984	6	2026-03-30	153	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3985	6	2026-03-30	152	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3986	6	2026-03-30	151	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3987	6	2026-03-30	150	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3988	6	2026-03-30	149	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3989	6	2026-03-30	148	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3990	6	2026-03-30	147	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3991	6	2026-03-30	146	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3992	6	2026-03-30	145	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3993	6	2026-03-30	144	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3994	6	2026-03-30	143	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3995	6	2026-03-30	141	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3996	6	2026-03-30	140	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3997	6	2026-03-30	139	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3998	6	2026-03-30	138	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3999	6	2026-03-30	136	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4000	6	2026-03-30	135	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4001	6	2026-03-30	134	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4002	6	2026-03-30	133	t	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4003	6	2026-03-30	132	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
4004	6	2026-03-30	131	f	2026-04-06 15:07:11.673	2026-04-06 15:07:11.673
3603	4	2026-04-01	75	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3604	4	2026-04-01	74	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3605	4	2026-04-01	73	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3606	4	2026-04-01	72	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3607	4	2026-04-01	71	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3608	4	2026-04-01	70	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3609	4	2026-04-01	69	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3610	4	2026-04-01	68	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3611	4	2026-04-01	67	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3612	4	2026-04-01	66	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3613	4	2026-04-01	65	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3614	4	2026-04-01	64	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3615	4	2026-04-01	63	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3616	4	2026-04-01	62	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3617	4	2026-04-01	61	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3618	4	2026-04-01	60	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3619	4	2026-04-01	59	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3620	4	2026-04-01	58	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3621	4	2026-04-01	57	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3622	4	2026-04-01	56	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3623	4	2026-04-01	55	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3624	4	2026-04-01	54	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3625	4	2026-04-01	53	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3626	4	2026-04-01	44	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3627	4	2026-04-01	43	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3628	4	2026-04-01	38	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3629	4	2026-04-01	26	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3630	4	2026-04-01	21	f	2026-04-06 11:29:02.348	2026-04-06 11:29:02.348
3885	5	2026-04-05	340	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3886	5	2026-04-05	339	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3887	5	2026-04-05	338	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3888	5	2026-04-05	337	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3889	5	2026-04-05	336	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3890	5	2026-04-05	296	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3891	5	2026-04-05	294	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3892	5	2026-04-05	293	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3893	5	2026-04-05	291	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3894	5	2026-04-05	290	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3895	5	2026-04-05	288	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3896	5	2026-04-05	287	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3897	5	2026-04-05	286	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3898	5	2026-04-05	285	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3899	5	2026-04-05	284	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3900	5	2026-04-05	283	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3901	5	2026-04-05	282	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3902	5	2026-04-05	281	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3664	4	2026-04-03	346	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3665	4	2026-04-03	325	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3666	4	2026-04-03	316	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3667	4	2026-04-03	120	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3668	4	2026-04-03	77	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3669	4	2026-04-03	75	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3670	4	2026-04-03	74	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3671	4	2026-04-03	73	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3672	4	2026-04-03	72	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3673	4	2026-04-03	71	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3674	4	2026-04-03	70	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3675	4	2026-04-03	69	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3676	4	2026-04-03	68	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3677	4	2026-04-03	67	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3678	4	2026-04-03	66	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3679	4	2026-04-03	65	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3680	4	2026-04-03	64	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3681	4	2026-04-03	63	t	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3682	4	2026-04-03	62	t	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3683	4	2026-04-03	61	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3684	4	2026-04-03	60	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3685	4	2026-04-03	59	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3686	4	2026-04-03	58	t	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3687	4	2026-04-03	57	t	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3688	4	2026-04-03	56	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3689	4	2026-04-03	55	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3690	4	2026-04-03	54	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3691	4	2026-04-03	53	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3692	4	2026-04-03	44	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3693	4	2026-04-03	43	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3694	4	2026-04-03	38	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3695	4	2026-04-03	26	t	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3696	4	2026-04-03	21	f	2026-04-06 11:48:39.721	2026-04-06 11:48:39.721
3697	4	2026-04-04	346	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3698	4	2026-04-04	325	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3699	4	2026-04-04	316	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3700	4	2026-04-04	120	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3701	4	2026-04-04	77	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3702	4	2026-04-04	75	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3703	4	2026-04-04	74	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3704	4	2026-04-04	73	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3705	4	2026-04-04	72	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3706	4	2026-04-04	71	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3707	4	2026-04-04	70	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3708	4	2026-04-04	69	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3709	4	2026-04-04	68	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3710	4	2026-04-04	67	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3711	4	2026-04-04	66	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3712	4	2026-04-04	65	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3713	4	2026-04-04	64	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3714	4	2026-04-04	63	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3715	4	2026-04-04	62	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3716	4	2026-04-04	61	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3717	4	2026-04-04	60	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3718	4	2026-04-04	59	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3719	4	2026-04-04	58	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3720	4	2026-04-04	57	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3721	4	2026-04-04	56	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3722	4	2026-04-04	55	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3723	4	2026-04-04	54	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3724	4	2026-04-04	53	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3725	4	2026-04-04	44	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3726	4	2026-04-04	43	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3727	4	2026-04-04	38	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3728	4	2026-04-04	26	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3729	4	2026-04-04	21	f	2026-04-06 11:56:38.626	2026-04-06 11:56:38.626
3730	4	2026-04-05	346	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3731	4	2026-04-05	325	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3732	4	2026-04-05	316	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3733	4	2026-04-05	120	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3734	4	2026-04-05	77	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3735	4	2026-04-05	75	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3736	4	2026-04-05	74	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3737	4	2026-04-05	73	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3738	4	2026-04-05	72	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3739	4	2026-04-05	71	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3740	4	2026-04-05	70	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3741	4	2026-04-05	69	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3742	4	2026-04-05	68	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3743	4	2026-04-05	67	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3744	4	2026-04-05	66	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3745	4	2026-04-05	65	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3746	4	2026-04-05	64	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3747	4	2026-04-05	63	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3748	4	2026-04-05	62	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3749	4	2026-04-05	61	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3750	4	2026-04-05	60	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3751	4	2026-04-05	59	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3752	4	2026-04-05	58	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3753	4	2026-04-05	57	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3754	4	2026-04-05	56	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3755	4	2026-04-05	55	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3756	4	2026-04-05	54	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3757	4	2026-04-05	53	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3758	4	2026-04-05	44	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3759	4	2026-04-05	43	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3760	4	2026-04-05	38	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3761	4	2026-04-05	26	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3762	4	2026-04-05	21	f	2026-04-06 12:00:23.852	2026-04-06 12:00:23.852
3903	5	2026-04-05	278	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3904	5	2026-04-05	277	t	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
3905	5	2026-04-05	276	f	2026-04-06 13:36:46.422	2026-04-06 13:36:46.422
4049	11	2026-04-01	345	t	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4050	11	2026-04-01	328	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4051	11	2026-04-01	327	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4052	11	2026-04-01	326	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4053	11	2026-04-01	324	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4054	11	2026-04-01	320	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4055	11	2026-04-01	319	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4056	11	2026-04-01	269	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4057	11	2026-04-01	155	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4058	11	2026-04-01	115	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4059	11	2026-04-01	113	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4060	11	2026-04-01	112	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4061	11	2026-04-01	111	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4062	11	2026-04-01	109	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4063	11	2026-04-01	108	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4064	11	2026-04-01	107	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4065	11	2026-04-01	105	t	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4066	11	2026-04-01	95	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4067	11	2026-04-01	94	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4068	11	2026-04-01	93	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4069	11	2026-04-01	92	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4070	11	2026-04-01	90	f	2026-04-06 15:07:29.253	2026-04-06 15:07:29.253
4071	6	2026-03-31	344	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4072	6	2026-03-31	321	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4073	6	2026-03-31	318	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4074	6	2026-03-31	317	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4075	6	2026-03-31	311	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4076	6	2026-03-31	273	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4077	6	2026-03-31	272	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4078	6	2026-03-31	161	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4079	6	2026-03-31	160	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4080	6	2026-03-31	159	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4081	6	2026-03-31	158	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4082	6	2026-03-31	157	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4083	6	2026-03-31	156	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4084	6	2026-03-31	153	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4085	6	2026-03-31	152	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4086	6	2026-03-31	151	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4087	6	2026-03-31	150	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4088	6	2026-03-31	149	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4089	6	2026-03-31	148	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4090	6	2026-03-31	147	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4091	6	2026-03-31	146	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4092	6	2026-03-31	145	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4093	6	2026-03-31	144	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4094	6	2026-03-31	143	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4095	6	2026-03-31	141	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4096	6	2026-03-31	140	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4097	6	2026-03-31	139	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4098	6	2026-03-31	138	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4099	6	2026-03-31	136	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4100	6	2026-03-31	135	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4101	6	2026-03-31	134	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4102	6	2026-03-31	133	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4103	6	2026-03-31	132	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4104	6	2026-03-31	131	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4105	6	2026-03-31	129	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4106	6	2026-03-31	128	t	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4107	6	2026-03-31	126	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4108	6	2026-03-31	116	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4109	6	2026-03-31	85	f	2026-04-06 15:07:54.355	2026-04-06 15:07:54.355
4110	11	2026-04-02	345	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4111	11	2026-04-02	328	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4112	11	2026-04-02	327	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4113	11	2026-04-02	326	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4114	11	2026-04-02	324	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4115	11	2026-04-02	320	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4116	11	2026-04-02	319	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4117	11	2026-04-02	269	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4118	11	2026-04-02	155	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4119	11	2026-04-02	115	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4120	11	2026-04-02	113	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4121	11	2026-04-02	112	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4122	11	2026-04-02	111	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4123	11	2026-04-02	109	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4124	11	2026-04-02	108	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4125	11	2026-04-02	107	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4126	11	2026-04-02	105	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4127	11	2026-04-02	95	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4128	11	2026-04-02	94	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4129	11	2026-04-02	93	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4130	11	2026-04-02	92	t	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4131	11	2026-04-02	90	f	2026-04-06 15:13:47.704	2026-04-06 15:13:47.704
4154	11	2026-04-03	345	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4155	11	2026-04-03	328	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4156	11	2026-04-03	327	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4157	11	2026-04-03	326	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4158	11	2026-04-03	324	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4159	11	2026-04-03	320	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4160	11	2026-04-03	319	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4161	11	2026-04-03	269	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4162	11	2026-04-03	155	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4163	11	2026-04-03	115	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4164	11	2026-04-03	113	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4165	11	2026-04-03	112	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4166	11	2026-04-03	111	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4167	11	2026-04-03	109	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4168	11	2026-04-03	108	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4169	11	2026-04-03	107	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4170	11	2026-04-03	105	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4171	11	2026-04-03	95	f	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4172	11	2026-04-03	94	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4173	11	2026-04-03	93	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4174	11	2026-04-03	92	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4175	11	2026-04-03	90	t	2026-04-06 15:18:59.393	2026-04-06 15:18:59.393
4223	11	2026-04-04	345	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4224	11	2026-04-04	328	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4225	11	2026-04-04	327	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4226	11	2026-04-04	326	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4227	11	2026-04-04	324	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4228	11	2026-04-04	320	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4229	11	2026-04-04	319	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4230	11	2026-04-04	269	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4231	11	2026-04-04	155	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4232	11	2026-04-04	115	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4233	11	2026-04-04	113	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4234	11	2026-04-04	112	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4235	11	2026-04-04	111	f	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4236	11	2026-04-04	109	f	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4237	11	2026-04-04	108	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4238	11	2026-04-04	107	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4239	11	2026-04-04	105	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4240	11	2026-04-04	95	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4241	11	2026-04-04	94	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4242	11	2026-04-04	93	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4243	11	2026-04-04	92	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
4244	11	2026-04-04	90	t	2026-04-06 15:25:58.946	2026-04-06 15:25:58.946
\.


--
-- Data for Name: funcionario_restaurante; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.funcionario_restaurante (id, "funcID", "restID", funcao, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.funcionarios ("funcID", name, contacto, photo, funcao, ativo, "restID", "createdAt", "updatedAt", data_admissao, iban, salario) FROM stdin;
3	Atiki Ullah 	123456789	\N	staff	t	1	2026-01-26 19:05:28.258	2026-01-26 19:05:28.258	\N	\N	\N
5	Sabita Tamang Lama	123456789	\N	staff	t	1	2026-01-26 19:05:55.801	2026-01-26 19:05:55.801	\N	\N	\N
6	Md Mehedee Hasan	123456789	\N	staff	t	1	2026-01-26 19:06:14.234	2026-01-26 19:06:14.234	\N	\N	\N
7	Zahidur Rahman	123456789	\N	staff	t	1	2026-01-26 19:06:27.452	2026-01-26 19:06:27.452	\N	\N	\N
4	Dhana Maya Tamang	123456798	\N	staff	t	1	2026-01-26 19:05:40.191	2026-01-26 19:10:43.629	\N	\N	\N
14	Teste 	932156789	\N	staff	f	1	2026-01-26 19:14:24.189	2026-01-26 19:14:28.236	\N	\N	\N
53	Adrian Wallace da Silva Fernandes 		\N	chamador	t	4	2026-03-06 17:09:32.859	2026-03-06 17:09:32.859	\N	\N	\N
52	TesteSubGerente	123456789	\N	sub-gerente	f	4	2026-03-04 13:32:32.131	2026-03-06 17:09:39.039	\N	\N	\N
21	Andressa Pereira de Campos		\N	staff	t	4	2026-02-18 12:23:53.975	2026-03-06 17:10:13.568	\N	\N	\N
22	Diones 		\N	staff	f	4	2026-02-18 12:24:40.854	2026-03-06 17:10:26.065	\N	\N	\N
43	Amit Kahulal		\N	cozinha	t	4	2026-02-18 12:31:55.751	2026-03-06 17:16:42.371	\N	\N	\N
54	Ana Indira Tavares de Brito		\N	cozinha	t	4	2026-03-06 17:17:48.884	2026-03-06 17:17:48.884	\N	\N	\N
39	Ana 		\N	cozinha	f	4	2026-02-18 12:30:57.912	2026-03-06 17:21:18.211	\N	\N	\N
44	Ana Paula Francisca Ferreira		\N	cozinha	t	4	2026-02-18 12:32:06.455	2026-03-06 17:21:41.295	\N	\N	\N
38	Carlos Eduardo Santos Benicio 		\N	cozinha	t	4	2026-02-18 12:30:45.662	2026-03-06 17:22:30.134	\N	\N	\N
55	Jorge Luiz da Conceição 		\N	cozinha	t	4	2026-03-06 17:35:02.407	2026-03-06 17:35:02.407	\N	\N	\N
50	Ilaas 		\N	cozinha	f	4	2026-02-18 12:33:44.023	2026-03-06 17:37:00.843	\N	\N	\N
51	Prince		\N	cozinha	f	4	2026-02-18 12:33:54.745	2026-03-06 18:03:23.6	\N	\N	\N
49	Suman		\N	cozinha	f	4	2026-02-18 12:33:21.321	2026-03-06 18:05:14.528	\N	\N	\N
48	Sachin		\N	cozinha	f	4	2026-02-18 12:33:09.62	2026-03-06 18:05:18.78	\N	\N	\N
47	Rajinder		\N	cozinha	f	4	2026-02-18 12:32:53.951	2026-03-06 18:05:22.885	\N	\N	\N
45	Dhruv		\N	cozinha	f	4	2026-02-18 12:32:25.162	2026-03-06 18:05:27.342	\N	\N	\N
46	Satvinder		\N	cozinha	f	4	2026-02-18 12:32:35.651	2026-03-06 18:05:31.227	\N	\N	\N
42	Srijana 		\N	cozinha	f	4	2026-02-18 12:31:44.611	2026-03-06 18:05:35.412	\N	\N	\N
41	Sandhya 		\N	cozinha	f	4	2026-02-18 12:31:24.415	2026-03-06 18:05:39.651	\N	\N	\N
40	Nirma		\N	cozinha	f	4	2026-02-18 12:31:07.244	2026-03-06 18:05:44.396	\N	\N	\N
37	Marcelo		\N	chamador	f	4	2026-02-18 12:29:56.959	2026-03-06 18:05:49.149	\N	\N	\N
36	Adrian 		\N	chamador	f	4	2026-02-18 12:29:43.731	2026-03-06 18:05:53.505	\N	\N	\N
35	Douglas		\N	supervisor	f	4	2026-02-18 12:29:22.789	2026-03-06 18:05:57.554	\N	\N	\N
33	Thaís 		\N	staff	f	4	2026-02-18 12:28:36.171	2026-03-06 18:06:01.525	\N	\N	\N
34	Hallyson		\N	staff	f	4	2026-02-18 12:28:58.036	2026-03-06 18:06:06.68	\N	\N	\N
32	Pedro		\N	garcom	f	4	2026-02-18 12:28:17.345	2026-03-06 18:06:10.409	\N	\N	\N
56	DHRUV MALHOTRA		\N	cozinha	t	4	2026-03-07 14:00:00.042	2026-03-07 14:00:00.042	\N	\N	\N
57	Hallysson Marinho Barbosa 		\N	garcom	t	4	2026-03-07 14:01:11.66	2026-03-07 14:01:11.66	\N	\N	\N
26	Kazi Imitiuz		\N	garcom	t	4	2026-02-18 12:25:56.655	2026-03-07 14:02:14.527	\N	\N	\N
58	Kazi Siam ( SIAM)		\N	garcom	t	4	2026-03-07 14:03:00.216	2026-03-07 14:03:00.216	\N	\N	\N
60	Luciano Rei Monteiro		\N	cozinha	t	4	2026-03-07 14:04:15.858	2026-03-07 14:04:15.858	\N	\N	\N
62	MD Mojsmmel Hossain ( Faisal) 		\N	garcom	t	4	2026-03-07 14:08:52.224	2026-03-07 14:08:52.224	\N	\N	\N
63	MD Mostafizur Rahman (Rony)		\N	garcom	t	4	2026-03-07 14:09:52.883	2026-03-07 14:09:52.883	\N	\N	\N
30	Rony		\N	staff	f	4	2026-02-18 12:27:32.618	2026-03-07 14:10:04.108	\N	\N	\N
31	Siam		\N	staff	f	4	2026-02-18 12:27:55.09	2026-03-07 14:10:08.693	\N	\N	\N
29	Ridam		\N	staff	f	4	2026-02-18 12:27:16.981	2026-03-07 14:10:12.867	\N	\N	\N
28	renan		\N	staff	f	4	2026-02-18 12:26:55.033	2026-03-07 14:10:18.276	\N	\N	\N
25	João 		\N	staff	f	4	2026-02-18 12:25:43.563	2026-03-07 14:10:24.003	\N	\N	\N
24	Jessie 		\N	staff	f	4	2026-02-18 12:25:27.187	2026-03-07 14:10:29.06	\N	\N	\N
23	Faisal		\N	staff	f	4	2026-02-18 12:25:07.052	2026-03-07 14:10:33.968	\N	\N	\N
64	Nirma Bagale Baskota		\N	cozinha	t	4	2026-03-07 14:11:33.333	2026-03-07 14:11:33.333	\N	\N	\N
65	Pavitar Singh		\N	cozinha	t	4	2026-03-07 14:12:03.836	2026-03-07 14:12:03.836	\N	\N	\N
66	Rajinder Singh		\N	cozinha	t	4	2026-03-07 14:12:42.638	2026-03-07 14:12:42.638	\N	\N	\N
67	Renan Martins Silva		\N	garcom	t	4	2026-03-07 14:13:16.039	2026-03-07 14:13:16.039	\N	\N	\N
68	Ridan Rai		\N	garcom	t	4	2026-03-07 14:13:48.075	2026-03-07 14:13:48.075	\N	\N	\N
70	Sachin Regmi 		\N	cozinha	t	4	2026-03-07 14:15:03.289	2026-03-07 14:15:03.289	\N	\N	\N
71	Srijana Sharma Sapkota		\N	cozinha	t	4	2026-03-07 14:15:36.3	2026-03-07 14:15:36.3	\N	\N	\N
72	Suman Chhetri		\N	cozinha	t	4	2026-03-07 14:16:05.552	2026-03-07 14:16:05.552	\N	\N	\N
73	Kaur 		\N	cozinha	t	4	2026-03-07 14:16:23.152	2026-03-07 14:16:23.152	\N	\N	\N
61	Matheus Rodrigues da Silva		\N	gerente	t	4	2026-03-07 14:07:35.896	2026-03-07 14:07:35.896	\N	\N	\N
75	Rahatul Islan Radowan	\N	\N	cozinha	t	4	2026-03-09 11:14:58.111	2026-03-09 11:14:58.111	\N	\N	\N
69	Rilda Gessica Santos Meneses Morais		\N	chefe de turno	t	4	2026-03-07 14:14:23.093	2026-03-09 17:24:10.012	\N	\N	\N
59	Lucas de Oliveira Santos		\N	chefe de turno	t	4	2026-03-07 14:03:39.302	2026-03-10 10:20:43.157	\N	\N	\N
27	Lucas 10%		\N	staff	f	4	2026-02-18 12:26:09.159	2026-03-14 14:14:44.935	\N	\N	\N
20	t4		\N	cozinha	f	3	2026-02-10 17:03:55.368	2026-03-14 19:03:29.952	\N	\N	\N
19	teste 3		\N	garcom	f	3	2026-02-10 17:03:38.685	2026-03-14 19:03:32.693	\N	\N	\N
18	teste1	444444444444	\N	garcom	f	3	2026-02-10 17:02:59.328	2026-03-14 19:03:35.709	\N	\N	\N
17	teste 	5555555555	\N	staff	f	3	2026-02-10 17:02:38.817	2026-03-14 19:03:39.472	\N	\N	\N
16	Bruna Moretti 		\N	supervisor	f	3	2026-02-10 16:20:51.46	2026-03-14 19:03:41.827	\N	\N	\N
79	AL AMIN KHANDAKER	\N	\N	cozinha	t	3	2026-03-14 19:06:53.986	2026-03-14 19:06:53.986	\N	\N	1200.00
80	CRISLANE FELICIANO GOMES	\N	\N	chefe de turno	t	3	2026-03-14 19:08:58.799	2026-03-14 19:08:58.799	\N	\N	1100.00
81	THAIS DAL BELLO	\N	\N	garcom	t	3	2026-03-14 19:09:33.096	2026-03-14 19:09:33.096	\N	\N	1050.00
82	Ana Maria Silva	\N	\N	cozinha	t	1	2026-03-14 19:42:34.804	2026-03-14 19:42:34.804	2026-01-01	\N	\N
2	Sabrina Zoane Correa	123456789	\N	staff	f	1	2026-01-26 19:04:45.626	2026-03-28 13:07:58.993	\N	\N	\N
74	Ueslei Santana Cunha		\N	cozinha	t	4	2026-03-07 14:16:43.222	2026-03-28 11:27:12.175	\N	\N	\N
86	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	5	2026-03-17 18:51:02.047	2026-03-18 16:38:07.858	2026-01-01	\N	\N
87	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	3	2026-03-17 18:51:02.275	2026-03-18 16:38:08.801	2026-01-01	\N	\N
88	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	2	2026-03-17 18:51:02.371	2026-03-18 16:38:09.067	2026-01-01	\N	\N
83	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	11	2026-03-17 18:51:01.78	2026-03-18 16:38:06.918	2026-01-01	\N	\N
84	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	7	2026-03-17 18:51:01.859	2026-03-18 16:38:07.264	2026-01-01	\N	\N
15	Maderson	123456789	\N	chamador	f	2	2026-01-26 19:19:34.024	2026-03-28 11:44:21.807	\N	\N	\N
1	Emylaine Gomes	123456789	\N	staff	f	1	2026-01-26 19:01:57.852	2026-03-28 13:07:45.53	2025-12-01	\N	\N
8	Deyse Jackeline Nogueira Paes	123456789	\N	staff	t	1	2026-01-26 19:06:46.555	2026-03-28 13:09:11.609	\N	\N	\N
9	Mohammed Sirajul Islan	123456789	\N	staff	t	1	2026-01-26 19:07:03.014	2026-03-28 13:10:18.157	\N	\N	\N
10	Brunna Lorraynne Ferreira Fagundes	123456789	\N	gerente	t	1	2026-01-26 19:07:29.474	2026-03-28 13:10:49.593	\N	\N	\N
78	Erica Ribeiro	123456789	\N	chefe de turno	f	1	2026-03-10 11:02:38.196	2026-03-28 13:11:26.561	\N	\N	\N
11	Erica Ribeiro	123456789	\N	chefe de turno	f	1	2026-01-26 19:07:43.243	2026-03-28 13:11:44.89	\N	\N	\N
12	Douglas	123456789	\N	supervisor	f	1	2026-01-26 19:07:52.865	2026-03-28 13:11:55.756	\N	\N	\N
13	Maderson Ribeiro Fabri	123456789	\N	chamador	t	1	2026-01-26 19:08:05.112	2026-03-28 13:12:26.159	\N	\N	\N
112	VERA LUCIA TAVARES DE BRITO	\N	\N	cozinha	t	11	2026-03-18 16:35:00.623	2026-03-18 16:35:00.623	2026-01-01	\N	\N
113	VINICIUS PIMENTA BALBINO	\N	\N	garcom	t	11	2026-03-18 16:35:46.653	2026-03-18 16:35:46.653	2026-01-01	\N	\N
98	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	11	2026-03-18 16:27:58.605	2026-03-18 16:38:06.622	2026-01-01	\N	\N
99	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	7	2026-03-18 16:27:58.79	2026-03-18 16:38:06.736	2026-01-01	\N	\N
101	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	5	2026-03-18 16:27:59.153	2026-03-18 16:38:06.846	2026-01-01	\N	\N
102	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	4	2026-03-18 16:27:59.37	2026-03-18 16:38:07.02	2026-01-01	\N	\N
103	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	3	2026-03-18 16:27:59.53	2026-03-18 16:38:07.355	2026-01-01	\N	\N
104	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	2	2026-03-18 16:27:59.685	2026-03-18 16:38:07.848	2026-01-01	\N	\N
89	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	1	2026-03-17 18:51:02.465	2026-03-18 16:38:08.382	2026-01-01	\N	\N
76	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	f	4	2026-03-09 11:17:01.084	2026-03-18 16:38:08.385	2026-01-01	\N	\N
114	ABHIGYA BK	\N	\N	cozinha	f	6	2026-03-18 16:38:10.323	2026-03-18 16:48:31.544	2025-12-01	\N	\N
100	ABHIGYA BK	\N	\N	cozinha	f	6	2026-03-18 16:27:59.002	2026-03-18 16:48:34.047	2025-12-01	\N	\N
126	ARTUR GONÇALVES CARVALHO COSTA	\N	\N	garcom	t	6	2026-03-18 16:50:55.757	2026-03-18 16:50:55.757	2026-01-01	\N	\N
125	ARTUR GONÇALVES CARVALHO COSTA	\N	\N	garcom	f	11	2026-03-18 16:50:22.812	2026-03-18 16:50:55.93	2026-01-01	\N	\N
129	ACACIO DE ALMEIDA SANTOS	\N	\N	garcom	t	6	2026-03-18 16:52:27.757	2026-03-18 16:52:27.757	2022-01-01	\N	\N
90	AUNTO ROY	\N	\N	staff	t	11	2026-03-17 18:58:55.298	2026-03-27 18:31:11.996	2025-11-01	0033.0000.45543180623.05	\N
140	FILIPPE STEFANO DE SOUZA	962197230	\N	chamador	t	6	2026-03-18 17:00:49.116	2026-04-02 11:39:57.509	2026-02-07	\N	950.80
92	DEEPTI SUBEDI BHANDARI	\N	\N	garcom	t	11	2026-03-17 19:00:31.169	2026-03-27 18:32:12.924	2025-10-01	0033.0000.45719077804.05	\N
93	EMILLY BRAZ CARDOSO	\N	\N	gerente	t	11	2026-03-17 19:01:17.621	2026-03-27 18:32:55.824	2026-01-01	0018.0003.57637001020.08	\N
109	SADDAM HOSSAIN	\N	\N	garcom	t	11	2026-03-18 16:32:38.493	2026-04-02 10:58:29.128	2025-12-04	\N	\N
95	ISTIAQUE AMIN	\N	\N	staff	t	11	2026-03-18 16:25:31.834	2026-03-27 18:33:50.818	2026-02-07	0033.0000.45583600038.05	\N
162	ADELIA MANUELA A VIEIRA LOPES	\N	\N	cozinha	t	3	2026-03-28 11:33:49.707	2026-03-28 11:33:49.707	\N	\N	\N
119	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	8	2026-03-18 16:49:50.288	2026-03-28 12:22:54.208	2026-01-01	\N	\N
121	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	7	2026-03-18 16:49:50.5	2026-03-28 12:22:54.407	2026-01-01	\N	\N
116	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	6	2026-03-18 16:49:49.655	2026-03-28 12:22:54.616	2026-01-01	\N	\N
118	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	5	2026-03-18 16:49:50.098	2026-03-28 12:22:54.821	2026-01-01	\N	\N
122	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	3	2026-03-18 16:49:50.598	2026-03-28 12:22:55.112	2026-01-01	\N	\N
123	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	2	2026-03-18 16:49:50.709	2026-03-28 12:22:55.198	2026-01-01	\N	\N
124	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	1	2026-03-18 16:49:50.861	2026-03-28 12:22:55.277	2026-01-01	\N	\N
130	ADILSON DELGADO DE OLIVEIRA	\N	\N	garcom	f	6	2026-03-18 16:53:35.214	2026-03-28 12:36:48.762	2023-10-01	\N	\N
117	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	9	2026-03-18 16:49:49.716	2026-03-28 12:22:53.999	2026-01-01	\N	\N
154	RENATO FIORENTIN	\N	\N	garcom	f	6	2026-03-18 17:26:04.401	2026-03-28 12:39:13.361	2026-02-01	\N	\N
105	MARIA HELOISA RODRIGUES DA SILVA	\N	\N	chefe de turno	t	11	2026-03-18 16:29:17.669	2026-04-02 10:51:32.104	2025-11-01	\N	\N
155	ROHAN NANDI	\N	\N	garcom	t	11	2026-03-18 17:26:40.449	2026-04-02 10:55:04.369	2026-06-01	\N	\N
111	SUNIL BAHADUR BK	\N	\N	cozinha	t	11	2026-03-18 16:34:31.652	2026-04-02 10:56:47.695	2026-02-01	\N	\N
110	SUMAIYA ISLAM RIYA	\N	\N	staff	f	11	2026-03-18 16:33:43.793	2026-04-02 10:56:55.603	2026-02-17	\N	\N
107	NAZIM UDDIN	\N	\N	cozinha	t	11	2026-03-18 16:30:48.018	2026-04-02 10:57:11.513	2026-02-01	\N	\N
97	LUIZ CLAUDIO MARINHO DA SILVA	\N	\N	garcom	f	11	2026-03-18 16:27:09.434	2026-04-02 10:57:57.225	2025-12-23	\N	\N
96	JENNIFER GOMEZ VILLALBA	\N	\N	garcom	f	11	2026-03-18 16:26:31.838	2026-04-02 10:58:01.455	2025-12-01	\N	\N
160	SATVINDER SINGH	\N	\N	cozinha	t	6	2026-03-18 17:50:20.288	2026-04-02 12:01:28.828	2026-02-07	\N	955.70
94	EVERTON LUCAS FERREIRA RODRIGUES	\N	\N	chefe de turno	t	11	2026-03-17 19:06:45.61	2026-04-02 10:58:12.322	\N	0036.0216.99100112004.83	\N
91	BK RAMESH	\N	\N	staff	f	11	2026-03-17 18:59:57.394	2026-04-02 10:59:03.363	2025-11-18	0007.0000.00592603071.23	\N
128	ABUL HASAN	920345509	\N	staff	t	6	2026-03-18 16:51:41.478	2026-04-02 11:42:04.24	\N	\N	950.80
147	MARIA LIDIANE PEREIRA DA SILVA	931498436	\N	chefe de turno	t	6	2026-03-18 17:06:21.373	2026-04-02 11:49:01.314	2025-12-01	\N	1273.84
106	MD MAKSUDUR RAHMAN	\N	\N	chamador	f	11	2026-03-18 16:30:02.546	2026-04-02 14:07:42.674	2025-10-01	\N	\N
144	KAMRUL HOSSAIN ABIR	1568570468	\N	garcom	t	6	2026-03-18 17:03:47.332	2026-04-02 11:52:39.329	2025-11-01	\N	950.80
156	SABBIR HOSSAIN	1830007728	\N	garcom	t	6	2026-03-18 17:39:30.192	2026-04-02 11:51:19.122	2025-12-01	\N	950.80
153	NABIN TILIJA	\N	\N	cozinha	t	6	2026-03-18 17:23:12.04	2026-04-02 12:12:07.749	2025-06-01	\N	950.80
139	FERNANDO DUARTE FORTES	910514744	\N	cozinha	t	6	2026-03-18 17:00:10.387	2026-04-02 11:55:22.528	\N	\N	1300.90
85	ABHIGYA BK	920192066	\N	balcão	t	6	2026-03-17 18:51:01.961	2026-04-02 14:37:07.074	2025-12-01	\N	950.80
150	MD ROKIBUL ISLAM RANA	\N	\N	cozinha	t	6	2026-03-18 17:08:02.175	2026-04-02 12:05:16.336	2025-12-01	\N	950.80
151	MD YUSUF SOBUJ	\N	\N	garcom	t	6	2026-03-18 17:08:50.027	2026-04-02 12:08:36.835	2025-10-01	\N	950.80
149	MD GALIB SHAHAN	920504007	\N	garcom	t	6	2026-03-18 17:07:32.445	2026-04-02 12:11:02.898	2025-10-01	\N	950.80
141	FOYSAL	\N	\N	cozinha	t	6	2026-03-18 17:01:27.621	2026-04-02 12:14:23.489	2024-07-01	\N	1170.99
134	ASIF HASAN NOHASH	\N	\N	cozinha	t	6	2026-03-18 16:57:05.658	2026-04-02 12:19:50.34	2025-12-01	\N	950.80
131	ALEX DA SILVA GOMES	927748944	\N	cozinha	t	6	2026-03-18 16:54:07.989	2026-04-02 12:26:31.967	2022-12-01	\N	1300.90
159	SANTOSH CHAPAGAIN	920106662	\N	garcom	t	6	2026-03-18 17:48:15.502	2026-04-02 12:28:25.12	2026-01-01	\N	950.80
158	SANGITA BUDHA MAGAR	\N	\N	garcom	t	6	2026-03-18 17:44:38.3	2026-04-02 12:49:25.495	2023-09-01	\N	950.80
127	ABU SAYED BHUIYAN	\N	\N	garcom	f	6	2026-03-18 16:51:25.346	2026-04-02 13:22:26.767	\N	\N	\N
148	MD BAZLUR RAHMAN	\N	\N	garcom	t	6	2026-03-18 17:06:54.096	2026-04-02 13:27:54.245	2024-07-01	\N	950.80
142	GURCHARAN SINGH (Prince)	\N	\N	chamador	f	6	2026-03-18 17:02:08.785	2026-04-02 13:52:59.122	2026-02-07	\N	\N
133	ANTONIO CARLOS NUNES	936824473	\N	chefe de turno	t	6	2026-03-18 16:56:06.18	2026-04-02 13:54:48.59	\N	\N	1153.64
108	PAWAN GURUNG (LEE)	\N	\N	cozinha	t	11	2026-03-18 16:31:41.482	2026-04-02 14:09:56.413	2026-01-01	\N	\N
137	BIJAY NAKARMI	\N	\N	garcom	f	6	2026-03-18 16:58:54.659	2026-04-02 14:12:13.81	2025-10-01	\N	\N
161	SUMITRA LAMA KARKI	\N	\N	balcão	t	6	2026-03-18 17:51:00.08	2026-04-02 14:34:07.487	2025-12-01	\N	950.80
146	MARIA ALBUQUERQUE DA COSTA	962606268	\N	balcão	t	6	2026-03-18 17:05:24.816	2026-04-02 14:35:21.057	2022-01-01	\N	1042.73
143	KAMALA SHRESTHA	\N	\N	balcão	t	6	2026-03-18 17:02:39.283	2026-04-02 14:35:44.584	2025-12-01	\N	950.80
138	ELIAS GALVÃO SIMÕES FERREIRA	926092103	\N	balcão	t	6	2026-03-18 16:59:30.954	2026-04-02 14:37:36.959	2025-10-16	\N	950.80
163	ALAN LIBERATO DE OLIVEIRA	\N	\N	cozinha	f	3	2026-03-28 11:34:26.317	2026-04-03 12:05:03.884	\N	\N	\N
164	BRUNA MORETTI DURKES LEAL	\N	\N	gerente	t	3	2026-03-28 11:35:05.167	2026-03-28 11:35:05.167	\N	\N	\N
165	EUGENIA SOFIA DA COSTA PORTO DIAZ	\N	\N	garcom	t	3	2026-03-28 11:35:40.357	2026-03-28 11:35:40.357	\N	\N	\N
166	FELIPE GOMES DE AMORIM	\N	\N	cozinha	t	3	2026-03-28 11:36:11.417	2026-03-28 11:36:11.417	\N	\N	\N
167	JESSICA BRUNA FERNANDES DO NASCIMENTO	\N	\N	cozinha	t	3	2026-03-28 11:36:42.491	2026-03-28 11:36:42.491	\N	\N	\N
168	JOÃO PEDRO MARQUES AUGUSTO	\N	\N	garcom	t	3	2026-03-28 11:37:13.469	2026-03-28 11:37:13.469	\N	\N	\N
169	KAZI ASIFUL ISLAM	\N	\N	cozinha	t	3	2026-03-28 11:37:44.69	2026-03-28 11:37:53.916	\N	\N	\N
170	LUCIENE PEREIRA DA SILVA	\N	\N	cozinha	t	3	2026-03-28 11:38:18.647	2026-03-28 11:38:18.647	\N	\N	\N
171	MAJHARUL ISLAM	\N	\N	cozinha	t	3	2026-03-28 11:38:57.215	2026-03-28 11:38:57.215	\N	\N	\N
172	MD JAWAD HOSSAIN	\N	\N	garcom	t	3	2026-03-28 11:39:31.595	2026-03-28 11:39:31.595	\N	\N	\N
173	PEDRO MOREIRA DO NASCIMENTO	\N	\N	garcom	t	3	2026-03-28 11:40:00.511	2026-03-28 11:40:00.511	\N	\N	\N
174	RAMESH KC	\N	\N	cozinha	t	3	2026-03-28 11:40:18.055	2026-03-28 11:40:18.055	\N	\N	\N
175	SAJOL SHANDRA PAUL	\N	\N	garcom	t	3	2026-03-28 11:40:50.542	2026-03-28 11:40:50.542	\N	\N	\N
176	SAMSUL ALAM	\N	\N	cozinha	t	3	2026-03-28 11:41:20.771	2026-03-28 11:41:20.771	\N	\N	\N
177	SARANA LETICIA NERES SOARES	\N	\N	cozinha	t	3	2026-03-28 11:41:48.173	2026-03-28 11:41:48.173	\N	\N	\N
178	YESENIA OCAMPO GUZMAN	\N	\N	garcom	t	3	2026-03-28 11:42:17.268	2026-03-28 11:42:17.268	\N	\N	\N
179	ABDUL FATAN	\N	\N	cozinha	t	2	2026-03-28 11:44:48.239	2026-03-28 11:44:48.239	\N	\N	\N
180	AGUEDA DA SILVA FURTADO	\N	\N	cozinha	t	2	2026-03-28 11:45:25.095	2026-03-28 11:45:25.095	\N	\N	\N
181	ASMITA POUDEL	\N	\N	cozinha	t	2	2026-03-28 11:45:48.087	2026-03-28 11:45:48.087	\N	\N	\N
184	DHAN BAHADUR THAJALI	\N	\N	cozinha	t	2	2026-03-28 11:49:13.463	2026-03-28 11:49:13.463	\N	\N	\N
185	DIVINO CESAR DE SOUZA MUNIZ	\N	\N	gerente	t	2	2026-03-28 11:49:43.463	2026-03-28 11:49:43.463	\N	\N	\N
186	DIVINO CESAR DE SOUZA MUNIZ	\N	\N	gerente	t	5	2026-03-28 11:49:43.515	2026-03-28 11:49:43.515	\N	\N	\N
187	ERIZA CIBEL DA GRAÇA VIEIRA	\N	\N	garcom	t	2	2026-03-28 11:50:16.846	2026-03-28 11:50:16.846	\N	\N	\N
189	FAHIM AHMED CHOWDURY	\N	\N	cozinha	t	2	2026-03-28 11:51:43.851	2026-03-28 11:51:43.851	\N	\N	\N
191	HANRY FELIPE MARTINS ALVES	\N	\N	chefe de turno	t	3	2026-03-28 11:52:37.642	2026-03-28 11:52:37.642	\N	\N	\N
193	IGOR FABRICIO SOUZA SACERDOTE	SOLAR DE LISBOA	\N	chamador	t	3	2026-03-28 11:53:47.142	2026-03-28 11:53:47.142	\N	\N	\N
194	INACIA DO NASCIMENTO ALMEIDA SEQUEIRA BRAGANÇA	\N	\N	cozinha	t	2	2026-03-28 11:54:29.771	2026-03-28 11:54:29.771	\N	\N	\N
195	JOMIR UDDI	\N	\N	cozinha	t	2	2026-03-28 11:54:56.846	2026-03-28 11:54:56.846	\N	\N	\N
199	KELVIN FRANCISCO JOSE FARIAS SOBREIRA	\N	\N	garcom	t	2	2026-03-28 11:57:34.792	2026-03-28 11:57:34.792	\N	\N	\N
200	MANI RAJ GIRI	\N	\N	cozinha	t	2	2026-03-28 11:58:09.955	2026-03-28 11:58:09.955	\N	\N	\N
203	MARIA SOCORRO ANDRADE PIRES	\N	\N	garcom	t	2	2026-03-28 11:59:25.438	2026-03-28 11:59:25.438	\N	\N	\N
204	MD JOBAED HOSSAIN	\N	\N	garcom	t	2	2026-03-28 11:59:59.5	2026-03-28 11:59:59.5	\N	\N	\N
208	MOMIN MIA	\N	\N	cozinha	t	2	2026-03-28 12:01:41.615	2026-03-28 12:01:41.615	\N	\N	\N
209	NIRAJAN FOUDAR CHHETRI	\N	\N	cozinha	t	2	2026-03-28 12:02:07.711	2026-03-28 12:02:07.711	\N	\N	\N
211	RAFAEL MAZEIRO	\N	\N	garcom	t	3	2026-03-28 12:03:00.845	2026-03-28 12:03:00.845	\N	\N	\N
212	RICARDO JORGE VENTURA GONÇALVES	\N	\N	garcom	t	2	2026-03-28 12:03:31.78	2026-03-28 12:03:31.78	\N	\N	\N
214	RONISH PURI	\N	\N	cozinha	t	2	2026-03-28 12:04:22.418	2026-03-28 12:04:22.418	\N	\N	\N
217	SHANTA MAYA BAMJAN	\N	\N	cozinha	t	2	2026-03-28 12:05:32.532	2026-03-28 12:05:32.532	\N	\N	\N
220	THAINARA  BANDEIRA DOS SANTOS	\N	\N	cozinha	t	2	2026-03-28 12:06:58.624	2026-03-28 12:06:58.624	\N	\N	\N
222	YOGYA BAHADUR	\N	\N	cozinha	t	2	2026-03-28 12:07:59.944	2026-03-28 12:07:59.944	\N	\N	\N
223	AMRLK SINGH	\N	\N	cozinha	t	7	2026-03-28 12:09:10.692	2026-03-28 12:09:10.692	\N	\N	\N
224	AYRTON PEREIRA DA CONCEIÇÃO	\N	\N	cozinha	t	7	2026-03-28 12:09:41.948	2026-03-28 12:09:41.948	\N	\N	\N
225	BECSY KATHERINE GUTIERREZ	\N	\N	garcom	t	7	2026-03-28 12:10:19.318	2026-03-28 12:10:19.318	\N	\N	\N
226	CARIDAD JOLLANNYS GONÇALVES AREVALO	\N	\N	garcom	t	7	2026-03-28 12:11:25.275	2026-03-28 12:11:25.275	\N	\N	\N
227	DAVID DA CRUZ DOMINGUES	\N	\N	garcom	t	7	2026-03-28 12:12:21.691	2026-03-28 12:12:21.691	\N	\N	\N
228	DIONIS MARCO LOPES	\N	\N	gerente	t	7	2026-03-28 12:12:52.814	2026-03-28 12:12:52.814	\N	\N	\N
229	EDNA ROCHA GOMES MENDES	\N	\N	cozinha	t	7	2026-03-28 12:13:15.362	2026-03-28 12:13:15.362	\N	\N	\N
230	EVERSON ALMEIDA DOS SANTOS	\N	\N	cozinha	t	7	2026-03-28 12:14:03.622	2026-03-28 12:14:03.622	\N	\N	\N
231	FABIO VALERIO SANTIN IE	\N	\N	cozinha	t	7	2026-03-28 12:14:32.067	2026-03-28 12:14:32.067	\N	\N	\N
232	IKSHYA RANA MAGAR	\N	\N	garcom	t	7	2026-03-28 12:15:02.632	2026-03-28 12:15:02.632	\N	\N	\N
233	LAXMI GURUNG	\N	\N	garcom	t	7	2026-03-28 12:15:26.62	2026-03-28 12:15:26.62	\N	\N	\N
234	MAHESH TAMANG	\N	\N	cozinha	t	7	2026-03-28 12:15:55.873	2026-03-28 12:15:55.873	\N	\N	\N
235	MOHAMED AMINE MESSOUD	\N	\N	cozinha	t	7	2026-03-28 12:16:18.912	2026-03-28 12:16:18.912	\N	\N	\N
236	SANGITA BHUJEL	\N	\N	garcom	t	7	2026-03-28 12:17:05.239	2026-03-28 12:17:05.239	\N	\N	\N
237	SANGITA SIRIS MAGAR	\N	\N	garcom	t	7	2026-03-28 12:17:34.992	2026-03-28 12:17:34.992	\N	\N	\N
238	SHANTI SIRIS MAGAR	\N	\N	cozinha	t	7	2026-03-28 12:18:19.163	2026-03-28 12:18:19.163	\N	\N	\N
239	SITAL CHHETRI	\N	\N	chamador	t	7	2026-03-28 12:18:41.684	2026-03-28 12:18:41.684	\N	\N	\N
240	VICTOR FABRICIO FARRO REYES	\N	\N	sub gerente	t	1	2026-03-28 12:19:36.029	2026-03-28 12:19:36.029	\N	\N	\N
241	YOJAN ANDRES ARAGON JIMENEZ	\N	\N	cozinha	t	7	2026-03-28 12:20:14.101	2026-03-28 12:20:14.101	\N	\N	\N
242	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	10	2026-03-28 12:22:53.693	2026-03-28 12:22:53.693	2026-01-01	\N	\N
115	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	11	2026-03-18 16:49:49.555	2026-03-28 12:22:53.797	2026-01-01	\N	\N
120	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	4	2026-03-18 16:49:50.393	2026-03-28 12:22:55.041	2026-01-01	\N	\N
243	MAIKEL DOUGLAS MORETTI DURKES LEAL	\N	\N	supervisor	t	10	2026-03-28 12:22:55.318	2026-03-28 12:22:55.318	2026-01-01	\N	\N
244	ABDULLAH	\N	\N	cozinha	t	10	2026-03-28 12:23:27.343	2026-03-28 12:23:27.343	\N	\N	\N
245	ABU SHAMRAN	\N	\N	chamador	t	10	2026-03-28 12:24:40.202	2026-03-28 12:24:40.202	\N	\N	\N
215	SAJON PAUL	\N	\N	cozinha	t	2	2026-03-28 12:04:39.902	2026-04-02 12:14:48.455	\N	\N	\N
221	WESLEY ALVES BARBOSA	962546417	\N	garcom	t	2	2026-03-28 12:07:38.145	2026-04-02 12:25:39.449	2026-02-07	PT50001800036066418202043	950.00
213	RICARDO JOSÉ RODRIGUES VIEIRA	Casa Augusta	\N	cozinha	t	2	2026-03-28 12:03:58.694	2026-04-02 12:30:11.233	\N	\N	\N
207	MOHAMMAD SAIDO HOSSAIN	\N	\N	garcom	t	2	2026-03-28 12:01:18.473	2026-04-02 12:31:01.627	\N	\N	\N
198	KELVIN FRANCISCO JOSE FARIAS SOBREIRA	\N	\N	garcom	f	2	2026-03-28 11:57:23.392	2026-04-02 12:31:52.506	\N	\N	\N
192	HASAN KHAN	\N	\N	cozinha	t	2	2026-03-28 11:53:05.37	2026-04-02 12:35:03.016	\N	\N	\N
188	FABIO ANDRE PEREIRA DA SILVA	\N	\N	chamador	t	2	2026-03-28 11:50:51.594	2026-04-02 12:36:21.62	\N	\N	\N
183	DEBORAH LINDSEY ATZORI CALDEIRA DA SILVA	\N	\N	garcom	t	2	2026-03-28 11:48:00.922	2026-04-02 12:37:16.937	\N	\N	\N
205	MD MIJANUR RAHAMAN	\N	\N	garcom	t	2	2026-03-28 12:00:28.745	2026-04-03 14:43:46.76	\N	\N	\N
197	KAYSOR AHMED (YOYO)	\N	\N	garcom	t	2	2026-03-28 11:55:42.363	2026-04-03 14:44:01.403	\N	\N	\N
218	SUKHJEET KAUR (BALCÃO)	\N	\N	garcom	t	2	2026-03-28 12:06:06.191	2026-04-03 15:07:04.637	\N	\N	\N
202	MARIA DE FATIMA TRAJANO (BALCÃO)	\N	\N	garcom	t	2	2026-03-28 11:59:03.178	2026-04-03 15:07:26.455	\N	\N	\N
201	MANISHA KHADKA (BALCÃO)	\N	\N	garcom	t	2	2026-03-28 11:58:42.147	2026-04-03 15:07:42.641	\N	\N	\N
216	SAMJHANA BASNET (BALCÃO)	\N	\N	garcom	t	2	2026-03-28 12:05:04.105	2026-04-03 15:07:58.701	\N	\N	\N
182	BAL KUMARI NEUPANE ADHIKARI (BALCÃO)	\N	\N	garcom	t	2	2026-03-28 11:46:38.491	2026-04-03 15:08:35.268	\N	\N	\N
206	MD SIAM HOSSAIN	\N	\N	cozinha	t	2	2026-03-28 12:00:51.033	2026-04-03 15:33:21.488	\N	\N	\N
190	GERMANO JOSE CARVALHO MENDES (BALCÃO)	\N	\N	garcom	t	2	2026-03-28 11:52:11.597	2026-04-03 15:09:51.454	\N	\N	\N
246	AMILCAR MANUEL MEIRELES CARDOSO	\N	\N	gerente	t	10	2026-03-28 12:25:11.179	2026-03-28 12:25:19.005	\N	\N	\N
247	AMILCAR MANUEL MEIRELES CARDOSO	\N	\N	gerente	t	10	2026-03-28 12:25:20.326	2026-03-28 12:25:20.326	\N	\N	\N
248	ANDRE FELIPE LOPES DOS REIS	\N	\N	chamador	t	10	2026-03-28 12:25:41.506	2026-03-28 12:25:41.506	\N	\N	\N
249	ANISH POKHREL	\N	\N	garcom	t	10	2026-03-28 12:26:10.444	2026-03-28 12:26:10.444	\N	\N	\N
250	ANU RANI	\N	\N	garcom	t	10	2026-03-28 12:26:25.707	2026-03-28 12:26:25.707	\N	\N	\N
251	ANWAR ALI	\N	\N	cozinha	t	10	2026-03-28 12:26:58.951	2026-03-28 12:26:58.951	\N	\N	\N
252	CARLOS ALBERTO SALVADOR PLACIDO	\N	\N	cozinha	t	10	2026-03-28 12:27:29.072	2026-03-28 12:27:29.072	\N	\N	\N
253	CONSTANTINO DIAS MENDES	\N	\N	cozinha	t	10	2026-03-28 12:28:14.322	2026-03-28 12:28:14.322	\N	\N	\N
254	HELAL MIAH	\N	\N	cozinha	t	10	2026-03-28 12:28:53.54	2026-03-28 12:29:09.804	\N	\N	\N
255	HENRIQUE ARAUJO ALVES	\N	\N	garcom	t	10	2026-03-28 12:29:27.479	2026-03-28 12:29:27.479	\N	\N	\N
256	JOAQUIN DA CRUZ	\N	\N	cozinha	t	10	2026-03-28 12:29:48.204	2026-03-28 12:29:48.204	\N	\N	\N
257	JOSE CARLOS VIDIGAL MARTINS	\N	\N	garcom	t	10	2026-03-28 12:30:23.131	2026-03-28 12:30:23.131	\N	\N	\N
258	JOSE FERNANDO OZORIO RODRIGUES	\N	\N	garcom	t	10	2026-03-28 12:30:47.159	2026-03-28 12:30:47.159	\N	\N	\N
259	KAWSER AHMED	\N	\N	garcom	t	10	2026-03-28 12:31:11.946	2026-03-28 12:31:11.946	\N	\N	\N
260	MD ABUL HASNAT	\N	\N	cozinha	t	10	2026-03-28 12:31:38.405	2026-03-28 12:31:38.405	\N	\N	\N
261	MD SOLAIMAN HOSSAN	\N	\N	cozinha	t	10	2026-03-28 12:32:08.682	2026-03-28 12:32:08.682	\N	\N	\N
262	MD ZIAUR RAHMAN	\N	\N	garcom	t	10	2026-03-28 12:32:44.709	2026-03-28 12:32:44.709	\N	\N	\N
263	MOHAMMAD MOYNOOL HAQUE	\N	\N	garcom	t	10	2026-03-28 12:33:11.308	2026-03-28 12:33:11.308	\N	\N	\N
264	MOSHARAF HOSSAIN	\N	\N	gerente	t	10	2026-03-28 12:33:43.829	2026-03-28 12:33:43.829	\N	\N	\N
265	PEDRO MANUEL DO CEU PINTO	\N	\N	garcom	t	10	2026-03-28 12:34:12.807	2026-03-28 12:34:12.807	\N	\N	\N
266	SAJINA JIREL	\N	\N	cozinha	t	10	2026-03-28 12:34:38.893	2026-03-28 12:34:38.893	\N	\N	\N
267	SANDRA CRISTINA RODRIGUES DUARTE FERNANDES	\N	\N	cozinha	t	10	2026-03-28 12:35:11.893	2026-03-28 12:35:11.893	\N	\N	\N
268	SRIJANA TAMANG	\N	\N	garcom	t	10	2026-03-28 12:35:37.145	2026-03-28 12:35:37.145	\N	\N	\N
270	RENATO FIORENTIN	\N	\N	chefe de turno	t	10	2026-03-28 12:39:13.049	2026-03-28 12:39:13.049	2026-02-01	\N	\N
276	CHU MAYA THAJALI	\N	\N	cozinha	t	5	2026-03-28 12:49:46.768	2026-03-28 12:49:46.768	\N	\N	\N
277	DANIEL RODRIGUES DA SILVA	\N	\N	garcom	t	5	2026-03-28 12:50:10.7	2026-03-28 12:50:10.7	\N	\N	\N
278	EDUARDO FERREIRA DE MELO	\N	\N	chamador	t	5	2026-03-28 12:50:30.634	2026-03-28 12:50:30.634	\N	\N	\N
280	EDUARDO SEMAN DA COSTA	\N	\N	chefe de turno	t	2	2026-03-28 12:50:56.124	2026-03-28 12:50:56.124	\N	\N	\N
281	JACIEL ARAUJO DA SILVA	\N	\N	garcom	t	5	2026-03-28 12:51:27.569	2026-03-28 12:51:27.569	\N	\N	\N
282	KEIRA MELISSA MOLNAR CALVARIO	\N	\N	cozinha	t	5	2026-03-28 12:52:16.022	2026-03-28 12:52:16.022	\N	\N	\N
284	KHIN BAHADUR ROKA	\N	\N	cozinha	t	5	2026-03-28 12:53:15.742	2026-03-28 12:53:15.742	\N	\N	\N
285	LAIZIANE ULIMA ALVES FERREIRA	\N	\N	chamador	t	5	2026-03-28 12:54:11.263	2026-03-28 12:54:11.263	\N	\N	\N
288	MOHAMMAD SAGAR HOSSAIN	\N	\N	garcom	t	5	2026-03-28 13:04:08.326	2026-03-28 13:04:08.326	\N	\N	\N
291	SARA HAVILLA SOARES FRANCO	\N	\N	cozinha	t	5	2026-03-28 13:05:24.542	2026-03-28 13:05:24.542	\N	\N	\N
292	SARA HAVILLA SOARES FRANCO	\N	\N	cozinha	t	2	2026-03-28 13:05:24.677	2026-03-28 13:05:24.677	\N	\N	\N
293	SUKAI KASSEH	\N	\N	cozinha	t	5	2026-03-28 13:05:51.762	2026-03-28 13:05:51.762	\N	\N	\N
296	ZAKIR HOSSAIN KHAN	\N	\N	garcom	t	5	2026-03-28 13:07:01.478	2026-03-28 13:07:01.478	\N	\N	\N
297	Erica Ribeiro	123456789	\N	gerente	t	7	2026-03-28 13:11:26.265	2026-03-28 13:11:26.265	\N	\N	\N
299	Ashish Aidi	\N	\N	cozinha	t	1	2026-03-28 13:13:09.18	2026-03-28 13:13:09.18	\N	\N	\N
300	Carla Andreia Cardoso Dos Santos	\N	\N	cozinha	t	1	2026-03-28 13:13:49.213	2026-03-28 13:13:49.213	\N	\N	\N
301	Danielle Rosa Nunes	\N	\N	cozinha	t	1	2026-03-28 13:14:19.602	2026-03-28 13:14:19.602	\N	\N	\N
302	Jose Manuel Fernandes Bordianu	\N	\N	cozinha	t	1	2026-03-28 13:15:03.174	2026-03-28 13:15:03.174	\N	\N	\N
303	Marta Alexandra Ferreira Bordianu	\N	\N	cozinha	t	1	2026-03-28 13:15:36.314	2026-03-28 13:15:36.314	\N	\N	\N
304	Menuka Giri	\N	\N	cozinha	t	1	2026-03-28 13:16:10.467	2026-03-28 13:16:10.467	\N	\N	\N
305	Mohammed Kayes Miah	\N	\N	cozinha	t	1	2026-03-28 13:16:42.87	2026-03-28 13:16:42.87	\N	\N	\N
306	Nisha Garbuja Pun	\N	\N	cozinha	t	1	2026-03-28 13:17:06.45	2026-03-28 13:17:06.45	\N	\N	\N
307	Pablo Henrique Da Silva	\N	\N	cozinha	t	1	2026-03-28 13:17:31.142	2026-03-28 13:17:31.142	\N	\N	\N
308	Rajesh Sunar	\N	\N	cozinha	t	1	2026-03-28 13:17:59.262	2026-03-28 13:17:59.262	\N	\N	\N
309	Surya Shiwa	\N	\N	cozinha	t	1	2026-03-28 13:18:24.249	2026-03-28 13:18:24.249	\N	\N	\N
298	Erica Ribeiro	123456789	\N	chefe de turno	f	7	2026-03-28 13:11:44.686	2026-03-28 13:18:55.484	\N	\N	\N
269	ADILSON DELGADO DE OLIVEIRA	\N	\N	cozinha	t	11	2026-03-28 12:36:48.554	2026-04-02 10:49:04.013	2023-10-01	\N	\N
313	Gurachan sing	920512609	\N	cozinha	f	6	2026-04-02 12:35:39.5	2026-04-02 13:15:45.972	\N	\N	1120.36
272	TIAGO JOSE PADILHA	915563574	\N	chefe de turno	t	6	2026-03-28 12:46:45.773	2026-04-02 11:43:26.674	\N	\N	1100.99
145	LEANDRO FERREIRA PERES	924741482	\N	gerente	t	6	2026-03-18 17:04:49.276	2026-04-02 11:45:32.63	2026-01-01	\N	1300.90
152	MIHAELA CERGARU	937321115	\N	cozinha	t	6	2026-03-18 17:17:55.094	2026-04-02 11:53:49.735	2025-12-01	\N	950.80
136	ATIQUR RAHMAN	920574593	\N	garcom	t	6	2026-03-18 16:58:19.379	2026-04-02 12:04:19.123	2025-12-01	\N	950.80
157	SAGAR CHOWDHURY	\N	\N	cozinha	t	6	2026-03-18 17:44:12.42	2026-04-02 12:13:33.17	2024-09-01	\N	1000.48
310	BRUNA ROMINA DA COSTA PORTO DIAZ	927043808	\N	chefe de turno	t	2	2026-04-02 12:20:54.902	2026-04-02 12:20:54.902	2026-04-01	BE85 96760832 0106	1100.00
274	AKILA LIMBU	\N	\N	chamador	t	5	2026-03-28 12:48:55.713	2026-04-02 12:21:44.571	\N	\N	\N
210	PAULA CRISTINA ROSADO DA COSTA	\N	\N	cozinha	t	2	2026-03-28 12:02:28.64	2026-04-02 12:28:45.996	\N	\N	\N
312	Sumitra lama  karki	920236590	\N	garcom	f	6	2026-04-02 12:24:22.894	2026-04-02 13:25:44.795	\N	\N	950.80
311	Abu Sayed bhuiyan	\N	\N	cozinha	t	6	2026-04-02 12:22:06.241	2026-04-02 13:22:49.439	\N	\N	950.80
273	VINICIUS ROSARIO MARINHO DA SILVA	936117162	\N	garcom	t	6	2026-03-28 12:47:12.9	2026-04-02 13:23:01.102	\N	\N	950.80
271	TATIANA PATRICIA DOS SANTOS	\N	\N	cozinha	f	6	2026-03-28 12:46:05.669	2026-04-02 13:26:03.47	\N	\N	\N
315	WILLIAM ROBERTO SOUZA	\N	\N	chamador	t	2	2026-04-02 13:45:36.226	2026-04-02 13:45:36.226	\N	\N	\N
295	WILLIAM ROBERTO SOUZA	\N	\N	chamador	f	5	2026-03-28 13:06:40.27	2026-04-02 13:45:36.433	\N	\N	\N
316	GURCHARAN SINGH (Prince)	\N	\N	cozinha	t	4	2026-04-02 13:52:58.925	2026-04-02 13:52:58.925	2026-02-07	\N	\N
317	Barbara joeliannys Gonçalves arevalo	+316 18655040	\N	staff	t	6	2026-04-02 14:00:11.343	2026-04-02 14:00:30.813	\N	\N	950.80
318	Tarek mahmud	\N	\N	chamador	t	6	2026-04-02 14:01:27.345	2026-04-02 14:01:27.345	\N	\N	950.80
135	ATIK MASUD SAFWAN	920202356	\N	balcão	t	6	2026-03-18 16:57:47.813	2026-04-02 14:39:29.645	2026-01-01	\N	550.16
294	THAYNA GUIMARAES ALMEIDA	910600905	\N	chefe de turno	t	5	2026-03-28 13:06:20.199	2026-04-02 16:51:14.801	\N	\N	\N
275	ANA SILEPO MARCELINO	937271610	\N	cozinha	t	5	2026-03-28 12:49:27.801	2026-04-02 16:52:29.599	2025-10-23	\N	\N
290	SABBIR HUSSAIN	\N	\N	garcom	t	5	2026-03-28 13:04:57.343	2026-04-03 12:42:43.626	\N	\N	\N
289	RAJU MIAH	\N	\N	garcom	f	5	2026-03-28 13:04:29.057	2026-04-03 12:43:02.305	\N	\N	\N
287	MICHAEL SKARLEN VASQUEZ COLMENARES	\N	\N	staff	t	5	2026-03-28 12:55:13.021	2026-04-03 12:43:16.487	\N	\N	\N
286	MARCIO WESLEY SANTOS NASCIMENTO	\N	\N	cozinha	t	5	2026-03-28 12:54:41.469	2026-04-03 12:43:32.755	\N	\N	\N
283	KHIM BAHADUR CHHANTYAL	\N	\N	cozinha	t	5	2026-03-28 12:52:56.78	2026-04-03 12:43:51.285	\N	\N	\N
314	ROGERIO  PERREIRA PINTO (BALCÃO)	935356910	\N	garcom	t	2	2026-04-02 12:42:57.8	2026-04-03 15:06:31.772	2025-03-23	\N	1300.00
219	SUKUN SHAHI (BALCÃO)	920291901	\N	garcom	t	2	2026-03-28 12:06:24.077	2026-04-03 15:06:47.843	2026-02-07	PT50000700000070296462723	950.00
77	MD MAKSUDUR RAHMAN	Especiaria cheirosa	\N	chamador	t	4	2026-03-10 10:42:52.389	2026-04-02 14:07:43.53	2025-10-01	\N	\N
319	BIJAY NAKARMI	\N	\N	cozinha	t	11	2026-04-02 14:12:13.526	2026-04-02 14:12:13.526	2025-10-01	\N	\N
320	BIJAY NAKARMI	\N	\N	cozinha	t	11	2026-04-02 14:12:15.57	2026-04-02 14:12:15.57	2025-10-01	\N	\N
321	Mahadi hassan	\N	\N	staff	t	6	2026-04-02 14:33:43.009	2026-04-02 14:33:43.009	\N	\N	950.80
132	ALFREDO MONTEIRO MARTINS	939874355	\N	balcão	t	6	2026-03-18 16:54:53.543	2026-04-02 14:36:44.646	2022-01-01	\N	1350.65
322	LEONARDO DOS SANTOS MANENTE	SEM CONTRATO	\N	chamador	t	3	2026-04-02 17:58:50.508	2026-04-02 17:58:50.508	\N	\N	\N
324	NORKIS MARTINEZ	936926252	\N	staff	t	11	2026-04-03 09:05:23.97	2026-04-03 09:05:23.97	\N	\N	950.00
325	MD Mojsmmel Hossain ( Faisal chamador)	\N	\N	chamador	t	4	2026-04-03 10:10:40.415	2026-04-03 10:10:40.415	\N	\N	\N
326	Emylaine Gomes Pereira	920404503	\N	staff	t	11	2026-04-03 11:01:21.941	2026-04-03 11:01:21.941	2026-04-01	PT50356000019109970362234	950.00
327	Habibur Rahman	920258129	\N	garcom	t	11	2026-04-03 11:06:16.357	2026-04-03 11:06:16.357	2026-03-25	PT50002300004576764822694	950.00
328	Marcelo Pompermayer	\N	\N	chamador	t	11	2026-04-03 11:15:34.416	2026-04-03 11:15:34.416	\N	PT50000700000070573979723	1200.00
323	DHEFERSSON DUARTE	SEM CONTRATO	\N	garcom	t	3	2026-04-02 18:01:02.899	2026-04-03 12:04:27.375	\N	\N	\N
329	ULYSSES FERREIRA VIANA	918306391	\N	cozinha	t	3	2026-04-03 12:07:13.196	2026-04-03 12:07:13.196	2026-02-28	\N	1200.00
330	MAIRA MOREIRA	\N	\N	cozinha	t	3	2026-04-03 12:08:31.259	2026-04-03 12:08:31.259	\N	\N	\N
331	ADELIA MANUELA	\N	\N	cozinha	t	3	2026-04-03 12:08:48.189	2026-04-03 12:08:55.412	\N	\N	\N
334	GANESHE	\N	\N	cozinha	t	3	2026-04-03 12:11:49.471	2026-04-03 12:11:49.471	\N	\N	\N
333	BEATRIZ FERREIRA FELIPE	\N	\N	cozinha	t	3	2026-04-03 12:11:04.546	2026-04-03 12:11:57.681	\N	\N	\N
332	LEONARDO DOS SANTOS MANENTE	\N	\N	chamador	f	3	2026-04-03 12:09:29.251	2026-04-03 12:20:54.509	\N	\N	\N
335	SUNITA	\N	\N	staff	t	3	2026-04-03 12:50:41.419	2026-04-03 12:50:41.419	\N	\N	\N
279	EDUARDO SEMAN DA COSTA	\N	\N	chefe de turno	f	5	2026-03-28 12:50:56.04	2026-04-03 13:21:55.545	\N	\N	\N
336	Tess da Ros	\N	\N	staff	t	5	2026-04-03 13:22:48.693	2026-04-03 13:22:48.693	\N	\N	\N
337	CAIO MURILO	\N	\N	garcom	t	5	2026-04-03 13:23:16.439	2026-04-03 13:23:16.439	\N	\N	\N
338	WESLEY MAYA	\N	\N	garcom	t	5	2026-04-03 13:23:37.741	2026-04-03 13:23:37.741	\N	\N	\N
339	RICARDO RODRIGUES VIERA	\N	\N	staff	t	5	2026-04-03 13:25:06.655	2026-04-03 13:25:06.655	\N	\N	\N
340	KUMARI	\N	\N	staff	t	5	2026-04-03 13:32:03.456	2026-04-03 13:32:03.456	\N	\N	\N
341	GABRIEL MACHADO	SEM CONTRATO	\N	garcom	t	2	2026-04-03 14:44:57.88	2026-04-03 14:44:57.88	\N	\N	\N
342	EXTRA	\N	\N	garcom	t	2	2026-04-03 14:52:14.11	2026-04-03 14:52:14.11	\N	\N	\N
196	JYOTY RAY (BALCÃO)	\N	\N	garcom	t	2	2026-03-28 11:55:13.909	2026-04-03 15:08:15.04	\N	\N	\N
343	RAFAEL MAZIERO	\N	\N	staff	t	2	2026-04-03 15:17:42.519	2026-04-03 15:17:42.519	\N	\N	\N
344	Sabbir hossan ( chamador)	\N	\N	staff	t	6	2026-04-04 08:12:12.525	2026-04-04 08:12:12.525	\N	\N	950.80
345	Quanto Roy	\N	\N	chamador	t	11	2026-04-04 09:22:01.538	2026-04-04 09:22:01.538	\N	\N	\N
346	Carlos Eduardo Santos Benicio EmpM	\N	\N	staff	t	4	2026-04-05 09:13:17.937	2026-04-05 09:13:17.937	\N	\N	\N
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
-- Data for Name: regras_distribuicao; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.regras_distribuicao (id, "restID", role_name, calculation_type, calculation_base, rate, payment_source, ordem, ativo, "criadoEm", "atualizadoEm", percent_mode, split_mode, tipo_de_acerto) FROM stdin;
5	4	gerente	PERCENT	VALOR_TOTAL_GORJETAS	1.9000	TIP_POOL	3	t	2026-03-03 14:54:24.364	2026-03-09 18:13:05.398	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
7	4	supervisor	PERCENT	VALOR_TOTAL_GORJETAS	1.3000	TIP_POOL	4	t	2026-03-03 14:55:20.281	2026-03-09 18:13:44.279	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
23	4	chefe de turno	PERCENT	VALOR_TOTAL_GORJETAS	10.0000	TIP_POOL	1	t	2026-03-09 17:44:18.582	2026-03-10 09:50:59.775	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
9	3	staff	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	0	t	2026-03-03 19:24:39.029	2026-03-03 19:24:39.029	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
12	1	staff	PERCENT	VALOR_TOTAL_GORJETAS	5.5000	TIP_POOL	0	t	2026-03-04 14:12:30.423	2026-03-05 08:29:31.391	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
2	4	staff	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	0	t	2026-03-03 14:43:53.227	2026-03-06 14:08:31.498	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
8	3	gerente	PERCENT	VALOR_TOTAL_GORJETAS	1.9000	TIP_POOL	3	t	2026-03-03 19:24:39.02	2026-03-14 18:59:23.679	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
26	3	chefe de turno	PERCENT	VALOR_TOTAL_GORJETAS	10.0000	TIP_POOL	1	t	2026-03-14 19:02:18.12	2026-03-14 19:02:45.23	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
37	8	garcom	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	1	t	2026-03-17 16:53:33.206	2026-03-17 16:53:33.206	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
38	8	cozinha	PERCENT	VALOR_TOTAL_GORJETAS	3.0000	TIP_POOL	2	t	2026-03-17 16:53:33.206	2026-03-17 16:53:33.206	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
39	8	supervisor	PERCENT	VALOR_TOTAL_GORJETAS	1.0000	TIP_POOL	3	t	2026-03-17 16:53:33.206	2026-03-17 16:53:33.206	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
44	10	cozinha	PERCENT	VALOR_TOTAL_GORJETAS	3.0000	TIP_POOL	2	t	2026-03-17 16:57:31.615	2026-03-17 16:57:31.615	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
28	5	staff	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	1	t	2026-03-17 16:44:47.044	2026-03-17 17:02:16.124	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
29	5	gerente	PERCENT	VALOR_TOTAL_GORJETAS	1.9000	TIP_POOL	3	t	2026-03-17 16:44:47.044	2026-03-17 17:03:36.689	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
49	5	chefe de turno	PERCENT	VALOR_TOTAL_GORJETAS	10.0000	TIP_POOL	10	t	2026-03-17 17:05:29.48	2026-03-17 17:05:29.48	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
50	11	gerente	PERCENT	VALOR_TOTAL_GORJETAS	1.9000	TIP_POOL	10	t	2026-03-17 19:05:01.667	2026-03-17 19:05:01.667	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
47	11	chefe de turno	PERCENT	VALOR_TOTAL_GORJETAS	10.0000	TIP_POOL	1	t	2026-03-17 16:58:15.452	2026-03-27 18:38:38.426	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
46	11	staff	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	0	t	2026-03-17 16:58:15.452	2026-03-27 18:38:50.256	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
40	9	staff	PERCENT	VALOR_TOTAL_GORJETAS	5.5000	TIP_POOL	1	t	2026-03-17 16:57:31.617	2026-03-27 18:52:23.309	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
42	9	cozinha	PERCENT	VALOR_TOTAL_GORJETAS	2.5000	TIP_POOL	2	t	2026-03-17 16:57:31.617	2026-03-27 18:52:38.031	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
43	9	gerente	PERCENT	VALOR_TOTAL_GORJETAS	3.5000	TIP_POOL	3	t	2026-03-17 16:57:31.617	2026-03-27 18:53:23.736	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
41	10	staff	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	1	t	2026-03-17 16:57:31.615	2026-03-27 18:54:42.911	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
45	10	gerente	PERCENT	VALOR_TOTAL_GORJETAS	2.0000	TIP_POOL	3	t	2026-03-17 16:57:31.615	2026-03-27 18:56:53.565	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
51	10	sub gerente	PERCENT	VALOR_TOTAL_GORJETAS	1.5000	TIP_POOL	4	t	2026-03-27 18:58:55.633	2026-03-27 18:58:55.633	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
52	7	gerente	PERCENT	VALOR_TOTAL_GORJETAS	2.0000	TIP_POOL	10	t	2026-03-27 19:50:17.379	2026-03-27 19:50:17.379	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
34	7	staff	PERCENT	VALOR_TOTAL_GORJETAS	5.5000	TIP_POOL	1	t	2026-03-17 16:49:25.808	2026-03-27 19:51:04.899	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
53	7	sub gerente	PERCENT	VALOR_TOTAL_GORJETAS	7.5000	TIP_POOL	10	t	2026-03-27 19:51:52.182	2026-03-27 19:51:52.182	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
54	6	gerente	PERCENT	VALOR_TOTAL_GORJETAS	1.9000	TIP_POOL	2	t	2026-03-27 19:56:03.904	2026-03-27 19:56:03.904	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
20	2	staff	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	0	t	2026-01-26 19:18:50.233	2026-04-02 13:13:37.53	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
10	3	supervisor	PERCENT	VALOR_TOTAL_GORJETAS	1.3000	TIP_POOL	2	t	2026-03-03 19:24:39.031	2026-04-02 17:50:48.799	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
19	1	gerente	PERCENT	FATURAMENTO_SEM_GORJETA	2.9000	TIP_POOL	3	t	2026-03-04 21:00:04.134	2026-04-02 20:09:11.776	ABSOLUTE_PERCENT	FULL_RATE_PER_EMPLOYEE	DIARIO
25	1	chefe de turno	PERCENT	FATURAMENTO_SEM_GORJETA	1.1000	TIP_POOL	4	t	2026-03-10 10:54:32.911	2026-04-02 20:09:32.838	ABSOLUTE_PERCENT	FULL_RATE_PER_EMPLOYEE	DIARIO
15	1	supervisor	PERCENT	FATURAMENTO_SEM_GORJETA	0.6000	TIP_POOL	2	t	2026-03-04 14:13:10.945	2026-04-02 20:09:52.368	ABSOLUTE_PERCENT	EQUAL_SPLIT	DIARIO
22	2	gerente	PERCENT	VALOR_TOTAL_GORJETAS	1.9000	TIP_POOL	3	t	2026-01-26 19:19:11.133	2026-04-02 20:15:15.035	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
21	2	supervisor	PERCENT	VALOR_TOTAL_GORJETAS	1.3000	TIP_POOL	4	t	2026-01-26 19:18:50.16	2026-04-02 20:15:25.31	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
30	5	supervisor	PERCENT	VALOR_TOTAL_GORJETAS	1.3000	TIP_POOL	4	t	2026-03-17 16:44:47.044	2026-04-02 20:16:26.943	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
36	7	supervisor	PERCENT	VALOR_TOTAL_GORJETAS	0.6000	TIP_POOL	3	t	2026-03-17 16:49:25.808	2026-04-02 20:18:04.948	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
48	11	supervisor	PERCENT	VALOR_TOTAL_GORJETAS	1.3000	TIP_POOL	3	t	2026-03-17 16:58:15.452	2026-04-02 20:19:09.927	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
27	2	chefe de turno	PERCENT	VALOR_TOTAL_GORJETAS	10.0000	TIP_POOL	1	t	2026-03-16 13:06:42.128	2026-04-03 14:47:43.91	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
56	2	balcão	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	2	f	2026-04-02 13:16:11.415	2026-04-03 15:23:26.346	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
31	6	staff	PERCENT	VALOR_TOTAL_GORJETAS	7.0000	TIP_POOL	0	t	2026-03-17 16:47:18.081	2026-04-06 12:18:29.781	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
55	6	chefe de turno	PERCENT	VALOR_TOTAL_GORJETAS	10.0000	TIP_POOL	1	t	2026-03-27 19:57:18.288	2026-04-06 12:20:07.548	BASE_PERCENT_POINTS	PROPORTIONAL_TO_POOL_INPUT	DIARIO
33	6	supervisor	PERCENT	VALOR_TOTAL_GORJETAS	1.3000	TIP_POOL	3	t	2026-03-17 16:47:18.081	2026-04-06 12:20:38.888	BASE_PERCENT_POINTS	FULL_RATE_PER_EMPLOYEE	DIARIO
57	6	balcão	PERCENT	VALOR_TOTAL_GORJETAS	0.0000	TIP_POOL	4	t	2026-04-02 14:31:57.778	2026-04-06 12:20:45.806	BASE_PERCENT_POINTS	EQUAL_SPLIT	DIARIO
\.


--
-- Data for Name: restaurantes; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.restaurantes ("restID", name, endereco, contacto, percentagem_gorjeta_base, ativo, "createdAt", "updatedAt") FROM stdin;
4	Terrazinno 	R. Augusta 218, 1100-056 Lisboa	\N	12.50	t	2026-02-18 12:22:02.547	2026-03-09 10:44:22.878
1	LOS CHANETES BY BEHER	R. do Comércio 18 20, 1100-200 Lisboa	968 992 245	11.50	t	2026-01-26 19:00:56.501	2026-03-10 10:46:44.788
3	Costa Lusitânia 	Rua augusta 158	+351 926 133 138	12.50	t	2026-02-10 16:20:03.671	2026-03-14 18:59:43.132
2	Solar de Lisboa 	R. Augusta 110, 1100-054 Lisboa	+351 926 133 080	12.50	t	2026-01-26 19:18:50.148	2026-03-16 11:52:17.215
5	Casa Augusta 	R. Augusta 98, 1100-060 Lisboa	+351 926 133 232	12.50	t	2026-03-17 16:44:47.044	2026-03-17 16:44:47.044
6	Brasa D´ouro	R. Augusta 238, 1100-056 Lisboa	+351 927 965 984	12.50	t	2026-03-17 16:47:18.081	2026-03-17 16:47:18.081
7	Cork Kitchen 	R. da Vitória 90, 1100-619 Lisboa	+351 961 587 422	11.50	t	2026-03-17 16:49:25.808	2026-03-17 16:49:25.808
8	Fiorella	Praça Dom Pedro IV 27/29, 1100-486 Lisboa	\N	10.00	t	2026-03-17 16:53:33.206	2026-03-17 16:53:33.206
11	Olé Olé Grill 	R. Augusta 260, 1100-422 Lisboa	\N	12.50	t	2026-03-17 16:58:15.452	2026-03-17 16:58:15.452
9	Nicola	Praça Dom Pedro IV 24, 1100-200 Lisboa	\N	11.50	t	2026-03-17 16:57:31.617	2026-03-27 18:39:28.87
10	Ferrary	R. Augusta 189, 1100-050 Lisboa	\N	11.00	t	2026-03-17 16:57:31.615	2026-03-27 18:47:26.784
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
24	43	6	\N	2026-03-28 13:27:24.101	2026-03-28 13:27:24.101
31	48	5	\N	2026-04-01 09:05:31.923	2026-04-01 09:05:31.923
32	46	3	\N	2026-04-01 09:05:44.508	2026-04-01 09:05:44.508
33	47	2	\N	2026-04-01 09:05:57.627	2026-04-01 09:05:57.627
34	45	4	\N	2026-04-01 09:06:07.815	2026-04-01 09:06:07.815
35	49	11	\N	2026-04-01 11:50:55.918	2026-04-01 11:50:55.918
36	42	11	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
37	42	8	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
38	42	9	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
39	42	7	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
40	42	5	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
41	42	6	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
42	42	4	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
43	42	3	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
44	42	1	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
45	42	2	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
46	42	10	\N	2026-04-01 12:34:28.722	2026-04-01 12:34:28.722
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.users (id, name, email, "passwordHash", role, "createdAt", "updatedAt") FROM stdin;
3	supervisor	super@gmail.com	$2b$10$cbWEfyE3PxOxVlN3OmJ60.MHKXo9n./DKpbk1L/94TNVz.AOtl7J6	SUPERVISOR	2026-01-26 19:28:04.071	2026-01-26 19:28:43.387
15	gorjeta_god	superadmin@yourlab.com	$2b$12$MRqfvvRk9lPK7b2ukK5Z4uzCcsc6uV.Fj3mcTtPyZDuwBAbyFMSR6	SUPER_ADMIN	2026-03-08 21:03:22.87	2026-04-01 20:19:07.704
64	Dâmaris Nascimento	dcns0403@gmail.com	$2b$12$8CdVfk0mt3VjTMUbM8KP2uR2lZmjJs.ZuagoxCwcXjZYiV0Ij.aBm	ADMIN	2026-04-02 17:35:56.799	2026-04-02 17:35:56.799
41	FELIPE FERREIRA	ff@gmail.com	$2b$12$3EaFz3eGWYi2VwCbDcnprus0DUFgaSGICYDmR4BJKgwsQaoJ6MGiO	ADMIN	2026-03-25 13:21:47.007	2026-03-25 13:21:47.007
43	Brasa douro	brasadouro123000@gmail.com	$2b$12$nGJnIA0kBB6ehk1gwrUtluiIpFMElWrApoMbWN/TpRWQ9HgVekK9K	GERENTE	2026-03-28 13:26:21.648	2026-03-28 13:27:23.991
48	Casa Augusta	casaaugusta2025@gmail.com	$2b$12$Bu8Zy7AkQlyMNosernXtEugNNxKprTUe2dGAM3jo5zZalJMjpraam	GERENTE	2026-03-31 18:39:17.657	2026-04-01 09:05:31.77
46	Costa Lusitania	costalusitanagf@gmail.com	$2b$12$EeK09/jXyc3/5zzekbwTLOJC7uUnv2fD7I2qzZimDbMYPd1CeT56i	GERENTE	2026-03-31 18:16:30.04	2026-04-01 09:05:44.471
47	Solar de Lisboa	solardelisboa@gmail.com	$2b$12$EnjY5O.gLRlNtmxlkOf5QuvVTNlVfB7U4VHNLLcOyks64QteHxoBO	GERENTE	2026-03-31 18:25:45.032	2026-04-01 09:05:57.547
45	TERRAZINNO	terrazinnoo@gmail.com	$2b$12$aX25bvTmpL/moMlSOXSadeLQwJTrE/UtPahRRrD5rxLAcsGN7yCja	GERENTE	2026-03-31 18:04:06.248	2026-04-01 09:06:07.78
49	Olé olé Grill House	oleolegrill@gmail.com	$2b$12$7mXgdNa87ngcdjzTZ.0XxO7U5SVbuTWjC6OuDxtArAv8ZZ9x8D176	GERENTE	2026-04-01 11:34:39.222	2026-04-01 11:50:55.831
42	douglas@gmail.com	douglassup@gmail.com	$2b$12$LP62Mt6er.mfqEArB1ebgu9sdSx0GVHh5WEVv6dxzpc.Pcau9x55i	SUPERVISOR	2026-03-25 13:27:50.166	2026-04-01 12:34:28.681
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
-- Name: distribuicao_gorjetas_distID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."distribuicao_gorjetas_distID_seq"', 1, false);


--
-- Name: faturamento_diario_distribuicao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.faturamento_diario_distribuicao_id_seq', 4377, true);


--
-- Name: faturamento_diario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.faturamento_diario_id_seq', 49, true);


--
-- Name: fecho_financeiro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.fecho_financeiro_id_seq', 84, true);


--
-- Name: fecho_financeiro_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.fecho_financeiro_item_id_seq', 489, true);


--
-- Name: fecho_financeiro_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.fecho_financeiro_template_id_seq', 41, true);


--
-- Name: funcionario_presenca_diaria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.funcionario_presenca_diaria_id_seq', 4294, true);


--
-- Name: funcionario_restaurante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.funcionario_restaurante_id_seq', 1, false);


--
-- Name: funcionarios_funcID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."funcionarios_funcID_seq"', 346, true);


--
-- Name: limpeza_prodID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."limpeza_prodID_seq"', 1, false);


--
-- Name: limpeza_records_recordID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."limpeza_records_recordID_seq"', 1, false);


--
-- Name: regras_distribuicao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.regras_distribuicao_id_seq', 60, true);


--
-- Name: restaurantes_restID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."restaurantes_restID_seq"', 11, true);


--
-- Name: transacoes_tranID_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."transacoes_tranID_seq"', 1, false);


--
-- Name: user_restaurant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.user_restaurant_id_seq', 46, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.users_id_seq', 64, true);


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
-- Name: fecho_financeiro_item fecho_financeiro_item_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro_item
    ADD CONSTRAINT fecho_financeiro_item_pkey PRIMARY KEY (id);


--
-- Name: fecho_financeiro fecho_financeiro_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro
    ADD CONSTRAINT fecho_financeiro_pkey PRIMARY KEY (id);


--
-- Name: fecho_financeiro_template fecho_financeiro_template_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro_template
    ADD CONSTRAINT fecho_financeiro_template_pkey PRIMARY KEY (id);


--
-- Name: funcionario_presenca_diaria funcionario_presenca_diaria_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionario_presenca_diaria
    ADD CONSTRAINT funcionario_presenca_diaria_pkey PRIMARY KEY (id);


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
-- Name: regras_distribuicao regras_distribuicao_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.regras_distribuicao
    ADD CONSTRAINT regras_distribuicao_pkey PRIMARY KEY (id);


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
-- Name: fecho_financeiro_data_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX fecho_financeiro_data_idx ON public.fecho_financeiro USING btree (data);


--
-- Name: fecho_financeiro_item_fecID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "fecho_financeiro_item_fecID_idx" ON public.fecho_financeiro_item USING btree ("fecID");


--
-- Name: fecho_financeiro_restID_data_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "fecho_financeiro_restID_data_key" ON public.fecho_financeiro USING btree ("restID", data);


--
-- Name: fecho_financeiro_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "fecho_financeiro_restID_idx" ON public.fecho_financeiro USING btree ("restID");


--
-- Name: fecho_financeiro_template_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "fecho_financeiro_template_restID_idx" ON public.fecho_financeiro_template USING btree ("restID");


--
-- Name: funcionario_presenca_diaria_funcID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "funcionario_presenca_diaria_funcID_idx" ON public.funcionario_presenca_diaria USING btree ("funcID");


--
-- Name: funcionario_presenca_diaria_restID_data_funcID_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "funcionario_presenca_diaria_restID_data_funcID_key" ON public.funcionario_presenca_diaria USING btree ("restID", data, "funcID");


--
-- Name: funcionario_presenca_diaria_restID_data_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "funcionario_presenca_diaria_restID_data_idx" ON public.funcionario_presenca_diaria USING btree ("restID", data);


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
-- Name: regras_distribuicao_restID_ativo_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "regras_distribuicao_restID_ativo_idx" ON public.regras_distribuicao USING btree ("restID", ativo);


--
-- Name: regras_distribuicao_restID_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "regras_distribuicao_restID_idx" ON public.regras_distribuicao USING btree ("restID");


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
-- Name: fecho_financeiro_item fecho_financeiro_item_fecID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro_item
    ADD CONSTRAINT "fecho_financeiro_item_fecID_fkey" FOREIGN KEY ("fecID") REFERENCES public.fecho_financeiro(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fecho_financeiro_item fecho_financeiro_item_templateId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro_item
    ADD CONSTRAINT "fecho_financeiro_item_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES public.fecho_financeiro_template(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fecho_financeiro fecho_financeiro_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro
    ADD CONSTRAINT "fecho_financeiro_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fecho_financeiro_template fecho_financeiro_template_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.fecho_financeiro_template
    ADD CONSTRAINT "fecho_financeiro_template_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: funcionario_presenca_diaria funcionario_presenca_diaria_funcID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionario_presenca_diaria
    ADD CONSTRAINT "funcionario_presenca_diaria_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES public.funcionarios("funcID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: funcionario_presenca_diaria funcionario_presenca_diaria_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.funcionario_presenca_diaria
    ADD CONSTRAINT "funcionario_presenca_diaria_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: regras_distribuicao regras_distribuicao_restID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.regras_distribuicao
    ADD CONSTRAINT "regras_distribuicao_restID_fkey" FOREIGN KEY ("restID") REFERENCES public.restaurantes("restID") ON UPDATE CASCADE ON DELETE CASCADE;


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

\unrestrict sCpd8XamdZMm1SildCW6mjP9i0GE7NpoP60jfmavkts3zleT0x8T3F4hTfcmPQ4

