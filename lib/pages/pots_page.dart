import 'package:expense_tracker/components/my_text_field.dart';
import 'package:expense_tracker/components/pot_card.dart';
import 'package:expense_tracker/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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

  // Providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // SelectedIcon
  String? selectedIconPath;

  // Add / Edit Pot Dialog
  void showPotDialog() {
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
                    nameController.clear();
                    goalController.clear();
                    selectedIconPath = null;
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),

                // Add
                MaterialButton(
                  onPressed: () {
                    if (mounted) Navigator.of(context).pop();
                    nameController.clear();
                    goalController.clear();
                    selectedIconPath = null;
                  },
                  child: Text('Add'),
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

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),

      // Body
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 75,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withAlpha(100),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Image.asset('assets/investment.png'),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Bajaj 4S',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Progress Bar
                        LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width * 0.58,
                          lineHeight: 8.0,
                          percent: 0.69,
                          barRadius: Radius.circular(12),
                          progressColor: Theme.of(context).colorScheme.tertiary,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name
                      Text(
                        '₹ 25,000',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),

                      SizedBox(
                        width: 60,
                        child: Divider(
                          thickness: 2,
                          color: const Color.fromARGB(255, 7, 106, 84),
                        ),
                      ),

                      // Progress Bar
                      Text(
                        '₹ 50,000',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // List<Pots>
            ListView.builder(
              shrinkWrap: true,
              itemCount: pots.length,
              itemBuilder: (context, index) {
                return PotCard(pot: pots[index]);
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
