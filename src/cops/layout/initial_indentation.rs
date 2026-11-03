use crate::prelude::*;

pub const NAME: &str = "Layout/InitialIndentation";
pub static COP: InitialIndentation = InitialIndentation;
pub struct InitialIndentation;

impl Cop for InitialIndentation {
    fn correctable(&self) -> bool {
        true
    }

    fn on_file(&self, cx: &mut Cx) {
        let src = cx.src;
        let tokens = helpers::parser_tokens::translated(src);
        // `processed_source.tokens.find { |t| !t.text.start_with?('#') }`: comments, but also a
        // token whose parser-gem text (a value, not source) starts with `#`.
        let Some(t) = tokens.iter().find(|t| !text_starts_with_hash(&src.text[t.start..t.end], t.kind)) else {
            return;
        };
        // Only spaces/tabs to the left count (a BOM gives a non-zero column but no space):
        // range_with_surrounding_space(newlines: false) moves over `/[ \t]/` only, not Ruby's `\s`.
        if matches!(src.text.as_bytes()[..t.start].last(), Some(b' ' | b'\t')) {
            let o = helpers::range_help::Surrounding {
                side: helpers::range_help::Side::Left,
                newlines: false,
                ..Default::default()
            };
            let (space, _) = helpers::range_help::range_with_surrounding_space(src.text, t.start, t.end, o);
            let first = t.start;
            cx.add_fix(t.start, t.end, "Indentation of first line in file detected.", |c| c.remove(space, first));
        }
    }
}

/// Whether the parser gem's Token#text starts with `#`: a comment's source; a quoted tSTRING's
/// value (`"#"`, `'#'`, and the escapes `"\#"`, `"\x23"`, `"\043"`, `"\u0023"`, `"\u{23}"`,
/// whose value is `#`); a character literal's value (`?#`). `%q(#)` and interpolated strings
/// start with a tSTRING_BEG whose text is the delimiter.
fn text_starts_with_hash(source: &str, kind: u32) -> bool {
    use helpers::parser_tokens::T_STRING;
    match kind {
        T_STRING if source.starts_with('\'') => source[1..].starts_with('#'),
        T_STRING if source.starts_with('"') => {
            let v = &source[1..];
            v.starts_with('#')
                || ["\\#", "\\x23", "\\043", "\\u0023", "\\u{23}"].iter().any(|e| v.starts_with(e))
        }
        T_STRING => false,
        ruby_prism_sys::PM_TOKEN_CHARACTER_LITERAL => source == "?#",
        _ => source.starts_with('#'),
    }
}
