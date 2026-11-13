BEGIN;

CREATE TABLE public.aufmassliste_new (
  projekt_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid uuid DEFAULT gen_random_uuid(),
  projekt_nummer character varying UNIQUE,
  kunde text,
  plz_ort text,
  straße_hausnummer text,
  telefon character varying,
  e_mail text,
  bau_typ text,
  status text CHECK (status = ANY (ARRAY['Auftragseingang'::text, 'Aufmass'::text, 'Montage'::text, 'Abgeschlossen'::text, 'Storniert'::text])),
  ansprechpartner text,
  vorlaufzeit_afms smallint,
  afms_typ text CHECK ((afms_typ = ANY (ARRAY['Besichtigung'::text, 'Aufmass'::text])) OR afms_typ IS NULL),
  aufmesser text,
  messen_ab smallint,
  aufmass_termin date,
  aufmass_uhrzeit time without time zone,
  bemerkung_afms character varying,
  montage_ab smallint,
  montage_termin date,
  bemerkung_mntg character varying,
  hpl boolean,
  formverleimt boolean,
  stahl boolean,
  glas boolean,
  sonstiges character varying,
  gemessen boolean DEFAULT false,
  montiert boolean,
  abgeschlossen_am timestamp with time zone,
  letzte_statusänderung timestamp with time zone,
  firma text,
  CONSTRAINT aufmassliste_new_pkey PRIMARY KEY (projekt_id)
);

INSERT INTO public.aufmassliste_new (
  projekt_id, uuid, projekt_nummer, kunde, plz_ort, straße_hausnummer, telefon, e_mail,
  bau_typ, status, ansprechpartner, vorlaufzeit_afms, afms_typ, aufmesser,essen_ab,
  aufmass_termin, aufmass_uhrzeit, bemerkung_afms, montage_ab, montage_termin, bemerkung_mntg,
  hpl, formverleimt, stahl, glas, sonstiges,
  gemessen, montiert, abgeschlossen_am, letzte_statusänderung, firma
)
OVERRIDING SYSTEM VALUE
SELECT
  projekt_id, uuid, projekt_nummer, kunde, plz_ort, straße_hausnummer, telefon, e_mail,
  bau_typ, status, ansprechpartner, vorlaufzeit_afms, afms_typ, aufmesser,essen_ab,
  aufmass_termin, aufmass_uhrzeit, bemerkung_afms, montage_ab, montage_termin, bemerkung_mntg,
  hpl, formverleimt, stahl, glas, sonstiges,
  gemessen, montiert, abgeschlossen_am, letzte_statusänderung, firma
FROM public.aufmassliste;

DROP TABLE public.aufmassliste;

ALTER TABLE public.aufmassliste_new RENAME TO aufmassliste;
ALTER TABLE public.aufmassliste RENAME CONSTRAINT aufmassliste_new_pkey TO aufmassliste_pkey;
ALTER INDEX public.aufmassliste_new_projekt_nummer_key RENAME TO aufmassliste_projekt_nummer_key;
ALTER SEQUENCE public.aufmassliste_new_projekt_id_seq RENAME TO aufmassliste_projekt_id_seq;

SELECT setval(pg_get_serial_sequence('public.aufmassliste', 'projekt_id'), COALESCE((SELECT MAX(projekt_id) FROM public.aufmassliste), 1));

GRANT SELECT, INSERT, UPDATE, DELETE ON public.aufmassliste TO anon, authenticated, service_role;

COMMIT;
