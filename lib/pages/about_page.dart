import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Expensio")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/app_icon.png"),
              ),
            ),
            SizedBox(height: 16),

            // App Name & Tagline
            Center(
              child: Column(
                children: [
                  Text(
                    "Expensio",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Track Every Rupee. Plan Every Move.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            _buildCard(
              title: "📌 About Expensio",
              content:
                  "Expensio is your smart personal finance manager. It helps you track daily expenses, categorize spending, and manage savings efficiently. "
                  "With insightful reports, budgets, and reminders, Expensio keeps your financial health in check effortlessly.",
            ),

            _buildCard(
              title: "🔹 Why Expensio?",
              content:
                  "✨ Simple & Intuitive UI – Designed for effortless navigation\n"
                  "📊 Smart Insights – Get detailed analytics of your spending habits\n"
                  "🔒 Secure & Private – Your data stays protected with Firebase\n"
                  "⚡ Lightweight & Fast – No unnecessary clutter, just what you need",
            ),

            _buildCardWithRichText(
              title: "👤 About the Developer",
              content: [
                TextSpan(text: "Hi, I’m "),
                TextSpan(
                  text: "Naga Ayushmaan Betapudi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ", the creator of Expensio! 🎯\n\nAs a passionate Flutter & Firebase developer, I built this app to simplify personal finance management. "
                      "My goal is to provide a user-friendly, efficient, and feature-packed expense tracker that helps people gain financial clarity.\n\n",
                ),
                TextSpan(
                  text: "Tech Stack Used:\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "✔ Flutter – Beautiful, responsive UI\n"),
                TextSpan(text: "✔ Firebase Authentication – Secure login system\n"),
                TextSpan(text: "✔ Firestore Database – Real-time data storage\n"),
                TextSpan(text: "✔ PDF & CSV Export – Easy data access anytime"),
              ],
            ),

            _buildCard(
              title: "🚀 Future Developments",
              content:
                  "🔹 Budget Constraints – Set an overall & category-wise budget\n"
                  "🔹 Recurring Transactions – Automate bill payments & expenses\n"
                  "🔹 AI-based Insights – Predictive analysis of spending habits\n"
                  "🔹 Dark Mode & Themes – Customize your experience\n"
                  "🔹 Graphical Insights – Line & bar charts for better analysis\n"
                  "🔹 Bank Integration – Auto-fetch transactions from linked accounts",
            ),

            _buildCard(
              title: "🎨 Inspiration",
              content:
                  "The inspiration for Expensio came from the app \"Day-To-Day Expenses\", from which I adapted most of the UI elements. "
                  "This app's simplicity and efficiency inspired me to build a more feature-rich and modernized version.",
            ),

            _buildCard(
              title: "💬 Stay Connected!",
              content:
                  "📩 Feedback & Support: Got suggestions or need help? Feel free to reach out @ ayushmaanbn@gmail.com!\n\n"
                  "⭐ Rate the App: If you love Expensio, don’t forget to leave a review!\n\n"
                  "Thank you for using Expensio! 🎉 Let’s make expense tracking effortless.",
            ),
          ],
        ),
      ),
    );
  }

  // Standard Card for Regular Text
  Widget _buildCard({required String title, required String content}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  // Card for Text with Bold Formatting
  Widget _buildCardWithRichText({required String title, required List<TextSpan> content}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                children: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
