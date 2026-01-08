--
-- PostgreSQL database dump
--

\restrict Hh36GfXALBSdzJWVlOd9T85umY9utCU6majyYunoLtnk7x6tRYDHmsdiLCHEOPz

-- Dumped from database version 18.1 (Debian 18.1-1.pgdg13+2)
-- Dumped by pg_dump version 18.1 (Debian 18.1-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dim_date; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_date (
    date_id integer NOT NULL,
    date_value date NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    month_name character varying(10) NOT NULL,
    quarter integer NOT NULL,
    day_of_month integer NOT NULL,
    day_of_week integer NOT NULL,
    day_name character varying(10) NOT NULL,
    is_weekend boolean NOT NULL,
    is_month_end boolean NOT NULL,
    is_quarter_end boolean NOT NULL,
    is_year_end boolean NOT NULL
);


--
-- Name: dim_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_entity (
    entity_id bigint NOT NULL,
    entity_name character varying(100) NOT NULL,
    entity_type character varying(30) NOT NULL,
    status character varying(15) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_entity_status CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


--
-- Name: dim_entity_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_entity_entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_entity_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_entity_entity_id_seq OWNED BY public.dim_entity.entity_id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expenses (
    expense_id bigint NOT NULL,
    entity_id bigint CONSTRAINT expenses_entiity_id_not_null NOT NULL,
    date_id integer NOT NULL,
    expense_category character varying(50) NOT NULL,
    amount numeric(14,2) NOT NULL,
    is_recurring boolean DEFAULT false NOT NULL,
    transaction_id bigint,
    CONSTRAINT expenses_amount_check CHECK ((amount >= (0)::numeric))
);


--
-- Name: expenses_expense_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expenses_expense_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expenses_expense_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expenses_expense_id_seq OWNED BY public.expenses.expense_id;


--
-- Name: financials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.financials (
    financial_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    date_id integer NOT NULL,
    statement_type character varying(15) NOT NULL,
    line_item character varying(60) NOT NULL,
    amount numeric(16,2) NOT NULL,
    CONSTRAINT chk_stmt_type CHECK (((statement_type)::text = ANY ((ARRAY['income'::character varying, 'balance'::character varying, 'cash_flow'::character varying])::text[])))
);


--
-- Name: financials_financial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.financials_financial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: financials_financial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.financials_financial_id_seq OWNED BY public.financials.financial_id;


--
-- Name: revenue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revenue (
    revenue_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    date_id integer NOT NULL,
    amount numeric(14,2) NOT NULL,
    revenue_type character varying(20) DEFAULT 'subscription'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT revenue_amount_check CHECK ((amount >= (0)::numeric))
);


--
-- Name: revenue_revenue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revenue_revenue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revenue_revenue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.revenue_revenue_id_seq OWNED BY public.revenue.revenue_id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    transaction_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    date_id integer NOT NULL,
    amount numeric(14,2) NOT NULL,
    category character varying(50) NOT NULL,
    transaction_type character varying(15) NOT NULL,
    description text,
    CONSTRAINT chk_txn_type CHECK (((transaction_type)::text = ANY ((ARRAY['income'::character varying, 'expense'::character varying, 'transfer'::character varying])::text[])))
);


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- Name: dim_entity entity_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_entity ALTER COLUMN entity_id SET DEFAULT nextval('public.dim_entity_entity_id_seq'::regclass);


--
-- Name: expenses expense_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses ALTER COLUMN expense_id SET DEFAULT nextval('public.expenses_expense_id_seq'::regclass);


--
-- Name: financials financial_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financials ALTER COLUMN financial_id SET DEFAULT nextval('public.financials_financial_id_seq'::regclass);


--
-- Name: revenue revenue_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue ALTER COLUMN revenue_id SET DEFAULT nextval('public.revenue_revenue_id_seq'::regclass);


--
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- Name: dim_date dim_date_date_value_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_date
    ADD CONSTRAINT dim_date_date_value_key UNIQUE (date_value);


--
-- Name: dim_date dim_date_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_date
    ADD CONSTRAINT dim_date_pkey PRIMARY KEY (date_id);


--
-- Name: dim_entity dim_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_entity
    ADD CONSTRAINT dim_entity_pkey PRIMARY KEY (entity_id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (expense_id);


--
-- Name: financials financials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financials
    ADD CONSTRAINT financials_pkey PRIMARY KEY (financial_id);


--
-- Name: revenue revenue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue
    ADD CONSTRAINT revenue_pkey PRIMARY KEY (revenue_id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: dim_entity uq_dim_entity; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_entity
    ADD CONSTRAINT uq_dim_entity UNIQUE (entity_name, entity_type);


--
-- Name: financials uq_financial_line; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financials
    ADD CONSTRAINT uq_financial_line UNIQUE (entity_id, date_id, statement_type, line_item);


--
-- Name: idx_exp_entity_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exp_entity_date ON public.expenses USING btree (entity_id, date_id);


--
-- Name: idx_fin_entity_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fin_entity_date ON public.financials USING btree (entity_id, date_id);


--
-- Name: idx_rev_entity_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rev_entity_date ON public.revenue USING btree (entity_id, date_id);


--
-- Name: idx_txn_entity_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_txn_entity_date ON public.transactions USING btree (entity_id, date_id);


--
-- Name: expenses expenses_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_date_id_fkey FOREIGN KEY (date_id) REFERENCES public.dim_date(date_id);


--
-- Name: expenses expenses_entiity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_entiity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.dim_entity(entity_id);


--
-- Name: expenses expenses_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id);


--
-- Name: financials financials_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financials
    ADD CONSTRAINT financials_date_id_fkey FOREIGN KEY (date_id) REFERENCES public.dim_date(date_id);


--
-- Name: financials financials_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financials
    ADD CONSTRAINT financials_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.dim_entity(entity_id);


--
-- Name: revenue revenue_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue
    ADD CONSTRAINT revenue_date_id_fkey FOREIGN KEY (date_id) REFERENCES public.dim_date(date_id);


--
-- Name: revenue revenue_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue
    ADD CONSTRAINT revenue_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.dim_entity(entity_id);


--
-- Name: transactions transactions_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_date_id_fkey FOREIGN KEY (date_id) REFERENCES public.dim_date(date_id);


--
-- Name: transactions transactions_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.dim_entity(entity_id);


--
-- PostgreSQL database dump complete
--

\unrestrict Hh36GfXALBSdzJWVlOd9T85umY9utCU6majyYunoLtnk7x6tRYDHmsdiLCHEOPz

