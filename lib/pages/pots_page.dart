// ignore_for_file: use_build_context_synchronously

import 'package:expense_tracker/components/my_text_field.dart';
import 'package:expense_tracker/components/pot_card.dart';
import 'package:expense_tracker/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PotsPage extends StatefulWidget {
  const PotsPage({super.key});

  @override
  State<PotsPage> createState() => _PotsPageState();
}

class _PotsPageState extends State<PotsPage> {
  // Controller
  final nameController = TextEditingController();
  final goalController = TextEditingController();
  final sofarController = TextEditingController();

  // Providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // Selected Icon
  String? selectedIconPath;

  // Selected type
  int selectedType = 1;

  @override
  void initState() {
    super.initState();
    loadPots();
  }

  // Fetch All Pots
  void loadPots() async {
    await databaseProvider.fetchPots();
  }

  // Add / Edit Pot Dialog
  void showPotDialog({bool edit = false, String? potId}) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Pot'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      selectedIconPath == null
                          ? IconButton(
                              onPressed: () => showIconsDialog(setState),
                              icon: Icon(Icons.add),
                            )
                          : GestureDetector(
                              onTap: () => showIconsDialog(setState),
                              child: Image.asset(
                                selectedIconPath!,
                                width: 40,
                                height: 40,
                              ),
                            ),

                      const SizedBox(width: 5),

                      // Name TextField
                      Expanded(
                        child: MyTextField(
                          controller: nameController,
                          icon: null,
                          hintText: 'Name',
                          obscureText: false,
                        ),
                      ),
                    ],
                  ),

                  // Goal TextField
                  MyTextField(
                    controller: goalController,
                    icon: null,
                    hintText: 'Goal',
                    obscureText: false,
                    textInputType: TextInputType.numberWithOptions(),
                  ),
                ],
              ),
              actions: [
                // Cancel
                MaterialButton(
                  onPressed: () {
                    // Pop the dialog
                    Navigator.of(context).pop();

                    // Clear the controllers
                    nameController.clear();
                    goalController.clear();

                    // Revert the iconPath
                    selectedIconPath = null;
                  },
                  child: Text('Cancel'),
                ),

                // Add
                MaterialButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        goalController.text.isNotEmpty) {
                      // Pop the dialog
                      if (mounted) Navigator.of(context).pop();

                      if (edit) {
                        // Edit the pot in firestore
                        await databaseProvider.editPot(
                          potId!,
                          nameController.text,
                          double.parse(goalController.text),
                          selectedIconPath ?? '',
                        );
                      } else {
                        // Add the pot in firestore
                        await databaseProvider.addPot(
                          nameController.text,
                          int.parse(goalController.text),
                          selectedIconPath ?? '',
                        );
                      }

                      // Clear the controllers
                      nameController.clear();
                      goalController.clear();

                      // Revert the iconPath
                      selectedIconPath = null;
                    }
                  },
                  child: edit ? Text('Save') : Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Icons For Pots
  void showIconsDialog(Function(void Function()) setDialogState) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select an Icon",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: icons.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedIconPath = icons[index];
                        setDialogState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                icons[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            icons[index].split('.')[0].split('/')[1],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Delete Pot Dialog
  void showDeleteDialog({required String potId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to delete this pot ?'),
          actions: [
            // Cancel
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),

            // Add
            TextButton(
              onPressed: () async {
                // Pop the dialog
                if (mounted) Navigator.of(context).pop();

                // Delete the pot in firestore
                await databaseProvider.deletePot(potId);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Edit SoFar Dialog
  void editSoFarDialog(String potId, int sofar, int goal) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add / Take Out
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Income Box
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedType = 1;
                              });
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                color: (selectedType == 1)
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(16)),
                              ),
                              child: Center(
                                child: Text('Add'),
                              ),
                            ),
                          ),
                        ),

                        // Expense Box
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedType = 0;
                              });
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                color: (selectedType == 0)
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.surface,
                                border: Border(
                                  top: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  bottom: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  right: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(16)),
                              ),
                              child: Center(
                                child: Text('Take Out'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount TextField
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: sofarController,
                          icon: null,
                          hintText: 'How Much?',
                          obscureText: false,
                          textInputType: TextInputType.numberWithOptions(),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        (selectedType == 1)
                            ? ' / ${goal - sofar}'
                            : ' / $sofar',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                // Cancel
                MaterialButton(
                  onPressed: () {
                    // Clear the controller
                    sofarController.clear();

                    // Pop the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),

                // Save
                MaterialButton(
                  onPressed: () async {
                    if (sofarController.text.isEmpty) {
                      return;
                    }

                    double enteredAmount =
                        double.tryParse(sofarController.text) ?? 0;

                    if (enteredAmount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Enter a valid amount"),
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                      );
                      return;
                    }

                    if (selectedType == 1) {
                      // Adding money
                      if (sofar + enteredAmount > goal) {
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Can't exceed goal amount!",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                          ),
                        );
                        return;
                      }

                      // Update Firestore
                      await databaseProvider.editSoFarInPot(
                          potId, sofar + enteredAmount);
                    } else {
                      // Taking out money
                      if (enteredAmount > sofar) {
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Can't take out more than available amount!",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                          ),
                        );
                        return;
                      }

                      // Update Firestore
                      await databaseProvider.editSoFarInPot(
                          potId, sofar - enteredAmount);
                    }

                    // Pop the dialog
                    if (mounted) Navigator.of(context).pop();

                    // Clear the controller
                    sofarController.clear();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get All Pots
    final pots = listeningProvider.allPots;

    return Scaffold(
      // Background color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Text('Your Savings'),
        actions: [
          IconButton(onPressed: () => showPotDialog(), icon: Icon(Icons.add))
        ],
      ),

      // Body
      body: SafeArea(
        child: Column(
          children: [
            // List<Pots>
            ListView.builder(
              shrinkWrap: true,
              itemCount: pots.length,
              itemBuilder: (context, index) {
                final pot = pots[index];

                return PotCard(
                  pot: pot,
                  onEditPressed: () {
                    // Prefill the controllers
                    nameController.text = pot.name;
                    goalController.text = pot.goal.toString();
                    selectedIconPath = pot.iconPath;

                    // Open the dialog
                    showPotDialog(edit: true, potId: pot.id);
                  },
                  onDeletePressed: () => showDeleteDialog(potId: pot.id),
                  onTapped: () => editSoFarDialog(pot.id, pot.sofar, pot.goal),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

List<String> icons = [
  "assets/Emergency.png",
  "assets/Fashion.png",
  "assets/Gadgets.png",
  "assets/Gaming.png",
  "assets/Gifts.png",
  "assets/House.png",
  "assets/Investment.png",
  "assets/Jewellery.png",
  "assets/Misc.png",
  "assets/Bike.png",
  "assets/Car.png",
  "assets/Shoes.png",
  "assets/Furniture.png",
  "assets/Vacation.png",
  "assets/Wedding.png",
];
