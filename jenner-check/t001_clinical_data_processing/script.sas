/*========================================================
 Project Name : Clinical Data Processing using SAS
 Author       : Nithish M S
 Description  : Real-time clinical data examples using
                DATA step, SET, MERGE, KEEP, DROP, RENAME,
                WHERE, FIRSTOBS, OBS and PROC PRINT
========================================================*/

/*--------------------------------------------------------
 Global Options
--------------------------------------------------------*/
OPTIONS NOCENTER MISSING=0;

/*--------------------------------------------------------
 1. DEMOGRAPHICS DATASET (DM)
    One record per subject
--------------------------------------------------------*/
DATA DM;
LENGTH USUBJID $10 SEX $1 ARM $10;
INPUT USUBJID $ AGE SEX $ ARM $;
CARDS;
SUB001 45 M PLACEBO
SUB002 52 F DRUGA
SUB003 38 M DRUGA
SUB004 60 F PLACEBO
RUN;

/*--------------------------------------------------------
 2. LABORATORY DATASET (LB)
    Multiple records per subject
--------------------------------------------------------*/
DATA LB;
LENGTH USUBJID $10 TEST $10;
INPUT USUBJID $ TEST $ RESULT;
CARDS;
SUB001 HB 13.2
SUB001 ALT 35
SUB002 HB 12.1
SUB002 ALT 55
SUB003 HB 14.0
SUB004 ALT 60
RUN;

/*--------------------------------------------------------
 3. SET STATEMENT
    Copy dataset
--------------------------------------------------------*/
DATA DM_COPY;
SET DM;
RUN;

/*--------------------------------------------------------
 4. KEEP OPTION
    Retain required variables only
--------------------------------------------------------*/
DATA DM_KEEP;
SET DM(KEEP=USUBJID ARM);
RUN;

/*--------------------------------------------------------
 5. DROP OPTION
    Remove unwanted variables
--------------------------------------------------------*/
DATA DM_DROP;
SET DM(DROP=AGE);
RUN;

/*--------------------------------------------------------
 6. RENAME OPTION
    Rename variables for standardization
--------------------------------------------------------*/
DATA DM_RENAME;
SET DM(RENAME=(USUBJID=SUBJID ARM=TRT));
RUN;

/*--------------------------------------------------------
 7. WHERE CONDITION
    Filter abnormal lab values
--------------------------------------------------------*/
DATA HIGH_ALT;
SET LB;
WHERE TEST='ALT' AND RESULT > 50;
RUN;

/*--------------------------------------------------------
 8. FIRSTOBS & OBS
    Partial data review (QC purpose)
--------------------------------------------------------*/
PROC PRINT DATA=LB(FIRSTOBS=1 OBS=4);
TITLE 'Partial Laboratory Data Review';
RUN;

/*--------------------------------------------------------
 9. MERGE
    Combine Demographics with Laboratory data
--------------------------------------------------------*/
PROC SORT DATA=DM; BY USUBJID; RUN;
PROC SORT DATA=LB; BY USUBJID; RUN;

DATA LB_DM;
MERGE LB DM;
BY USUBJID;
RUN;

/*--------------------------------------------------------
 10. INNER JOIN using IN= option
--------------------------------------------------------*/
DATA LB_INNER;
MERGE LB(IN=A) DM(IN=B);
BY USUBJID;
IF A AND B;
RUN;

/*--------------------------------------------------------
 11. Derived Variable
    Flag high ALT values
--------------------------------------------------------*/
DATA LB_FLAG;
SET LB;
IF TEST='ALT' AND RESULT > 50 THEN FLAG='HIGH';
ELSE FLAG='NORMAL';
RUN;

/*--------------------------------------------------------
 12. PROC PRINT
    Final clinical listing
--------------------------------------------------------*/
PROC PRINT DATA=LB_FLAG NOOBS;
TITLE 'Laboratory Results with Abnormal Flag';
RUN;

/*====================== END OF PROGRAM ==================*/
