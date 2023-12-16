var sw_msg = new Array(
"Bienvenido al Mago Inteligente. Este mago le ayudará  a instalar rápidamente la Cámara de Red para funcionar en su red.",
": Entre un nombre descriptivo para la cámara. Por ejemplo, cámara 1.",
": Entre un nombre descriptivo para la localización usada por la cámara. Por ejemplo, sala de reunión 1.",
": Entre dos veces la contraseña del administrador para ajustar y confirmar la contraseña para accede a la  Utilidad de Configuración de la cámara.",
": Seleccione esta opción cuando su red utiliza el servidor de DHCP. Cuando la cámara se inicia, le será asignado automáticamente un IP address del servidor de DHCP.",
": Seleccione esta opción para asignar directamente el IP address para la cámara. Usted puede utilizar el IP Finder para obtener los valores relativos del ajuste.",
"- IP address: Por ejemplo, entre el ajuste de defecto ",
"- Mascara del Subnet: Por ejemplo, incorpore el ajuste de defecto , ",
"- Entrada de Defecto: Por ejemplo, entre el ajuste de defecto ",
"- DNS Primario / Secundario: Incorpore el DNS  proporcionado por su ISP.",
": Seleccione esta opción cuando usted utiliza una conexión directa vía el módem del ADSL. Usted debe tener una cuenta de PPPoE de su proveedor del servicio de Internet. Entre el nombre y la contraseña de usuario a las casillas siguientes. Observe por favor que una vez que la cámara consigue un IP address de la ISP como inicio, le envía automáticamente un email de notificación. Por lo tanto, cuando seleccione PPPoE como su tipo de conexión, usted tiene que ajustar la configuración del email en el paso siguiente.",
": Entre el mail server address. Por ejemplo, mymail.com",
": Entre el email address del usuario que enviará el email. Por ejemplo, John@mymail.com",
": Si el mail server necesita login, por favor seleccione el SMTP.",
": Entre el nombre de usuario para hacer login el mail server.",
": Entre la contraseña para hacer login el mail server.",
": Entre el primer email address del usuario que recibirá el email.",
": Entre el segundo email address del usuario que recibirá el email.",
": Para conectar la cámara con un punto de acceso especificado, ajuste un SSID para que la cámara corresponda con el ESS-ID del punto de acceso. Para conectar la cámara con un grupo de trabajo Ad-Hoc inalámbrico, ajuste el mismo canal inalámbrico y SSID para concordar con la configuración del ordenador.",
"Click ",
" visualizar las redes inalámbricas disponibles, de modo que usted pueda conectar fácilmente con una de las redes inalámbricas mencionadas.",
": Seleccione el tipo de comunicación inalámbrica para la cámara.",
": Seleccione el canal apropiado de la lista estirado.",
": Seleccione el método de autentificación para asegurar la cámara de ser utilizado por el usuario no autorizado.",
"- Abierto: El ajuste de defecto del modo de autentificación, que comunica la llave a través de la red.",
"- Llave compartida: Permite la comunicación solamente con otros dispositivos con los ajustes de WEP idénticos.",
"- WPA-PSK / WPA2-PSK: Diseñado especialmente para los usuarios que no tienen acceso a los servidores de autentificación de la red. El usuario tiene que entrar manualmente la contraseña de inicio en su punto de acceso o entrada, así como en cada PC en la red inalámbrica.",
"Confirme por favor la configuración que usted ha ajustado.",
"Cuando usted confirma los ajustes, haga click ",
" para terminar con el mago y reanudar la cámara. Si no, haga click ",
" para volver a los pasos anteriores y cambiar los ajustes; o haga click  ",
" para terminar con el mago y desechar los cambios.",
"Observe por favor que el IP address de la cámara será actualizado si usted ha cambiado el ajuste del IP. Esto puede hacer que la cámara pierda la pantalla de la imagen. Si sucede esto, utilice la aplicación suministrada de IP Finder para localizar el IP address de la cámara. Entonces, conecte a la cámara para reasumir la pantalla de imagen.",
"La cámara está reanudando. Espere por favor 50 segundos.",
" para terminar el asistente. Si no, haga clic en ",
"Welcome to the Smart Wizard.",
"This wizard will help you quickly set up the Network Camera to run on your network.",
"Example:",
": Enter the mail server port number."
);
var ad_msg = new Array(
"Bienvenido a Mi Asistente para Android",
": Introduzca el de Google(Gmail) cuenta para su teléfono Android",
": Introduzca el de Google(Gmail) cuenta para su cámara de red",
": Introduzca el Google(discusión) cuenta para su cámara de red",
": Escriba la cuenta de Picasa para su teléfono Android",
": Introduzca la cuenta de YouTube para su teléfono Android",
"Estos ajustes se aplicarán a la fijación correspondiente servidor de eventos."
)
var popup_msg = new Array(
"El altavoz está ocupado. Por favor intente otra vez más tarde",
"Abrir el micrófono del sistema fallido",
"El altavoz de la cámara está deshabilitado",
"Error de la red",
"Error desconocido",
"El micrófono de la cámara está ocupado",
"Abrir el sonido del sistema fallido",
"El micrífono de la cámara está deshabilitado",
"Deseche los cambios",
"Contraseña del administrador dejada en blanco",
"La contraseña no concuerda",
"no debe dejarlo en blanco",
"excede la gama",
"no es número legal",
"'0.0.0.0' es un address reservado",
" '255.255.255.255' es un address reservado",
"La llave de WEP no debe estar vacía",
"La llave de WEP debe estar ",
" longitud de los caracteres",
"Debe entrar solamente el código de ASCII",
"La Llave de WPA debe ser 8-63 caracteres de largo en ASCII o 64 en Hexadecimal",
"Debe entrar solamente el número hexadecimal [a-f], [A-F], [0-9]",
"Esto solamente debe contener [a-f],[A-F],[0-9]  ",
"Esto debe contiene solamente código de ASCII ",
"No igual a",
"Nombre de usuario en uso",
"Provando",
"Está seguro de suprimir a este usuario?",
"'admin' es reservado ",
"Usted quiere reanudar el dispositivo para dejar los valores entren en vigor",
"la regla ya está fijada",
"Está seguro de suprimir esta regla?",
"no puede contener espacio",
"La hora debe estar entre 0-23",
"El minuto debe estar entre 0-59",
"La hora de salida debe ser antes de hora de conclusión",
"seleccione por favor un perfil primero",
"seleccione por favor un intervalo de tiempo primero",
"Este nombre ya está en uso",
"La longitud del nombre debe ser entre 1-16",
"'always' es un horario predefinido y no puede ser modificado",
"Está seguro de suprimir el perfil",
"Entre por favor un nombre de perfil",
"no es un número positivo",
"debe ser rellenado",
"Lista de usuario llena",
"Está seguro de suprimir a este usuario?",
"El control de ActiveX no está instalado.",
"Tiempo idéntico",
"Por favor seleccione primero un archivo",
"Actualización del firmware fallido!",
"Actualización del firmware con éxito!",
"Espere por favor 50 segundos para la reinicialización!",
"Reinicialización fallida!",
"La actualización del firmware está procesando. Reanude por favor más tarde.",
"El dispositivo estaba en reset de fábrica!",
"El restablecimiento de la configuración fallido!",
"El restablecimiento de la configuración con éxito!",
"Prueba fallada!",
"Almacenaje por completo!",
"El índice de la resolución o del marco ha sido cambiado. La grabación se para.",
"Formato del video de fuente ha sido cambiado. La grabación se para.",
"Error en el acceso del archivo!",
"no hay elementos",
"Esto solamente debe contener [a-z],[A-Z],[0-9]  ",
"Espere por favor!",
"Formato no válido!",
"Email no válido!",
"El Nombre de la Cámara debe ser 1-16 caracteres de largo en ningún ASCII",
"La localización debe ser 1-16 caracteres de largo en ningún ASCII",
"seleccione por favor para preestablecer la posición primero",
"El Nombre Amistoso debe ser 1-16 caracteres de largo en ningún ASCII",
"entrada inválida",
"Aceptar que la lista de IP no debe ser vacía",
"Negar que la lista de IP no debe ser vacía",
"El vídeo no soporta el Protocolo de HTTPS.",
"ActiveX no está instalado.",
"Descanso de Multicast",
"El número de orificio ha sido utilizado",
"Esperar para la conexión de WPS-PIN, Esperar por favor",
"Esperar para la conexión de WPS-PBC, Esperar por favor",
"La conexión de WPS está en proceso, esperar por favor",
"Conexión con éxito",
"Conexión fallida",
"Conexión parada",
"Dispositivo inactivo",
"La conexión de WCN.NET está procesando, espera por favor ",
"El área de la máscara (Anchura * Altura) debe ser más pequeño de 38400",
"X + Anchura debe ser más pequeño de 639 ",
"Y + Altura deben ser más pequeñas de 479",
"debe ser óctuplo",
"IPv6 Address inválido",
"Esto solamente debe contener [a-z],[A-Z],[0-9],+,-,_,",
"Esto debe ser solamente valores pares",
"Multicst (Audio) Descanso ",
"Conflicto de la gama!",
"Alcanzada la cuenta máxima soportada. Interrupción de la operación!",
"El área de la máscara (Anchura * Altura) debe ser más grande de 64"
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