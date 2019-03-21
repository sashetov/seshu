declare -g DEBUG=0;                                                           #WHETHER TO DO XTRACE DEBUGGING OR NOT
export TERM='screen-256color';                                                #TERMINAL TWEAKS ETC
export COLORTERM='truecolor';                                                 #USED BY CERTAIN COLOR TERMINAL EMULATORS
export PS1_TYPE='DATE_TIME_CWD';                                              #PROMPT TYPE OPTIONS
export GIT_BRANCH_PS1=1;                                                      #PRINT GIT BRANCH IN PS1
export ENABLE_RANDOM_IMAGES_DISPLAY=0;                                        #USE W3MIMG TO DISPLAY RAND IMG IN CONSOLE VIA /DEV/FB0
export ALWAYS_RECORD='1';                                                     #ALWAYS RECORD TERM SESSION WHEN STARTING SCREEN ETC
export LOGDIR="";                                                             #PHYSICAL LOGFILE DIR FOR DOLOG
export ALTOPT="/srv/data/opt";                                                #ALT PYTHON #TODO: NOT A GOOD SOLUTION FOR SYSTEM PYTHON - EITHER MAKE IT BETTER OR LEARN HOW TO USE THE SYSTEM
export SYSTEM_PYTHON="/usr/bin/python2.7"                                     #SYSTEM PYTHON 
export SYSTEM_PY3="/usr/bin/python3.5";                                       #SYSTEM PY2
export DEFAULT_VENV_PY3="/srv/data/altpython/venvs/3.6.1-generic/bin/";       #ALTPY3
export DEFAULT_VENV_PY2="/srv/data/altpython/venvs/bpython-2.7.13/bin/";      #ALTPY2
export PERL_LOCAL_LIB_ROOT="$HOME/perl5";                                     #PERL LOCAL DIR
export PERL5LIB="$PERL_LOCAL_LIB_ROOT/lib/perl5";                             #LIB DIR ROOT
export PERL_MB_OPT="--install_base '$PERL_LOCAL_LIB_ROOT'";                   #MB_OPT
export PERL_MM_OPT=" INSTALL_BASE=$HOME/perl5";                               #MM_OPT
export BCC_TOOLS="/usr/share/bcc/tools/";                                     #BCC TOOLS
export R2PM_DBDIR="/srv/data/src/radare2-pm/db";                              #RADARE2 R2PM
export EDITOR='/usr/bin/vim';                                                 #EDITOR
export BROWSER='/usr/bin/w3m';                                                #BROWSER
export PAGER='less';                                                          #PAGER
export LESSOPEN='||/usr/bin/lesspipe.sh %s';                                  #LESSOPEN
export LESS='SRC';                                                            #LESS
export MANOPT='';                                                             #MANOPTS
export MANPAGER='';                                                           #MANPAGER - EMPTY BUT ALIAS FOR MAN RUNS MANWRAPPER WHICH SETS THIS MANUALLY
export MANWIDTH='';                                                           #UNSET HERE, SET IN MANWRAPPER
export _JAVA_AWT_WM_NONREPARENTING=1;                                         #PREVENTS WHITE WINDOW IN DWM for java apps
export PKG_CONFIG_PATH="/usr/lib64/pkgconfig/";                               #PKG_CONFIG_PATH
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/lib/pkgconfig/";
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig/";
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/share/pkgconfig/";
export PATH_ORIG="$PATH";                                                     #ORIGINAL PATH SETTINGS SAVED IN PATH_ORIG
export PATH="$ALTOPT";                                                        #PATH
export PATH+=":$DEFAULT_VENV_PY3";
export PATH+=":$DEFAULT_VENV_PY2";
export PATH+=":$SHUTILS_DIR/:$SHU_BIND/";
export PATH+=":$PERL_LOCAL_LIB_ROOT/bin";
export PATH+=":$BCC_TOOLS";
export PATH+=":$PATH_ORIG";
export PATH="$(ordered_uniq_path)";                                           #PATH IS OK NOW - CAN NOW SET ENV VARS FOR BINARIES IN THIS PATH
