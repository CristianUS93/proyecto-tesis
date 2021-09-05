import 'package:flutter/material.dart';

class PoliticsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("POLÍTICAS DE PRIVACIDAD",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text('Nuestras Políticas de Privacidad',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10,),
                Text('Qarwash está comprometida a garantizar la confidencialidad de sus datos en línea. Lea la siguiente normativa para entender el tratamiento de su información personal cuando utiliza nuestros servicios. Esta normativa puede cambiar por lo que le recomendamos que la revise periódicamente.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 30,),
                Text('¿Cómo utiliza Qarwash mis datos?',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Text('Nuestro objetivo principal al recoger sus datos personales es proporcionarle una experiencia personalizada en nuestro aplicativo. \n Esto incluye personalización de servicios que se utiliza para entender y servir mejor a nuestros usuarios. \n De esta manera, solo recogemos información básica de su cuenta de google, debido a que nuestro aplicativo usa sus servidores para un mejor rendimiento y optimización del aplicativo.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 30,),
                Text('¿Quién recoge la información?',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Text('Cuando usted se registra con su cuenta de google, automáticamente nuestro aplicativo se comunica con los servidores de google, para obtener sus datos personales generales y básicos.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 30,),
                Text('¿Con quién comparte Qarwash mis datos?',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Text('De acuerdo a la ley, Qarwash no revelará datos personales a menos que usted nos autorice o en circunstancias especiales (a)Cuando sea requerido por ley.(b)Para cumplir con las disposiciones procesales, o en las circunstancias que se describen a continuación. \n Qarwash puede difundir sus datos en casos especiales, como identificar, localizar o realizar acciones legales contra personas que pudisen infringir las Condiciones del Servicio de Qarwash o causar daños. Qarwash no vende ni alquila la información de sus usuarios, la localización del usuario es solo de uso informativa, para armar su ruta de camino hacia el lugar de destino. Recalcando que dicha ubicación no se registra en la base de datos. \n Desafortunadamente, ninguna transmisión de internet es 100% confiable. Por lo tanto, aunque nos esforcemos en proteger su información, Qarwash no puede asegurar ni garantizar la seguridad completa en el manejo de sus datos pero una vez recibido sus datos, haremos todo lo posible para garantizar su seguridad en nuestros sistemas.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}