var sw_msg = new Array(
"Willkommen beim Smart Wizard. Dieser Wizard wird Ihnen helfen, die Netzwerkkamera schnell zu installieren und auf Ihrem Netzwerk laufen zu lassen.",
": Geben Sie einen deskriptiven Namen für den von der Kamera benützten Ort ein. Zum Beispiel, Meetingroom1.",
": Geben Sie das Administratorpasswort zweimal ein um das Kennwort für den  Zugang zur Kamera-Konfigurations-Utility  zu setzen und zu bestätigen .",
": Geben Sie das Administratorpasswort zweimal ein, um das Passwort für den Zugang zum Konfigurationsdienstprogramm zu setzen und zu bestätigen.",
": Wählen Sie diese Option um eine IP-Adresse für die Kamera direkt zuzuordnen.Sie können den IP-Finder verwenden, um die relevanten Einstellwerte zu erhalten.",
": Wählen Sie diese Option, um die IP-Adresse für die Kamera direkt zuordnen. Sie können IP-Finder, um die damit verbundenen Werte zu erhalten Einstellung.",
"- IP-Adresse: Zum Beispiel, geben Sie die Standardeinstellung ein ",
"- Subnetzmaske: Zum Beispiel, geben Sie die Standardeinstellung ein ",
"- Standardschnittstelle: Zum Beispiel, geben Sie die Standardeinstellung ein ",
"- Primäre/Sekundäre DNS: Geben Sie die DNS ein, die von ihrem ISP bereitgestellt wird.",
": Wählen Sie diese Option, falls Sie eine direkte Verbindung via ADSL modem benützen. Sie sollten ein PPPoE-Konto von Ihrem Internetprovider haben. Geben Sie Benutzername und Passwort in den folgenden Kästchen ein. Bitte nehmen Sie zur Kenntnis, dass sobald die Kamera eine IP-Adresse von der ISP beim Start bekommen hat, Sie Ihnen automatisch eine Benachrichtigungsmail sendet. Daher, müssen Sie im nächsten Schritt die Emailkonfiguration einstellen, wenn sie PPPoE aks Verbindungstyp selektieren.",
": Geben Sie die Mailserveradresse ein. Zum Beispiel, mymail.com",
": Geben Sie die Emailadresse des Benützers ein, der die Email versenden wird. Zum Beispiel,  John@mymail.com.",
": Falls sich der Mailserver einloggen muss, wählen Sie bitte SMTP.",
": Geben Sie den Benutzernamen ein, um sich in den Mailserver einzuloggen.",
": Geben Sie das Passwort ein, um sich in den Mailserver einzuloggen.",
": Geben Sie die erste Emailadresse des Benützers, der die Email erhalten wird, ein.",
": Geben Sie die zweite Emailadresse des Benützers, der die Email erhalten wird, ein.",
": Um die Kamera mit einem bestimmten Zugangspunkt zu verbinden, setzen Sie eine SSID für die Kamera, die mit dem Zugangspunkt der ESS-ID korrespondiert. Um die Kamera an eine Ad-hoc-Wireless-Arbeitsgruppe zu verbinden, setzen Sie passend zur Konfiguration des Computers den gleichen Funkkanal und die gleiche SSID.",
"Klick ",
" um die verfügbaren drahtlosen Netzwerke anzuzeigen, damit sie einfach an eines der gelisteten drahtlosen Netzwerke verbinden können.",
": Wählen Sie den Typ der drahtlosen Datenübertragung für die Kamera.",
": Wählen Sie zuerst den passenden Kanal.",
": Wählen Sie eine Authentifizierungsmethode, um die Kamera vor dem Gebrauch durch nicht authorisierte Benützer zu schützen.",
"- Offen: Die Standardeinstellung des Authentifikationsmodus, welche den Schlüsse+C2l im Netzwerk überträgt",
"- Shared-Key: Lassen Sie nur die Kommunikation mit anderen Geräten mit der gleichen WEP-Einstellungen zu.",
"- WPA-PSK/WPA2-PSK: Speziell für die Nutzer, die keinen Zugang zur Netzwerk-Server-Authentifizierung haben. Der Benutzer muss manuell das Start-Passwort in den Zugangspunkt oder Gateway, als auch in jedem PC über das drahtlose Netzwerk, eingeben.",
"Bitte bestätigen Sie die von Ihnen eingestellte Konfiguration",
"Wenn Sie die Einstellungen bestätigen, klicken ",
" um den Wizard zu beenden und die Kamera neuzustarten. Ansonsten, klicken ",
" um zu vorigem/n Schritt(en) zurückzugehen und die Einstellungen zu ändern; oder klicken ",
" um den Wizard zu beenden und die änderungen zu verwerfen.",
"Bitte beachten Sie, dass die IP-Adresse der Kamera aktualisiert wird, wenn Sie die IP-Einstellung [ae]ndern. Dies kann dazu führen, dass die Kamera das Bildschirmbild verliert. Wenn dies der Fall ist, verwenden Sie die mitgelieferte IP-Finder Software-Anwendung, um die IP-Adresse der Kamera festzustellen. Verbinden Sie dann mit der Kamera, um das Bildschirmbild wiederzugewinnen.",
"Kamera startet neu. Bitte warten Sie 50 Sekunden.",
" bis zum Ende des Assistenten. Klicken Sie andernfalls auf ",
"Welcome to the Smart Wizard.",
"This wizard will help you quickly set up the Network Camera to run on your network.",
"Example:",
": Enter the mail server port number."
);
var ad_msg = new Array(
"Welcome to My Android-Assistent",
": Geben Sie die Google(Gmail) Account für Ihre Android Handy",
": Geben Sie die Google(Gmail) Account für Ihre Netzwerk-Kamera",
": Geben Sie die Google(Diskussion) Konto für Ihre Netzwerk-Kamera",
": Geben Sie die Picasa-Account für Ihre Android Handy",
": Geben Sie die YouTube-Konto für Ihr Handy Android",
"Diese Einstellungen werden auf entsprechende Ereignis-Server-Einstellung angewendet werden."
)
var popup_msg = new Array(
"Lautsprecher ist belegt. Bitte versuchen sie später nochmals",
"Offenes Systemmikrofon fehlgeschlagen",
"Kameralautsprecher ist deaktiviert",
"Netzwerkfehler",
"Unbekannter Fehler",
"Kameramikrofon werd belegt",
"Offener Systemklang fehlgeschlagen",
"Kameramikrofon ist deaktiviert",
"änderungen verwerfen",
"Admin-Passwort leer gelassen",
"Passwörter stimmen nicht überein",
"sollte nicht leer gelassen werden",
"überschreitet Bereich",
"keine legale Zahl",
"'0.0.0.0' ist eine reservierte Adresse",
"'255.255.255.255' ist eine reservierte Adresse",
"WEP-Schlüssel sollte nicht leer sein",
"WEP-Schlüssel sollte sein ",
" Zeichen lang",
"Sollte als Input nur ASCII-Code enthalten",
"WPA Schlüssel sollte 8-63 Zeichen in ASCII oder 64 Zeichen in Hexadecimal lang sein",
"Sollte als Input nur eine Hexadecimalzahl a-f],[A-F],[0-9] sein",
"Das sollte nur [a-f],[A-F],[0-9] enthalten ",
"Das sollte nur ASCII-Code enthalten",
"ungleich",
"Benutzername bereits in Verwendung",
"Testen",
"Sind Sie sicher, dass Sie diesen Benützer löschen möchten?",
"'admin' ist reserviert",
"Möchten Sie das Gerät neustarten, damit die neuen Werte sich auswirken?",
"Regel ist schon eingestellt",
"Sind Sie sicher, dass Sie die Regel löschen möchten?",
"Darf kein Leerzeichen enthalten",
"Stunden sollten zwischen 0-23 sein",
"Minuten sollten zwischen 0-59 sein",
"Beginnszeit sollte vor Endzeit liegen",
"Bitte wählen Sie zuerst ein Profil",
"Bitte wählen Sie zuerst ein Zeitintervall ",
"Dieser Name wird schon verwendet",
"Namenslänge sollte zwischen 1-16 sein",
"'always' ist ein vordefinierter Ablaufplan und kann nicht modifiziert werden.",
"Sind Sie sicher, dass Sie das Profil löschen möchten",
"Bitte wählen Sie einen Profilnamen",
"ist keine positive Zahl",
"sollte eingetragen werden",
"Userliste voll",
"Sind Sie sicher, dass Sie diesen Benützer löschen möchten?",
"Die ActiveX Steuerung ist nicht installiert.",
"Zeiten identisch",
"Bitte wählen Sie zuerst eine Datei",
"Firmware Aktualisierung fehlgeschlagen!",
"Firmware Aktualisierung erfolgreich!",
"Bitte warten Sie 50 Sekunden für den Neustart!",
"Neustart fehlgeschlagen!",
"Firmware Aktualisierung läuft. Bitte starten sie nachher neu.",
"Gerät war fabriksmäßig auf Standardeinstellung gesetzt",
"Wiederherstellung der Konfiguration fehlgeschlagen!",
"Wiederherstellung der Konfiguration erfolgreich!",
"Test fehlgeschlagen!",
"Storage full!",
"Auflösung oder Bildfolge geändert. Aufnahme beendet.",
"Ursprüngliches Videoformat geändert. Aufname beendet.",
"Dataizugriffsfehler!",
"keine Elemente",
"Das sollte nur [a-z],[A-Z],[0-9] enthalten ",
"Bitte Warten!",
"Format ungültig!",
"Email ungültig!",
"Kameraname sollte in Nicht-ASCII-Zeichen 1-16 Zeichen lang sein",
"Ortname sollte in Nicht-ASCII-Zeichen 1-16 Zeichen lang sein",
"Bitte wählen Sie zuerst eine Standard Position",
"Freundlicher Name sollte 1-16 Zeichen in Nicht-ASCII lang sein",
"Ungültige Eingabe",
"Akzeptierte IP sollte nicht leer sein",
"Verweigerte IP sollte nicht leer sein",
"HTTPS Protokoll unterstütz Video nicht.",
"ActiveX ist nicht installiert.",
"Mehrfachbelegung Zeitüberschreitung",
"Anschlussnummer ist schon in Verwendung",
"Warte auf WPS-PIN Verbindung, Bitte warten",
"Warte auf WPS-PBC Verbindung, Bitte warten",
"WPS Verbindung arbeitet, Bitte warten",
"Erfolgreich verbunden",
"Verbindung fehlgeschlagen",
"Verbindung beenden",
"Gerät-Leerlauf",
"WCN.NET Verbindung arbeitet, bitte warten",
"Maskenfeld(Breite*Höhe muss kleiner als 38400 sein",
"X+Breite muss kleiner als 639 sein",
"Y+Höhe muss kleiner als 479 sein",
"sollte achtfach sein",
"Ungültige IPv6-Adresse",
"Das sollte nur [a-z],[A-Z],[0-9],+,-,_, enthalten",
"Das sollte nur geradzahlige Werte haben",
"Mehrfachbelegung(Audio) Zeitüberschreitung",
"Bereichskonflikt!",
"Max unterstützter Zähler erreicht. Vorgang abgebrochen.",
"Maskenfeld(Breite*Höhe muss grösser als 64 sein"
);
var sw_msg_0 = 0;
var sw_msg_1 = 1;
var sw_msg_2 = 2;
var sw_msg_3 = 3;
var sw_msg_4 = 4;
var sw_msg_5 = 5;
var sw_msg_6 = 6;
var sw_msg_7 = 7;
var sw_msg_8 = 8;
var sw_msg_9 = 9;
var sw_msg_10 = 10;
var sw_msg_11 = 11;
var sw_msg_12 = 12;
var sw_msg_13 = 13;
var sw_msg_14 = 14;
var sw_msg_15 = 15;
var sw_msg_16 = 16;
var sw_msg_17 = 17;
var sw_msg_18 = 18;
var sw_msg_19 = 19;
var sw_msg_20 = 20;
var sw_msg_21 = 21;
var sw_msg_22 = 22;
var sw_msg_23 = 23;
var sw_msg_24 = 24;
var sw_msg_25 = 25;
var sw_msg_26 = 26;
var sw_msg_27 = 27;
var sw_msg_28 = 28;
var sw_msg_29 = 29;
var sw_msg_30 = 30;
var sw_msg_31 = 31;
var sw_msg_32 = 32;
var sw_msg_33 = 33;
var sw_msg_34 = 34;
var sw_msg_35 = 35;
var sw_msg_36 = 36;
var sw_msg_37 = 37;
var sw_msg_38 = 38;

