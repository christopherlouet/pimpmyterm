import inspect
import os

current_dir: str = "./"
if os.getenv('ENV_TESTS') == "docker":
    current_dir = "/app/tests"
else:
    current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
script: str = os.path.abspath(f"{current_dir}/../installer.sh")
usage: str = "Usage installer.sh [--all] [--zsh|--neovim|--tmux] [--fonts] [--gnome-terminal] [--auto]"


def test_no_argument(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script) == usage
        assert s.last_return_code == 1


def test_bad_argument(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['--test']).partition('\n')[0] == "Invalid option: --test"
        assert s.last_return_code == 1


def test_check_env(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['--check-env', '--debug']) == "Check environment"
        assert s.last_return_code == 0


def test_setup_zsh(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['--zsh', '--debug']).splitlines()[1] == "Setup zsh"
        assert s.last_return_code == 0


def test_setup_neovim(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['--neovim', '--debug']).splitlines()[1] == "Setup neovim"
        assert s.last_return_code == 0


def test_setup_tmux(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['--tmux', '--debug']).splitlines()[1] == "Setup tmux"
        assert s.last_return_code == 0


def test_setup_fonts(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['--fonts', '--debug']).splitlines()[1] == "Setup fonts"
        assert s.last_return_code == 0


def test_setup_gnome_terminal(bash):
    with bash() as s:
        s.auto_return_code_error = False
        assert s.run_script(script, ['--gnome-terminal', '--debug']).splitlines()[1] == "Setup gnome terminal theme"
        assert s.last_return_code == 0


def test_setup_all(bash):
    with bash() as s:
        s.auto_return_code_error = False
        setup_all = s.run_script(script, ['--all', '--debug'])
        assert setup_all.splitlines()[0] == "Check environment"
        assert setup_all.splitlines()[1] == "Setup zsh"
        assert setup_all.splitlines()[3] == "Setup neovim"
        assert s.last_return_code == 0
