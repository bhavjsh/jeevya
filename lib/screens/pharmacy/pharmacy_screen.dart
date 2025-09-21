import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<Pharmacy> _pharmacies = [
    Pharmacy(
      name: 'Nabha Medical Store',
      address: 'Main Bazaar, Nabha, Punjab',
      distance: 0.5,
      isOpen: true,
      phone: '+91 98765 11111',
      rating: 4.2,
      medicines: ['Paracetamol', 'Cough Syrup', 'Antibiotics'],
    ),
    Pharmacy(
      name: 'City Pharmacy',
      address: 'Civil Lines, Nabha, Punjab',
      distance: 1.2,
      isOpen: true,
      phone: '+91 98765 22222',
      rating: 4.5,
      medicines: ['Insulin', 'BP Medicine', 'Vitamins'],
    ),
    Pharmacy(
      name: 'Sharma Medical Hall',
      address: 'Bus Stand Road, Nabha, Punjab',
      distance: 2.1,
      isOpen: false,
      phone: '+91 98765 33333',
      rating: 4.0,
      medicines: ['Pain Killers', 'Fever Medicine', 'Cough Syrup'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Pharmacies'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Location: Nabha, Punjab'),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search medicines, pharmacy name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Quick filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Open Now', true),
                      const SizedBox(width: 8),
                      _buildFilterChip('24/7', false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Home Delivery', false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Near Me', false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '${_pharmacies.length} Pharmacies Found',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                const SizedBox(width: 4),
                Text(
                  'Within 5 km',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          
          // Pharmacy List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = _pharmacies[index];
                return _buildPharmacyCard(pharmacy);
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showUploadPrescriptionDialog();
        },
        backgroundColor: AppTheme.accentColor,
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Prescription'),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {},
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  Widget _buildPharmacyCard(Pharmacy pharmacy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              pharmacy.address,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Status and Distance
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: pharmacy.isOpen 
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: pharmacy.isOpen 
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      ),
                      child: Text(
                        pharmacy.isOpen ? 'Open' : 'Closed',
                        style: TextStyle(
                          fontSize: 10,
                          color: pharmacy.isOpen 
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pharmacy.distance.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Rating and Phone
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.warningColor, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      '${pharmacy.rating}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  pharmacy.phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Available Medicines
            const Text(
              'Available Medicines:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: pharmacy.medicines.map((medicine) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    medicine,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.accentColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling ${pharmacy.name}...'),
                          backgroundColor: AppTheme.accentColor,
                        ),
                      );
                    },
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pharmacy.isOpen ? () {
                      _showOrderDialog(pharmacy);
                    } : null,
                    icon: const Icon(Icons.shopping_cart, size: 16),
                    label: const Text('Order'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Directions to ${pharmacy.name}'),
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                    },
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text('Direction'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(Pharmacy pharmacy) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order from ${pharmacy.name}'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select order method:'),
              SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed via call! They will contact you.'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              child: const Text('Order by Call'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showUploadPrescriptionDialog();
              },
              child: const Text('Upload Prescription'),
            ),
          ],
        );
      },
    );
  }

  void _showUploadPrescriptionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.upload_file, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text('Upload Prescription'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Upload your prescription to order medicines:'),
              const SizedBox(height: 16),
              
              // Upload options
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Camera opened! (Demo)'),
                      backgroundColor: AppTheme.accentColor,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gallery opened! (Demo)'),
                      backgroundColor: AppTheme.accentColor,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Upload Document'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File picker opened! (Demo)'),
                      backgroundColor: AppTheme.accentColor,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class Pharmacy {
  final String name;
  final String address;
  final double distance;
  final bool isOpen;
  final String phone;
  final double rating;
  final List<String> medicines;

  Pharmacy({
    required this.name,
    required this.address,
    required this.distance,
    required this.isOpen,
    required this.phone,
    required this.rating,
    required this.medicines,
  });
}