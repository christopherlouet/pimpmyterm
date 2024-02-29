import inspect
import os

current_dir: str = "./"
if os.getenv('ENV') == "docker":
    current_dir = "/app/tests"
else:
    current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
script: str = os.path.abspath(f"{current_dir}/../libs/common.sh")


def test_no_argument(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script) == "No function to call"
        assert s.last_return_code == 1


def test_function_not_exist(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['test_function']) == "Function with name test_function does not exist"
        assert s.last_return_code == 2


def test_success_empty(bash):
    with bash() as s:
        s.auto_return_code_error = False
        s.run_script(script, ['success'])
        assert s.last_return_code == 1


def test_success_not_empty(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['success', 'test']) == "test"
        assert s.last_return_code == 0


def test_die_empty(bash):
    with bash() as s:
        s.auto_return_code_error = False
        s.run_script(script, ['die'])
        assert s.last_return_code == 1


def test_die_not_empty(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['die', 'test']) == "test"
        assert s.last_return_code == 0


def test_warning_empty(bash):
    with bash() as s:
        s.auto_return_code_error = False
        s.run_script(script, ['warning'])
        assert s.last_return_code == 1


def test_warning_not_empty(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['warning', 'test']) == "test"
        assert s.last_return_code == 0


def test_info_empty(bash):
    with bash() as s:
        s.auto_return_code_error = False
        s.run_script(script, ['info'])
        assert s.last_return_code == 1


def test_info_not_empty(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['info', 'test']) == "test"
        assert s.last_return_code == 0
