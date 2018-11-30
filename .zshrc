#!/bin/zsh
zshrc_load_status () {
  if [[ -n "$ZSH_LOAD_STATUS_DEBUG" ]]; then
    echo ".zshrc load: $* ... \e[0K"
  else
    echo -n "\r.zshrc load: $* ... \e[0K"
  fi
}
zshrc_load_status 'setting options'
setopt \
  NO_all_export \
     always_last_prompt \
  NO_always_to_end \
     append_history \
  NO_auto_cd \
     auto_list \
     auto_menu \
     auto_name_dirs \
     auto_param_keys \
     auto_param_slash \
     auto_pushd \
     auto_remove_slash \
  NO_auto_resume \
     bad_pattern \
     bang_hist \
  NO_beep \
  NO_bg_nice \
     brace_ccl \
     correct_all \
  NO_bsd_echo \
     cdable_vars \
  NO_chase_links \
  NO_clobber \
     complete_aliases \
     complete_in_word \
  NO_correct \
     correct_all \
     csh_junkie_history \
  NO_csh_junkie_loops \
  NO_csh_junkie_quotes \
  NO_csh_null_glob \
     equals \
     extended_glob \
     extended_history \
     function_argzero \
     glob \
  NO_glob_assign \
     glob_complete \
  NO_glob_dots \
     glob_subst \
     hash_cmds \
     hash_dirs \
     hash_list_all \
     hist_allow_clobber \
     hist_beep \
     hist_ignore_dups \
  NO_hist_ignore_space \
  NO_hist_no_store \
     hist_verify \
  NO_hup \
  NO_ignore_braces \
  NO_ignore_eof \
     interactive_comments \
  NO_list_ambiguous \
  NO_list_beep \
     list_types \
     long_list_jobs \
     magic_equal_subst \
  NO_mail_warning \
  NO_mark_dirs \
  NO_menu_complete \
     multios \
     nomatch \
     notify \
  NO_null_glob \
     numeric_glob_sort \
  NO_overstrike \
     path_dirs \
     posix_builtins \
  NO_print_exit_value \
  NO_prompt_cr \
     prompt_subst \
     pushd_ignore_dups \
  NO_pushd_minus \
  NO_pushd_silent \
     pushd_to_home \
     rc_expand_param \
  NO_rc_quotes \
  NO_rm_star_silent \
  NO_sh_file_expansion \
     sh_option_letters \
     short_loops \
  NO_sh_word_split \
  NO_single_line_zle \
  NO_sun_keyboard_hack \
     unset \
  NO_verbose \
     zle \
     hist_expire_dups_first \
     hist_ignore_all_dups \
  NO_hist_no_functions \
  NO_hist_save_no_dups \
     inc_append_history \
     list_packed \
  NO_rm_star_wait \
     hist_reduce_blanks
