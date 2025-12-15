import 'package:flutter/material.dart';

// ==========================================================
// 1. MODELO DE DATOS
// ==========================================================
class Reserva {
  final int id;
  final String motivo;
  final String fecha;
  final String estado; // Nuevo campo para darle color visual

  Reserva({
    required this.id,
    required this.motivo,
    required this.fecha,
    this.estado = 'Pendiente',
  });
}

// ==========================================================
// 2. PANTALLA PRINCIPAL (CONTENEDOR DE NAVEGACIÓN)
// ==========================================================
class DashboardScreen extends StatefulWidget {
  final String userName;
  const DashboardScreen({super.key, required this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Títulos dinámicos para la AppBar según la pestaña
  static const List<String> _titles = <String>[
    'Inicio - BienestarMind',
    'Mi Agenda',
    'Mi Perfil',
  ];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Inicializamos las 3 pantallas pasándoles los datos necesarios
    _pages = [
      HomeTab(userName: widget.userName),      // Pestaña 1: Dashboard original
      const CalendarTab(),                     // Pestaña 2: Calendario Visual
      ProfileTab(userName: widget.userName),   // Pestaña 3: Perfil
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Función para abrir el formulario de Nueva Reserva (Modal)
  void _showNewReservaForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ReservaFormModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dinámica
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: _selectedIndex == 0 
            ? IconButton(icon: const Icon(Icons.menu), onPressed: (){}) // Menú hamburguesa solo en Inicio
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sin notificaciones nuevas')),
              );
            },
          ),
        ],
      ),
      
      // Muestra la pantalla seleccionada de la lista _pages
      body: _pages[_selectedIndex],

      // Botón flotante: Solo aparece en la pestaña de Inicio
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showNewReservaForm,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text("Agendar"),
            )
          : null,

      // Barra de Navegación Inferior
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ==========================================================
// 3. PESTAÑA 1: HOME (Lógica del Dashboard)
// ==========================================================
class HomeTab extends StatefulWidget {
  final String userName;
  const HomeTab({super.key, required this.userName});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  
  // Datos simulados (Hardcoded para el prototipo)
  final List<Reserva> _allReservas = [
    Reserva(id: 1, motivo: 'Psicología - Ansiedad', fecha: '2025-12-05', estado: 'Confirmada'),
    Reserva(id: 2, motivo: 'Enfermería - Chequeo', fecha: '2025-12-06'),
    Reserva(id: 3, motivo: 'Gimnasio - Rutina', fecha: '2025-12-07'),
  ];
  List<Reserva> _filteredReservas = [];

  @override
  void initState() {
    super.initState();
    _filteredReservas = _allReservas;
    _searchController.addListener(_filterReservas);
  }

  void _filterReservas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredReservas = _allReservas.where((r) {
        return r.motivo.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          Text(
            'Hola, ${widget.userName} 👋',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3E50)),
          ),
          const Text("Bienvenido a tu espacio de bienestar.", style: TextStyle(color: Colors.grey)),
          
          const SizedBox(height: 25),

          // Estadísticas Rápidas
          Row(
            children: [
              Expanded(child: _buildStatCard('Citas Activas', '3', Colors.green, Icons.calendar_today)),
              const SizedBox(width: 15),
              Expanded(child: _buildStatCard('Histórico', '12', Colors.orange, Icons.history)),
            ],
          ),

          const SizedBox(height: 30),

          // Buscador
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar reserva...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            ),
          ),

          const SizedBox(height: 25),
          const Text("Próximas Actividades", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // Lista de Reservas
          ListView.builder(
            shrinkWrap: true, // Vital para que funcione dentro de SingleScrollView
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredReservas.length,
            itemBuilder: (context, index) {
              final reserva = _filteredReservas[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(Icons.medical_services, color: Theme.of(context).primaryColor),
                  ),
                  title: Text(reserva.motivo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(reserva.fecha),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: reserva.estado == 'Confirmada' ? Colors.green.shade100 : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      reserva.estado,
                      style: TextStyle(
                        fontSize: 12,
                        color: reserva.estado == 'Confirmada' ? Colors.green.shade800 : Colors.orange.shade800,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ],
      ),
    );
  }
}

// ==========================================================
// 4. PESTAÑA 2: CALENDARIO (VISUAL)
// ==========================================================
class CalendarTab extends StatelessWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Calendario Visual
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2024),
              lastDate: DateTime(2030),
              onDateChanged: (date) {},
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          // Lista de eventos simulados del día
          Expanded(
            child: ListView(
              children: [
                _buildEventItem("Cita Psicología", "10:00 AM - 11:00 AM", Colors.blue),
                _buildEventItem("Pausa Activa", "03:00 PM - 03:15 PM", Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String title, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border(left: BorderSide(color: color, width: 4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(time, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}

// ==========================================================
// 5. PESTAÑA 3: PERFIL (VISUAL)
// ==========================================================
class ProfileTab extends StatelessWidget {
  final String userName;
  const ProfileTab({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFE3F2E2),
              child: Icon(Icons.person, size: 60, color: Colors.green),
            ),
            const SizedBox(height: 20),
            Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Aprendiz SENA", style: TextStyle(color: Colors.grey, fontSize: 16)),
            const Text("Ficha: 2901234 - ADSO", style: TextStyle(color: Colors.grey, fontSize: 14)),
            
            const SizedBox(height: 40),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileOption(Icons.settings, "Configuración"),
                  _buildProfileOption(Icons.history, "Historial Médico"),
                  _buildProfileOption(Icons.help, "Ayuda y Soporte"),
                  _buildProfileOption(Icons.info, "Acerca de BienestarMind"),
                ],
              ),
            ),
  
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Simula Logout (regresa al Login)
              },
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar Sesión"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.grey.shade50,
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}

// ==========================================================
// 6. FORMULARIO FLOTANTE (MODAL SHEET)
// ==========================================================
class ReservaFormModal extends StatefulWidget {
  const ReservaFormModal({super.key});

  @override
  State<ReservaFormModal> createState() => _ReservaFormModalState();
}

class _ReservaFormModalState extends State<ReservaFormModal> {
  String? _selectedService;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Ajuste teclado
        left: 20, 
        right: 20, 
        top: 20
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nueva Cita", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))
            ],
          ),
          const SizedBox(height: 20),

          // Selector de Servicio
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Servicio",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            items: const [
              DropdownMenuItem(value: "Psicología", child: Text("Psicología")),
              DropdownMenuItem(value: "Enfermería", child: Text("Enfermería")),
              DropdownMenuItem(value: "Deporte", child: Text("Gimnasio / Deporte")),
              DropdownMenuItem(value: "Cultura", child: Text("Actividad Cultural")),
            ],
            onChanged: (value) => setState(() => _selectedService = value),
          ),
          
          const SizedBox(height: 15),

          // Campo de fecha simulado
          const TextField(
            decoration: InputDecoration(
              labelText: "Fecha Deseada",
              hintText: "Ej: 2025-12-10",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
          ),

          const SizedBox(height: 25),

          // Botón de Guardar
          ElevatedButton(
            onPressed: _isLoading ? null : () async {
              if (_selectedService == null) return;
              
              setState(() => _isLoading = true);
              // Simulación de carga
              await Future.delayed(const Duration(seconds: 2));

              if (mounted) {
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡Cita de $_selectedService agendada!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F9C18),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            child: _isLoading 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text("CONFIRMAR RESERVA"),
          ),
        ],
      ),
    );
  }
}