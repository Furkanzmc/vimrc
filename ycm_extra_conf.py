"""
Provides additional functionality for the custom ycm_extra_conf.py files.

`g:ycm_conf_search_for_nearest`: Default value is false. If set to true,
`compile_commands.json` and `.clang_complete` files will be looked for
in the nearst path.

C++ Configuration:
    Set 'g:include_search_dirs' variable in your .vimrc file to walk in
    that directory to add include paths.

    Set 'g:extend_isystem' to 1 to add the local include paths to the
    system include paths as well.

    Set 'g:cpp_include_paths' to extend the include paths.
    Set 'g:cpp_frameworks' to extend the include paths (macOS Only).

    Set 'g:cpp_qt_path' and 'g:cpp_qt_modules' to enable Qt support.
    Qt's path should be to the kit directory (eg.
    ~/Qt/5.11.1/clang_64)

    Set 'g:cpp_compilation_database_folder' to the directory of the json file.

    Set those variables to 'g:ycm_extra_conf_vim_data'.
"""

import os
import ycm_core
import logging
from subprocess import call


C_BASE_FLAGS = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-fexceptions',
    '-ferror-limit=10000',
    '-DNDEBUG',
    '-std=c11',
    '-I/usr/lib/',
    '-I/usr/include/'
]

CPP_BASE_FLAGS = [
    '-Wall',
    '-Wextra',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-fexceptions',
    '-ferror-limit=10000',
    '-DNDEBUG',
    '-std=c++1z',
    '-xc++',
    '-I/usr/lib/',
    '-I/usr/include/'
]

C_SOURCE_EXTENSIONS = ['.c']

CPP_SOURCE_EXTENSIONS = [
    '.cpp',
    '.cxx',
    '.cc',
    '.m',
    '.mm'
]

SOURCE_DIRECTORIES = [
    'src',
    'lib'
]

HEADER_EXTENSIONS = [
    '.h',
    '.hxx',
    '.hpp',
    '.hh'
]

HEADER_DIRECTORIES = ['include']

BUILD_DIRECTORY = 'build'

DIR_OF_THIS_SCRIPT = os.path.abspath(os.path.dirname(__file__))

PWD = os.environ['PWD']


def is_header_file(filename):
    extension = os.path.splitext(filename)[1]
    return extension in HEADER_EXTENSIONS


def is_source_file(filename):
    extension = os.path.splitext(filename)[1]
    return extension in C_SOURCE_EXTENSIONS + CPP_SOURCE_EXTENSIONS


def get_compilation_info_for_file(database, filename):
    if is_header_file(filename):
        basename = os.path.splitext(filename)[0]
        for extension in C_SOURCE_EXTENSIONS + CPP_SOURCE_EXTENSIONS:
            # Get info from the source files by replacing the extension.
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                compilation_info = database.GetCompilationInfoForFile(replacement_file)
                if compilation_info.compiler_flags_:
                    return compilation_info
            # If that wasn't successful, try replacing possible header directory with possible source directories.
            for header_dir in HEADER_DIRECTORIES:
                for source_dir in SOURCE_DIRECTORIES:
                    src_file = replacement_file.replace(header_dir, source_dir)
                    if os.path.exists(src_file):
                        compilation_info = database.GetCompilationInfoForFile(src_file)
                        if compilation_info.compiler_flags_:
                            return compilation_info

        return None
    return database.GetCompilationInfoForFile(filename)


def find_nearest(path, target, build_folder=None):
    candidate = os.path.join(path, target)
    if os.path.isfile(candidate) or os.path.isdir(candidate):
        logging.info("Found nearest " + target + " at " + candidate)
        return candidate

    parent = os.path.dirname(os.path.abspath(path))
    if parent == path:
        return ''

    if build_folder:
        candidate = os.path.join(parent, build_folder, target)
        if os.path.isfile(candidate) or os.path.isdir(candidate):
            logging.info("Found nearest " + target + " in build folder at " + candidate)
            return candidate

    return find_nearest(parent, target, build_folder)


def make_relative_paths_absolute_in_flags(flags, working_directory):
    if not working_directory:
        return list(flags)

    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)

    return new_flags


def get_flags_for_clang_complete(root):
    clang_complete_path = find_nearest(root, '.clang_complete')
    clang_complete_flags = []
    if os.path.exists(clang_complete_path):
        clang_complete_flags = open(clang_complete_path, 'r').read().splitlines()

    return clang_complete_flags


def get_flags_for_inc(root):
    include_path = find_nearest(root, 'include')
    flags = []
    for dirroot, dirnames, filenames in os.walk(include_path):
        for dir_path in dirnames:
            real_path = os.path.join(dirroot, dir_path)
            flags = flags + ["-I" + real_path]
            return flags


def get_flags_from_compilation_db(root, filename, **kwargs):
    if kwargs['comp_commands_folder'] is not None:
        compilation_db_path = os.path.join(kwargs['comp_commands_folder'], 'compile_commands.json')
        compilation_db_dir = kwargs['comp_commands_folder']
    else:
        # Last argument of next function is the name of the build folder for
        # out of source projects
        compilation_db_path = find_nearest(root, 'compile_commands.json', BUILD_DIRECTORY)
        compilation_db_dir = os.path.dirname(compilation_db_path)
    logging.info("Set compilation database directory to " + compilation_db_dir)
    compilation_db = ycm_core.CompilationDatabase(compilation_db_dir)
    if not compilation_db:
        logging.info("Compilation database file found but unable to load")
        return None

    compilation_info = get_compilation_info_for_file(compilation_db, filename)
    if not compilation_info:
        logging.info("No compilation info for " + filename + " in compilation database")
        return None

    return make_relative_paths_absolute_in_flags(
        compilation_info.compiler_flags_,
        compilation_info.compiler_working_dir_
    )


