Ignore moved diff lines
=======================

Diffs often show a lot of lines which have simply been moved around, for example after running `sort` on a configuration file. For each line in the diff, this script will check whether that line has been added and removed the same amount of times. If so, it's simply removed from output.

Installation
------------

    make test # Optional; requires shunit2
    sudo make install

Usage
-----

    diff ... | diff-ignore-moved-lines
    diff-ignore-moved-lines < file.patch
