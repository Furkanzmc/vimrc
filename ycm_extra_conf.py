"""
Provides additional functionality for the custom ycm_extra_conf.py files.
"""

import os


DIR_OF_THIS_SCRIPT = os.path.abspath(os.path.dirname(__file__))
SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']
VIRTUAL_ENV_DIR = None
PWD = os.environ['PWD']

if 'VIRTUAL_ENV' in os.environ:
    VIRTUAL_ENV_DIR = os.environ['VIRTUAL_ENV']


def get_python_conf(**kwargs):
    """Returns the interpreter path and import path."""
    conf = {
        'interpreter_path': '',
        'sys_path': []
    }

    if os.path.exists('%s/.venv' % (PWD, )):
        VIRTUAL_ENV_DIR = '%s/.venv' % (PWD, )
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


def Settings(**kwargs):
    conf = {}
    if kwargs['language'] == 'python':
        conf = get_python_conf(**kwargs)

    fh = open('/Users/Furkanzmc/Desktop/debug.log', 'w')
    fh.write(str(conf))
    fh.close()

    return conf