def get_flags_for_file(filename, **kwargs):
    final_flags = []
    root = os.path.realpath(filename)
    compilation_db_flags = get_flags_from_compilation_db(root, filename, **kwargs)
    if compilation_db_flags:
        final_flags = compilation_db_flags
    else:
        if is_source_file(filename):
            extension = os.path.splitext(filename)[1]
            if extension in C_SOURCE_EXTENSIONS:
                final_flags = C_BASE_FLAGS
            else:
                final_flags = CPP_BASE_FLAGS

        clang_flags = get_flags_for_clang_complete(root)
        if clang_flags:
            final_flags = final_flags + clang_flags
            include_flags = get_flags_for_inc(root)
            if include_flags:
                final_flags = final_flags + include_flags

    return final_flags


def find_corresponding_source_file(filename):
    if is_header_file(filename):
        basename = os.path.splitext(filename)[0]
    else:
        return filename

    for extension in C_SOURCE_EXTENSIONS + CPP_SOURCE_EXTENSIONS:
        replacement_file = basename + extension
        if os.path.exists(replacement_file):
            return replacement_file

    return filename


def contains_headers(file_list):
    contains = False
    for file_name in file_list:
        if file_name.endswith('.h') or file_name.endswith('.hpp'):
            contains = True
            break

    return contains


def get_cpp_conf(**kwargs):
    """Return C++ configuration."""

    conf = {
        'flags': [],
        'include_paths_relative_to_dir': '',
        'override_filename': '',
        'do_cache': True
    }

    frameworks = [
        '/System/Library/Frameworks',
        '/Library/Frameworks',
    ]

    system_inc_paths = []

    include_paths = [
        '.',
        PWD,
    ]

    extend_isystem = False
    dir_to_walk = []
    com_commands_folder = None
    if 'client_data' in kwargs:
        client_data = kwargs['client_data']

        if 'g:include_search_dirs' in client_data:
            dir_to_walk = client_data['g:include_search_dirs']

        if 'g:extend_isystem' in client_data:
            extend_isystem = client_data['g:extend_isystem']

        if 'g:cpp_include_paths' in client_data:
            include_paths.extend(client_data['g:cpp_include_paths'])

        if 'g:cpp_frameworks' in client_data:
            frameworks.extend(client_data['g:cpp_frameworks'])

        if 'g:cpp_qt_path' in client_data and 'g:cpp_qt_modules' in client_data:
            qt_path = client_data['g:cpp_qt_path']
            qt_modules = client_data['g:cpp_qt_modules']
            # Create symbolic links in the include directory for the modules because the header
            # files use relative includes (e.g QtCore/qstring.h)
            qt_top_include_path = '%s/include/' % (qt_path, )
            include_paths.append(qt_top_include_path)

            for module in qt_modules:
                framework_path = '%s/lib/%s.framework' % (qt_path, module)
                if os.path.exists('%s/%s' % (qt_top_include_path, module)) is False:
                    call([
                        'ln',
                        '-s',
                        '%s/Headers' % (framework_path, ),
                        '%s/%s' % (qt_top_include_path, module)
                    ])

                frameworks.append(framework_path)
                include_paths.append('%s/Headers' % (framework_path, ))

        if 'g:cpp_compilation_database_folder' in client_data:
            com_commands_folder = client_data['g:cpp_compilation_database_folder']

    if dir_to_walk:
        for subdir, dirs, files in os.walk(dir_to_walk):
            include_paths.append(subdir)

    for path in system_inc_paths:
        conf['flags'].extend(['-isystem ', path])

    for path in include_paths:
        conf['flags'].extend(['-I', path])
        if extend_isystem:
            conf['flags'].extend(['-isystem', path])

    for path in frameworks:
        conf['flags'].extend(['-F', path])

    if PWD:
        conf['include_paths_relative_to_dir'] = PWD

    if 'filename' in kwargs:
        conf['override_filename'] = find_corresponding_source_file(kwargs['filename'])

    cmp_flags = get_flags_for_file(kwargs['filename'], comp_commands_folder=com_commands_folder)
    conf['flags'].extend(cmp_flags)
    return conf


def get_python_conf(**kwargs):
    """Returns the interpreter path and import path."""

    conf = {
        'interpreter_path': '',
        'sys_path': []
    }

    VIRTUAL_ENV_DIR = None
    if os.path.exists('%s/.venv' % (PWD, )):
        VIRTUAL_ENV_DIR = '%s/.venv' % (PWD, )
    elif 'VIRTUAL_ENV' in os.environ:
        VIRTUAL_ENV_DIR = os.environ['VIRTUAL_ENV']
    else:
        logging.warn('VIRTUAL_ENV cannot be found.')

    if VIRTUAL_ENV_DIR:
        conf['interpreter_path'] = '%s/bin/python' % (VIRTUAL_ENV_DIR,)
        conf['sys_path'] = [
            '%s/lib/python2.7/site-packages/' % (VIRTUAL_ENV_DIR, )
        ]

    if 'client_data' in kwargs:
        client_data = kwargs.get('client_data')
        if 'g:ycm_python_import_paths' in client_data:
            conf['sys_path'].extend(client_data.get('g:ycm_python_import_paths'))

        if 'g:ycm_python_interpreter_path' in client_data:
            conf['interpreter_path'] = client_data.get('g:ycm_python_interpreter_path')

    return conf


def Settings(**kwargs):
    conf = {}
    if kwargs['language'] == 'python':
        conf = get_python_conf(**kwargs)
    if kwargs['language'] == 'cfamily':
        conf = get_cpp_conf(**kwargs)

    return conf
