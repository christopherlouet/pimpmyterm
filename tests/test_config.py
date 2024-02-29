import inspect
import os

current_dir: str = "./"
if os.getenv('ENV') == "docker":
    current_dir = "/app/tests"
else:
    current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
script: str = os.path.abspath(f"{current_dir}/../libs/config.sh")


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


def test_config_read_conf_file_not_exists(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_read', '--test=2']) == "Configuration file not found! (test)"
        assert s.last_return_code == 1


def test_config_read_profile_path_not_exists(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_read', '--test=3']) == "Profile path not found! (test)"
        assert s.last_return_code == 2


def test_config_read_profile_not_exists(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_read', '--test=4']) == "Profile not found!"
        assert s.last_return_code == 3


def test_config_read_profile_file_not_exists(bash):
    with (bash() as s):
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_read', '--test=5']
                            ) == f"Profile configuration file not found! ({current_dir}/profiles/profile_fake.ini)"
        assert s.last_return_code == 4


def test_config_read(bash):
    with bash() as s:
        s.auto_return_code_error = False
        result = s.run_script(script, ['config_read', '--test=1'])
        assert result.splitlines()[0] == f"CONFIG_FILE_PATH {current_dir}/config/config_profile.ini"
        assert result.splitlines()[1] == "PROFILE profile"
        assert result.splitlines()[2] == f"PROFILE_CONFIG_FILE {current_dir}/profiles/profile.ini"
        assert s.last_return_code == 0


def test_config_profile_list_profile_path_not_exists(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_profile_list', '--test=3']) == "Profile path not found! (test)"
        assert s.last_return_code == 1


def test_config_profile_list(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_profile_list', '--test=1']) == "2"
        assert s.last_return_code == 0


def test_config_profile_update_conf_file_not_exists(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_profile_update', '--test=2']) == "Configuration file not found! (test)"
        assert s.last_return_code == 1


def test_config_profile_update_profile_file_not_exists(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_profile_update', '--test=4']) == "Profile not found!"
        assert s.last_return_code == 2


def test_config_profile_update_profile_key_not_exists(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_profile_update', '--test=6']
                            ) == "The profile field was not found in the global section"
        assert s.last_return_code == 3


def test_config_profile_update(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_profile_update', '--test=1']) == "2"
        assert s.last_return_code == 0


def test_config_theme_list_profile_path_not_exists(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_theme_list', '--test=8']) == "Theme path not found! (test)"
        assert s.last_return_code == 1


def test_config_theme_list(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['config_theme_list', '--test=1']) == "1"
        assert s.last_return_code == 0
