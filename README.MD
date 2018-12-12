Fun Docker tasks
================

All tiers have task directories with broken scripts. After completing the task, submit a pull request, which we'll all review and discuss.


Tier 1
------
Beginner tier.

Task 1: Run nginx, and expose its' port 80 on *:8080

Bonus: expose port 8080 on 127.0.0.1 only

Task2: Run nginx. Serve static content from your computer. 

Bonus: you can change the content on-the-fly

Tier 2
------
Slightly advanced tier.

Task 1: Run nginx + php "hello_world.php" application without docker-compose

Bonus: without using host network

Task 2: Build and publish your "hello_world.php" application to dockerhub


Tier 3
------
Actually useful stuff tier.

Task 1: Run a default wordpress application using docker-compose.

Tier 4
------

Advanced tier

Task: Run firefox on Xvfb, accessible via VNC

Bonus 1: firefox runs on your desktop (Linux users only!)


Tier 5
------

God tier

Task 1: Run firefox on Xvfb, accessible via VNC. VNC is filtered, allowing only certain IPs to connect.

Task 2: Run deluge torrent service, routing all traffic over openvpn tunnel.