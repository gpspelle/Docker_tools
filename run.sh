sudo nvidia-docker run --rm --runtime=nvidia -it --user $(id -u) -v "/mnt:/mnt" -v "/home/gabriel/teste/Fall_detection:/home/developer/Fall_detection/" "semantix/v0.0.1" /bin/bash
