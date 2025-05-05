-- Create table
create table tmp_DIAR_SAMPLES
(
  SAM_RES_YEAR          NUMBER(4) not null,
  SAM_RSC_CODE          VARCHAR2(4) not null,
  SAM_CODE              VARCHAR2(8) not null,
  SAM_CREATED_BY        VARCHAR2(30),
  SAM_CHANGED_BY        VARCHAR2(30),
  SAM_DATE_CREATED      DATE,
  SAM_DATE_CHANGED      DATE,
  SAM_NUMBER_NEW        NUMBER(2),
  SAM_CURRENT_STATE     VARCHAR2(1),
  SAM_AGR_OCCUPATION    VARCHAR2(1),
  SAM_NEW_GEOCODE       VARCHAR2(8),
  SAM_TRAINING          VARCHAR2(1),
  SAM_TRAINING_LEVEL    VARCHAR2(1),
  SAM_CONSUMPTION       VARCHAR2(1),
  SAM_SALE              VARCHAR2(1),
  SAM_OTHER_POSITION    VARCHAR2(1),
  SAM_OTHER_GEOCODE     VARCHAR2(8),
  SAM_OTHER_AREA        NUMBER(9,2),
  SAM_OTHER_STAVLOI     NUMBER(9,2),
  SAM_CURRENT_AREA      NUMBER(9,2),
  SAM_CURRENT_STAVLOI   NUMBER(9,2),
  SAM_FACE              VARCHAR2(1),
  SAM_DURATION          VARCHAR2(2),
  SAM_DATE              DATE,
  SAM_COOPERATION       VARCHAR2(1),
  SAM_NOTES             VARCHAR2(4000),
  SAM_GEOCODE           VARCHAR2(8),
  SAM_NEW_LAST_NAME     VARCHAR2(50),
  SAM_NEW_FIRST_NAME    VARCHAR2(30),
  SAM_NEW_FATHERNAME    VARCHAR2(25),
  SAM_NEW_BIRTH_YR      NUMBER(4),
  SAM_NEW_IDCARD        VARCHAR2(8),
  SAM_NEW_LEGALPERS     VARCHAR2(80),
  SAM_NEW_AFM           VARCHAR2(10),
  SAM_NEW_STREET        VARCHAR2(50),
  SAM_NEW_STREET_NUMBER VARCHAR2(4),
  SAM_NEW_ZIPCODE       VARCHAR2(5),
  SAM_NEW_TEL           VARCHAR2(15),
  SAM_BIO_ZWA_FLG       NUMBER(1)
)
tablespace PRODSTAT
  pctfree 10
  pctused 40
  initrans 1
  maxtrans 255
  storage
  (
    initial 512K
    next 20M
    minextents 1
    maxextents 4000
    pctincrease 0
  );
-- Add comments to the table 
comment on table SPR_DIAR_SAMPLES
  is '������ �������������� ����������';
-- Add comments to the columns 
comment on column SPR_DIAR_SAMPLES.SAM_RES_YEAR
  is '���� ������� ';
comment on column SPR_DIAR_SAMPLES.SAM_RSC_CODE
  is '������� �������';
comment on column SPR_DIAR_SAMPLES.SAM_CODE
  is '������� �������������';
comment on column SPR_DIAR_SAMPLES.SAM_NUMBER_NEW
  is '������� ���� �������������� ��� ��������� ��� �������� (2.1.�4.�)';
comment on column SPR_DIAR_SAMPLES.SAM_CURRENT_STATE
  is '�������� ��������� ��� ������� (2.1.�)';
comment on column SPR_DIAR_SAMPLES.SAM_AGR_OCCUPATION
  is '� ����������������� ������� ����������� ����� �� �� �������? (2.1.�)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_GEOCODE
  is '����������� ������� ��� ���� ������������� (2.3)';
comment on column SPR_DIAR_SAMPLES.SAM_TRAINING
  is '� ������� ���� ����������� �� �������� ������? (3.3.1)';
