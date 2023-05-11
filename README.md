# utl-creating-a-reproducible-example-from-a-sas-table-for-posting-to-a-listserve-
Creating a reproducible example from a sas table for posting to a listserve FOR POSTERS

    %let pgm=utl-creating-a-reproducible-example-from-a-sas-table-for-posting-to-a-listserve ;

    Creating a reproducible example from a sas table for posting to a listserve

    Sometimes called 'Creating a flatfile';

    github
    https://tinyurl.com/3df37hz9
    https://github.com/rogerjdeangelis/utl-creating-a-reproducible-example-from-a-sas-table-for-posting-to-a-listserve-

    This is not a finished product but it may help when submitting reproducible
    postings to a listserve. I suspect you may need to edit the output.

    I prety sure it will not work for all sas tables and you have to cut from
    the log and pase into your program.

    The problem

       Convert a sas table to a cars input datastep

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
            |_|
    */

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

    /*         _       _   _
     ___  ___ | |_   _| |_(_) ___  _ __
    / __|/ _ \| | | | | __| |/ _ \| `_ \
    \__ \ (_) | | |_| | |_| | (_) | | | |
    |___/\___/|_|\__,_|\__|_|\___/|_| |_|

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

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */

