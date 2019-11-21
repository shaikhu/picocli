#!/usr/bin/env bash
#
# rcmd Bash Completion
# =======================
#
# Bash completion support for the `rcmd` command,
# generated by [picocli](http://picocli.info/) version %1$s.
#
# Installation
# ------------
#
# 1. Source all completion scripts in your .bash_profile
#
#   cd $YOUR_APP_HOME/bin
#   for f in $(find . -name "*_completion"); do line=". $(pwd)/$f"; grep "$line" ~/.bash_profile || echo "$line" >> ~/.bash_profile; done
#
# 2. Open a new bash console, and type `rcmd [TAB][TAB]`
#
# 1a. Alternatively, if you have [bash-completion](https://github.com/scop/bash-completion) installed:
#     Place this file in a `bash-completion.d` folder:
#
#   * /etc/bash-completion.d
#   * /usr/local/etc/bash-completion.d
#   * ~/bash-completion.d
#
# Documentation
# -------------
# The script is called by bash whenever [TAB] or [TAB][TAB] is pressed after
# 'rcmd (..)'. By reading entered command line parameters,
# it determines possible bash completions and writes them to the COMPREPLY variable.
# Bash then completes the user input if only one entry is listed in the variable or
# shows the options if more than one is listed in COMPREPLY.
#
# References
# ----------
# [1] http://stackoverflow.com/a/12495480/1440785
# [2] http://tiswww.case.edu/php/chet/bash/FAQ
# [3] https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# [4] http://zsh.sourceforge.net/Doc/Release/Options.html#index-COMPLETE_005fALIASES
# [5] https://stackoverflow.com/questions/17042057/bash-check-element-in-array-for-elements-in-another-array/17042655#17042655
# [6] https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html#Programmable-Completion
# [7] https://stackoverflow.com/questions/3249432/can-a-bash-tab-completion-script-be-used-in-zsh/27853970#27853970
#

if [ -n "$BASH_VERSION" ]; then
  # Enable programmable completion facilities when using bash (see [3])
  shopt -s progcomp
elif [ -n "$ZSH_VERSION" ]; then
  # Make alias a distinct command for completion purposes when using zsh (see [4])
  setopt COMPLETE_ALIASES
  alias compopt=complete

  # Enable bash completion in zsh (see [7])
  autoload -U +X compinit && compinit
  autoload -U +X bashcompinit && bashcompinit
fi

# ArrContains takes two arguments, both of which are the name of arrays.
# It creates a temporary hash from lArr1 and then checks if all elements of lArr2
# are in the hashtable.
#
# Returns zero (no error) if all elements of the 2nd array are in the 1st array,
# otherwise returns 1 (error).
#
# Modified from [5]
function ArrContains() {
  local lArr1 lArr2
  declare -A tmp
  eval lArr1=("\"\${$1[@]}\"")
  eval lArr2=("\"\${$2[@]}\"")
  for i in "${lArr1[@]}";{ [ -n "$i" ] && ((++tmp[$i]));}
  for i in "${lArr2[@]}";{ [ -n "$i" ] && [ -z "${tmp[$i]}" ] && return 1;}
  return 0
}

# Bash completion entry point function.
# _complete_rcmd finds which commands and subcommands have been specified
# on the command line and delegates to the appropriate function
# to generate possible options and subcommands for the last specified subcommand.
function _complete_rcmd() {
  CMDS0=(sub-1)
  CMDS1=(sub-2)

  ArrContains COMP_WORDS CMDS1 && { _picocli_rcmd_sub2; return $?; }
  ArrContains COMP_WORDS CMDS0 && { _picocli_rcmd_sub1; return $?; }

  # No subcommands were specified; generate completions for the top-level command.
  _picocli_rcmd; return $?;
}

# Generates completions for the options and subcommands of the `rcmd` command.
function _picocli_rcmd() {
  # Get completion data
  CURR_WORD=${COMP_WORDS[COMP_CWORD]}
  PREV_WORD=${COMP_WORDS[COMP_CWORD-1]}

  COMMANDS="sub-1 sub-2"
  FLAG_OPTS="-h --help -V --version"
  ARG_OPTS=""

  if [[ "${CURR_WORD}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${FLAG_OPTS} ${ARG_OPTS}" -- ${CURR_WORD}) )
  else
    COMPREPLY=( $(compgen -W "${COMMANDS}" -- ${CURR_WORD}) )
  fi
}

# Generates completions for the options and subcommands of the `sub-1` subcommand.
function _picocli_rcmd_sub1() {
  # Get completion data
  CURR_WORD=${COMP_WORDS[COMP_CWORD]}
  PREV_WORD=${COMP_WORDS[COMP_CWORD-1]}

  COMMANDS=""
  FLAG_OPTS="flag1 -h --help -V --version"
  ARG_OPTS="option1"

  compopt +o default

  case ${PREV_WORD} in
    option1)
      return
      ;;
  esac

  if [[ "${CURR_WORD}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${FLAG_OPTS} ${ARG_OPTS}" -- ${CURR_WORD}) )
  else
    COMPREPLY=( $(compgen -W "${COMMANDS}" -- ${CURR_WORD}) )
  fi
}

# Generates completions for the options and subcommands of the `sub-2` subcommand.
function _picocli_rcmd_sub2() {
  # Get completion data
  CURR_WORD=${COMP_WORDS[COMP_CWORD]}
  PREV_WORD=${COMP_WORDS[COMP_CWORD-1]}

  COMMANDS=""
  FLAG_OPTS="flag-2 -h --help -V --version"
  ARG_OPTS="option-2"

  compopt +o default

  case ${PREV_WORD} in
    option-2)
      return
      ;;
  esac

  if [[ "${CURR_WORD}" == -* ]]; then
    COMPREPLY=( $(compgen -W "${FLAG_OPTS} ${ARG_OPTS}" -- ${CURR_WORD}) )
  else
    COMPREPLY=( $(compgen -W "${COMMANDS}" -- ${CURR_WORD}) )
  fi
}

# Define a completion specification (a compspec) for the
# `rcmd`, `rcmd.sh`, and `rcmd.bash` commands.
# Uses the bash `complete` builtin (see [6]) to specify that shell function
# `_complete_rcmd` is responsible for generating possible completions for the
# current word on the command line.
# The `-o default` option means that if the function generated no matches, the
# default Bash completions and the Readline default filename completions are performed.
complete -F _complete_rcmd -o default rcmd rcmd.sh rcmd.bash
