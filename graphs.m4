dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   UTILITIES
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(__, `_INTERNAL_M4_MACRO_')
define(__RANDOM, `esyscmd(uuidgen | sed "s/-/_/g" | tr -d "\n")')dnl
define(`_forloop', `$4`'ifelse($1, `$3', ,`define(`$1', incr($1))_forloop(`$1', `$2', `$3', `$4')')')dnl
define(`forloop', `pushdef(`$1', `$2')_forloop(`$1', `$2', `$3', `$4')popdef(`$1')')dnl
dnl #
define(__GRAPH_FILE_MIDDLE, `regexp(`$1', `== \(.+\) >>', `\1')')dnl
define(__GRAPH_FILE_LAST, `regexp(`$1', `== \(.+\)', `\1')')dnl
define(__GRAPH_FILE_FIRST, `regexp($1, `\(.+\) >>', `\1')')dnl
dnl #
define(__GRAPH_HAS_IN, `regexp($1, `==')')dnl
define(__GRAPH_HAS_OUT, `regexp($1, `>>')')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   Configuration variables for Graph and Process.

define(__SG_EXT__, `.sg')dnl File extension.
define(__SG_PATH__, `graphs')dnl Path to be looked for.
define(__GRAPH_PATH, `./'__SG_PATH__`/'$1`'__SG_EXT__`')dnl
dnl #
define(__GRAPH_FILE_NAME, `ifelse(__GRAPH_HAS_IN($1), -1, __GRAPH_FILE_FIRST($1), __GRAPH_HAS_OUT($1), -1, __GRAPH_FILE_LAST($1), __GRAPH_FILE_MIDDLE($1))')dnl
define(__GRAPH_FILE_PATH, `__GRAPH_PATH(__GRAPH_FILE_NAME($1))')dnl
define(__GRAPH_FILE, `subgraph { node [id="GRAPHNODE-\N-__GRAPH_FILE_NAME($1)"]; include(__GRAPH_FILE_PATH($1)) }')dnl
dnl #
define(__GRAPH_INS, `ifelse(__GRAPH_HAS_IN($1), -1, {}, regexp($1, `\({.+}\) ==', `\1'))')dnl
define(__GRAPH_OUTS, `ifelse(__GRAPH_HAS_OUT($1), -1, {}, regexp($1, `>> \({.+}\)', `\1'))')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   This function counts the number of arguments
dnl .   only by how many spaces are there between words.
dnl .   NOTE: it is a BAD solution as it depends on number
dnl .   of spaces, not number of arguments.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(`__COUNT_SPACES', `len(patsubst($1, `[^ ]', `'))')dnl Very bad – counting
define(`__COUNT_ARGS', `eval(__COUNT_SPACES($1) + 1)')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   Makes regexp covering graph args.
dnl .   Graph args are in form `arg1 arg2 arg3' – strings separated by space.
dnl .   Example: `\(\w+\) \(\w+\) \(\w+\)' when $1=3
dnl .
dnl .   Arguments:
dnl .   $1: number of args.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(__MAKE_REGEXP, `substr(forloop(`x', 1, $1, ` \(\w+\)'), 1)')dnl
define(__GET_NTH_ARG, `regexp($1, __MAKE_REGEXP(__COUNT_ARGS($1)), \$2)')dnl *** args, n
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   In a .dot file $1, substitute dummy node ($2)
dnl .   with nth ($4) argument from the list ($3)
dnl .
dnl .   Arguments:
dnl .   file, symbol, subst arg, arg index
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(__SUBST, `patsubst($1, $2$4, __GET_NTH_ARG($3, $4))')dnl
define(`__SUBST_ALL', `ifelse($4,0,$1, `__SUBST_ALL(__SUBST($1, $2, $3, $4), $2, $3, eval($4 - 1))')')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   G R A P H
dnl .   Includes a graph defined in '.sg' file, replacing
dnl .   all `INx' and `OUTx' with given names.
dnl .
dnl .   Arguments:
dnl .   $1 – graph definition (see below)
dnl .   $2 – default formating when subgraph is folded
dnl .
dnl .   Graph Definition
dnl .   The syntax shows how you can define Graph components.
dnl .   Inside {} parentheses, you define variables names that
dnl .   are going to replace input and output nodes (e.g. IN1, OUT2).
dnl .   Variable names followed by '==' are input names, and those
dnl .   proceeded by '>>' are output names.
dnl .   The process name is a filename of a subgraph inside path defined
dnl .   in __SG_PATH__. It's file must be in '.sg' format.
dnl .
dnl .   {in1_name in2_name ...} == process_name >> {out1_name out2_name ...}
dnl .
dnl .   '.sg' file format
dnl .   A file in this format contains a template for the graph.
dnl .   It can contain nodes named as 'IN1', 'IN2', 'IN`n'' (or `OUT1'...)
dnl .   that are going to be replaced with the names provided in Graph macro.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(__GRAPH, `__SUBST_ALL(__SUBST_ALL($2, IN, $1, __COUNT_ARGS($1)), OUT, $3, __COUNT_ARGS($3))')dnl
define(Graph, `__GRAPH(__GRAPH_INS($1), __GRAPH_FILE($1), __GRAPH_OUTS($1))')dnl
dnl
dnl define(__PROCESS, `forloop(`n', 1, __COUNT_ARGS($3), `n')')dnl
dnl define(__PROCESS, `__GRAPH_FILE_NAME($1) $3')dnl
dnl
define(__OUTS_REGEXP, `ifelse($1,1,`OUT1.+',`OUT1\(\w\|\W\)+OUT$1.+')')
dnl define(__PROCESS, `regexp(__GRAPH_FILE($1), __OUTS_REGEXP(3), `\&')')
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   P R O C E S S
dnl .   Includes a folded representation of a subgraph defined
dnl .   in an .sg file (using $2 as format).
dnl .
dnl .   Refer to 'Graph' docs.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(__OVERRIDE_OUTS, `forloop(`n',1,__COUNT_ARGS($2),`define(__GET_NTH_ARG($2, n), $1)')')
define(__PROCESS, `__OVERRIDE_OUTS($1, $2)$1 $3')
define(Process, `__GRAPH_INS($1) -> subgraph{ node [id="PROCESSNODE-\N-__GRAPH_FILE_NAME($1)"] __PROCESS(__GRAPH_FILE_NAME($1), __GRAPH_OUTS($1), $2) }')dnl
