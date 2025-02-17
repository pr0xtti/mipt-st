TRUNCATE brand RESTART IDENTITY CASCADE;
INSERT INTO brand (id, name) VALUES (1, 'Solex');
INSERT INTO brand (id, name) VALUES (2, 'Norco Bicycles');
INSERT INTO brand (id, name) VALUES (3, 'OHM Cycles');
INSERT INTO brand (id, name) VALUES (4, 'Trek Bicycles');
INSERT INTO brand (id, name) VALUES (5, 'Giant Bicycles');
INSERT INTO brand (id, name) VALUES (6, 'WeareA2B');

TRUNCATE product_line RESTART IDENTITY CASCADE;
INSERT INTO product_line (id, name) VALUES (1, 'Road');
INSERT INTO product_line (id, name) VALUES (2, 'Standard');
INSERT INTO product_line (id, name) VALUES (3, 'Touring');
INSERT INTO product_line (id, name) VALUES (4, 'Mountain');

TRUNCATE product_class RESTART IDENTITY CASCADE;
INSERT INTO product_class (id, name) VALUES (1, 'medium');
INSERT INTO product_class (id, name) VALUES (2, 'high');
INSERT INTO product_class (id, name) VALUES (3, 'low');

TRUNCATE product_size RESTART IDENTITY CASCADE;
INSERT INTO product_size (id, name) VALUES (1, 'medium');
INSERT INTO product_size (id, name) VALUES (2, 'large');
INSERT INTO product_size (id, name) VALUES (3, 'small');


TRUNCATE job_industry_category RESTART IDENTITY CASCADE;
INSERT INTO job_industry_category (id, name) VALUES (1, 'Health');
INSERT INTO job_industry_category (id, name) VALUES (2, 'Financial Services');
INSERT INTO job_industry_category (id, name) VALUES (3, 'Property');
INSERT INTO job_industry_category (id, name) VALUES (4, 'IT');
INSERT INTO job_industry_category (id, name) VALUES (5, 'Manufacturing');
INSERT INTO job_industry_category (id, name) VALUES (6, 'Argiculture');
INSERT INTO job_industry_category (id, name) VALUES (7, 'Entertainment');
INSERT INTO job_industry_category (id, name) VALUES (8, 'Retail');
INSERT INTO job_industry_category (id, name) VALUES (9, 'Telecommunications');

TRUNCATE wealth_segment RESTART IDENTITY CASCADE;
INSERT INTO wealth_segment (id, name) VALUES (1, 'Mass Customer');
INSERT INTO wealth_segment (id, name) VALUES (2, 'High Net Worth');
INSERT INTO wealth_segment (id, name) VALUES (3, 'Affluent Customer');


-- TRUNCATE customer RESTART IDENTITY CASCADE ;