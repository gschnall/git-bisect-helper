#!/usr/bin/env_bash
HEADER="
  ____ _ _     ____  _               _   
 / ___(_) |_  | __ )(_)___  ___  ___| |_ 
| |  _| | __| |  _ \| / __|/ _ \/ __| __|
| |_| | | |_  | |_) | \__ \  __/ (__| |_ 
 \____|_|\__| |____/|_|___/\___|\___|\__|
 +-+-+-+-+ +-+-+-+ +-+-+-+ +-+-+-+-+-+-+
 |F|I|N|D| |T|H|E| |B|A|D| |C|O|M|M|I|T|
 +-+-+-+-+ +-+-+-+ +-+-+-+ +-+-+-+-+-+-+
"
INTRO="$HEADER
  To start you'll need to select your 
  initial range of commits (bad to good)

 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 | 1. A bad commit         | HAS BUGS  | 
 |-------------------------|-----------|
 | 2. A recent good commit | BUG FREE  | 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ 
"
CLEAN_EXIT="true"

function selectCommit {
  local header_string="$1"
  local commit=$(git log --graph --color=always \
   --format="%C(auto)%h%d %s | %C(auto)%C(bold)%cr" |
   fzf --multi --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --header="$header_string" | 
   awk '{print $2}')
  echo "$commit"
}

function gitStatusCheck {
  local stash_warning="
     < WARNING >
      --------- 
  You've got changes in your local repo
  "
  local git_status="$(git status -u | sed -n '4 p')"

  if [ "${git_status}" = "Untracked files:" ]; then
    echo "$stash_warning"
    echo "Would you like to stash your changes and continue? (y|n)"
    echo "-- use 'git stash apply' to bring them back"
    read option
    if [ "$option" = "Y" ] || [ "$option" = "y" ]; then
      git stash
      clear
    else
      echo "Exiting..."
      exit
    fi
  fi
}

function dependencyCheck {
  if ! command -v fzf &> /dev/null
  then
    echo "Could not use command fzf\n"
    echo "You'll need to install fzf first.\n"
    echo "For Mac os:"
    echo "\`brew install fzf\`"
    echo "For Linux"
    echo "\`git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf\`"
    echo "\`cd ~/.fzf/\`"
    echo "\`./install\`"
    exit
  fi
}

function exitHandler {
  # Your cleanup code here
  if [ $CLEAN_EXIT == "false" ]; then
    git bisect reset
    echo "\n Exited bisect and reset state."
  fi
}
  

function main {
  clear
  dependencyCheck
  gitStatusCheck
  trap exitHandler EXIT

  echo "$INTRO"
  read -p "       --- ENTER to start ---"
  local commit_range=$(selectCommit "use TAB to select initial range | bad -> good | ENTER to confirm")
  local number_of_commits=$(echo "$commit_range" | wc -l)
  if (( $number_of_commits != 2 )); then
    clear
    echo "You must select 2 commits for the initial range"
    echo "The first  | the known bad commit (HAS BUGS)"
    echo "The second | a recent good commit (BUG FREE)"
    exit
  fi
  local bad_commit=$(echo "$commit_range" | sed -n '1p')
  local good_commit=$(echo "$commit_range" | sed -n '2p')
  # initiate git bisect
  clear
  CLEAN_EXIT="false"
  git bisect start
  git bisect good $good_commit
  git bisect bad $bad_commit
  # start interactive bisect
  bisect_output="Bisecting: "
  while [[ $bisect_output == Bisecting* ]]; do
    clear
    echo "$HEADER"
    current_commit=$(git log -1 --oneline -s | sed -n '1p')
    echo " Currently on the following commit"
    echo "-----------------------------------"
    echo "$current_commit"
    echo "-----------------------------------"
    echo " - Enter q to quit"
    echo " - Enter v to view the current bisect status"
    echo " - Enter g or b to mark the commit good or bad\n"
    echo "Is this commit good or bad?"
    read -p "(g,b,v): " userOption
    case $userOption in
      g | G | good | Good)
        bisect_output=$(git bisect good)
        ;;

      b | B | bad | Bad)
        bisect_output=$(git bisect bad)
        ;;

      v | V | view | View)
        git bisect visualize
        ;;

      q | Q | quit | Quit)
        CLEAN_EXIT="true"
        git bisect reset
        exit
        ;;

      *) echo "Invalid input"
        ;;
    esac
  done
  # Completion sequence
  CLEAN_EXIT="true"
  git bisect reset
  clear
  echo "
      __________________ 
     < CONGRATULATIONS! >
      ------------------

 ┏(T_T)┛┗(-_-)┓┗(O.O)┛┏(-_-)┓
 ----------------------------
 | You found the bad commit |
 ----------------------------

$bisect_output
"
}
main
