export COMMON_INC=${BASH_SOURCE[0]}; #THIS FILE
export MAXARGC=100000;
export LOG_BUFFER_LEN='0';
export ECHO_MODE=color;
export SPACER;
export UJRNLT_PID;
export LOG_TO_SYSLOG=1;
export LOGDIR;
function shu_init(){
  export SHUTILS_DIR="$HOME/bin";
  export INIT_SHUTILS="$SHUTILS_DIR/p.sh";
  . $INIT_SHUTILS || echo ERR_SHUTILS_INCLUDE >&2 | tee | logger -i -t shu_init;
}
function include_common(){                                                    #INCLUDE SHELL PREFS SCRIPTS FUNCTION
  . $COMMON_INC
}
function find_function_declaration() {                                        #COMMON SCRIPTING FUNCS
  shopt -s extdebug;
  declare -F $1 | awk '{ print $3":"$2":function "$1 }';
  shopt -u extdebug;
}
function check_num_params(){
  let NUM_PARAMS=$1;
  let MIN_PARAMS=$2;
  let MAX_PARAMS=$3;
  ( [ $NUM_PARAMS -lt $MIN_PARAMS ] || [ $NUM_PARAMS -gt $MAX_PARAMS ] ) && echo "ERROR: function called with NUM_PARAMS=$NUM_PARAMS, where MIN_PARAMS=$MIN_PARAMS MAX_PARAMS=$MAX_PARAMS" >&2 && exit 3;
}
function user_jrnl_tail(){
  check_num_params $# 1 1;
  journalctl -n ${LOG_BUFFER_LEN} -b 0 -f -o cat --user -t ${1} & export UJRNLT_PID=$!;
}
function logdo() {
  echo  $*;
  export SN=$( basename $0 );
  export TS=$( datets_print );
  if [ -n "$LOGDIR" ]; then
    export STDOUT_LOG="${LOGDIR}/${SN}.stdout.log";
    export STDERR_LOG="${LOGDIR}/${SN}.stderr.log";
    export MIXED_LOG="${LOGDIR}/${SN}.mixed.log";
    if [ -n "$LOG_TO_SYSLOG" ]; then
      { echo $*   2>$STDERR_LOG >$STDOUT_LOG; } |& tee -a $MIXED_LOG | logger -i -t "${SN}" &>/dev/null;
        { eval "$*" 2>>$STDERR_LOG >>$STDOUT_LOG; } |& tee -a $MIXED_LOG | logger -i -t "${SN}" &>/dev/null;
          logger -i -f $STDOUT_LOG -t "${SN}" &>/dev/null;
          logger -i -f $STDERR_LOG -t "${SN}" &>/dev/null;
        else 
          echo $*   2>$STDERR_LOG >$STDOUT_LOG;
          eval "$*" 2>>$STDERR_LOG >>$STDOUT_LOG;
        fi
      else
        if [ -n "$LOG_TO_SYSLOG" ]; then
          echo $*   | logger -i -t "${SN}" &>/dev/null;
          eval "$*" | logger -i -t "${SN}" &>/dev/null;
        else
          echo  $* ;
          eval "$*";
        fi
      fi;
    }