zshrc_load_status 'setting environment'
export COLUMNS
[[ "$ZSH_VERSION_TYPE" == 'old' ]] || typeset -T INFOPATH infopath
typeset -U infopath
export INFOPATH
infopath=( 
  ~/local/info(N)
  /usr/info(N)
  $infopath
)
zdotdir=~
WORDCHARS='' # Choose word delimiter characters in line editor
HISTFILE=$zdotdir/.zsh_history # Save a large history
HISTSIZE=3000
SAVEHIST=3000
LISTMAX=0 # Maximum size of completion listing# Only ask if line would scroll off screen
LOGCHECK=60 # Watching for other users
WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"
local _find_promptinit # Prompts # Load the theme-able prompt system and use it to set a prompt.
_find_promptinit=( /usr/share/zsh/4.1.1/functions/promptinit(N) ) #_find_promptinit=( /usr/local/share/zsh/functions/promptinit(N) ) 
if (( $#_find_promptinit == 1 )) && [[ -r $_find_promptinit[1] ]]; then
  zshrc_load_status 'prompt system'
  autoload -U promptinit
  promptinit
  PS4="trace %N:%i> "
  if [[ -r $zdotdir/.zsh_prompts ]]; then
    . $zdotdir/.zsh_prompts # define extra prompts in here
    prompt e101 white red  #prompt e101_short black black blue
  fi
else
  zshrc_load_status 'no prompt system'
  PS1='%n@%m %B%3~%b %# '
fi
zshrc_load_status 'completion system' # Completions
autoload -U compinit
compinit # don't perform security check
zstyle ':completion:*' completer _complete _prefix  ## Enable the way cool bells and whistles.  # General completion technique #zstyle ':completion:*' completer _complete _correct _approximate _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion::complete:*' use-cache 1 # Completion caching
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' expand 'yes' # Expand partial paths
zstyle ':completion:*' squeeze-slashes 'yes' #zstyle ':completion::complete:*' tag-order 'globbed-files directories' all-files # Include non-hidden directories in globbed file completions for certain commands #zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # Don't complete backup files as executables
zstyle ':completion:*:matches' group 'yes' # Separate matches into groups
zstyle ':completion:*:descriptions' format "%B---- %d%b" # Describe each match group.
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' # Messages/warnings format
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b' # Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:history-words' stop verbose # Simulate my old dabbrev-expand 3.0.5 patch 
zstyle ':completion:*:history-words' remove-all-dups yes
users=( sasheto sashetov ) # Common usernames
zstyle ':completion:*' users $users
zstyle ':completion:*:*:*' hosts $ssh_config_hosts $ssh_known_hosts
zshrc_load_status 'aliases and functions' # Aliases and functions
autoload zrecompile # zrecompile
alias which >&/dev/null && unalias which # which # reverse unwanted aliasing of `which' by distribution startup files (e.g. /etc/profile.d/which*.sh); zsh's which is perfectly good as is.
alias run-help >&/dev/null && unalias run-help # run-help
autoload run-help # Restarting zsh or bash; reloading .zshrc or functions
bash () {
  NO_ZSH="yes" command bash "$@"
}
restart () {
  exec $SHELL "$@"
}
profile () {
  ZSH_PROFILE_RC=1 $SHELL "$@"
}
reload () {
  if [[ "$#*" -eq 0 ]]; then
    . $zdotdir/.zshrc
  else
    local fn
    for fn in "$@"; do
      unfunction $fn
      autoload -U $fn
    done
  fi
}
compdef _functions reload
set_title () { #Window.title
    local num title
    case "$1" in
    window) num=2
        ;;
    icon) num=1
        ;;
    *) print "Usage: set_title ( window | title ) <title>"
        return 1 
        ;;
    esac
    title="$2"
    if [[ "$TERM" == 'linux' ]]; then # Other checks will need to be added here.
      print "Cannot currently display $1 title; only remembering value set."
    else
      print -Pn "\e]$num;$title\a"
    fi
}
cx () {
    local long_host short_host title_host short_from_opts
    long_host=${HOST}
    short_host=${HOST%%.*}
    if [[ "$1" == "-s" ]]
    then
        short_from_opts=yes
        shift
    fi
    if [[ ${+CX_SHORT_HOSTNAMES} -eq 1 || 
          "$short_from_opts" == "yes" ]] ; then
        title_host=$short_host
    else
        title_host=$long_host
    fi
    if [[ "$USER" != "$USERNAME" ]]; then
        # We've probably su'ed to a different user but not as a login
        # shell
        unset TITLE ITITLE
    fi   

    if [[ -z "$*" ]]; then
        # Revert window title to previous setting or default
        : ${TITLE="$USERNAME@${title_host}"}
        set_title window "$TITLE"
        
        # Revert window icon title to previous setting or default
        : ${ITITLE="$USERNAME@${short_host}"}
        set_title icon "$ITITLE"
    else
        # Change window title
        TITLE="$USERNAME@${title_host} $*"
        set_title window "$TITLE"
        
        # Change window icon title
        ITITLE="$* @ $USERNAME@${short_host}"
        set_title icon "$ITITLE"
    fi
}

cxx () {
    # Clear titles
    unset TITLE ITITLE
    cx 
}

# File management

# Changing/making/removing directory

# blegh
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd/='cd /'

cd () {
  if   [[ "x$*" == "x..." ]]; then
    cd ../..
  elif [[ "x$*" == "x...." ]]; then
    cd ../../..
  elif [[ "x$*" == "x....." ]]; then
    cd ../../..
  elif [[ "x$*" == "x......" ]]; then
    cd ../../../..
  else
    builtin cd "$@"
  fi
}

alias md='mkdir -p'
alias rd=rmdir

alias dirs='dirs -v'
alias d=dirs

# Don't need this because auto_pushd is set
#alias pu=pushd

alias po=popd

# Renaming

autoload zmv

# Job/process control

alias j='jobs -l'

# History

alias h=history

# Environment

alias ts=typeset
compdef _vars_eq ts

# Terminal

# cls := clear

alias cls='clear'

# Other users

compdef _users lh

alias f=finger
compdef _finger f

# su changes window title, even if we're not a login shell
su () {
  command su "$@"
  cx
}

# No spelling correction

alias man='nocorrect man'
alias mysql='nocorrect mysql'
alias mysqlshow='nocorrect mysqlshow'

# X windows related

# Changing terminal window/icon titles

