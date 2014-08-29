--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: update_leg_counts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_leg_counts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
     pet_leg_count INTEGER;
     pet_count INTEGER;
    BEGIN
      SELECT INTO pet_leg_count species.leg_count
        FROM species
        WHERE species.id = NEW.species_id;
    
      SELECT INTO pet_count count(*)
        FROM pets
        JOIN species ON species.id = pets.species_id
        WHERE species.leg_count = pet_leg_count;
    
      DELETE FROM leg_counts where leg_counts.leg_count = pet_leg_count;
      INSERT INTO leg_counts (leg_count, pet_count) values (pet_leg_count, pet_count);
  
      RETURN NULL;
    END;
    $$;


ALTER FUNCTION public.update_leg_counts() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: leg_counts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE leg_counts (
    id integer NOT NULL,
    leg_count integer,
    pet_count integer
);


ALTER TABLE public.leg_counts OWNER TO postgres;

--
-- Name: leg_counts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE leg_counts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leg_counts_id_seq OWNER TO postgres;

--
-- Name: leg_counts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE leg_counts_id_seq OWNED BY leg_counts.id;


--
-- Name: pets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pets (
    id integer NOT NULL,
    name text,
    species_id integer
);


ALTER TABLE public.pets OWNER TO postgres;

--
-- Name: pets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pets_id_seq OWNER TO postgres;

--
-- Name: pets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pets_id_seq OWNED BY pets.id;


--
-- Name: species; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE species (
    id integer NOT NULL,
    name text,
    leg_count integer
);


ALTER TABLE public.species OWNER TO postgres;

--
-- Name: species_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE species_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.species_id_seq OWNER TO postgres;

--
-- Name: species_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE species_id_seq OWNED BY species.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY leg_counts ALTER COLUMN id SET DEFAULT nextval('leg_counts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pets ALTER COLUMN id SET DEFAULT nextval('pets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY species ALTER COLUMN id SET DEFAULT nextval('species_id_seq'::regclass);


--
-- Name: leg_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY leg_counts
    ADD CONSTRAINT leg_counts_pkey PRIMARY KEY (id);


--
-- Name: pets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (id);


--
-- Name: species_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY species
    ADD CONSTRAINT species_pkey PRIMARY KEY (id);


--
-- Name: update_leg_counts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_leg_counts AFTER INSERT ON pets FOR EACH ROW EXECUTE PROCEDURE update_leg_counts();


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

