DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS product;
--
DROP TABLE IF EXISTS product_class;
DROP TABLE IF EXISTS product_size;
DROP TABLE IF EXISTS job_industry_category;
DROP TABLE IF EXISTS wealth_segment;
DROP TABLE IF EXISTS brand;
DROP TABLE IF EXISTS product_line;
-------------------------------------------------------------------------------

CREATE TABLE brand (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE product_line (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE product_class (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE product_size (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE job_industry_category (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE wealth_segment (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(1024) NOT NULL,
    last_name VARCHAR(1024),
    gender VARCHAR(1) NOT NULL,
    dob DATE,
    job_title TEXT,
    job_industry_category_id INT,
    FOREIGN KEY (job_industry_category_id) REFERENCES job_industry_category (id)
        ON DELETE NO ACTION,
    wealth_segment_id INT NOT NULL,
    FOREIGN KEY (wealth_segment_id) REFERENCES wealth_segment (id)
        ON DELETE NO ACTION,
    deceased_indicator BOOLEAN NOT NULL,
    owns_car BOOLEAN NOT NULL,
    address TEXT NOT NULL,
    postcode VARCHAR(4) NOT NULL,
    state TEXT NOT NULL,
    country TEXT NOT NULL,
    property_valuation INT NOT NULL
);

CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    brand_id INT NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brand (id) ON DELETE NO ACTION,
    product_line_id INT NOT NULL,
    FOREIGN KEY (product_line_id) REFERENCES product_line (id) ON DELETE NO ACTION,
    product_class_id INT NOT NULL,
    FOREIGN KEY (product_class_id) REFERENCES product_class (id) ON DELETE NO ACTION,
    product_size_id INT NOT NULL,
    FOREIGN KEY (product_size_id) REFERENCES product_size (id) ON DELETE NO ACTION,
    list_price FLOAT NOT NULL
);

CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE NO ACTION ,
    transaction_product_id INT,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE NO ACTION,
    transaction_date DATE NOT NULL,
    online_order BOOLEAN,
    order_status TEXT NOT NULL,
    standard_cost FLOAT
);


