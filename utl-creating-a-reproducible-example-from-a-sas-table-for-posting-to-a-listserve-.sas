%let pgm=utl-creating-a-reproducible-example-from-a-sas-table-for-posting-to-a-listserve ;

Creating a reproducible example from a sas table for posting to a listserve

/*----

The problem

   Convert a sas table to a cards input datastep

   Sometimes called 'Creating a flatfile'

      Solutions

         1. SAS array varlist

         2. Alan's macro (better choice - more likely to handle your dataset)
            https://core.sasjs.io/mp__ds2cards_8sas.html
            Allan Bowe <allan@BOWE.IO>
            Native code (no need for %array or %utl_varlist)
            You really need to spend some time looking over
            Alan et all at.

            https://github.com/sasjs
            https://github.com/sasjs/core

            There is a lot of good stuff in these repos.
            Much more useful than my hacks,

         2. data2datastep,sas
            I added code to send the output code to the log for cutting and pasteing
            https://github.com/SASJedi/sas-macros

macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

github
https://tinyurl.com/3df37hz9
https://github.com/rogerjdeangelis/utl-creating-a-reproducible-example-from-a-sas-table-for-posting-to-a-listserve-

This is not a finished product but it may help when submitting reproducible
postings to a listserve. I suspect you may need to edit the output.

I pretty sure it will not work for all sas tables and you have to cut from
the log and paste into your program and edit.

----*/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
----*/

/*---- 5 records from sashelp.class ----*/

data have;
  set sashelp.class(obs=5);
