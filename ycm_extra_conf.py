"""
Provides additional functionality for the custom ycm_extra_conf.py files.
"""

import os
import ycm_core
from subprocess import call


DIR_OF_THIS_SCRIPT = os.path.abspath(os.path.dirname(__file__))
SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']
PWD = os.environ['PWD']
compilation_database_folder = ''


def get_python_conf(**kwargs):
    """Returns the interpreter path and import path.

    Use 'g:ycm_python_sys_path' to add additional import paths.
    """
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
        print('VIRTUAL_ENV cannot be found.')

    if VIRTUAL_ENV_DIR:
        conf['interpreter_path'] = '%s/bin/python' % (VIRTUAL_ENV_DIR,)
        conf['sys_path'] = [
            '%s/lib/python2.7/site-packages/' % (VIRTUAL_ENV_DIR, )
        ]

    if 'client_data' in kwargs:
        client_data = kwargs.get('client_data')
        if 'g:ycm_python_sys_path' in client_data:
            conf['sys_path'].extend(client_data.get('g:ycm_python_sys_path'))

        if 'g:ycm_python_interpreter_path' in client_data:
            conf['interpreter_path'] = client_data.get('g:ycm_python_interpreter_path')

    return conf


def is_header_file(filename):
    extension = os.path.splitext(filename)[1]
    return extension in ['.h', '.hxx', '.hpp', '.hh']


def find_corresponding_source_file(filename):
    if is_header_file(filename):
        basename = os.path.splitext(filename)[0]
    else:
        return filename

    for extension in SOURCE_EXTENSIONS:
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
    """Return C++ configuration.

    Set 'g:project_dir' variable in your .vimrc file to walk in
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

    conf = {
        'flags': [
            '-x',
            'c++',
            '-c',
            '-pipe',
            '-stdlib=libc++',
            '-g',
            '-std=gnu++1y',
            '-arch',
            'x86_64',
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
            '-fPIC',
            '-headerpad_max_install_names',
            '-Wl,-syslibroot,/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk',
            '-Wl,-rpath,@executable_path/Frameworks',
            '-Wl,-rpath,/Users/uzumcuf/Qt/5.10.0/clang_64/lib',
        ],
        'include_paths_relative_to_dir': '',
        'override_filename': ''
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

    include_paths.extend(system_inc_paths)
    extend_isystem = False

    dir_to_walk = PWD
    if 'client_data' in kwargs:
        client_data = kwargs['client_data']

        if 'g:project_dir' in client_data:
            dir_to_walk = client_data['g:project_dir']

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
            db_conf = get_flags_from_database(
                client_data['g:cpp_compilation_database_folder'],
                **kwargs
            )
            if 'flags' in db_conf:
                conf['flags'] = db_conf['flags']

            if 'include_paths_relative_to_dir' in db_conf:
                conf['include_paths_relative_to_dir'] = db_conf['include_paths_relative_to_dir']

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

    return conf


def get_flags_from_database(database_folder, **kwargs):
    if os.path.exists(database_folder) is False or 'filename' not in kwargs:
        return {}

    database = ycm_core.CompilationDatabase(database_folder)
    compilation_info = database.GetCompilationInfoForFile(kwargs['filename'])
    if not compilation_info.compiler_flags_:
        return {}

    final_flags = list(compilation_info.compiler_flags_)
    return {
        'flags': final_flags,
        'include_paths_relative_to_dir': compilation_info.compiler_working_dir_
    }


def Settings(**kwargs):
    conf = {}
    if kwargs['language'] == 'python':
        conf = get_python_conf(**kwargs)
    if kwargs['language'] == 'cfamily':
        conf = get_cpp_conf(**kwargs)

    return conf
