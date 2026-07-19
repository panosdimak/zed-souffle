; Comments
(line_comment) @comment
(block_comment) @comment

; Directives and structural keywords
[
  ".decl"
  ".type"
  ".comp"
  ".init"
  ".input"
  ".output"
  ".printsize"
  ".limitsize"
  ".pragma"
  ".functor"
  ".plan"
  ".override"
  ".number_type"
  ".symbol_type"
  "as"
  "stateful"
] @keyword

; C preprocessor line markers
"#line" @keyword

; Relation qualifiers (scoped so a bare `input`/`output` elsewhere is left alone)
(relation_decl
  [
    "brie"
    "btree"
    "btree_delete"
    "eqrel"
    "inline"
    "magic"
    "no_inline"
    "no_magic"
    "override"
    "overridable"
    "input"
    "output"
    "printsize"
    "choice-domain"
  ] @attribute)

; Types
(primitive_type) @type.builtin

; Type declaration names
(subtype left: (ident) @type)
(type_synonym left: (ident) @type)
(type_union left: (ident) @type)
(type_record left: (ident) @type)
(adt left: (ident) @type)
(legacy_bare_type_decl (ident) @type)

; Type references
(attribute type: (qualified_name) @type)
(subtype right: (qualified_name) @type)
(type_synonym right: (qualified_name) @type)
(type_union (qualified_name) @type)
(functor_decl return: (qualified_name) @type)
(functor_decl type: (qualified_name) @type)
(as type: (qualified_name) @type)

; Components
(component_type name: (ident) @type)
(component_type param: (ident) @type)
(component_init name: (ident) @type)

; ADT constructor use sites (declaration-site names are unmatchable in this grammar)
(adt_constructor
  "$" @punctuation.special
  constructor: (qualified_name) @constructor)

; Relation names (predicate position)
(atom relation: (qualified_name) @function)
(relation_decl head: (ident) @function)
(directive relation: (qualified_name) @function)
(functor_decl name: (ident) @function)

; Attribute names, directive keys and values
(attribute var: (ident) @property)
(directive key: (ident) @property)
(directive value: (ident) @constant)

; Functors and aggregates
(intrinsic_functor) @function.builtin
(user_defined_functor
  "@" @punctuation.special
  (ident) @function)

(match "match" @function.builtin)
(contains "contains" @function.builtin)

(aggregator
  [
    "count"
    "max"
    "mean"
    "min"
    "sum"
  ] @keyword)
(range "range" @keyword)

; Variables and the wildcard
(variable) @variable
(anonymous) @variable.special

; Constants and literals
(number) @number
(ipv4) @number
(string) @string
(bool) @boolean
(nil) @constant

; Operators
(comparison operator: _ @operator)
(binary_op operator: _ @operator)
(unary_op operator: _ @operator)
(negation "!" @operator)
(subtype "<:" @operator)
":-" @operator
"=" @operator

; Punctuation
[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket
[ "," ";" "." ":" "|" ] @punctuation.delimiter
