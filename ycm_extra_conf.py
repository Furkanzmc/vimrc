"""
Provides additional functionality for the custom ycm_extra_conf.py files.
"""

import os
import sys

DIR_OF_THIS_SCRIPT = os.path.abspath(os.path.dirname(__file__))
SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']
virtual_env_dir = None

if 'VIRTUAL_ENV' in os.environ:
    virtual_env_dir = os.environ['VIRTUAL_ENV']


def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in ['h', '.hxx', '.hpp', '.hh']


def FindCorrespondingSourceFile(filename):
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                return replacement_file

    return filename


def get_python_conf(**kwargs):
    """Returns the interpreter path and import path."""
    conf = {}

    if virtual_env_dir:
        conf['interpreter_path'] = '%s/bin/python' % (virtual_env_dir,)
        conf['sys_path'] = [
            '%s/lib/python2.7/site-packages/',
        ]

    return conf

def contains_headers(file_list):
    contains = False
    for file_name in file_list:
        if file_name.endswith('.h') or file_name.endswith('.hpp'):
            contains = True
            break

    return contains

def get_cpp_conf(**kwargs):

    fh = open('/Users/uzumcuf/Desktop/output.json', 'w')
    open_file_dir = None
    if 'filename' in kwargs:
        open_file_dir = os.path.dirname(kwargs['filename'])

    dir_to_walk = DIR_OF_THIS_SCRIPT # open_file_dir if open_file_dir is not None else DIR_OF_THIS_SCRIPT
    current_folder_includes = [dir_to_walk, ]
    for subdir, dirs, files in os.walk(dir_to_walk):
        # if dirs:
        #     current_folder_includes.append(os.path.join(subdir, dirs[0]))
        # else:
        if contains_headers(files):
            current_folder_includes.append(subdir)

    conf = {
        'flags': [
            '-x',
            'c++',
            '-Wall',
            '-Wextra',
            '-Werror',
            '-pipe',
            '-stdlib=libc++',
            '-g',
            '-std=gnu++11',
            '-arch',
            'x86_64',
            '-mmacosx-version-min=10.14',
            '-Wall',
            '-W',
            '-fPIC',
            '-I .',
            '-I/Users/uzumcuf/Qt/5.10.0/clang_64/lib/QtGui.framework/Headers',
            '-I/Users/uzumcuf/Qt/5.10.0/clang_64/lib/QtCore.framework/Headers',
            '-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/OpenGL.framework/Headers',
            '-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/AGL.framework/Headers',
            '-I/Users/uzumcuf/Qt/5.10.0/clang_64/mkspecs/macx-clang',
            '-F/Users/uzumcuf/Qt/5.10.0/clang_64/lib',
            '-headerpad_max_install_names',
            '-Wl,-syslibroot,/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk',
            '-Wl,-rpath,@executable_path/Frameworks',
            '-Wl,-rpath,/Users/uzumcuf/Qt/5.10.0/clang_64/lib',
            '-F/Users/uzumcuf/Qt/5.10.0/clang_64/lib',
            '-framework',
            'QtGui',
            '-framework',
            'QtCore',
            '-framework',
            'DiskArbitration',
            '-framework',
            'IOKit',
            '-framework',
            'OpenGL',
            '-framework',
            'AGL',
            '-isystem',
            '/usr/include',
            '-isystem',
            '/usr/local/include',
        ],
    }

    if 'filename' in kwargs:
        conf['override_filename'] = FindCorrespondingSourceFile(kwargs['filename'])

    for inc in current_folder_includes:
        conf['flags'].append('-I' + inc)
        conf['flags'].extend(['-isystem', inc])

    fh.write(str(conf))
    fh.close()

    return conf


def Settings(**kwargs):
    if kwargs['language'] == 'cfamily':
        return get_cpp_conf(**kwargs)
    elif kwargs['language'] == 'python':
        return get_python_conf(**kwargs)
