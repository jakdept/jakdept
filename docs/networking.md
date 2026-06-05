# Networking Concepts

This is an attempt to explain some common networking concepts from a server level.

## OSI 7 Layer Networks

THe OSI 7 layer network model is used for wired networking.
The layers are:

- Physical
- Data Link
- Network
- Transport
- Session
- Presentation
- Application

The physical layer in wired networking is the physical, eleectrical connection.
With ethernet, copper and electricity; or light and glass for fiber optics.

Next, the Data Link layer is all mac addressed.
Devices send frames (not packets) to other macs.
It can only talk to macs on the same network - so you're only hitting switches, hubs, and other computers with this.
There is no routing.
Mac addresses are piled onto ports in a table in a switch.
The switches detect loops, and drop interfaces to eliminate the loops.

Network layer is layer 3 in the OSI model, and it actually involves IP addresses.
Instead of having mac addresses, it has IPs.
There's a table to map IPs to macs.
Here, the chunks of data are called packets.
Subnetting lives here, and routing sends entire subnets to different things.

Layers 4 - 7 are blurry - Trnasport, Session, Presentation, and Application are fuzzy.
They kindof don't matter-ish.
Transport is focused on errors, Session is similar and handles TCP connections.
Presentation is encryption, Application is ports kindof.
But also, all of that distinctino doesn't matter.

It's far easier to just blend layers 4 - 7 together as:

- source and destinatino IP
- source and destinatino port number
- TCP sessions, ICMP stuff, UDP packet control, QUIC sessions
- tls encryption, starttls encryption, or other encryption
- protocols like http, smtp, imap, sftp, sql, etc

## Alternate Models

Instead of the OSI model, you can look at the TCP/IP model instead.
It's just more useful.
It's the first 3 layers of the OSI model - physical, macs, and IPs with routing;
Then it just smashes all of the IPs, ports, encryption, and protocols into a layer.
That's how physical ethernet networks largely work anyway.

There's an alternate network stack for wifi.
Wifi encrypts packets and transmits frames.
Everyone on the wifi network gets the frames, there's individual encryption keys but they're not strong.
It's shared bandwidth in the air, but the protocols split stuff across radio waves and amplitudes and other stuff.
But then it gets to the same routing and IPs then layer 4 with all of the TCP/IP stuff.

Fiber networks use a different network stack too.
The physical layer is light instead, and uses multiple wavelengths sometimes to transmitt different channels.
You don't have the MAC layer cause the physical is dedicated to two machines.
And your encoder / decoder are light based and not standardized like ethernet, so they work different.

Ultimately, the model does not matter.
You need to instead mostly understand that:

- there's an IP on both ends
- there's a port number on both ends (or ICMP type)
- routing happens
- on a switched network, links are dropped to kill loops. routing happens with IPs

## Network Hardware Devices

There are a few specific networking hardware pieces with computers.

### Network Card

The network card kindof doesn't count as networking hardware.
But you need one?
So it's here?
Let's pretend there's network cables here too mmmk.
Sometimes your network card has 

### Hub

The hub is the simplest networking device probably still in use.
It's a layer 2 device, meaning it doesn't do a thing with IPs.
It actually doesn't even see the IPs _or the mac addresses_.
It gets a packet in, and it sends it back out on all interfaces.
Done.
SUPER simple.

### Switch

### Router

### Layer 3 Switch

### Modem

### Access Point

### Firewall

### Dist / Distribution

### Core

### Border
