#!/usr/bin/env python3
# Executa um comando sob um pty e descarta a saida (para o vsim do
# ModelSim 10.1d, que exige terminal e morre em silencio sem ele).
import os, pty, select, sys, time

cmd = sys.argv[1:]
env = dict(os.environ)
pid, fd = pty.fork()
if pid == 0:
    os.execve(cmd[0], cmd, env)
t0 = time.time()
while time.time() - t0 < 600:
    r, _, _ = select.select([fd], [], [], 1.0)
    if r:
        try:
            if not os.read(fd, 4096):
                break
        except OSError:
            break
    else:
        p, st = os.waitpid(pid, os.WNOHANG)
        if p:
            break
try:
    os.waitpid(pid, 0)
except ChildProcessError:
    pass
