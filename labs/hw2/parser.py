import re
from typing import Callable, Tuple

Parsed = Tuple[str, bool]


def from_pattern(pattern: str) -> Callable[str, Parsed]:
    pattern = re.compile(pattern)
    def matches(s: str) -> Parsed:
        match = pattern.match(s)
        if (match is None):
            return s, False
        else:
            return s[match.endpos:], True
    return matches

is_letter = from_pattern()


def is_statement(s: str) -> Parsed:
    leftover, ok = is_assignment(s)
    if ok:
        return leftover, ok
# leftover, ok = is_while(s)
    return is_assignment(s) or False  # is_while(s)


def is_assignment(s: str) -> Parsed:
    return ""


is_letter_re = re.compile(r'[a-zA-Z]')


def is_letter(s: str) -> Parsed:
    match = is_letter_re.match(s)
    if (match is None):
        return s, False
    else:
        return s[match.endpos:], True


is_digit_re = re.compile(r'[0-9]')


def is_digit(s: str) -> Parsed:
    match = is_digit_re.match(s)
    if (match is None):
        return s, False
    else:
        return s[match.endpos:], True


def is_alphanumeric(s: str) -> Parsed:
    leftover, ok = is_digit(s)
    if ok:
        return leftover, ok
    leftover, ok = is_letter(s)
    if ok:
        return leftover, ok
