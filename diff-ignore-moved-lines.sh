#!/usr/bin/env bash
#
# NAME
#        diff-ignore-moved-lines.sh - Strip moved lines from a diff
#
# SYNOPSIS
#        diff-ignore-moved-lines
#
# DESCRIPTION
#
# EXAMPLES
#        diff -u ... | diff-ignore-moved-lines
#        git diff ... | diff-ignore-moved-lines
#               Remove lines from diff output.
#
#        diff-ignore-moved-lines < file.diff
#               Remove moved lines from existing patch.
#
# BUGS
#        https://github.com/l0b0/diff-ignore-moved-lines/issues
#
# COPYRIGHT
#    Copyright (C) 2011-2014 Victor Engmark
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

set -o errexit -o noclobber -o nounset -o pipefail

# Only output diff lines (context lines and such would not be accurate anyway)
# Also, convert unified diffs to "normal" diffs
diff_lines="$(grep -v '^\(---\|+++\|@@ \)'| grep '^\([><] \)\|[+-]' | sed 's/^+/> /;s/^-/< /')" || exit 0

while IFS= read -r line || [ -n "$line" ]
do
    contents="${line:2}"
    count_removes="$(grep -cFxe "< $contents" <<< "$diff_lines" || true)"
    count_adds="$(grep -cFxe "> $contents" <<< "$diff_lines" || true)"
    if [[ "$count_removes" -eq "$count_adds" ]]
    then
        # Line has been moved; skip it.
        continue
    fi

    echo "$line"
done <<< "$diff_lines"

exit 1 # Diff exists, so we should use the diff exit code
