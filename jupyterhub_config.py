import pwd, subprocess, os, nativeauthenticator

c = get_config()  # noqa

c.JupyterHub.tornado_settings = {
    "headers": {
        "Content-Security-Policy": "frame-ancestors *",
      # "Content-Security-Policy": "frame-ancestors 'self' http://localhost:8000 https://my-external-domain.com",
    }
}

c.Authenticator.admin_users = {"admin", "indi", "user-admin"}

c.Authenticator.allow_all = True



# c.JupyterHub.authenticator_class = 'github'

c.JupyterHub.authenticator_class = "native"
c.JupyterHub.template_paths = [
    f"{os.path.dirname(nativeauthenticator.__file__)}/templates/"
]


def pre_spawn_hook(spawner):
    username = spawner.user.name
    try:
        pwd.getpwnam(username)
    except KeyError:
        subprocess.check_call(["useradd", "-ms", "/bin/bash", username])


c.Spawner.pre_spawn_hook = pre_spawn_hook

c.Spawner.default_url = "/lab"
