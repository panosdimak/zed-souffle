(relation_decl
  ".decl" @context
  head: (ident) @name) @item

(subtype
  left: (ident) @name) @item

(type_synonym
  left: (ident) @name) @item

(type_union
  left: (ident) @name) @item

(type_record
  left: (ident) @name) @item

(adt
  left: (ident) @name) @item

(legacy_bare_type_decl
  (ident) @name) @item

(component_decl
  ".comp" @context
  type: (component_type
    name: (ident) @name)) @item

(component_init
  ".init" @context
  name: (ident) @name) @item

(functor_decl
  ".functor" @context
  name: (ident) @name) @item
