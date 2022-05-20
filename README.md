# stomp_tools
Tools for using STOMP with Apache ActiveMQ without additional dependencies

## Usage
```
find $(pwd) | grep mp4 | bin/stomp_sender_bulk videos_to_process
NEXT_VIDEO = $(bin/stomp_receiver videos_to_process)
NEXT_VIDEO = $(ssh -q server_with_internet_connection "~/stomp_tools/bin/stomp_receiver" videos_to_process)
bin/stomp_dump_queue videos_to_process > list_of_videos_in_queue.txt
```
Settings (including credentials) are specified in `stomp_config.cfg`, which needs to be in the same directory as the tools. A sample is provided in the src directory. 

## Compiling
The binaries were compiled on Ubuntu 16.04 LTS, because it has the oldest glibc. If compiled on 20.04 it will not run on 18.04, for instance. They should work on anything newer than that. The following packages were installed.
```
sudo apt install libnet-stomp-perl
sudo apt install libio-socket-inet6-perl
sudo apt install libpar-packer-perl
sudo apt install libconfig-file-perl
```
The compilation is done with pp by `makeit.sh`.

## Server Side
The config file in the `server_conf` directory is a closed-down version of the original `activemq.xml` shipped with ActiveMQ.

The variables `admin.password` and `user.password` are defined in `credentials.properties`.

A web user admin password is defined in `jetty-realm.properties`.

A further potential place for passwords with the JAAS provider is `users.properties`, but I think this is not used with this config.
