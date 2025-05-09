CREATE TABLE COUNTRY
(CO_ID INT NOT NULL,
CO_NAME VARCHAR2(50) NOT NULL,
CO_CURRENCY DECIMAL(6,6) NOT NULL,
CO_EXCHANGE VARCHAR2(18) NOT NULL,
PRIMARY KEY(CO_ID));

CREATE TABLE AUTHOR
(A_ID INT NOT NULL,
A_FNAME VARCHAR2(20) NOT NULL,
A_LNAME VARCHAR2(20) NOT NULL,
A_MNAME VARCHAR2(20),
PRIMARY KEY(A_ID));

CREATE TABLE ADDRESS
(ADDR_ID INT NOT NULL,
ADDR_STREET1 VARCHAR2(60) NOT NULL,
ADDR_STREET2 VARCHAR2(60),
ADDR_CITY VARCHAR2(30) NOT NULL,
ADDR_STATE VARCHAR2(30),
ADDR_ZIP VARCHAR2(30) NOT NULL,
ADDR_CO_ID INT NOT NULL,
PRIMARY KEY(ADDR_ID),
FOREIGN KEY(ADDR_CO_ID) REFERENCES COUNTRY(CO_ID)
);
-- ON DELETE CASCADE);

CREATE TABLE CUSTOMER
(C_ID INT NOT NULL,
C_FNAME VARCHAR2(20) NOT NULL, 
C_LNAME VARCHAR2(20) NOT NULL,
C_DISCOUNT DECIMAL(10,10) NOT NULL,
C_USNAME VARCHAR2(20) NOT NULL,
C_PASSWD VARCHAR2(20) NOT NULL,
C_PHONE VARCHAR2(20),
C_EMAIL VARCHAR2(20),
C_BIRTHDATE DATE,
C_DATA VARCHAR2(50),
C_ADDR_ID INT NOT NULL,
C_LOGIN DATE NOT NULL,
C_EXPIRATION DATE NOT NULL,
C_LAST_VISIT DATE NOT NULL,
C_SINCE DATE,
PRIMARY KEY(C_ID),
FOREIGN KEY(C_ADDR_ID) REFERENCES ADDRESS(ADDR_ID)
);
-- ON DELETE CASCADE);

CREATE TABLE ITEM
(I_ID INT NOT NULL,
I_SUBJECT VARCHAR2(60) NOT NULL,
I_COST DECIMAL(15,2) NOT NULL,
I_SRP DECIMAL(15,2) NOT NULL,
I_TITLE VARCHAR2(60) NOT NULL,
I_BACKING VARCHAR2(15),
I_STOCK INT,
I_PUBLISHER VARCHAR2(60),
I_A_ID INT NOT NULL,
I_PUB_DATE DATE NOT NULL,
I_DESC VARCHAR2(500),
I_AVAIL VARCHAR2(20),
I_ISBN VARCHAR2(13) NOT NULL,
I_DIMENSIONS VARCHAR2(25),
I_PAGE INT,
PRIMARY KEY(I_ID),
FOREIGN KEY(I_A_ID) REFERENCES AUTHOR(A_ID)
);
-- ON DELETE CASCADE); 

CREATE TABLE ORDER1
(O_ID INT NOT NULL,
O_C_ID INT NOT NULL,
O_DATE DATE NOT NULL,
O_SUB_TOTAL DECIMAL(15,2) NOT NULL,
O_TAX DECIMAL(15,2) NOT NULL,
O_SHIP_COST DECIMAL(15,2) NOT NULL,
O_TOTAL DECIMAL(15,2) NOT NULL,
O_SHIP_TYPE VARCHAR2(10) NOT NULL,
O_SHIP_DATE DATE,
O_BILL_ADDR_ID INT NOT NULL,
O_SHIP_ADDR_ID INT NOT NULL,
O_STATUS VARCHAR2(15),
PRIMARY KEY(O_ID),
FOREIGN KEY(O_C_ID) REFERENCES CUSTOMER(C_ID),
FOREIGN KEY(O_BILL_ADDR_ID) REFERENCES ADDRESS(ADDR_ID),
FOREIGN KEY(O_SHIP_ADDR_ID) REFERENCES ADDRESS(ADDR_ID)
);
-- ON DELETE CASCADE);

CREATE TABLE ORDER_LINE
(OL_O_ID INT NOT NULL,
OL_I_ID INT NOT NULL,
OL_ID INT NOT NULL,
OL_QTY INT NOT NULL,
OL_DISCOUNT DECIMAL(3,2) NOT NULL,
OL_COMMENTS VARCHAR2(100),
PRIMARY KEY(OL_ID), 
FOREIGN KEY(OL_O_ID) REFERENCES ORDER1(O_ID),
FOREIGN KEY(OL_I_ID) REFERENCES ITEM(I_ID)
);
-- ON DELETE CASCADE);

CREATE TABLE CREDIT_CARD
(CC_O_ID INT NOT NULL,
CC_TYPE VARCHAR2(10) NOT NULL,
CC_NUM INT NOT NULL,
CC_NAME VARCHAR2(31) NOT NULL,
CC_EXPIRY DATE NOT NULL,
CC_AMT DECIMAL(15,2) NOT NULL,
CC_DATE DATE,
CC_CO_ID INT NOT NULL,
PRIMARY KEY(CC_O_ID),
FOREIGN KEY(CC_O_ID) REFERENCES ORDER1(O_ID),
FOREIGN KEY(CC_CO_ID) REFERENCES COUNTRY(CO_ID)
);
-- ON DELETE CASCADE);

CREATE TABLE SHOPPING_CART
(SC_ID INT NOT NULL,
SC_C_ID INT NOT NULL,
SC_FNAME VARCHAR2(20) NOT NULL,
SC_LNAME VARCHAR2(20) NOT NULL,
SC_DATE DATE,
SC_DISCOUNT DECIMAL(3,2) NOT NULL,
SC_SUB_TOTAL DECIMAL(15,2) NOT NULL,
SC_TAX DECIMAL(15,2) NOT NULL, 
SC_SHIP_COST DECIMAL(15,2) NOT NULL,
SC_TOTAL DECIMAL(15,2) NOT NULL,
SC_SHIP_TYPE VARCHAR2(10),
PRIMARY KEY(SC_ID),
FOREIGN KEY(SC_C_ID) REFERENCES CUSTOMER(C_ID)
);
-- ON DELETE CASCADE);

CREATE TABLE S_C_L
(SCL_I_ID INT NOT NULL,
SCL_SC_ID INT NOT NULL,
SCL_QTY INT NOT NULL,
SCL_COST DECIMAL(15,2) NOT NULL,
SCL_SRP DECIMAL(15,2) NOT NULL,
SCL_TITLE VARCHAR2(30),
SCL_BACKING VARCHAR2(15),
PRIMARY KEY(SCL_I_ID,SCL_SC_ID),
FOREIGN KEY(SCL_I_ID) REFERENCES ITEM(I_ID),
FOREIGN KEY(SCL_SC_ID) REFERENCES SHOPPING_CART(SC_ID)
);
-- ON DELETE CASCADE);