if [[ "$TERM" == xterm* ]]; then
  # Could also look at /proc/$PPID/cmdline ...
  which cx >&/dev/null || cx () { }
  cx
fi

# export DISPLAY=:0.0

alias sd='export DISPLAY=:0.0'

# Different CVS setups

# Sensible defaults
unset CVS_SERVER
export CVSROOT
export CVS_RSH=ssh

#typeset -A _CVSROOTS
#_CVSROOTS=(
#    @my_cvsroots
#           # Put your own CVSROOTs here
#)

# Other programs

# less

alias v=less

# editors

# emacs, windowed
e () {
  emacs "$@" &!
}

# emacs, fast, non-windowed (see also $VISUAL)
fe () {
  QUICK_EMACS=1 emacs -nw "$@"
}

# emacs, slow, non-windowed
se () {
  emacs -nw "$@"
}

alias pico='/usr/bin/pico -z'

# remote logins

ssh () {
  command ssh "$@"
  cx
}

# Best to run this from .zshrc.local
#dsa >&/dev/null

alias sa=ssh-add

# ftp
if which lftp >&/dev/null; then
  alias ftp=lftp
elif which ncftp >&/dev/null; then
  alias ftp=ncftp
fi

# Global aliases

# WARNING: global aliases are evil.  Use with caution.

# Paging with less / head / tail

alias -g L='| less'
alias -g LS='| less -S'
alias -g EL='|& less'
alias -g ELS='|& less -S'
alias -g H='| head -20'
alias -g T='| tail -20'

# Sorting / counting

alias -g C='| wc -l'
alias -g S='| sort'
alias -g US='| sort -u'
alias -g NS='| sort -n'
alias -g RNS='| sort -nr'

# common filenames

alias -g DN=/dev/null

# Key bindings 

zshrc_load_status 'key bindings'

bindkey -s '^X^Z' '%-^M'
bindkey '^[e' expand-cmd-path
bindkey -s '^X?' '\eb=\ef\C-x*'
bindkey '^[^I' reverse-menu-complete
bindkey '^X^N' accept-and-infer-next-history
bindkey '^[p' history-beginning-search-backward
bindkey '^[n' history-beginning-search-forward
bindkey '^[P' history-beginning-search-backward
bindkey '^[N' history-beginning-search-forward
bindkey '^W' kill-region
bindkey '^I' complete-word
bindkey '^[b' emacs-backward-word
bindkey '^[v' emacs-backward-word
bindkey '^[f' emacs-forward-word

# Fix weird sequence that rxvt produces
bindkey -s '^[[Z' '\t'

# make sure these work
bindkey -e 

alias no=ls  # for Dvorak

# Miscellaneous

zshrc_load_status 'miscellaneous'

# Hash named directories
hash -d I3=/usr/src/RPM/RPMS/i386
hash -d I6=/usr/src/RPM/RPMS/i686
hash -d NA=/usr/src/ROM/RPMS/noarch
hash -d SR=/usr/src/RPM/SRPMS
hash -d SP=/usr/src/RPM/SPECS
hash -d SO=/usr/src/RPM/SOURCES
hash -d BU=/usr/src/RPM/BUILD
#hash -df

# ls colours

if which dircolors >&/dev/null && [[ -e "${zdotdir}/.dircolors" ]]; then
  # show directories in yellow
  eval `dircolors -b $zdotdir/.dircolors`
fi

if [[ $ZSH_VERSION > 3.1.5 ]]; then
  zmodload -i zsh/complist

  zstyle ':completion:*' list-colors ''

  zstyle ':completion:*:*:kill:*:processes' list-colors \
    '=(#b) #([0-9]#)*=0=01;31'

  # completion colours
  zstyle ':completion:*' list-colors "$LS_COLORS"
fi  

# Specific to xterms

if [[ "${TERM}" == xterm* ]]; then
  unset TMOUT
fi

# Specific to hosts

if [[ -r ~/.zshrc.local ]]; then
  zshrc_load_status '.zshrc.local'
  . ~/.zshrc.local
fi

if [[ -r ~/.zshrc.${HOST%%.*} ]]; then
  zshrc_load_status ".zshrc.${HOST%%.*}"
  . ~/.zshrc.${HOST%%.*}
fi

# Clear up after status display

if [[ $TERM == tgtelnet ]]; then
  echo
else
  echo -n "\r"
fi

# Profile report

if [[ -n "$ZSH_PROFILE_RC" ]]; then
  zprof >! ~/zshrc.zprof
  exit
fi

pmversion () { perl -M$1 -le "print $1->VERSION" } 
pmemacs  () { emacs `perldoc -l $1 | sed -e 's/pod$/pm/'` } 
