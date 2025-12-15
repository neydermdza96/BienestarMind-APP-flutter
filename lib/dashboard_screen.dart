// dashboard_screen.dart

import 'package:flutter/material.dart';

// Modelo de datos simple
class Reserva {
  final int id;
  final String motivo;
  final String fecha;

  Reserva({required this.id, required this.motivo, required this.fecha});
}

// ==========================================================
// SIMULACIÓN DE DATOS (SERVICIO)
// ==========================================================

Future<List<Reserva>> fetchPendingReservas() async {
  await Future.delayed(const Duration(seconds: 2));

  return [
    Reserva(id: 1, motivo: 'Asesoría Psicológica', fecha: '2025-12-05'),
    Reserva(id: 2, motivo: 'Reserva de Aula Multimedia', fecha: '2025-12-06'),
    Reserva(id: 3, motivo: 'Revisión de Proyecto', fecha: '2025-12-07'),
    Reserva(id: 4, motivo: 'Equipo de Video', fecha: '2025-12-08'),
  ];
}

List<Reserva> fetchHistoricalReservas() {
  return [
    Reserva(
      id: 10,
      motivo: 'Reunión de Equipo (Histórico)',
      fecha: '2025-11-01',
    ),
    Reserva(
      id: 11,
      motivo: 'Taller de Liderazgo (Histórico)',
      fecha: '2025-11-05',
    ),
    Reserva(
      id: 12,
      motivo: 'Asesoría Nutricional (Histórico)',
      fecha: '2025-11-10',
    ),
  ];
}

// ==========================================================
// DashboardScreen CON ESTADO
// ==========================================================

class DashboardScreen extends StatefulWidget {
  final String userName;
  const DashboardScreen({super.key, required this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Reserva> _allReservas = [];
  List<Reserva> _filteredReservas = [];
  final TextEditingController _searchController = TextEditingController();

  // Estado para el BottomNavigationBar
  int _selectedIndex = 0;
  // Estado para el Toggle de Listas (true = Próximas, false = Histórico)
  bool _showPending = true;

  late Future<List<Reserva>> _reservasFuture;

  @override
  void initState() {
    super.initState();
    _reservasFuture = fetchPendingReservas();
    _searchController.addListener(_filterReservas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterReservas() {
    final List<Reserva> sourceList = _showPending
        ? _allReservas
        : fetchHistoricalReservas();

    final query = _searchController.text.toLowerCase();

    if (query.isEmpty && _showPending) {
      setState(() {
        _filteredReservas = _allReservas;
      });
      return;
    }

    if (!_showPending && _allReservas.isEmpty) {
      _allReservas = sourceList;
    }

    final results = sourceList.where((reserva) {
      return reserva.motivo.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredReservas = results;
    });
  }

  void _toggleList(bool showPending) {
    if (_showPending == showPending) return;

    _searchController.clear();

    setState(() {
      _showPending = showPending;

      if (!_showPending) {
        _filteredReservas = fetchHistoricalReservas();
      } else {
        _filteredReservas = _allReservas;
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Lógica de navegación (simulada)
    if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Navegando a Perfil... (simulado)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard BienestarMind'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '¡Bienvenido, ${widget.userName}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            // Layouts: Tarjetas
            Row(
              children: <Widget>[
                // ✅ Tarjeta 1: Verde (OK)
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Asesorías',
                    '120',
                    Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 10),
                // ✅ Tarjeta 2: Tono Neutro (Reemplaza el Azul/Morado)
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Espacios Reservados',
                    '45',
                    Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Campo de búsqueda
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar Reserva por Motivo...',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                ),
              ),
            ),

            // Toggle de Listas (Pendientes vs. Histórico)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _toggleList(true),
                  icon: Icon(
                    Icons.pending_actions,
                    color: _showPending
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Próximas Reservas',
                    style: TextStyle(
                      color: _showPending ? Colors.white : Colors.black87,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showPending
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    elevation: _showPending ? 5 : 0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _toggleList(false),
                  icon: Icon(
                    Icons.history,
                    color: !_showPending
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Reservas Históricas',
                    style: TextStyle(
                      color: !_showPending ? Colors.white : Colors.black87,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_showPending
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    elevation: !_showPending ? 5 : 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Future Builder: Carga los datos una vez
            _showPending && _allReservas.isEmpty
                ? FutureBuilder<List<Reserva>>(
                    future: _reservasFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        _allReservas = snapshot.data!;
                        _filteredReservas = _allReservas;
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _filterReservas(),
                        );
                        return _buildReservasList(_filteredReservas);
                      } else {
                        return const Text('No hay reservas próximas.');
                      }
                    },
                  )
                : _buildReservasList(_filteredReservas),
          ],
        ),
      ),

      // ✅ BOTÓN FLOTANTE
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Botón flotante: Crear nueva reserva (simulado)'),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),

      // ✅ BottomNavigationBar (Tonos Morados/Ámbar reemplazados por Blanco/Verde)
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        // ✅ Color de fondo de la barra
        backgroundColor: Theme.of(context).primaryColor,
        // ✅ Ítem seleccionado en BLANCO (Reemplaza el ámbar/morado)
        selectedItemColor: Colors.white,
        // ✅ Ítems no seleccionados en un verde más claro
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      ),
    );
  }

  // 5. Container (Propiedades Avanzadas: BoxDecoration y Sombra)
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String count,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(color: color, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 4. ListView.builder: Generador de Listas Eficiente
  Widget _buildReservasList(List<Reserva> reservas) {
    if (reservas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'No se encontraron reservas con ese criterio.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: reservas.length,
        itemBuilder: (context, index) {
          final reserva = reservas[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                reserva.motivo,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text('Fecha: ${reserva.fecha}'),
              trailing: Text('#${reserva.id}'),
            ),
          );
        },
      ),
    );
  }
}
