#!/usr/bin/env bash
#
# NAME
#    test.sh - Test script
#
# BUGS
#    https://github.com/l0b0/diff-ignore-moved-lines/issues
#
# COPYRIGHT AND LICENSE
#    Copyright (C) 2011 Victor Engmark
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################

declare -r cmd="$(dirname -- "$0")/ignore_moves.sh"

test_empty() {
    file1=$'test'
    file2=$'test'
    assertEquals \
        Empty \
        x \
        "$(diff <(printf %s "$file1") <(printf %s "$file2") | "$cmd" && printf x)"

    file1=$'test\n'
    file2=$'test\n'
    assertEquals \
        Empty \
        x \
        "$(diff <(printf %s "$file1") <(printf %s "$file2") | "$cmd" && printf x)"
}

test_simple() {
    file1=$'1\n'
    file2=$'2\n'
    assertEquals \
        "Different lines" \
        "< ${file1}> ${file2}x" \
        "$(diff <(printf %s "$file1") <(printf %s "$file2") | "$cmd" || printf x)"

    file1=$'1\n2\n'
    file2=$'2\n1\n'
    assertEquals \
        "Flipped lines" \
        x \
        "$(diff <(printf %s "$file1") <(printf %s "$file2") | "$cmd" || printf x)"

    file1=$'1\n2\n3\n'
    file2=$'2\n1\n3\n'
    assertEquals \
        "Single moved line" \
        x \
        "$(diff <(printf %s "$file1") <(printf %s "$file2") | "$cmd" || printf x)"
}

test_natural() {
    file1="In theory
there is no difference
between theory and practice

In practice there is

Yogi Berra
"
    file2="In theory
between theory and practice
there no difference is

In practice there is

Yoda
"
    diff="< there is no difference
> there no difference is
< Yogi Berra
> Yoda
"
    assertEquals \
        "Moved and changed lines" \
        "$diff"x \
        "$(diff <(printf %s "$file1") <(printf %s "$file2") | "$cmd" || printf x)"
}

# load and run shUnit2
test -n "${ZSH_VERSION:-}" && SHUNIT_PARENT=$0
. shunit2
