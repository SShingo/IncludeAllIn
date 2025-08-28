/*** HELP START ***//*
   %macro IncludeAllIn(
                  i_dir_path                    /* Full path of directory where .sas files to be included stored */
                  , i_is_recursive =            /* (Optional)Flag to specify if .sas files in sub-directories of "i_dir_path" will be included or not(default: 1) */
                  , i_exc_dirname_regex =       /* (Optional)Regular expression for directory name to be excluded. */
                  , i_exc_filename_regex =      /* (Optional)Regular expression for file name(without extension) to be excluded. */
                  , i_leading_files =           /* (Optional)List of files to be included preferentially */
                  , i_trailing_files =          /* (Optional)List of files to be included lastly */
                  , i_including_mode =          /* (Optional)Including mode (RELEAS/DEBUG) (default: RELEASE) */
                  , i_is_verbose =              /* (Optional)Flag of verbose log (defulat: 0) */
                  )
*//*** HELP END ***/
/*===================================================================================*/
/* IncludeAllIn
/*
/* Description
/*    指定ディレクトリ内（サブディレクトリも含む）の .sas ファイルを一括インクルードします
/*
/* Arguments
/*    i_dir_path           : （必須）読み込み対象ディレクトリパス）
/*    i_is_recursive       : （オプション）サブディレクトリも読み込むか否か（デフォルト: 1）
/*    i_exc_dirname_regex  : （オプション）除外ディレクトリ名フィルタ（正規表現）
/*    i_exc_filename_regex : （オプション）除外ファイル名フィルタ（拡張子を覗いた部分に対する正規表現）
/*    i_leading_files      : （オプション）優先読込ファイルリスト（'|' 区切りで複数指定可）
/*    i_trailing_files     : （オプション）劣後読込ファイルリスト（'|' 区切りで複数指定可）
/*    i_including_mode     : （オプション）読み込みモード（RELEASE/DEBUG）（デフォルト：モードなし）
/*    i_is_verbose         : （オプション）冗長ログ出力フラグ（デフォルト：0）
/*===================================================================================*/
%macro IncludeAllIn(i_dir_path
                  , i_is_recursive = 1
                  , i_exc_dirname_regex =
                  , i_exc_filename_regex =
                  , i_leading_files =
                  , i_trailing_files =
                  , i_including_mode = RELEASE
                  , i_is_verbose = 0);
   /* Step1. Preparation */
   %local _path_separator;
   %if (%upcase(&sysscpl.) = LINUX) %then %do;
      %let _path_separator = /;
   %end;
   %else %do;
      %let _path_separator = \;
   %end;
   %local _dir_path_in_message;
   %if (&i_is_recursive.) %then %do;
      %let _dir_path_in_message = "&i_dir_path." and sub-directories;
   %end;
   %else %do;
      %let _dir_path_in_message = "&i_dir_path.";
   %end;
   %local _mode;
   %if (%upcase(&i_including_mode.) ne DEBUG) %then %do;
      %let _mode = RELEASE;
   %end;
   %else %do;
      %let _mode = %upcase(&i_including_mode.);
   %end;
   %local _exc_dir_regex;
   %let _exc_dir_regex = &i_exc_dirname_regex.;
   %if (%sysevalf(%superq(i_exc_dirname_regex) =, boolean)) %then %do;
      %let _exc_dir_regex = <NONE>;
   %end;
   %local _exc_file_regex;
   %let _exc_dir_regex = &i_exc_filename_regex.;
   %if (%sysevalf(%superq(i_exc_filename_regex) =, boolean)) %then %do;
      %let _exc_file_regex = <NONE>;
   %end;
   %put Including all .sas files in &_dir_path_in_message.;
   %put Includeing Mode                : &_mode.;
   %put Excluding Dirname filter regex : &_exc_dir_regex.;
   %put Excluding Filename filter regex: &_exc_file_regex.;

   /* Step2. Collecting .sas files */
   %local /readonly _TMPDS_INCLUDING_FILE_LIST_ = WORK.___SAS_FILE_LIST___;
   %local _no_of_sas_files;
   %local /readonly _TEMP_OPTIONS_DS = WORK._TEMP_OPTIONS_DS;
   %if (not &i_is_verbose.) %then %do;
      proc optsave out = &_TEMP_OPTIONS_DS.;
      run;
      quit;
      options nonotes;
   %end;
	%Prv_IAI__MakeSASFileList(i_dir_path = &i_dir_path.
                           , i_path_separator = &_path_separator.
                           , i_is_recursive = &i_is_recursive.
                           , i_exc_dirname_regex = &i_exc_dirname_regex.
                           , i_exc_filename_regex = &i_exc_filename_regex.
                           , i_leading_files = &i_leading_files.
                           , i_trailing_files = &i_trailing_files.
                           , ods_output_ds = &_TMPDS_INCLUDING_FILE_LIST_.
                           , ovar_no_of_sas_files = _no_of_sas_files)
	%if (1 <= &_no_of_sas_files.) %then %do;
   /* Step3. Including all files */
   	%put &_no_of_sas_files. .sas file(s) found in the directory.;
      %Prv_IAI__DoIncludingProcess(ids_files = &_TMPDS_INCLUDING_FILE_LIST_.
                                 , i_no_of_sas_files = &_no_of_sas_files.
                                 , i_including_mode = &_mode.
                                 , i_is_verbose = &i_is_verbose.)
	%end;
   %else %do;
		%put No .sas file found;
   %end;
	proc delete
		data = &_TMPDS_INCLUDING_FILE_LIST_.;
	run;
   %if (not &i_is_verbose.) %then %do;
      proc optload data = &_TEMP_OPTIONS_DS.(where = (upcase(optname) = 'NOTES'));
      run;
      quit;
	proc delete
		data = &_TEMP_OPTIONS_DS.;
	run;
   %end;
%mend IncludeAllIn;
