#!/usr/bin/env python3

import dbus
import dbus.mainloop.glib
from gi.repository import GLib
import os
import subprocess
import threading
import time
import fcntl

import logging

logger = logging.getLogger("lock")
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
log_handler = logging.StreamHandler()
log_handler.setFormatter(formatter)
logger.addHandler(log_handler)
logger.setLevel(logging.INFO)


class Lock:
    def __init__(self):
        dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
        self.bus = dbus.SystemBus()
        logind = self.bus.get_object(
            "org.freedesktop.login1", "/org/freedesktop/login1"
        )
        self.manager = dbus.Interface(logind, "org.freedesktop.login1.Manager")
        session_path = self.manager.GetSession(os.environ["XDG_SESSION_ID"])
        logger.info(f"session object {session_path}")
        self.lock_process = None
        self.acquire_inhibitor()
        self.manager.connect_to_signal(
            "PrepareForSleep", lambda active: self.prepare_for_sleep(active)
        )
        self.bus.add_signal_receiver(
            lambda: self.lock_signal_handler(),
            "Lock",
            "org.freedesktop.login1.Session",
            path=session_path,
        )

    def release_inhibitor(self):
        if self.inhibitor_fd is not None:
            logger.info("Releasing inhibitor")
            os.close(self.inhibitor_fd)
            self.inhibitor_fd = None
            logger.info("Inhibitor released")

    def acquire_inhibitor(self):
        fd_object = self.manager.Inhibit(
            "sleep", "inhibit-lock-release-loop.py", "Lock before sleeping", "delay"
        )
        self.inhibitor_fd = fd_object.take()
        fcntl.fcntl(self.inhibitor_fd, fcntl.F_SETFD, fcntl.FD_CLOEXEC)
        logger.info(f"inhibitor fd {self.inhibitor_fd}")

    def wait_lock_process(self):
        self.lock_process.wait()
        self.lock_process = None
        self.acquire_inhibitor()
        pass

    def lock(self):
        if self.lock_process is not None:
            logger.info("The lock is already running.")
            return
        logger.info("Locking...")
        (ready_fd_r, ready_fd_w) = os.pipe()
        os.set_inheritable(ready_fd_w, True)
        self.lock_process = subprocess.Popen(
            ["swaylock-my", str(ready_fd_w)], close_fds=False
        )
        os.close(ready_fd_w)
        t = threading.Thread(target=lambda: self.wait_lock_process())
        t.start()
        ready_file = os.fdopen(ready_fd_r)
        logger.info("Waiting for the lockscreen to appear.")
        ready_str = ready_file.readline()
        if ready_str == "":
            logger.error("ready_fd got an empty string")
        ready_file.close()
        logger.info("The lock process is ready.")
        #logger.info("sleep to avoid race")
        #time.sleep(1)
        self.release_inhibitor()

    def sway_idle_workaround(self):
        def run_in_thread():
            p = subprocess.Popen(["wayland-idle-inhibitor.py"])
            time.sleep(1)
            p.terminate()

        t = threading.Thread(target=run_in_thread)
        t.start()

    def before_sleep(self):
        logger.info("Before sleep.")
        self.lock()

    def resume_from_sleep(self):
        logger.info("Resume from sleep.")
        if self.lock_process is None:
            logger.error("The lock process exited before resuming from sleep.")
        self.sway_idle_workaround()

    def prepare_for_sleep(self, active: bool):
        if active:
            self.before_sleep()
        else:
            self.resume_from_sleep()

    def lock_signal_handler(self):
        logger.info("Lock signal received.")
        self.lock()


def main():
    lock = Lock()
    loop = GLib.MainLoop()
    try:
        loop.run()
    except KeyboardInterrupt:
        lock.release_inhibitor()
        loop.quit()


if __name__ == "__main__":
    main()
