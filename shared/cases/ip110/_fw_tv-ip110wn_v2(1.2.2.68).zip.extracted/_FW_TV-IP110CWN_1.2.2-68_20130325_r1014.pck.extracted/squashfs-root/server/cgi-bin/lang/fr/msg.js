var sw_msg = new Array(
"Bienvenue à la Smart Wizard. Cet assistant vous aidera à établir rapidement la caméra réseau pour fonctionner sur votre réseau.",
": Entrez un nom descriptif pour la caméra. Par exemple, caméra 1.",
": Entrez un nom descriptif de l'emplacement utilisé par la caméra. Par exemple, salle de réunion 1.",
": Entrez le mot de passe d'administrateur à deux reprises d'établir et de confirmer le mot de passe pour accéder à l'utilitaire de configuration de la caméra.",
": Sélectionnez cette option si votre réseau utilise le serveur DHCP. Lorsque la caméra démarre, il sera attribué une adresse IP du serveur DHCP automatiquement.",
": Sélectionnez cette option pour attribuer l'adresse IP de la caméra directement. Vous pouvez utiliser IP Finder pour obtenir les valeurs de paramètre.",
"- Adresse IP: Par exemple, entrez le paramètre par défaut",
"- Masque de sous-réseau: Par exemple, entrez le paramètre par défau ",
" - Passerelle par défaut: Par exemple, entrez le paramètre par défaut ",
"- Primaire / secondaire DNS: Entrez le DNS qui sont fournis par votre FAI.",
": Sélectionnez cette option lorsque vous utilisez une connexion directe via le modem ADSL. Vous devez avoir un compte PPPoE de votre fournisseur de services Internet. Entrez le nom d'utilisateur et mot de passe dans les cases suivantes. Notez s'il vous plaît que une fois la caméra obtenir une adresse IP du FAI de départ, il vous envoie automatiquement un e-mail de notification. Par conséquent, lorsque vous sélectionnez PPPoE comme votre type de connexion, vous devez mettre en place la configuration de l'Email dans la prochaine étape.",
": Entrez l'adresse du serveur de mail. Par exemple, mymail.com",
": Entrez l'adresse Email de l'utilisateur qui envoie l'Email. Par exemple, John@mymail.com",
": Si le serveur de messagerie doit se connecter, sélectionnez SMTP s'il vous plaît.",
": Entrez le nom de l'utilisateur de se connecter au serveur de messagerie.",
": Entrez le mot de passe pour vous connecter au serveur de messagerie.",
": Entrez la première adresse Email de l'utilisateur qui recevra le message.",
": Entrez la deuxième adresse e-mail de l'utilisateur qui recevra le message.",
": Pour connecter la caméra à un point d'accès spécifié, met un SSID pour la caméra pour correspondre avec l'ESS-ID du point d'accès. Pour connecter la caméraà un workgroup sans fil ad hoc, fixez le même canal san fil et SSID pour répondre à la configuration de l'ordinateur. ",
"Cliquer ",
" pour afficher les réseaux sans fil disponibles, afin que vous pouvez facilement connecter à l'un des réseaux sans filde listé.",
": Sélectionnez le type de communication sans fil pour la caméra.",
": Sélectionnez le canal just à partir de la liste déroulante.",
": Sélectionnez la méthode d'authentification pour garantir la caméra d'être utilisé par tout utilisateur non autorisé.",
"- Ouvrir: Le paramètre par défaut du mode d'authentification, qui communique la clé à travers le réseau.",
"- Clés partagée: permettre la communication seulement avec les autres appareils avec des paramètres WEP identiques.",
"- WPA-PSK/WPA2-PSK: Spécialement conçu pour les utilisateurs qui n'ont pas accès au réseau de serveurs d'authentification. L'utilisateur doit entrer manuellement le mot de passe à partir de leur point d'accès ou de la passerelle, ainsi que dans chaque PC sur le réseau sans fil.",
"Confirmer la configuration que vous avez mis en place, s'il vous plaît.",
"Lorsque vous confirmer les paramètres, cliquez sur ",
" pour terminer l'assistant et réinitialiser la caméra. Sinon, cliquez sur ",
" pour revenir à l'étape(s) précédente et modifier les paramètres, ou cliquez sur ",
" de mettre fin à l'assistant et défaire les changements.",
"Notez s'il vous plaît que l'adresse IP de l'appareil sera mis à jour si vous avez changé l'IP. Cette peut causer de la caméra à perdre de l'écran d'image. Dans ce cas, utiliser le logiciel fourni IP Finder pour localiser l'adresse IP de la caméra. Ensuite, se connecter à l'appareil de reprendre l'écran d'image.",
"La caméra est en train de réinitialiser. Attendez 50 secondes s'il vous plaît.",
" para completar el asistente. De lo contrario, haga clic en ",
"Welcome to the Smart Wizard.",
"This wizard will help you quickly set up the Network Camera to run on your network.",
"Example:",
": Enter the mail server port number."
);
var ad_msg = new Array(
"Welcome to My Assistant Android",
": Entrez le Google(Gmail) compte pour votre téléphone Android",
": Entrez le Google(Gmail) compte pour votre caméra réseau",
": Entrez le Google(Talk) compte pour votre caméra réseau",
": Entrez le compte Picasa pour votre téléphone Android",
": Entrez le compte YouTube pour votre téléphone Android",
"Ces paramètres seront appliqués à la mise en action du serveur correspondant."
)
var popup_msg = new Array(
"Haut-parleur est occupé. Essayer à nouveau plus tard s'il vous plaît",
"Ouvrir microphone de système raté",
"Haut-parleur de la caméra est désactivé",
"Erreur de réseau",
"Erreur inconnue",
"Microphone de la caméra est occupé",
"Ouvrir son de système raté",
"Microphone de la caméra est désactivé",
"Annuler les modifications",
"Mot de passe d'administrateur est laissé en blanc",
"Mot de passe ne correspondent",
"ne doit pas être laissé en blanc",
"dépasse gamme",
"pas de numéro légal",
"'0.0.0.0' est une adresse réservée",
"'255.255.255.255' est une adresse réservée",
"Clé WEP ne doit pas être vide",
"Clé WEP doit être ",
" caractères longes",
"doit seulement entrer code ASCII",
"WPA-clé doit être 8-63 caractères de ASCII ou 64 en hexadécimal",
"doit seulement entrer numéro hexadécimal [a-f],[A-F],[0-9]",
"Cela devrait contient seulement [a-f],[A-F],[0-9]  ",
"Cela devrait contenir que code ascii",
"pas égal à",
"Nom d'utilisateur dans l'utilisation",
"Essai",
"Êtes-vous sûr de vouloir supprimer cet utilisateur?",
"'admin' est réservé",
"Voulez-vous réinitialiser l'appareil pour que les valeurs en vigueur?",
"règle est déjà fixée",
"Êtes-vous sûr de vouloir supprimer cette règle?",
"ne peuvent pas contenir d'espace",
"Heure doit être entre 0-23",
"Minute doit être entre 0-59",
"Heure de départ devrait être avant la fin du temps",
"sélectionner un profil en premier s'il vous plaît",
"sélectionner un intervalle de temps en premier s'il vous plaît",
"Ce nom est déjà utilisé",
"Longueur de nom doit être comprise entre 1-16",
"'always' est un programme pré-défini et ne peut être modifié",
"Etes-vous sûr de supprimer le profil",
"Entrez un nom de profil s'il vous plaît",
"n'est pas un nombre positif",
"doivent être remplis",
"Liste d'utilisateur remplie",
"Êtes-vous sûr de vouloir supprimer cet utilisateur?",
"Le contrôle ActiveX n'est pas installé.",
"Temps identique",
"Choisir un premier fichier s'il vous plaît",
"Microprogramme actualiser raté!",
"Microprogramme actualiser réussi!",
"attendez 50 seconds pour réinitialiser!",
"Réintialiser raté!",
"Microprogramme est en train de actualiser. Réinitialisez plus tard s'il vous plaît.",
"Appareil a été remis à l'état usine!",
"Configuration rendre raté!",
"Configuration rendre réussi!",
"Test raté!",
"Stockage rempli!",
"La résolution ou la fréquence d'images modifiées. L'enregistrement s'arrête.",
"Format vidéo source changé. L'enregistrement s'arrête.",
"Erreur d'accès au fichier!",
"aucun élément",
"Cela devrait contient seulement [a-z],[A-Z],[0-9]  ",
"Attendez s'il vous plaît!",
"Format non valide!",
"Email non valide!",
"Nom de Camera devrait être 1-16 caractères non ASCII",
"Emplacement doit être 1-16 caractères non ASCII",
"sélectionnez une position en premier s'il vous plaît",
"Nom ami devrait être 1-16 caractères non ASCII",
"données incorrectes",
"Liste IP d'acceptance ne doit pas être vide",
"Liste IP de déni ne doit pas être vide",
"La vidéo n'est pas un soutien pour le protocole HTTPS.",
"ActiveX n'est pas installé.",
"Multicast temps mort",
"Numéro du port ont été utilisés",
"Attendez que la connexion WPS-PIN, attendez s'il vous plaît",
"Attendez que la connexion WPS-PBC, attendez s'il vous plaît",
"WPS connexion est en transformation, attendez s'il vous plaît",
"Connexion réussi",
"Connexion rate",
"Connecxion termine",
"Appareil au repos",
"WCN.NET connexion est en transformation, attendez s'il vous plaît",
"Secteur de masque (Largeur * Hauteur) doit être inférieure à 38400",
"X + largeur doit être inférieur à 639",
"Y + Hauteur doit être inférieur à 479",
"devrait être octuple",
"Adresse IPv6 non valide",
"Cela devrait contient seulement [a-z],[A-Z],[0-9],+,-,_,",
"Cela devrait être que les valeurs pairs",
"Multicast(audio) temps mort",
"Gamme s'oppose!",
"Compte soutenu max atteint. Opération avorte!",
"Secteur de masque (Largeur * Hauteur) doit être plus grande que 64"
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