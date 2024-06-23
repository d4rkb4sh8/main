<img width="44" height="44" src="../_resources/1_zRUFfqsikrDiY3yB-ltBzw_7c70cb8a444a47578013ef0bc.png"/>](https://medium.com/@ucihamadara?source=post_page-----4c9beb23339f--------------------------------)

![](../_resources/1_eb5oE6h-djckn-zp_O1Gvw_3d6956f58d2645cf8c50d4679.png)

(Image for metasploitable)

Metasploitable 2 is a image which are made for learning how to way to do penetration testing and testing tool for cyber security, becasuse metasploitable have several vulnerabilities.

Preparation :

1.  Virtual Machnine
2.  Metasploitable for testing
3.  Parrotsec for attacker

![](../_resources/1_NoGjO11HUICtFCjqEDH2UA_a2b38004c80a4fa1a828ea730.png)

(Image for metasploitable 2)

The default login for metasploitable 2 is msfadmin:msfadmin, we can arrange network for metasploitable 2 use (Bride or Host-only mode).

**Network Scan**

first step we can start network scan using **nmap -Pn -sV &lt;ip target&gt;**.

![](../_resources/1_WknI6VkKzIVJZ2URaycD_g_f6c9e3eb5a7e4708b2e3c493f.png)

(Image for network scan)

**How to exploit port 21 FTP**

let’s start by exploiting port 21 running FTP with Hydra and two wordlists for operation we have default login names and passwords.

![](../_resources/1_uhxdfXHSKm9yGtusgZrW3g_210233dc2f2443aa968fcc3dc.png)

(Brute-force username and password using Hydra)

let’s try to connect using FTP.

<img width="680" height="446" src="../_resources/1_khqjYdJ8F9pX1c8y8o8UBQ_878ede0da9a94421b423d05b5.png"/>

(Connect to FTP)

**How to exploit VSFTPD 2.3.4**

let’s try to exploit VSFTPD 2.3.4 running in port 21 version of the FTP services.

<img width="680" height="110" src="../_resources/1_EFXtA5y7lV7xWzTC2OZu8g_00e2c5deed8c430eadfba1ef7.png"/>

(Search exploit for VSFTPD)

we now have our exploit exploit/unix/ftp/vsftpd_234_backdoor and let’s try to exploit VSFTPD 2.3.4.

<img width="680" height="269" src="../_resources/1_h2bBa9ul6sqtWD-s_vtYzQ_5f0e4cd8875f45f1a41c90c8f.png"/>

<img width="680" height="320" src="../_resources/1_0lcRdUNZru0MswWounItsA_cbb6290421e44e30a730cc113.png"/>

**How to exploit port 22 SSH**

let’s start to exploit port 22 running SSH services using **auxiliary/scanner/ssh/ssh_login** module**.**

<img width="680" height="291" src="../_resources/1_cG7QtvAFx6cqPWwhZuixhg_6be8e7b3f38d443cb603b4268.png"/>

<img width="680" height="194" src="../_resources/1_OM_Bw7r0mikeBmI8_KeTvA_628010008c514a5dab9b34117.png"/>

<img width="680" height="238" src="../_resources/1_xdoQ6X-FfJodzEnnKNouQQ_a2f20c2a787a48caac454d1ec.png"/>

**How to exploit port 139 & 445 SAMBA**

samba running on port 139 & 445 and we can exploit using metasploit and use **exploit/multi/samba/usermap_script** module.

<img width="680" height="288" src="../_resources/1_-bTnPkJ8ZVnoqTgN1cIC6Q_597b331a9812467ebd8f3f260.png"/>

<img width="680" height="213" src="../_resources/1_KDAQh7g_OwLxj_86YDHyeg_720d8e58386546bdbea61d621.png"/>

**How to exploit port 2049 NFS_ACL**

Based on the port scan result, there’s an open port 2049 that runs nfs_acl.  
NFS is a Network File Sharing protocol that allows users to share directories and files over the network across different operating systems. In the real case scenario while the NFS service is misconfigured, it can allow an attacker to access the sensitive data or obtain a shell on the system in an unauthorized way.

<img width="680" height="231" src="../_resources/1_9woxI5GV_ilZGro_goabtg_b11b7db113c945dcaaaa6d829.png"/>

<img width="680" height="362" src="../_resources/1_fB3vZV37pjpbFJereJEfLA_3c1c90db12424e228799afa81.png"/>

**How to exploit port 5432 POSTGRES**

Postgres running in port 5432, postgress allowing execute of arbitary code, we can use payloads **exploit/linux/postgres/postgres_payload,** we can search exploit with command &lt;search exploit_name&gt;.

<img width="680" height="300" src="../_resources/1_G99mRPdri-bjTt9eu72GoA_ee0b3d429ec04b9f86b56b22e.png"/>

<img width="680" height="255" src="../_resources/1_3JuCwaQiXNlA2AleqYmgdg_848c27ff6911443ca87316c73.png"/>

<img width="680" height="347" src="../_resources/1_zqOEVl1y_mVwybqdTwSqMg_e0d2b0bfa8dc4a56bd0bb81ca.png"/>

**How to exploit port 5900 VNC**

virtual network computing running in port 5900, we can use metasploit to exploit and we can use payload **auxiliary/scanner/vnc/vnc_login.**

<img width="680" height="310" src="../_resources/1_5_wdEfs0URlR8Ji1sMC-uw_d781d65e3914457eba600512d.png"/>

<img width="680" height="170" src="../_resources/1_kPapK1vrPLb9o6kSazYgwA_cc4d73316d564a3ca405fd670.png"/>

let’s try to connect vnc using vncviewer.

<img width="680" height="257" src="../_resources/1_c9f1wfnA8ecSMXiAJWce6w_6e7efd02f50a4af88b2c675d1.png"/>

<img width="680" height="530" src="../_resources/1_6D1-A4fBEfJBftxSfMldtA_a425ba5afd86472492fcede96.png"/>

**How to exploit port 8081 APACHE TOMCAT**

apache tomcat running in port 8180, we can metasploit to exploit the services apache tomcat and we can use to get a meterpreter sessions.

<img width="680" height="292" src="../_resources/1_xVwRuxeyBmxgSagrOk_Fyg_41ad4da78616410192865687d.png"/>

<img width="680" height="199" src="../_resources/1_hHOcwWOeDiHav3TSkamT7w_073db6acce7944f7863e48f5a.png"/>

<img width="680" height="271" src="../_resources/1_xyKp-dF3OTz2nieiTbEo0w_bf646d0d87cf4ac6823dcf78f.png"/>

This article is a gateway to the world of pentesting. The goal is to provide you with a single source containing all the ways and means to exploit all Metasploiable 2 vulnerabilities classified by port and service.

Thank You.