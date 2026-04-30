CREATE TABLE book_author_bridge_dim (
    Author_SK INT NOT NULL,
    Book_SK INT NOT NULL,
    
    
    CONSTRAINT PK_book_author_bridge PRIMARY KEY (Author_SK, Book_SK),
    
  
    CONSTRAINT FK_Bridge_Author FOREIGN KEY (Author_SK) REFERENCES Author_DIM(Author_SK),
    CONSTRAINT FK_Bridge_Book FOREIGN KEY (Book_SK) REFERENCES Book_DIM(Book_SK)
);