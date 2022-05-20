#!/bin/bash
pp -M IO::Socket::INET -o bin/stomp_sender_bulk src/stomp_sender_bulk.pl
pp -M IO::Socket::INET -o bin/stomp_receiver src/stomp_receiver.pl
pp -M IO::Socket::INET -o bin/stomp_dump_queue src/stomp_dump_queue.pl