function print_and_do() {
    logdo $*;
}
function padl() {
  print_and_do $*;
}
function ee(){
  echo $*;
  eval $*;
}
function start_xtrace() {
  if [[ $DEBUG == 1 ]]; then {
    set -x ;
  }; fi;
}
function stop_xtrace() {
  if [[ $DEBUG == 1 ]]; then {
    set +x ;
  }; fi;
}
function exit_with_msg() {
  echo "${*:2:999999}"
  return $1
}
function printf_to_file() {
  start_xtrace
  export FN_NAME="printf_to_file";
  export FN_ARGS="FILE MODE PRINTF_TEMPLATE TEMPL_STR1 ... TEMPLATE_STR_N";
  if [[ $# -lt 2 ]]; then
    export PRINT_USAGE=0;
    stop_xtrace;
    exit_with_msg 1 "not enough arguments (NARGS=$#<2)\n args:'$*'\n";
  fi;
  FILE=$1;
  if [[ $FILE == '-' ]]; then
    PRINTF_TEMPLATE_STR=$2;
    T_ARGS_POS=3;
    MODE='';
  else 
    MODE=$2;
    PRINTF_TEMPLATE_STR=$3;
    T_ARGS_POS=4;
  fi;
  TARGS=()
  let OI=1
  for OPT; do
    if [[ $OI -ge $T_ARGS_POS ]]; then
      TARGS+=("$OPT");
    fi;
    let OI=$OI+1;
  done;
  if [[ $MODE == 'w' ]]; then
    printf "${PRINTF_TEMPLATE_STR}" "${TARGS[@]}" > $FILE
  elif [[ $MODE == 'a' ]]; then
    printf "${PRINTF_TEMPLATE_STR}" "${TARGS[@]}" >> $FILE
  else
    printf "${PRINTF_TEMPLATE_STR}" "${TARGS[@]}"
    stop_xtrace
  fi;
}
function print_ppid () {
  sudo ps -p $$ -o ppid=;
}
function is_numeric() {
  CODE=$1;
  IS_NUMERIC=1
  if [[ -z $CODE ]]; then
    return 1;
  fi;
  NUM_CHARS_NON_NUMERIC=$( printf -- '%b' "${CODE}" | sed -r 's/^-?[0-9]+//g' | wc -c );
  [[ $NUM_CHARS_NON_NUMERIC -eq 0 && -n $NUM_CHARS_NON_NUMERIC ]]
  return $?
}
function rand_num() {
  s=$1;
  e=$2;
  r="${RANDOM}";
  len=`echo "${e}-${s}" |bc `;
  part=`echo "${r}/${len}"| bc`;
  r=`echo "${r}-(${len}*${part})"|bc`;
  r=`echo "${r}+${s}"|bc`;
  echo "${r}";
}
function random_passwd_alphanum() {
  if [ $# -lt 1 ]; then n=12;
  else n=$1;
  fi;
  {
    dd if=/dev/urandom of=/dev/stdout count=1600 bs=8 2>/dev/null;
  } | tr -dc 'A-Z-a-z-0-9' | head -c $n;
printf "\n";
}
function random_passwd() {
  if [ $# -lt 1 ]; then n=12;
  else n=$1;
  fi;
  {
    dd if=/dev/urandom of=/dev/stdout count=1600 bs=8 2>/dev/null;
  } | tr -dc '_A-Z-a-z-0-9-#%\$^\&\!\@\#\\^\*\(\)\/\\-\\+' | head -c $n;
    printf "\n";# print extra newline, as its generally needed to not fuck with your prompt
  }
function random_fake_md5() {
  export N=32;
  { dd if=/dev/urandom of=/dev/stdout count=1600 bs=8 2>/dev/null; } | tr -dc 'a-f0-9' | head -c $N;
    printf "\n";
  }
function print_256_colors() { 
  for i in {0..255}; do
    printf "\e[38;5;${i}m[${i} TEXT]\e[0m ""printf '\\\\e[38;5;''${i}m''[${i} TEXT]''\\\\e[0m''\\\\n';""\n";
  done;
} #echo $( infocmp ) print color codes            # https://linux.die.net/man/5/terminfo 
function ordered_uniq_path(){
  start_xtrace
  declare -a UNIQ_SUBPATHS_SORTED=(`echo $PATH | tr ':' '\n' | sort | uniq`);
  declare -a SUBPATHS_ORDERED=(`echo $PATH | tr ':' '\n'`);
  declare -A UNIQ_ORD_SUBPATHS_COUNTS;
  declare -a UNIQ_ORD_SUBPATHS
  PATHS_NUM=${#SUBPATHS_ORDERED[*]};
  let i=0;
  while [ $i -lt $PATHS_NUM ]; do
    SUBPATH="${SUBPATHS_ORDERED[$i]}";
    if is_numeric ${UNIQ_ORD_SUBPATHS_COUNTS["$SUBPATH"]} ; then 
      let UNIQ_ORD_SUBPATHS_COUNTS["$SUBPATH"]++;
    else
      UNIQ_ORD_SUBPATHS+=($SUBPATH);
      let UNIQ_ORD_SUBPATHS_COUNTS["$SUBPATH"]=1;
    fi;
    let i++;
  done;
  echo "${UNIQ_ORD_SUBPATHS[@]}" | sed -r 's/\s+/:/g' | sed -r 's/\/+/\//g'
  stop_xtrace
}
function num_leadz() {
  export N=$1
  export L=$2
  export D=$( [[ $N -lt 0 ]] && echo +1 || echo -1 ); #whether to subtract or add the 1 in M
  export M=$( echo  "(10^$L)$D" | bc ) ;
  seq -w $N $M | head -n 1
}
function set_color_esc() {                                                    #STDOUT/ERR FUNCS
  export RES_COL=1;
  declare -A SETCOLOR_MAP=( [FAILURE]="0;31m" [WARNING]=33 [NORMAL]="0;39m" );
  export N=$1;
  case $N in
    MOVE_TO_COL) export ECHOCMD="echo -en \\033[1G"; ;;
    FAILURE) export ECHOCMD="echo -en \\033[0;31m"; ;;
    WARNING) export ECHOCMD="echo -en \\033[0;33m"; ;;
    SUCCESS) export ECHOCMD="echo -en \\033[0;32m"; ;;
    NORMAL) export ECHOCMD="echo -en \\033[0;39m"; ;;
  esac;
  $ECHOCMD;
}
function note_to_stdout() {
  check_num_params $# 3 $MAXARGC;
  [ -z "$SPACER" ] && export SPACER='' || export SPACER;
  export SCP='WARNING';
  export NOTENAME=$1;
  export PRINTF_TEMPLATE="$2";
  export PRINTF_ARGS="${@:3:$MAXARGC}";
  [ "$ECHO_MODE" = "color" ] && set_color_esc 'NORMAL' && set_color_esc 'MOVE_TO_COL' && set_color_esc $SCP;
  printf "$NOTENAME:$SPACER"
  [ "$ECHO_MODE" = "color" ] && set_color_esc 'NORMAL';
  printf "$PRINTF_TEMPLATE" $PRINTF_ARGS;
}
function echo_common() {
  check_num_params $# 4 $MAXARGC;
  export FDECL=$( find_function_declaration ${FUNCNAME[0]} );
  export SCP=$1;
  export STATUS_TXT=$2;
  export RETURN_VAL=$3;
  export PRINTF_TEMPLATE=$4
  export PRINTF_ARGS="${*:5:$MAXARGC}";
  [ -z "$SPACER" ] && export SPACER='' || export SPACER;
  [ "$ECHO_MODE" = "color" ] && set_color_esc 'NORMAL' && set_color_esc 'MOVE_TO_COL';
  printf "[";
  [ "$ECHO_MODE" = "color" ] && set_color_esc $SCP;
  printf "$STATUS_TXT";
  [ "$ECHO_MODE" = "color" ] && set_color_esc 'NORMAL';
  printf "]$SPACER";
  printf "$PRINTF_TEMPLATE" $PRINTF_ARGS;
  return ${RETURN_VAL}
}
function echo_success() {
  echo_common 'SUCCESS' 'OK' 0  "$1" "${@:2:$MAXARGC}";
}
function echo_failure() {
  echo_common 'FAILURE' "FAILED" 1 "$1" "${@:2:$MAXARGC}";
}
function echo_passed() {
  echo_common 'NORMAL' "PASSED" 0 "$1" "${@:2:$MAXARGC}";
}
function echo_warning() {
  echo_common 'WARNING' 'WARNING' 0 "$1" "${@:2:$MAXARGC}";
}
function err_to_stderr(){
  echo_failure "$@" >&2;
}
function success_to_stdout(){
  echo_success "$*";
}
function warn_to_stdout(){
  echo_warning $*;
}
function ok_to_stdout(){
  echo_success $*;
}
function passed_to_stdout(){
  echo_passed $*;
}
function print_date_custom {
  DATE=$( date +'%d/%m/%Y' ) #33
  printf '%b' $DATE;
  return $?
}
function print_time_custom {
  TIME=$(date +'%H:%M:%S');#10
  printf '%b' $TIME;
  return $?
}
function print_datets_nano(){
  date +"%D %T %N"
}
function datets_print(){
  start_xtrace
  export LEN=14;
  if test -n $1 && is_numeric $1; then
    export LEN=$1;
  fi;
  date -Iseconds | sed -r 's/[^0-9]//g' | head -c $LEN;
  stop_xtrace
}
function pfe(){ #prints file ext to stdout
  check_num_params $# 1 $MAXARGC;
  for F in "$*"; do
    echo $F | sed -r 's/^.+\.([^.]+)$/\1/g';
  done;
}
function pfne(){ #prints file w/o ext to stdout
  check_num_params $# 1 $MAXARGC;
  for F in $*; do
    echo $F | sed -r 's/^(.+)\.[^.]+$/\1/g';
  done;
}
function get_pa_in_src(){                                                     #PULSEAUDIO FUNCTIONS
  start_xtrace
  export I=$1;
  export PA_INPUTS=$( ffmpeg -f pulse -sources pulse 2>/dev/null | grep '\*' | awk '{ print $2; }' );
  declare -a PAINS=( $PA_INPUTS );
  let N=${#PAINS[*]};
  [ -z "$I" ] || [[ $I -ge $N ]] || [[ $I -lt 0 ]] && echo "INVALID PARAM: please pass number in range [0,$N) to get desired input" && exit 244;
  echo "${PAINS[$I]}";
  stop_xtrace
}
function get_display {                                                        #X11
  sudo ss -x src @/tmp/.X11-unix/* -np | grep Xorg | sed -r 's/.+unix\/X([0-9]*).+/\1/g' | sort | uniq | sort -rn | while read DISPLAY_NUM; do { echo ":$DISPLAY_NUM"; break;}; done;
}
function get_displays {                                                        #X11
  sudo ss -x src @/tmp/.X11-unix/* -np | grep Xorg | sed -r 's/.+unix\/X([0-9]*).+/\1/g' | sort | uniq | sort -rn;
}
function tmuxed_mc_session(){
  CMD="/bin/bash -l -c 'mc $*'";
  /usr/bin/tmux new-session -s $1 "$CMD"
}
function print_qs() {                                                         #TEXT BROWSING
  python3 -c "from urllib import parse; print(parse.quote_plus('$*'))";
};
function search_with_qs(){
  start_xtrace
  QS=`print_qs $*`;
  # must have set URL prefix correctly prior to using..
  URL="${URL_PREFIX}${QS}"
  ${BROWSER} "$URL"
  stop_xtrace
}
function display_rand_img {                                                   #/dev/fb*
  p=$RIMAGES_PROBABILITY; # make it rare-ish
  export LINES=$(tput lines)
  export COLUMNS=$(tput cols)
  export maxw=$(echo $COLUMNS*$PIX_PER_COL|bc)
  export maxh=$(echo $LINES*$PIX_PER_ROW|bc)
  export draw=$(python -c 'import random; DRAW=random.randint(0,100); print(DRAW)' 2>/dev/null);
  if [ $draw -lt $p ]; then {
    export img=$( find ${PICS_DIR} -type f | egrep -v ' |svg' | shuf | head -n 1 );
    export wh=$(file $img 2>&1 | sed -r 's/.* ([0-9]{1,})\s*x\s*([0-9]+).*/\1x\2/g');
    export w=$( echo $wh | cut -d x -f 1 );
    export h=$( echo $wh | cut -d x -f 2 ); 
    #echo maxw $maxw maxh $maxh 
    #echo w $w h $h
    if is_numeric $w && is_numeric $h ; then
      if [ $w -gt $maxw ] || [ $h -gt $maxh ] ; then 
        if [ $w -gt $maxw ]; then
            export w2=$maxw;
            export ar=$(python -c "print($w2*1.000/$w)" 2>/dev/null);
            export h=$(python -c "print(int(round($h*1.00*($ar))))" 2>/dev/null)
            export w=$w2
        fi
        #echo w $w h $h
        if [ $h -gt $maxh ]; then
            export h2=$maxh;
            export ar=$(python -c "print($h2*1.000/$h)" 2>/dev/null);
            export w=$(python -c "print(int(round($w*1.00*$ar)))" 2>/dev/null)
            export h=$h2
        fi
        #echo w $w h $h
      else
        export w=0;
        export h=0;
      fi;
    fi;
    mwa=$(echo $maxw-$w|bc)
    mha=$(echo $maxh-$h|bc)
    #echo mwa $mwa mha $mha
    export xywh=$( python -c "import random; x=random.randint(0,${mwa}); y=random.randint(0,${mha}); w=$w; h=$h; print('0;1;%d;%d;%d;%d' % (x,y,w,h))" 2>/dev/null );
    echo -e $xywh";;;;;$img\n4;\n3;" | /usr/libexec/w3m/w3mimgdisplay 2>/dev/null;
  }; fi;
}
function parse_git_branch() {                                                 #PS1
  GITSTATUS=$(git status 2> /dev/null);
  if [[ $(echo $GITSTATUS | grep '^fatal' | wc -l ) == 1 ]]; then
    return 1;
  fi;
  if [[ `echo $GITSTATUS | grep "Changes to be committed"` != "" ]]; then 
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1***)/';
  elif [[ `echo $GITSTATUS | grep "Changes not staged for commit"` != "" ]]; then 
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1**)/';
  elif [[ `echo $GITSTATUS | grep "Untracked"` != "" ]]; then 
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1*)/';
  elif [[ `echo $GITSTATUS | grep "nothing to commit"` != "" ]]; then
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/';
  else
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1?)/';
  fi;
}
function color_branch(){
  BRANCH="$( parse_git_branch )";
  echo -ne "\e[2;49;91m${BRANCH}\e[m"
}
function last_basename {
  LINKPATH=$(readlink -f .);
  CWD=$(basename "$LINKPATH"); #1
  printf '%b' $CWD;
  return $?
}
function print_patriotic(){
  echo -ne "\e[7;102;30m[\e[m\e[7;49;39m${1}\e[m\e[7;49;92m${2}\e[7;107;31m${3}\e[m\e[7;102;30m]\e[m"
}
function normal_prompt(){ 
  echo -ne ""
}
function prompt_dtcwd(){
  echo -ne "\e[$( date +%T )\e[m\e[4;40;36m$( date +%D%Z )\e[m\e[1;40;37m$( short_cwd )\e[m";
}
function work_prompt(){
  echo -ne "$(datets_print) ";
}
function long_ass_prompt(){
  MYUSER="$(whoami)"                        && export MYUSER;
  MYHOST="$(hostname -s)"                   && export MYHOST; #\e[38;5;5m${MYUSER}\e[0m@\e[38;5;220m${MYHOST}\e[0m:
  CWD_FULL=$('pwd')                         && export CWD_FULL;
  CURR_DIR="$(basename ${CWD_FULL})"        && export CURR_DIR;
  PARENT_DIR="$(dirname ${CWD_FULL})"       && export PARENT_DIR;
  W=$( cat /proc/loadavg | awk '{print $1" "$2" "$3}' ) && export W
  echo -ne "[\e[38;5;7m$W\e[0m]\e[38;5;220m${MYHOST}\e[0m\e[4;40;36m${PARENT_DIR}/\e[m\e[38;5;69m${CURR_DIR}\e[0m/";
}
function real_cwd(){
  LINKPATH=$(readlink -f .);
  echo $LINKPATH;
  return $?;
}
function short_uname(){
  printf "%b" `whoami`;
  return $?;
}
function short_hostname(){
  printf "%b" `nisdomainname -s`;
  return $?;
}
function short_cwd(){
  start_xtrace
  local PATH_CWD_SHORT='';
  local REAL_CWD=$( real_cwd );
  local DIRS_LTR="$( dirname "$REAL_CWD" | tr '/' ' ' )";
  local CWD_NAME="$( basename "$REAL_CWD" )";
  for LTR_DIR in $DIRS_LTR; do {
    local FIRST_CHAR=$( echo $LTR_DIR | head -c 1 );
    PATH_CWD_SHORT="${PATH_CWD_SHORT}/${FIRST_CHAR}";
  }; done;
  PATH_CWD_SHORT="${PATH_CWD_SHORT}/$CWD_NAME";
  echo $PATH_CWD_SHORT
  stop_xtrace
  return $?;
}
function set_prompt_PS1(){
  start_xtrace
  unset PS1
  export PS1=''
  export P="$";
  if [[ $PS1_TYPE = 'DATE_TIME_CWD' ]]; then #PROMPT PREFIXES
    export PS1+='$( prompt_dtcwd )';
  elif [[ $PS1_TYPE = 'PATRIOTIC' ]]; then
    export PS1+='$( print_patriotic @ $( -s) $( date +%e%T ):$/)';
  elif [[ $PS1_TYPE = 'SHORT_PATRIOTIC' ]]; then
    export PS1+='$( print_patriotic "$( short_uname )" "@$( short_hostname )" ":$( short_cwd )" )';
  elif [[ $PS1_TYPE = "FULL_LINE_OVERFLOWS" ]]; then
    export PS1+='$( long_ass_prompt )\n'; 
  elif [[ $PS1_TYPE = "work_prompt" ]]; then
    export PS1+='$( work_prompt)';
  else 
    export PS1='';
  fi;
  if [[ $GIT_BRANCH_PS1 != 0 ]]; then #POSTFIXES
    export PS1+='$( color_branch )';
  fi;
  if [ "$ENABLE_RANDOM_IMAGES_DISPLAY" -gt 0 ]; then
    export PS1+='$( display_rand_img )'
  fi;
  export PS1+='\[\033[5;41;37m\]${P}\[\033[0m\] '
  stop_xtrace;
}
