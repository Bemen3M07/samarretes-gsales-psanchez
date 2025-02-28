import 'package:flutter/material.dart';

void main() {
  runApp(TShirtCalculatorApp());
}

class TShirtCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TShirtCalculator(),
    );
  }
}

class TShirtCalculator extends StatefulWidget {
  @override
  _TShirtCalculatorState createState() => _TShirtCalculatorState();
}

class _TShirtCalculatorState extends State<TShirtCalculator> {
  int _quantity = 0;
  double _pricePerShirt = 0.0;
  String _selectedDiscount = 'Cap descompte';
  double _totalPrice = 0.0;

  final Map<String, double> _shirtPrices = {
    'Small': 7.99,
    'Medium': 9.95,
    'Large': 13.50,
  };

  void _calculatePrice() {
    if (_quantity > 0 && _pricePerShirt > 0) {
      double price = _quantity * _pricePerShirt;
      if (_selectedDiscount == 'Descompte 10%') {
        price *= 0.9;
      } else if (_selectedDiscount == '20€ per més de 100€' && price > 100) {
        price -= 20;
      }
      setState(() {
        _totalPrice = price;
      });
    } else {
      setState(() {
        _totalPrice = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('T-shirt Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Number of Shirts'),
              onChanged: (value) {
                setState(() {
                  _quantity = int.tryParse(value) ?? 0;
                  _calculatePrice();
                });
              },
            ),
            SizedBox(height: 10),
            Text('Select Size:'),
            Column(
              children: _shirtPrices.keys.map((size) {
                return RadioListTile(
                  title: Text('$size (\$${_shirtPrices[size]!.toStringAsFixed(2)})'),
                  value: _shirtPrices[size],
                  groupValue: _pricePerShirt,
                  onChanged: (value) {
                    setState(() {
                      _pricePerShirt = value as double;
                      _calculatePrice();
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text('Select Discount:'),
            DropdownButton<String>(
              value: _selectedDiscount,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDiscount = newValue!;
                  _calculatePrice();
                });
              },
              items: <String>['Cap descompte', 'Descompte 10%', '20€ per més de 100€']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              _totalPrice > 0 ? 'Preu Total: \$${_totalPrice.toStringAsFixed(2)}' : '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
