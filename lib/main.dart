import 'package:flutter/material.dart';

// Pantalla tipo contador
// Estructura de pantalla con Scaffold
// AppBar ya acciones
// Gestion de estado setState
// Texto dinamico y operador ternario
// Widgets personalizados + uso de voidcallsbacks

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _CounterFunctionsScreenState();
}

//Metodo para dibujar cada luz del semaforo
Widget _buildLuz(Color color, bool encendida) {
  //const AnimatedPositioned positioned = AnimatedPositioned;
  //const AnimatedContainer container = AnimatedContainer;
  return Container(
    width: 80,
    height: 80,
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: encendida ? color : color.withOpacity(0.3),
      border: Border.all(color: Colors.black, width: 2),
    ),
  );
}

class _CounterFunctionsScreenState extends State<MyApp> {
  int clickCounter = 0;
  int aforo = 0;
  String activeColor = 'verde';

  // Metodo para actualizar el color del semaforo
  void updateTrafficLight() {
    if (aforo == 0 || clickCounter == 0) {
      activeColor = 'verde';
      return;
    }
    double ratio = clickCounter / aforo;
    if (ratio < 0.60) {
      activeColor = 'verde';
    } else if (ratio >= 0.60 && ratio < 0.90) {
      activeColor = 'amarillo';
    } else {
      activeColor = 'rojo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Aforo – Ferry Isla Mujeres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                clickCounter = 0;
              });
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://www.visitmexico.com/viajemospormexico/sites/default/files/styles/elemento_destacado/public/2020-11/Ferry%20Isla%20Mujeres%20-%20Puerto%20Juarez.jpg',
                width: 250,
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese el aforo maximo',
                labelText: 'Aforo maximo',
                prefixIcon: Icon(Icons.people_alt_rounded),
              ),
              onChanged: (value) {
                aforo = int.tryParse(value) ?? 0;
                updateTrafficLight();
                setState(() {});
              },
            ),
            Text(
              'Aforo del ferry ${aforo == 0 ? 'vacio' : '${aforo}personas'}',
            ),
            _buildLuz(Colors.red, activeColor == "rojo"),
            _buildLuz(Colors.yellow, activeColor == "amarillo"),
            _buildLuz(Colors.green, activeColor == "verde"),
            // PorcentajeP
            LinearProgressIndicator(
              value: aforo == 0 ? 0 : (clickCounter / aforo),
              backgroundColor: Colors.grey[300],
              color: (clickCounter / aforo) < 0.60
                  ? Colors.green
                  : (clickCounter / aforo) > 0.60 &&
                        (clickCounter / aforo) < 0.90
                  ? Colors.orange
                  : (clickCounter / aforo) >= 90
                  ? Colors.red
                  : Colors.red,
              minHeight: 10,
            ),
            CustomButton(
              icon: Icons.refresh_rounded,
              onPressed: () {
                aforo = 0;
                updateTrafficLight();
                setState(() {});
              },
            ),
            Text(
              '$clickCounter',
              style: TextStyle(
                color: Colors.black,
                fontSize: 160,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text(
              'Click${clickCounter == 1 ? '' : 's'}',
              style: const TextStyle(fontSize: 25),
            ),
            // historial de contador
            Expanded(
              child: ListView.builder(
                itemCount: clickCounter,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.check),
                    title: Text('Click numero ${index + 1}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Se cambio de Column a Row para popner los botenes en fila
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // boton -5
          ElevatedButton.icon(
            //icon: const Icon(Icons.minus),
            label: const Text('-5'),
            onPressed: () {
              if (clickCounter == 0 && clickCounter > aforo) return;
              clickCounter -= 5;
              updateTrafficLight();
              setState(() {});
            },
          ),
          const SizedBox(width: 50.0),
          // boton -2
            CustomButton(
              icon: Icons.exposure_minus_2_outlined,
              onPressed: () {
                if (clickCounter == 0 && clickCounter > aforo) return;
                clickCounter -= 2;
                updateTrafficLight();
                setState(() {});
              },
            ),
          const SizedBox(width: 50.0),
          // boton -1
            CustomButton(
              icon: Icons.exposure_minus_1_outlined,
              onPressed: () {
                if (clickCounter == 0 || clickCounter > aforo) return;
                clickCounter--;
                updateTrafficLight();
                setState(() {});
              },
            ),
          const SizedBox(width: 50.0),
          // refresh
            CustomButton(
              icon: Icons.refresh_rounded,
              onPressed: () {
                clickCounter = 0;
                updateTrafficLight();
                setState(() {});
              },
            ),
          const SizedBox(
            width: 50.0,
          ), // se uso width en vez de height para el espaciado
          // boton + 1
            CustomButton(
              icon: Icons.plus_one,
              onPressed: () {
                if (clickCounter > aforo) return;
                clickCounter++;
                updateTrafficLight();
                setState(() {});
              },
            ),
          const SizedBox(width: 50.0),
          // boton +2
            CustomButton(
              icon: Icons.exposure_plus_2_outlined,
              onPressed: () {
                if (clickCounter > aforo) return;
                clickCounter += 2;
                updateTrafficLight();
                setState(() {});
              },
            ),
          const SizedBox(width: 50.0),
          // boton +5
            ElevatedButton.icon(
              label: const Text('+5'),
              onPressed: () {
                if (clickCounter > aforo) return;
                clickCounter += 5;
                updateTrafficLight();
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      enableFeedback: true,
      elevation: 5,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
