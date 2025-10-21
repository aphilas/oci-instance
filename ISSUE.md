# Issue

Can't access instance via ssh.

## Steps to Reproduce

Note: Replace 192.168.0.1 with the actual public IP address of the instance.

```
$ ssh -i ~/.ssh/id_ed25519 -p 2222 ubuntu@192.168.0.1
ssh: connect to host 192.168.0.1 port 2222: No route to host

$ ping -c 5 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=51 time=235 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=51 time=235 ms
64 bytes from 192.168.0.1: icmp_seq=3 ttl=51 time=235 ms
64 bytes from 192.168.0.1: icmp_seq=4 ttl=51 time=235 ms
64 bytes from 192.168.0.1: icmp_seq=5 ttl=51 time=235 ms

--- 192.168.0.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4004ms
rtt min/avg/max/mdev = 234.986/235.240/235.400/0.151 ms
```

## What I have tried

1. Logging into the Cloud Console to verify ufw and ssh are running.

  ```
  $ sudo ufw status
  Status: active
  To                         Action      From
  --                         ------      ----
  2222/tcp                     ALLOW       Anywhere
  2222/tcp (v6)                ALLOW       Anywhere (v6)

  # SSH server running on port 2222 as expected.
  $ sudo systemctl status ssh
    ssh.service - OpenBSD Secure Shell server
        Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: ena>
        Active: active (running) since Mon 2025-10-20 15:40:10 UTC; 9min ago
    TriggeredBy: ssh.socket
          Docs: man:sshd(8)
                man:sshd_config(5)
        Process: 10466 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCES>
      Main PID: 10467 (sshd)
          Tasks: 1 (limit: 7017)
        Memory: 1.1M (peak: 1.4M)
            CPU: 20ms
        CGroup: /system.slice/ssh.service
                10467 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

    Oct 20 15:40:10 hostname systemd[1]: Starting ssh.service - OpenBSD Secure Shell s>
    Oct 20 15:40:10 hostname sshd[10467]: Server listening on 0.0.0.0 port 2222.
    Oct 20 15:40:10 hostname sshd[10467]: Server listening on :: port 2222.
    Oct 20 15:40:10 hostname systemd[1]: Started ssh.service - OpenBSD Secure Shell se>
    
  $ cat /etc/ssh/sshd_config.d/cloud-init.conf
  # Truncated output
  # Config is as expected.

  $ sudo less /var/log/cloud-init-output.log
  # No errors found.

  $ ss -tuln | grep 2222
  # Truncated output: Port 2222 is listening as expected.
  ```

2. Attempting to nc to the ssh port.

  ```
  $ ncat -zv 192.168.0.1 2222
  Ncat: Version 7.98 ( https://nmap.org/ncat )
  Ncat: No route to host.

  # Trying a random port: No response, hangs forever.
  $ ncat -zv 192.168.0.1 22
  ```

3. Adding NSG rules to the instance VNIC to allow inbound traffic on port 2222 from all sources.

  Result: No change.

4. Manually reviewing the instance VNIC, subnet security lists, and route tables on the Cloud Console.

  Result: No misconfigurations (I could perceive) found.
