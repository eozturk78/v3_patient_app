import 'package:flutter/material.dart';
import '../../apis/apis.dart';
import '../shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class ContactsListingPage extends StatefulWidget {
  const ContactsListingPage({super.key});

  @override
  _ContactsListingPageState createState() => _ContactsListingPageState();
}

class _ContactsListingPageState extends State<ContactsListingPage>
    with SingleTickerProviderStateMixin {
  final Apis _apis = Apis();
  List<dynamic> _contacts = []; // To store fetched contacts
  int _selectedCategory = 0; // Default category index
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add this line

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, // Number of tabs
      vsync: this,
      initialIndex: _selectedCategory,
    );
    _fetchContactsByCategory(_selectedCategory + 1); // Fetch contacts initially
  }

  Future<void> _fetchContactsByCategory(int category) async {
    try {
      List<dynamic> contacts =
      await _apis.getPatientContactsByCategory(category.toString());
      setState(() {
        _contacts = contacts;
      });
    } catch (error) {
      // TODO: Handle errors
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Meine medizinischen Kontakte', context),
      body: Column(
        children: [
          TabBar(
            labelColor: Colors.red[800],
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _selectedCategory = index;
                _fetchContactsByCategory(_selectedCategory + 1);
              });
            },
            tabs: const [
              Tab(
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text("Ansprechpartner",
                          textAlign: TextAlign.center))),
              Tab(child: Text("Ärzte", textAlign: TextAlign.center)),
              Tab(
                  child: Text("Medizinische Einrichtungen",
                      textAlign: TextAlign.center)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContactList(1), // Contact Persons
                _buildContactList(2), // Doctors
                _buildContactList(3), // Medical Centers
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContactModal();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddContactModal() {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController institutionNameController = TextEditingController();
    TextEditingController institutionAddressController = TextEditingController();
    int selectedCategory = 1; // Default category index

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Contact'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButton<int>(
                    value: selectedCategory,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Ansprechpartner'),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text('Ärzte'),
                      ),
                      DropdownMenuItem<int>(
                        value: 3,
                        child: Text('Medizinische Einrichtungen'),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: institutionNameController,
                    decoration: InputDecoration(labelText: 'Institution Name'),
                  ),
                  TextFormField(
                    controller: institutionAddressController,
                    decoration:
                    InputDecoration(labelText: 'Institution Address'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save the new contact and close the dialog
                  Map<String, dynamic> newContact = {
                    'category': selectedCategory,
                    'first_name': firstNameController.text,
                    'last_name': lastNameController.text,
                    'phone_number': phoneController.text,
                    'email': emailController.text,
                    'institution_name': institutionNameController.text,
                    'institution_address': institutionAddressController.text,
                  };
                  // Add logic to save the new contact using _apis class or other methods
                  _contacts.add(newContact);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without saving
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactList(int category) {
    return _contacts.isEmpty
        ? const Center(child: Text('No contacts available.'))
        : ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        var contact = _contacts[index];
        return ExpansionTile(
          leading: Icon(Icons.phone),
          title: Text(contact['first_name']),
          subtitle: Text(contact['last_name']),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactDetailRow("Phone", contact['phone_number']),
                  _buildContactDetailRow("Email", contact['email']),
                  _buildContactDetailRow(
                      "Institution Name", contact['institution_name']),
                  _buildContactDetailRow(
                      "Institution Address", contact['institution_address']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditContactModal(contact);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteContactConfirmation(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactDetailRow(String label, String value) {
    Widget valueWidget;

    if (label == 'Phone') {
      valueWidget = GestureDetector(
        onTap: () => _launchPhoneDialer(value),
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
      );
    } else if (label == 'Email') {
      valueWidget = GestureDetector(
        onTap: () => _sendEmail(value),
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
      );
    } else {
      valueWidget = Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: valueWidget,
          ),
        ],
      ),
    );
  }

  void _showDeleteContactConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteContact(index);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  void _showEditContactModal(Map<String, dynamic> contact) {
    TextEditingController firstNameController =
    TextEditingController(text: contact['first_name']);
    TextEditingController lastNameController =
    TextEditingController(text: contact['last_name']);
    TextEditingController phoneController =
    TextEditingController(text: contact['phone_number']);
    TextEditingController emailController =
    TextEditingController(text: contact['email']);
    TextEditingController institutionNameController =
    TextEditingController(text: contact['institution_name']);
    TextEditingController institutionAddressController =
    TextEditingController(text: contact['institution_address']);
    int selectedCategory = int.parse(contact['category']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Contact'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButton<int>(
                    value: selectedCategory,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Ansprechpartner'),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text('Ärzte'),
                      ),
                      DropdownMenuItem<int>(
                        value: 3,
                        child: Text('Medizinische Einrichtungen'),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: institutionNameController,
                    decoration: InputDecoration(labelText: 'Institution Name'),
                  ),
                  TextFormField(
                    controller: institutionAddressController,
                    decoration:
                    InputDecoration(labelText: 'Institution Address'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Update the contact details and close the dialog
                  contact['category'] = selectedCategory;
                  contact['first_name'] = firstNameController.text;
                  contact['last_name'] = lastNameController.text;
                  contact['phone_number'] = phoneController.text;
                  contact['email'] = emailController.text;
                  contact['institution_name'] = institutionNameController.text;
                  contact['institution_address'] =
                      institutionAddressController.text;

                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without saving
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri(scheme: 'tel', path: phoneNumber))) {
      await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
    } else {
      // TODO: Handle errors, e.g., show a toast or alert
    }
  }

  void _sendEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrl(Uri(scheme: 'mailto', path: email))) {
      await launchUrl(Uri(scheme: 'mailto', path: email));
    } else {
      throw 'Could not launch $url';
    }
  }
}
