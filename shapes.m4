dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   UTILITIES
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(__, `_INTERNAL_M4_MACRO_')
define(__RANDOM, `esyscmd(uuidgen | sed "s/-/_/g" | tr -d "\n")')dnl
define(STYLE, `stylesheet="style.css"; nodesep=0.666; /*bgcolor=transparent;*/ node [shape=box; colorscheme="paired12";] edge [labelOverlay=true label2node="50%"]')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   S H A P E S
dnl .   Basic flowchart shapes.
dnl .
dnl .   Usage:
dnl .   node_name Shape("label")
dnl .   node_name Shape(<<p>HTML label</p>>)
dnl .   * The argument is directly passed to 'label' node attribute.
dnl .   * Thus, you need either quotation marks around the label
dnl .   * or the HTML tag anchors '<>'.
dnl .
dnl .   Note:
dnl .   You can define a shape _inline_ if you prepend the shape name
dnl .   with underscore:
dnl .   * node1 -> _Shape("label") -> node2
dnl .   IMPORTANT: this may fail if your terminal does not
dnl .   support 'uuidgen' command; see definition of "__RANDOM" macro.
dnl .
dnl .   Argument:
dnl .   $1:label [string|HTML] — label of the node to be displayed.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(__LOWERCASE, `translit($1, `A-Z', `a-z')')dnl
define(__CLASS_ATTR, `[class="__LOWERCASE($1)"]')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   If no arguments are provided to macro, return macro name.
dnl .
dnl .   Sanitize's arguments:
dnl .   $1 — Shape's first argument.
dnl .   $2 — Value displayed if no Shape has no argument.
dnl .   $3 — Normal processed value displayed according to Shape's arguments.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(__SANITIZE, ``ifelse($1,,$2,$3)'')dnl
define(__SHAPE_DEF, `__SANITIZE($`1', ```$1''', __CLASS_ATTR(``$1'')$2)')dnl
define(__SHAPE_INLINE, `__SANITIZE($`1', _```$1''', {node $1($`1'); ``$1''__RANDOM})')dnl
define(__SHAPE, `define(_$1, __SHAPE_INLINE($1)) define($1, __SHAPE_DEF($1, $2))')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   Shapes definitions
dnl .   Automatic generation of the definition for Shape and inline _Shape.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
__SHAPE(Input, `[label=$1;shape="ellipse"]')dnl
__SHAPE(Output, `[label=$1;shape="ellipse"]')dnl
__SHAPE(Action, `[label=$1;shape=box]')dnl
__SHAPE(Manual, `[label=$1;shape=invtrapezium;height=0;width=0;margin=0]')dnl
__SHAPE(Preparation, `[label=$1;shape=hexagon;]')dnl
__SHAPE(Decision, `[label=$1;shape="diamond"]')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   D A T A B A S E
dnl .   Defining CSS-adressable data.
dnl .   Each database and other related shapes (like Data) represent
dnl .   the same CSS class allowing for a closer style control.
dnl .
dnl .   Usage:
dnl .   Database(label)
dnl .
dnl .   Argument:
dnl .   $1:label — label of the node to be displayed (important: needs quotation marks).
dnl .
dnl .   Note:
dnl .   When rendered to svg, those classes gain additional class being a database's name.
dnl .   You can adress it then in your CSS styling file.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(Database, `$1 [class="database $1";
        height=1;
        width=1;
        shape=cylinder;
        style=filled;
    ]')dnl
define(Data, `[
        class="form`'ifelse($1,,,` $1')";
        label=`$2'
        shape=parallelogram;
        ifelse($2,,,style=filled;)dnl
    ]')dnl;
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   D A T A   R O W   &   C O L U M N
dnl .   A custom shape for complex data.
dnl .
dnl .   Background:
dnl .   Graphviz uses "record" shapes in order to allow complex data structures.
dnl .   That feature is however limited and one needs to adress to HTML in order to
dnl .   provide more customized experience (e.g. having records of different colors).
dnl .   The code below thus replaces the "record" structure with a custom one
dnl .   using features available from Graphviz "HTML-like" interface.
dnl .
dnl .   Usage:
dnl .   DataRow(FIELD("field label"), FIELD("another label")
dnl .   DataColumn(FIELD("field label"), FIELD("another label")
dnl .
dnl .   Arguments:
dnl .   $1, $2, $3...: data fields.
dnl .
dnl .   Note:
dnl .   Use FIELD only inside DataRow.
dnl .   Feel free to create your custom fields using _ROW function.
dnl .   To define a new DataRow, use DataRow($@) with 'all arguments' symbol.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   _ R O W
dnl .   Create data field.
dnl .
dnl .   Arguments:
dnl .   $1:label – displayed label in the field.
dnl .   $2:color – color of the field's background.
dnl .   $3:port – name of the port and edge can connect to.
dnl .
dnl .   Note:
dnl .   Use your custom m4 macra with this function to create
dnl .   your own custom data fields. For example:
dnl .   define(PERSONEL, `_ROW($1, orange, `personel_$1')')dnl
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(_DATA, `<td bgcolor="`$2'" port="$3">$1</td>')dnl
define(__FILL_ROWS, `ifelse($1,,,``$1'_FILL_ROWS(shift($@))')')dnl
define(__FILL_COLUMNS, `ifelse($1,,,`<tr cellpadding="1">`$1'</tr>__FILL_COLUMNS(shift($@))')')dnl
define(DataRow, `[shape=note
    margin=0.1
    height=0
    width=0
    label=<
        <table cellspacing="0"><tr cellpadding="1">
            __FILL_ROWS($@)
        </tr></table>>
    ]')dnl
define(DataColumn, `[shape=note
    margin=0.1
    height=0
    width=0
    label=<
        <table cellspacing="0">
            __FILL_COLUMNS($@)
        </table>>
    ]')dnl
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
dnl .
dnl .   Some examples of custom data rows.
dnl .
dnl . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
define(ExcelExport, `DataRow($@) [style=filled; fillcolor=lightgreen]')dnl