run;quit;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/* In the SAS Log                                                                                                         */
/*                                                                                                                        */
/* data have;informat                                                                                                     */
/* NAME $8.                                                                                                               */
/* SEX $1.                                                                                                                */
/* AGE 8.                                                                                                                 */
/* HEIGHT 8.                                                                                                              */
/* WEIGHT 8.                                                                                                              */
/* ;input                                                                                                                 */
/* NAME SEX AGE HEIGHT WEIGHT;                                                                                            */
/* cards4;                                                                                                                */
/* Alfred M 14 69 112.5                                                                                                   */
/* Alice F 13 56.5 84                                                                                                     */
/* Barbara F 13 65.3 98                                                                                                   */
/* Carol F 14 62.8 102.5                                                                                                  */
/* Henry M 14 63.5 102.5                                                                                                  */
/* ;;;;                                                                                                                   */
/* run;quit;                                                                                                              */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _
/ |    ___  __ _ ___   _ __ ___   __ _  ___ _ __ ___     __ _ _ __ _ __ __ _ _   _
| |   / __|/ _` / __| | `_ ` _ \ / _` |/ __| `__/ _ \   / _` | `__| `__/ _` | | | |
| |_  \__ \ (_| \__ \ | | | | | | (_| | (__| | | (_) | | (_| | |  | | | (_| | |_| |
|_(_) |___/\__,_|___/ |_| |_| |_|\__,_|\___|_|  \___/   \__,_|_|  |_|  \__,_|\__, |
                                                                             |___/
*/

%let _vls=%utl_varlist(have) ;
%array(_var,values=&_vls);

data _null_;
  set have end=dne;
  if _n_=1 then do;
     put "data have;informat ";
     %do_over(_var,phrase=%str(
         if vtype(?) ne "N" then typ='$';
         else typ = "";
         typLen = cats(typ,vlength(?),'.');
         put "?" +1 typLen;
         )
     );
     put ';input';
     put "&_vls;";
     put 'cards4;';
     if dne then put ';run;quit;';
  end;

  put &_vls ;
  if dne then put ';;;;' / 'run;quit;';

run;quit;

/*---- cleanup ----*/
%arraydelete(_var);
%symdel _vls / nowarn;

/*  _    _
   / \  | | __ _ _ __  ___   _ __ ___   __ _  ___ _ __ ___
  / _ \ | |/ _` | `_ \/ __| | `_ ` _ \ / _` |/ __| `__/ _ \
 / ___ \| | (_| | | | \__ \ | | | | | | (_| | (__| | | (_) |
/_/   \_\_|\__,_|_| |_|___/ |_| |_| |_|\__,_|\___|_|  \___/

*/

data have;
  set sashelp.class(obs=5);
run;quit;

/*---- There are are many options.  ----*/
/*---- This a minimal call          ----*/
/*---- Cut and paste from the log   ----*/
/*----Has options to write to a file----*/

%utl_ds2cards(
    have
   ,tgt_ds=class_cards want
   );

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  FROM THE LOG                                                                                                          */
/*                                                                                                                        */
/*  data WORK.have ;                                                                                                      */
/*  attrib                                                                                                                */
/*  NAME                             length= $8                                                                           */
/*  SEX                              length= $1                                                                           */
/*  AGE                              length= 8                                                                            */
/*  HEIGHT                           length= 8                                                                            */
/*  WEIGHT                           length= 8                                                                            */
/*  ;                                                                                                                     */
/*  infile cards dsd;                                                                                                     */
/*  input                                                                                                                 */
/*    NAME                             :$char.                                                                            */
/*    SEX                              :$char.                                                                            */
/*    AGE                                                                                                                 */
/*    HEIGHT                                                                                                              */
/*    WEIGHT                                                                                                              */
/*  ;                                                                                                                     */
/*  missing a b c d e f g h i j k l m n o p q r s t u v w x y z _;                                                        */
/*  datalines4;                                                                                                           */
/*  Alfred,M,14,69,112.5                                                                                                  */
/*  Alice,F,13,56.5,84                                                                                                    */
/*  Barbara,F,13,65.3,98                                                                                                  */
/*  Carol,F,14,62.8,102.5                                                                                                 */
/*  Henry,M,14,63.5,102.5                                                                                                 */
/*  ;;;;                                                                                                                  */
/*  run;                                                                                                                  */
/*                                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____        _       _        ____     _       _            _
|___ /     __| | __ _| |_ __ _|___ \ __| | __ _| |_ __ _ ___| |_ ___ _ __
  |_ \    / _` |/ _` | __/ _` | __) / _` |/ _` | __/ _` / __| __/ _ \ `_ \
 ___) |  | (_| | (_| | || (_| |/ __/ (_| | (_| | || (_| \__ \ ||  __/ |_) |
|____(_)  \__,_|\__,_|\__\__,_|_____\__,_|\__,_|\__\__,_|___/\__\___| .__/
                                                                    |_|
*/

/*---- cut and paste from log ----*/
%utl_data2datastep(sashelp.class);

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  data WORK.CLASS(label='Student Data');                                                                                */
/*    infile datalines dsd truncover;                                                                                     */
/*    input NAME:$8. SEX:$1. AGE:32. HEIGHT:32. WEIGHT:32.;                                                               */
/*  datalines4;                                                                                                           */
/*  Alfred M 14 69 112.5                                                                                                  */
/*  Alice F 13 56.5 84                                                                                                    */
/*  Barbara F 13 65.3 98                                                                                                  */
/*  Carol F 14 62.8 102.5                                                                                                 */
/*  Henry M 14 63.5 102.5                                                                                                 */
/*  James M 12 57.3 83                                                                                                    */
/*  Jane F 12 59.8 84.5                                                                                                   */
/*  Janet F 15 62.5 112.5                                                                                                 */
/*  Jeffrey M 13 62.5 84                                                                                                  */
/*  John M 12 59 99.5                                                                                                     */
/*  Joyce F 11 51.3 50.5                                                                                                  */
/*  Judy F 14 64.3 90                                                                                                     */
/*  Louise F 12 56.3 77                                                                                                   */
/*  Mary F 15 66.5 112                                                                                                    */
/*  Philip M 16 72 150                                                                                                    */
/*  Robert M 12 64.8 128                                                                                                  */
/*  Ronald M 15 67 133                                                                                                    */
/*  Thomas M 11 57.5 85                                                                                                   */
/*  William M 15 66.5 112                                                                                                 */
/*  ;;;;                                                                                                                  */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

%utl_data2datastep(sashelp.class);

filename ft15f001 "c:/oto/utl_data2datastep.sas";
parmcards4;
%macro utl_data2datastep(dsn,lib,outlib,file,obs,fmt,lbl);
%local varlist fmtlist inputlist msgtype ;

%if %superq(obs)= %then %let obs=MAX;

%let msgtype=NOTE;
%if %superq(dsn)= %then %do;
   %let msgtype=ERROR;
   %put &msgtype: * &SYSMACRONAME ERROR ************************************;
   %put &msgtype: You must specify a data set name;
%syntax:
   %put;
   %put &msgtype- Purpose: Converts a data set to a SAS DATA step.;
   %put &msgtype- Syntax: %nrstr(%%)&SYSMACRONAME(dsn<,lib,outlib,file,obs,fmt,lbl>);
   %put &msgtype- dsn:    Name of the dataset to be converted. Required.;
   %put &msgtype- lib:    LIBREF of the original dataset. (Optional);
   %put &msgtype- outlib: LIBREF for the output dataset. (Optional);
   %put &msgtype- file:   Fully qualified filename for DATA step code. (Optional);
   %put &msgtype-         Default is %nrstr(create_&outlib._&dsn._data.sas);
   %put &msgtype-         in the SAS default directory.;
   %put &msgtype- obs:    Max observations to include the created dataset.;
   %put &msgtype-         (Optional) Default is MAX (all observations);
   %put &msgtype- fmt:    Copy numeric variable formats?;
   %put &msgtype-         (YES|NO - Optional) Default is YES;
   %put &msgtype- lbl:    Copy column labels? ;
   %put &msgtype-         (YES|NO - Optional) Default is YES;
   %put;
   %put NOTE:   &SYSMACRONAME cannot be used in-line - it generates code.;
   %put NOTE-   CAVEAT: Numeric FORMATS in the original data must have a ;
   %put NOTE-           corresponding INFORMAT of the same name.;
   %put NOTE-           Character formats are ingnored.;
   %put NOTE-   Data set label is automatically re-created.;
   %put;
   %put NOTE-   Use ? to print these notes.;
   %put;
   %return;
%end;
%let dsn=%qupcase(%superq(dsn));
%if %superq(dsn)=? %then %do;
   %put &msgtype: * &SYSMACRONAME help ************************************;
   %goto Syntax;
%end;
%if %superq(fmt)= %then %let fmt=YES;
%let fmt=%qupcase(&fmt);
%if %superq(lbl)= %then %let lbl=YES;
%let lbl=%qupcase(&lbl);

%if %superq(lib)= %then %do;
    %let lib=%qscan(%superq(dsn),1,.);
    %if %superq(lib) = %superq(dsn) %then %let lib=WORK;
    %else %let dsn=%qscan(&dsn,2,.);
%end;
%if %superq(outlib)= %then %let outlib=WORK;
%let lib=%qupcase(%superq(lib));
%let dsn=%qupcase(%superq(dsn));

%if %sysfunc(exist(&lib..&dsn)) ne 1 %then %do;
   %put ERROR: (&SYSMACRONAME) - Dataset &lib..&dsn does not exist.;
   %let msgtype=NOTE;
   %GoTo syntax;
%end;

%if %superq(file)= %then %do;
   %let file=create_&outlib._&dsn._data.sas;
   %if %symexist(USERDIR) %then %let file=&userdir/&file;
%end;

%if %symexist(USERDIR) %then %do;
   %if %qscan(%superq(file),-1,/\)=%superq(file) %then
      %let file=&userdir/&file;
%end;

proc sql noprint;
select Name
      into :varlist separated by ' '
   from dictionary.columns
   where libname="&lib"
     and memname="&dsn"
;
select case type
          when 'num' then
             case
                when missing(format) then cats(Name,':32.')
                else cats(Name,':',format)
             end
          else cats(Name,':$',length,'.')
       end
      into :inputlist separated by ' '
   from dictionary.columns
   where libname="&lib"
     and memname="&dsn"
;
%if %qsubstr(%superq(lbl),1,1)=Y %then %do;
select strip(catx('=',Name,put(label,$quote.)))
   into : lbllist separated by ' '
   from dictionary.columns
   where libname="&lib"
     and memname="&dsn"
     and label is not null
;
%end;
%else %let lbllist=;
select memlabel
   into :memlabel trimmed
   from dictionary.tables
   where libname="&lib"
     and memname="&dsn"
;
%if %qsubstr(%superq(fmt),1,1)=Y %then %do;
select strip(catx(' ',Name,format))
      into :fmtlist separated by ' '
   from dictionary.columns
   where libname="&lib"
     and memname="&dsn"
     and format is not null
     and format not like '$%'
;
%end;
%else %let fmtlist=;
quit;

%put _local_;

data _null_;
   file "%superq(file)" dsd;
   if _n_ =1 then do;
   %if %superq(memlabel)= %then %do;
      put "data &outlib..&dsn;";
   %end;
   %else %do;
      put "data &outlib..&dsn(label=%tslit(%superq(memlabel)));";
   %end;
      put @3 "infile datalines dsd truncover;";
      put @3 "input %superq(inputlist);";
   %if not (%superq(fmtlist)=) %then %do;
      put @3 "format %superq(fmtlist);";
   %end;
   %if not (%superq(lbllist)=) %then %do;
      put @3 "label %superq(lbllist);";
   %end;
      put "datalines4;";
   end;
   set &lib..&dsn(obs=&obs) end=__last;
   put &varlist @;
   if __last then do;
      put;
      put ';;;;';
   end;
   else put;
run;

data _null_;
   file "%superq(file)" dsd;
   if _n_ =1 then do;
   %if %superq(memlabel)= %then %do;
      putlog "data &outlib..&dsn;";
   %end;
   %else %do;
      putlog "data &outlib..&dsn(label=%tslit(%superq(memlabel)));";
   %end;
      putlog @3 "infile datalines dsd truncover;";
      putlog @3 "input %superq(inputlist);";
   %if not (%superq(fmtlist)=) %then %do;
      putlog @3 "format %superq(fmtlist);";
   %end;
   %if not (%superq(lbllist)=) %then %do;
      putlog @3 "label %superq(lbllist);";
   %end;
      putlog "datalines4;";
   end;
   set &lib..&dsn(obs=&obs) end=__last;
   putlog &varlist @;
   if __last then do;
      putlog;
      putlog ';;;;';
   end;
   else putlog;
run;
%mend utl_data2datastep;
;;;;
run;quit;