var ad_msg_0 = 0;
var ad_msg_1 = 1;
var ad_msg_2 = 2;
var ad_msg_3 = 3;
var ad_msg_4 = 4;
var ad_msg_5 = 5;
var ad_msg_6 = 6;
						  
var popup_msg_0 = 0;
var popup_msg_1 = 1;
var popup_msg_2 = 2;
var popup_msg_3 = 3;
var popup_msg_4 = 4;
var popup_msg_5 = 5;
var popup_msg_6 = 6;
var popup_msg_7 = 7;
var popup_msg_8 = 8;
var popup_msg_9 = 9;
var popup_msg_10 = 10;
var popup_msg_11 = 11;
var popup_msg_12 = 12;
var popup_msg_13 = 13;
var popup_msg_14 = 14;
var popup_msg_15 = 15;
var popup_msg_16 = 16;
var popup_msg_17 = 17;
var popup_msg_18 = 18;
var popup_msg_19 = 19;
var popup_msg_20 = 20;
var popup_msg_21 = 21;
var popup_msg_22 = 22;
var popup_msg_23 = 23;
var popup_msg_24 = 24;
var popup_msg_25 = 25;
var popup_msg_26 = 26;
var popup_msg_27 = 27;
var popup_msg_28 = 28;
var popup_msg_29 = 29;
var popup_msg_30 = 30;
var popup_msg_31 = 31;
var popup_msg_32 = 32;
var popup_msg_33 = 33;
var popup_msg_34 = 34;
var popup_msg_35 = 35;
var popup_msg_36 = 36;
var popup_msg_37 = 37;
var popup_msg_38 = 38;
var popup_msg_39 = 39;
var popup_msg_40 = 40;
var popup_msg_41 = 41;
var popup_msg_42 = 42;
var popup_msg_43 = 43;
var popup_msg_44 = 44;
var popup_msg_45 = 45;
var popup_msg_46 = 46;
var popup_msg_47 = 47;
var popup_msg_48 = 48;
var popup_msg_49 = 49;
var popup_msg_50 = 50;
var popup_msg_51 = 51;
var popup_msg_52 = 52;
var popup_msg_53 = 53;
var popup_msg_54 = 54;
var popup_msg_55 = 55;
var popup_msg_56 = 56;
var popup_msg_57 = 57;
var popup_msg_58 = 58;
var popup_msg_59 = 59;
var popup_msg_60 = 60;
var popup_msg_61 = 61;
var popup_msg_62 = 62;
var popup_msg_63 = 63;
var popup_msg_64 = 64;
var popup_msg_65 = 65;
var popup_msg_66 = 66;
var popup_msg_67 = 67;
var popup_msg_68 = 68;
var popup_msg_69 = 69;
var popup_msg_70 = 70;
var popup_msg_71 = 71;
var popup_msg_72 = 72;
var popup_msg_73 = 73;
var popup_msg_74 = 74;
var popup_msg_75 = 75;
var popup_msg_76 = 76;
var popup_msg_77 = 77;
var popup_msg_78 = 78;
var popup_msg_79 = 79;
var popup_msg_80 = 80;
var popup_msg_81 = 81;
var popup_msg_82 = 82;
var popup_msg_83 = 83;
var popup_msg_84 = 84;
var popup_msg_85 = 85;
var popup_msg_86 = 86;
var popup_msg_87 = 87;
var popup_msg_88 = 88;
var popup_msg_89 = 89;
var popup_msg_90 = 90;
var popup_msg_91 = 91;
var popup_msg_92 = 92;
var popup_msg_93 = 93;
var popup_msg_94 = 94;
var popup_msg_95 = 95;
var popup_msg_96 = 96;
var popup_msg_97 = 97;