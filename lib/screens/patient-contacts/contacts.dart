import 'package:flutter/material.dart';
import 'package:patient_app/shared/toast.dart';
import '../../apis/apis.dart';
import '../shared/bottom-menu.dart';
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
  int _tmpSelectedCategory = 0;
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
      body: SafeArea(
        // Wrap your body with SafeArea
        child: Column(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContactModal();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
    );
  }

  Widget _buildContactList(int category) {
    return _contacts.isEmpty
        ? const Center(child: Text('  '))
        : ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              var contact = _contacts[index];
              return ExpansionTile(
                leading: Icon(Icons.phone),
                title: Text(contact['first_name'] ?? ""),
                subtitle: Text(contact['last_name'] ?? ""),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //_buildContactDetailRow("ID", contact['id'].toString()??""),
                        _buildContactDetailRow(
                            AppLocalizations.tr('Phone') ?? 'Phone',
                            contact['phone_number'] ?? ""),
                        _buildContactDetailRow("Email", contact['email'] ?? ""),
                        _buildContactDetailRow(
                            AppLocalizations.tr('Institution Name') ??
                                'Institution Name',
                            contact['institution_name'] ?? ""),
                        _buildContactDetailRow(
                            AppLocalizations.tr('Institution Address') ??
                                'Institution Address',
                            contact['institution_address'] ?? ""),
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

    if (label == 'Telefon') {
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
        onTap: () => _showEmailConfirmationDialog(value),
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

  void _showEmailConfirmationDialog(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.tr("Confirmation")),
          content: Text(
              'Möchten Sie die Mail-App öffnen, um eine E-Mail an $email zu senden?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the confirmation dialog
                _sendEmail(email); // Open the mail app
              },
              child: Text('Ja'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the confirmation dialog
              },
              child: Text('Nein'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteContactConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kontakt löschen'),
          content:
              Text('Sind Sie sicher, dass Sie diesen Kontakt löschen möchten?'),
          actions: [
            TextButton(
              onPressed: () async {
                var contact = _contacts[index];
                _deleteContact(index);
                await _apis
                    .deletePatientContact(contact)
                    .then((value) => Navigator.pop(context));
              },
              child: Text('Ja'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Nein'),
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

  void _showAddContactModal() {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController institutionNameController = TextEditingController();
    TextEditingController institutionAddressController =
        TextEditingController();

    _tmpSelectedCategory = _selectedCategory + 1;

    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => AlertDialog(
          title: Text('Neuen Kontakt hinzufügen'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButton<int>(
                    value: _tmpSelectedCategory,
                    onChanged: (newValue) {
                      setState(() {
                        print(newValue);
                        _tmpSelectedCategory = newValue!;
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
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.tr('First Name') ?? 'First Name'),
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.tr('Last Name') ?? 'Last Name'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.tr('Phone') ?? 'Phone'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Notwendig';
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
                    decoration: InputDecoration(
                        labelText: AppLocalizations.tr('Institution Name') ??
                            'Institution Name'),
                  ),
                  TextFormField(
                    controller: institutionAddressController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.tr('Institution Address') ??
                            'Institution Address'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Save the new contact and close the dialog
                  Map<String, dynamic> newContact = {
                    'category': _tmpSelectedCategory,
                    'first_name': firstNameController.text,
                    'last_name': lastNameController.text,
                    'phone_number': phoneController.text,
                    'email': emailController.text,
                    'institution_name': institutionNameController.text,
                    'institution_address': institutionAddressController.text,
                  };
                  // Add logic to save the new contact using _apis class or other methods
                  _contacts.add(newContact);
                  await _apis
                      .createPatientContact(newContact)
                      .then((value) => Navigator.pop(context));
                  _fetchContactsByCategory(_selectedCategory + 1);
                }
              },
              child: Text('Speichern'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without saving
                Navigator.pop(context);
              },
              child: Text('Abbrechen'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditContactModal(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditContactDialog(
          contact: contact,
          onUpdate: () {
            setState(() {
              showToast(AppLocalizations.tr('Contact updated.') ??
                  'Contact updated.');
              _fetchContactsByCategory(_selectedCategory + 1);
            });
          },
        );
      },
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri(scheme: 'tel', path: phoneNumber))) {
      await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
    } else {
      throw '$url konnte nicht gestartet werden'; //Could not launch URL
    }
  }

  void _sendEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrl(Uri(scheme: 'mailto', path: email))) {
      await launchUrl(Uri(scheme: 'mailto', path: email));
    } else {
      throw '$url konnte nicht gestartet werden'; //Could not launch URL
    }
  }
}

class EditContactDialog extends StatefulWidget {
  final Map<String, dynamic> contact;
  //final Function(Map<String, dynamic> updatedContact) onUpdate;
  final void Function() onUpdate;

  EditContactDialog({required this.contact, required this.onUpdate});

  @override
  _EditContactDialogState createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<EditContactDialog> {
  final Apis _apis = Apis();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController institutionNameController =
      TextEditingController();
  final TextEditingController institutionAddressController =
      TextEditingController();
  late int selectedCategory;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add this line

  @override
  void initState() {
    super.initState();
    selectedCategory = int.parse(widget.contact['category']);
    firstNameController.text = widget.contact['first_name'] ?? "";
    lastNameController.text = widget.contact['last_name'] ?? "";
    phoneController.text = widget.contact['phone_number'] ?? "";
    emailController.text = widget.contact['email'] ?? "";
    institutionNameController.text = widget.contact['institution_name'] ?? "";
    institutionAddressController.text =
        widget.contact['institution_address'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.tr('Edit Contact') ?? 'Edit Contact'),
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
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.tr('First Name') ?? 'First Name'),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.tr('Last Name') ?? 'Last Name'),
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.tr('Phone') ?? 'Phone'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Notwendig'; //Required field warning
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
                decoration: InputDecoration(
                    labelText: AppLocalizations.tr('Institution Name') ??
                        'Institution Name'),
              ),
              TextFormField(
                controller: institutionAddressController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.tr('Institution Address') ??
                        'Institution Address'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Update the contact details and close the dialog
              widget.contact['category'] = selectedCategory.toString();
              widget.contact['first_name'] = firstNameController.text;
              widget.contact['last_name'] = lastNameController.text;
              widget.contact['phone_number'] = phoneController.text;
              widget.contact['email'] = emailController.text;
              widget.contact['institution_name'] =
                  institutionNameController.text;
              widget.contact['institution_address'] =
                  institutionAddressController.text;

              await _apis.updatePatientContact(widget.contact);
              //widget.onUpdate(widget.contact);
              widget.onUpdate();
              Navigator.pop(context);
            }
          },
          child: Text('Speichern'),
        ),
        TextButton(
          onPressed: () {
            // Close the dialog without saving
            Navigator.pop(context);
          },
          child: Text('Abbrechen'),
        ),
      ],
    );
  }
}
