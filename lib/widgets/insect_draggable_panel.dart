import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/insect_controller.dart';
import '../models/insect_model.dart';

// Widget personalizado para el panel deslizable de insectos
class InsectDraggablePanel extends StatefulWidget {
  final InsectController insectController;
  final Function(Insect) buildCompactInsectListItem;
  final Function(Insect) buildInsectListItem;
  final Function(Insect) showInsectDetails;

  const InsectDraggablePanel({
    Key? key,
    required this.insectController,
    required this.buildCompactInsectListItem,
    required this.buildInsectListItem,
    required this.showInsectDetails,
  }) : super(key: key);

  @override
  State<InsectDraggablePanel> createState() => _InsectDraggablePanelState();
}

class _InsectDraggablePanelState extends State<InsectDraggablePanel> {
  // Controlador para el panel deslizable
  late DraggableScrollableController _dragController;
  
  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController();
  }
  
  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25, // Inicialmente ocupa 25% de la pantalla
      minChildSize: 0.15, // Mínimo 15% de la pantalla
      maxChildSize: 0.8, // Máximo 80% de la pantalla
      controller: _dragController,
      snap: true, // Permite que el panel se ajuste a posiciones específicas
      snapSizes: const [0.15, 0.25, 0.5, 0.8], // Posiciones de ajuste
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determinar si estamos en modo compacto (panel pequeño)
              final isCompactMode = constraints.maxHeight < 150;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Importante para evitar desbordamiento
                children: [
                  // Barra de arrastre con GestureDetector específico para arrastre vertical
                  GestureDetector(
                    // Capturar el inicio del arrastre vertical
                    onVerticalDragUpdate: (details) {
                      // Calcular la nueva posición basada en el movimiento del dedo
                      final currentSize = _dragController.size;
                      final delta = details.primaryDelta! / MediaQuery.of(context).size.height;
                      
                      // Actualizar la posición del panel directamente
                      try {
                        // Limitar el tamaño entre minChildSize y maxChildSize
                        final newSize = (currentSize - delta).clamp(0.15, 0.8);
                        _dragController.jumpTo(newSize);
                      } catch (e) {
                        print('Error al mover el panel: $e');
                      }
                    },
                    // Al finalizar el arrastre, ajustar a la posición más cercana
                    onVerticalDragEnd: (details) {
                      final velocity = details.primaryVelocity ?? 0;
                      final currentSize = _dragController.size;
                      
                      double targetSize;
                      // Determinar el tamaño objetivo basado en la velocidad y posición actual
                      if (velocity.abs() > 300) {
                        // Si hay velocidad significativa, ir en esa dirección
                        if (velocity < 0) { // Hacia arriba
                          targetSize = currentSize < 0.5 ? 0.5 : 0.8;
                        } else { // Hacia abajo
                          targetSize = currentSize > 0.5 ? 0.25 : 0.15;
                        }
                      } else {
                        // Si no hay velocidad significativa, ir al más cercano
                        if (currentSize < 0.2) targetSize = 0.15;
                        else if (currentSize < 0.375) targetSize = 0.25;
                        else if (currentSize < 0.65) targetSize = 0.5;
                        else targetSize = 0.8;
                      }
                      
                      // Animar al tamaño objetivo
                      _animatePanel(targetSize);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: Column(
                        children: [
                          // Barra de arrastre visual
                          Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          // Solo mostrar el texto si no estamos en modo compacto
                          if (!isCompactMode) ...[  
                            const SizedBox(height: 8),
                            // Texto indicativo
                            Text(
                              'desliza_ver_mas'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Fila de título y botones - adaptable al modo compacto
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0, 
                      vertical: isCompactMode ? 4.0 : 8.0, // Reducir el padding vertical en modo compacto
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Título con contador de insectos centrado
                        Obx(() => Text(
                              'insectos_encontrados'.tr +
                                  ': ${widget.insectController.nearbyInsects.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isCompactMode ? 14 : 16, // Texto más pequeño en modo compacto
                                overflow: TextOverflow.ellipsis, // Evitar desbordamiento de texto
                              ),
                            )),
                      ],
                    ),
                  ),
                  // Divisor más delgado en modo compacto
                  Divider(height: isCompactMode ? 0.5 : 1, thickness: isCompactMode ? 0.5 : 1),
                  // Lista de insectos
                  Expanded(
                    child: Obx(() {
                      if (widget.insectController.error.isNotEmpty) {
                        return Center(
                          child: Text(
                            widget.insectController.error.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isCompactMode ? 12 : 14, // Texto más pequeño en modo compacto
                            ),
                          ),
                        );
                      }
                      
                      if (widget.insectController.nearbyInsects.isEmpty) {
                        return Center(
                          child: Text(
                            'no_insectos_encontrados'.tr,
                            style: TextStyle(
                              fontSize: isCompactMode ? 12 : 14, // Texto más pequeño en modo compacto
                            ),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        controller: scrollController, // Importante: usar el scrollController proporcionado
                        padding: EdgeInsets.zero, // Eliminar padding por defecto
                        itemCount: widget.insectController.nearbyInsects.length,
                        itemBuilder: (context, index) {
                          final insect = widget.insectController.nearbyInsects[index];
                          return isCompactMode 
                              ? widget.buildCompactInsectListItem(insect) // Versión compacta del item
                              : widget.buildInsectListItem(insect); // Versión normal del item
                        },
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
  
  // Método para animar el panel a un tamaño específico
  void _animatePanel(double targetSize) {
    try {
      _dragController.animateTo(
        targetSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      print('Error al animar el panel: $e');
    }
  }
}
