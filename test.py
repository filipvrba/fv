from multiprocessing.connection import wait
from subprocess import Popen, PIPE
import os
import signal, time

def build():    
    command = "fv -m 'table'" 
    pipe = Popen(command, shell=True, stdout=PIPE, stderr=PIPE)
    pid = pipe.stdout.readline().decode()

    print(int(pid))

    time.sleep(1)
    os.kill( int(pid), signal.SIGUSR1 )

    while True:         
        line = pipe.stdout.readline().decode()
        if line:        
            os.system( f"cat {line}" )
            break
        if not line:
            break
    


build()