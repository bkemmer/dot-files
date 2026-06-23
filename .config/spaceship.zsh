#THEME SPACESHIP
LS_COLORS=$LS_COLORS:'ow=01;34:' ; export LS_COLORS

SPACESHIP_PROMPT_ORDER=(
	venv		# Active virtualenv
	user		# Username section
	dir 		# Current directory section
	host		# Hostname section
	git 		# Git section (git branch + git_status)
	exec_time 	# Execution time
	line_sep 	# Line break
	jobs 		# Background jobs indication
	exit_code 	# Exit code section
	char		# Prompt character
)

SPACESHIP_USER_SHOW="always" # Shows System user name before directory name

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
SPACESHIP_VENV_PREFIX='('
SPACESHIP_VENV_SUFFIX=') '
SPACESHIP_VENV_GENERIC_NAMES=(virtualenv venv .venv)

SPACESHIP_CHAR_SYMBOL=">"
SPACESHIP_CHAR_SUFFIX=" "

# Kanagawa Dragon colors
SPACESHIP_USER_COLOR="#C8C093"       # warm cream
SPACESHIP_DIR_COLOR="#7FB4CA"        # blue
SPACESHIP_GIT_BRANCH_COLOR="#87a987" # green
SPACESHIP_GIT_STATUS_COLOR="#E6C384" # yellow
SPACESHIP_VENV_COLOR="#938AA9"       # purple
SPACESHIP_EXEC_TIME_COLOR="#a6a69c"  # muted gray
SPACESHIP_EXIT_CODE_COLOR="#E46876"  # red
SPACESHIP_CHAR_COLOR_SUCCESS="#8a9a7b" # muted green
SPACESHIP_CHAR_COLOR_FAILURE="#E46876" # red

