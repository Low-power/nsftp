Use the Secure File Transfer Protocol, originally a sub-protocol of the Secure Shell (SSH) protocol, as a standalone protocol that established directly on TCP instead of SSH.
This FTP server / client is really simple, doesn't have any encryption and authentication stuff.
Based on the SFTP implementation in OpenSSH, specifically sftp(1) and sftp-server(8).

## Dependencies
Server depends on xinetd(8) and sftp-server(8) (OpenSSH).
Client depends on nc(1) and ssh(1) (OpenSSH).

## Usage
Setup the server by deploy the provided xinetd configuration file, modify it to fit your needs, then restart xinetd.
In the client, deploy file `sftp-ssh-to-nc.sh` to some where you could easily find or under the PATH; connect to server using `sftp -S <path/to/sftp-ssh-to-nc.sh> [-P <port>] <server-address>`.