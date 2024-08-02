#!/usr/bin/env python3

# Converts a Python path to a folder path and open Vim on the relevant
# lines.
#
# Usage:
#
#   pyvi <python_module_path>
#
# For example:
#
#   pyvi nova.tests.unit.virt.libvirt.test_vif.LibvirtVifTestCase
#
# This will convert the 'nova.tests.unit.virt.libvirt.test_vif' part of this
# module path to a filepath then open the file (test_vif.py) on the
# appropriate line.

# originally from: https://that.guru/blog/open-python-paths-with-vim/
# but with modifications

import os.path
import subprocess
import sys


def runner(args):
    if len(args) != 2:
        print("Must pass the test path to the file")
        sys.exit(1)

    editor = os.environ.get('EDITOR', None)
    if editor is None:
        print("Must set the EDITOR variable for the script to run")
        sys.exit(1)

    path = sys.argv[1].split('.')

    for i in range(len(path), 1, -1):
        filename = os.path.join(*path[0:i-1] + ['{}.py'.format(path[i-1])])
        if os.path.isfile(filename):
            args = ['{}'.format(filename)]
            args = args + ['+1'] + ['+/{}'.format(p) for p in path[i:]]
            os.execv(editor, [editor] + args)

    print("Couldn't find the path as a file?")
    exit(1)


if __name__ == '__main__':
    runner(sys.argv)