comment on column SPR_DIAR_SAMPLES.SAM_TRAINING_LEVEL
  is '������� ��������� ����������� (3.3.2)';
comment on column SPR_DIAR_SAMPLES.SAM_CONSUMPTION
  is '���������� ��� ��������� (4.1)';
comment on column SPR_DIAR_SAMPLES.SAM_SALE
  is '������ ��� ��������� (4.2)';
comment on column SPR_DIAR_SAMPLES.SAM_OTHER_POSITION
  is '���� ��� ������������� (7.1)';
comment on column SPR_DIAR_SAMPLES.SAM_OTHER_GEOCODE
  is '����������� ������� ��� ����� ��� ������������� (7.2)';
comment on column SPR_DIAR_SAMPLES.SAM_OTHER_AREA
  is '���������������� ������ ��������� ��� ��� ��������� �� ���� ���� (7.2.�)';
comment on column SPR_DIAR_SAMPLES.SAM_OTHER_STAVLOI
  is '���������������� ������ ������������ ������������� ��� ��������� �� ���� ���� (7.2.�)';
comment on column SPR_DIAR_SAMPLES.SAM_CURRENT_AREA
  is '���������������� ������ ��������� ��� ��� ��������� ��� ���� ��������� (7.2.�)';
comment on column SPR_DIAR_SAMPLES.SAM_CURRENT_STAVLOI
  is '���������������� ������ ������������ ������������� ��� ��������� ��� ���� ��������� (7.2.�)';
comment on column SPR_DIAR_SAMPLES.SAM_FACE
  is '������� ��� ����� ��� ���������� (34)';
comment on column SPR_DIAR_SAMPLES.SAM_DURATION
  is '�������� ����������� (34)';
comment on column SPR_DIAR_SAMPLES.SAM_DATE
  is '���������� ����������� (34)';
comment on column SPR_DIAR_SAMPLES.SAM_COOPERATION
  is '������ ����������� (34)';
comment on column SPR_DIAR_SAMPLES.SAM_NOTES
  is '������������ (34)';
comment on column SPR_DIAR_SAMPLES.SAM_GEOCODE
  is '����������� ������� ���������������';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_LAST_NAME
  is '������� ���� ������� (��� 2.2)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_FIRST_NAME
  is '����� ���� ������� (��� 2.2)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_FATHERNAME
  is '��������� ���� ������� (��� 2.2)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_BIRTH_YR
  is '���� �������� ���� ������� (��� 2.2)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_IDCARD
  is '������� ����������� ���������� ���� ������� (��� 2.2)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_LEGALPERS
  is '�������� ���� ������� (��� 2.2)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_AFM
  is '�.�.�. ���� ������� (��� 2.2)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_STREET
  is '���� ��� ���� ������������� (2.3)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_STREET_NUMBER
  is '������� ���� ��� ���� ������������� (2.3)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_ZIPCODE
  is '������������ ������� ��� ���� ������������� (2.3)';
comment on column SPR_DIAR_SAMPLES.SAM_NEW_TEL
  is '�������� ��� ���� ������������� (2.3)';
comment on column SPR_DIAR_SAMPLES.SAM_BIO_ZWA_FLG
  is '��������� ����� ��� �� �� � ������������ ��������� ��������� ������� �� ��� (flag=1), �� ������ (2) � �� ������ (default = null) ��� �� ��� ��� (��� 14.2)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_DIAR_SAMPLES
  add constraint TMP_DIAR_SAMPLES_PK primary key (SAM_RES_YEAR, SAM_RSC_CODE, SAM_CODE)
  using index 
  tablespace PRODSTAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 512K
    next 512K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
alter table TMP_DIAR_SAMPLES
  add constraint TMP_DIAR_SAMPLES_FK foreign key (SAM_RES_YEAR, SAM_RSC_CODE, SAM_CODE)
  references TMP_SAMPLES (SAM_RES_YEAR, SAM_RSC_CODE, SAM_CODE)
  disable; 
 
