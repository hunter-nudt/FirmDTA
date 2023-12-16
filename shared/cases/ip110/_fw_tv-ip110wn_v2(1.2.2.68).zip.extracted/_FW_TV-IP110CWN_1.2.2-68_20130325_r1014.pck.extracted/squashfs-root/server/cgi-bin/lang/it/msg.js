var sw_msg = new Array(
"Benvenuto nel Wizard. Questo strumento ti aiuterà ad installare rapidamente la telecamera IP.",
": Inserisca un nome descrittivo per la telecamera. Per esempio, telecamera 1.",
": Inserisca  un nome descrittivo per la posizione usata dalla telecamera. Per esempio, sala riunioni 1.",
": Inserire due volte la password dell'amministratore per impostare e confermare la parola chiave di accesso all'Utility di configurazione della telecamera.",
": Selezioni questa opzione quando la vostra rete utilizza un server DHCP. Quando la telecamera si avvia le verrà assegnato automaticamente un indirizzo IP dal server DHCP.",
": Selezioni questa opzione per assegnare staticamente l'indirizzo IP alla telecamera. Puo' usare il programma 'IP Finder' per verificare valori inseriti.",
" - Indirizzo IP : Per esempio, inserisca il valore di default,",
" - Subnet mask: Per esempio, inserisca il valore di default,",
" - Default  Gateway: Per esempio, inserisca il valore di default ",
" - DNS Primario / Secondario: Inserisca il DNS che è fornito dall'ISP,",
": Selezioni questa opzione quando usa un collegamento diretto tramite modem ADSL. Dovrebbe aver ricevuto un account PPPoE dall'ISP. Digiti il nome e la password nei seguenti riquadri. Non appena  la telecamera ottiene un indirizzo IP dall'ISP  le invierà automaticamente un email di notifica. Di conseguenza, quando seleziona PPPoE come modalità di collegamento, dove configurare i parametri email al punto successivo.",
": Inserisca l'indirizzo del mail server. Per esempio, gmail.com.",
": Inserisca l'indirizzo email del mittente. Per esempio, John@gmail.com.",
": Se il mail server richiede l'autenticazione, selezioni SMTP.",
": Inserisca  il nome dell'utente per fare il login sul mail server.",
": Inserisca la pasword di accesso per fare il login sul mail server.",
": Inserisca il primo indirizzo email dell'utente che riceverà il messaggio.",
": Inserisca l'indirizzo email di un secondo utente che riceverà il messaggio.",
": Per collegare la telecamera ad un access point, selezioni un SSID corrispondondente a quel punto di accesso. Per collegare la telecamera ad un gruppo di lavoro Ad-Hoc senza fili, inserisca lo stesso canale e lo stesso SSID.",
"Click ",
" visualizzare le reti senza fili disponibili, di modo da collegarti facilmente ad una delle reti wireless elencate.",
": Selezioni il tipo di comunicazione senza fili per la telecamera.",
": Selezioni il canale adatto dalla lista",
": Selezioni il metodo di autenticazione per evitare che la telecamera possa essere utilizzata da persone non autorizzate.",
" - Aperto: impostazione di default per l'autenticazione, che comunica la chiave in chiaro attraverso la rete.,",
" - Shared Key: Permetta la comunicazione soltanto con altri dispositivi con le chiavi WEP identiche.,",
" - WPA-PSK/WPA2-PSK: L'utente deve inserire manualmente la Preshared Key in ognuno dei client wireless della rete.,",
"Confermi, per cortesia, la configurazione inserita.",
"Quando desidera confermare le impostazioni, faccia click",
"per terminare il wizard e far ripartire la telecamera. Altrimenti faccia click",
" per tornare ai punti precedenti e cambiare le impostazioni; oppure faccia click ",
"Per terminare il wizard e annullare le modifiche",
"Fate attenzione in quanto l'indirizzo IP della telecamera verrà modificato. Questo può causare la disconnessione della telecamera dalla rete. Se questo accade, usi l'applicazione software 'IP Finder' per individuare l'iindirizzo IP della telecamera, collegarsi alla telecamera e riprenderne il controllo.",
"La telacamera si sta riavviando. Attendere 1 minuto…",
" para finalizar el asistente. De lo contrario, haga Click ",
"Welcome to the Smart Wizard.",
"This wizard will help you quickly set up the Network Camera to run on your network.",
"Example:",
": Enter the mail server port number."
);
var ad_msg = new Array(
"Welcome to My Android Wizard",
": Inserisci il Google(Gmail) rappresentano per il tuo cellulare Android",
": Inserisci il Google(Gmail) per il tuo account Network Camera",
": Inserisci il Google(Talk) rappresentano per il tuo Network Camera",
": Immettere l'account di Picasa per il tuo cellulare Android",
": Immettere l'account su YouTube per il telefono cellulare Android",
"Queste impostazioni verranno applicate per impostazione corrispondente server degli eventi."
)
var popup_msg = new Array(
"L'altoparlante è occupato. Riprovi tra qualche istante",
"Errore durante l'attivazione del microfono",
"L'altoparlante della camera è disabile",
"Errore di rete",
"Errore sconosciuto",
"Il microfono della telecamera è occupato. Riprovi tra qualche istante",
"Errore durante l'attivazione dell'altoparlante",
"Il microfono della telecamera è disabilitato",
"Cancellare i cambiamenti",
"Password di amministrazione non inserita",
"La password non corrisponde",
"non dovrebbe essere lasciato in bianco",
"range troppo ampio",
"non è un valore valido",
"0.0.0.0 è un indirizzo riservato",
"255.255.255.255 è un indirizzo riservato",
"La chiave WEP non può essere vuota",
"La chiave di WEP dovrebbe essere di",
" caratteri",
"Deve immettere solo in formato ASCII",
"La Chiave WPA deve essere lunga  8-63 caratteri  in ASCII o 64 in Esadecimale ",
"Dovrebbe immettere soltanto caratteri esadecinali in formato [a-f], [A-F], [0-9]",
"Dovrebbe contenere solamente [a-f],[A-F],[0-9]",
"Dovrebbe contenere solamente caratteri informato ASCII",
"non uguale a",
"Nome utente in uso",
"In fase di test",
"Sei sicuro di voler cancellare questo utente?",
"'admin' è riservato",
"Vuoi riavviare il sistema per attivarele nuove impostazioni?",
"La regola è già impostata",
"Sei sicuro di voler cancellare questa regola? ",
"non può contenere spazi",
"Il valore deve essere compreso tra 0-23",
"Il valore deve essere compreso tra 0-59",
"Il tempo di inizio deve essere antecedente a quello di fine",
"Prima selezioni un profilo",
"Seleziona prima un intervallo di tempo",
"Questo nome è già in uso",
"La lunghezza del nome deve essere compresa tra 1-16 caratteri",
"always' è un profilo predefinito e non può essere modificato",
"Sei sicuro di voler cancellare il profilo?",
"Inserisca il nome di un profilo",
"Deve essere un numero positivo",
"deve essere presente un valore",
"Lista utenti piena",
"Sicuro di voler cancellare l'utente? ",
"Il controllo  Activex non è installato.",
"Tempo identico",
"Prima selezioni un file",
"Aggiornamento firmware fallito!",
"Aggiornamento firmware effettuato con successo!",
"Attendi circa 1 minuto!",
"Riavvio fallito!",
"Aggiornamento in corso. Attenda qualche istante prima di riavviare. ",
"E' stata ripristinata la configurazione di fabbrica",
"Ripristino della configurazione fallita!",
"Ripristino della configurazion effettuata con successo!",
"Prova fallita!",
"Disco di rete pieno!",
"La risoluzione o il frame rate sono variati. La registrazione verrà interrotta.",
"Il formato video sorgente è variato. La registrazione verrà interrotta. ",
"Errore durante l'accesso al file!",
"Nessun elemento",
"Deve contenere  soltanto [a-z],[A-Z],[0-9] ",
"Attendere qualche instante!",
"Formato non valido!",
"Email non valida!",
"Il nome della telecamera deve essere compreso tra  1 e 16 caratteri ASCII",
"Il nome della  posizione deve essere compreso tra  1 e 16 caratteri ASCII",
"Selezionare prima una posizione predefinita",
"Il nome mnemonico deve essere lungo tra 1 e 16 caratteri ASCII",
"Input non valido",
"La lista degli IP accettati non può essere vuota",
"La lista degli IP esclusi non può essere vuota",
"Il video non supporta il protocollo HTTPS.",
"Activex non è installato.",
"Multicast timeout",
"Il numero di porta è già utilizzato",
"Attendere il collegamento WPS-PIN",
"Attendere il collegamento WPS-PBC",
"Collegamento WPS in corso, attendere…",
"Connessione avvenuta con successo",
"Connessione fallita",
"Connessione chiusa",
"Dispositivo inattivo",
"Collegamento WCN.NET in corso, attendere qualche istante",
"L'area della maschera deve essere più piccola di 38400 (larghezza*altezza)",
"X+larghezza deve essere inferiore di 639",
"Y+altezza deve essere inferiore di 479",
"Deve essere un multiplo di 8",
"Indirizzo IPv6 non valido",
"Deve contenere soltanto [a-f],[A-F],[0-9],+,-,_,",
"Deve essere un valore pari",
"Timeout Multicast (audio)",
"Conflitto nel range inserito",
"Raggiunto il conteggio massimo supportato. Operazione interrotta! ",
"La zona di oscuramento (Larghezza * Altezza) deve essere più grande di 64"
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