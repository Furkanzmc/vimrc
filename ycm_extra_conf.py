"""
Provides additional functionality for the custom ycm_extra_conf.py files.
"""

import os

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


def get_cpp_conf(**kwargs):

    current_folder_includes = [DIR_OF_THIS_SCRIPT, ]
    for subdir, dirs, files in os.walk(DIR_OF_THIS_SCRIPT):
        current_folder_includes.append(os.path.join(subdir, dirs[0]))

    conf = {
        'flags': [
            '-x',
            'c++',
            '-Wall',
            '-Wextra',
            '-Werror',
            '-v',
            '-isystem',
            '/usr/include',
            '-isystem',
            '/usr/local/include',
            '-isystem',
            DIR_OF_THIS_SCRIPT,
            '-I' + DIR_OF_THIS_SCRIPT,
            '-I.'
            '-c',
            '-pipe',
            '-stdlib=libc++',
            '-g',
            '-std=gnu++1y',
            '-arch',
            'x86_64',
            '-isysroot',
            '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk',
            '-mmacosx-version-min=10.11',
            '-Wall',
            '-W',
            '-fPIC'
        ],
        'include_paths_relative_to_dir': current_folder_includes,
        'override_filename': FindCorrespondingSourceFile(kwargs['filename'])
    }

    return conf


def Settings(**kwargs):
    if kwargs['language'] == 'cfamily':
        return get_cpp_conf(**kwargs)
    elif kwargs['language'] == 'python':
        return get_python_conf(**kwargs)
