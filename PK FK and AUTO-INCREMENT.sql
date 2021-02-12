-- Create tables
CREATE TABLE BookShelf (

    ShelfID INT PRIMARY KEY,
    ShelfHeight FLOAT,
    ShelfWidth FLOAT
);

INSERT INTO BookShelf (ShelfID, ShelfHeight, ShelfWidth) VALUES (1, 12.5, 45.1);
INSERT INTO BookShelf (ShelfID, ShelfHeight, ShelfWidth) VALUES (2, 12.5, 45.1);
INSERT INTO BookShelf (ShelfID, ShelfHeight, ShelfWidth) VALUES (3, 16.0, 45.1);
INSERT INTO BookShelf (ShelfID, ShelfHeight, ShelfWidth) VALUES (4, 18.3, 45.1);

-- For auto-generating PRIMARY KEYS
CREATE SEQUENCE seq_book MINVALUE 1 START WITH 1 INCREMENT BY 1 CACHE 10; 

CREATE TABLE BOOKS (
    BookID INT PRIMARY KEY,
    ISBN NUMBER (13),
    BookTitle VARCHAR (50),
    Author VARCHAR (50),
    Genre VARCHAR (50),
    ShelfID INT,
    FOREIGN KEY(ShelfID) REFERENCES BookShelf(ShelfID)
);

-- Insert data into tables
INSERT INTO BOOKS (BookID, ISBN, BookTitle, Author, Genre, ShelfID) VALUES (seq_book.NEXTVAL, 9780679455134, 'Ulysses', 'James Joyce', 'Modernist', 1);
INSERT INTO BOOKS (BookID, ISBN, BookTitle, Author, Genre, ShelfID) VALUES (seq_book.NEXTVAL, 9780684833392, 'Catch-22', 'Joseph Heller', 'Satire', 2);
INSERT INTO BOOKS (BookID, ISBN, BookTitle, Author, Genre, ShelfID) VALUES (seq_book.NEXTVAL, 9780385474542, 'Things Fall Apart', 'Chinua Achebe', 'Historical Fiction', 3);
INSERT INTO BOOKS (BookID, ISBN, BookTitle, Author, Genre, ShelfID) VALUES (seq_book.NEXTVAL, 9780375753411, 'Frankenstein: Or the Modern Prometheus', 'Mary Shelley', 'Gothic Horror', 1);

-- Query tables
SELECT  * FROM BOOKS;
SELECT * FROM BookShelf;
