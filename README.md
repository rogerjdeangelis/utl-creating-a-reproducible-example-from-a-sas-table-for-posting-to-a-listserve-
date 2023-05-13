# utl-creating-a-reproducible-example-from-a-sas-table-for-posting-to-a-listserve-
Creating a reproducible example from a sas table for posting to a listserve FOR POSTERS
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

    filename mc url "https://raw.githubusercontent.com/sasjs/core/main/all.sas";
    %inc mc;

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
    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
