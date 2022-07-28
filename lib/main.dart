import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _runAnimation = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You have pushed the button this many times:',
                textAlign: TextAlign.center,
              ),
              _RotatingText(
                counter: _counter,
                runAnimation: _runAnimation,
              ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            FloatingActionButton(
              foregroundColor: Colors.red,
              backgroundColor:
                  _runAnimation ? Colors.amber : Colors.yellowAccent,
              onPressed: () => setState(() {
                _runAnimation = !_runAnimation;
              }),
              tooltip: 'Rotate',
              child: Icon(_runAnimation
                  ? Icons.rotate_right_rounded
                  : Icons.rotate_left_rounded),
            ),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          ]),
        ));
  }
}

class _RotatingText extends HookWidget {
  const _RotatingText(
      {Key? key, required int counter, this.runAnimation = false})
      : _counter = counter,
        super(key: key);

  final int _counter;
  final bool runAnimation;

  @override
  Widget build(BuildContext context) {
    var controller = useAnimationController(
        duration: const Duration(seconds: 4), upperBound: 2 * pi);

    if (runAnimation) {
      controller.repeat();
    } else {
      controller.stop();
    }

    return AnimatedBuilder(
      animation: controller,
      child: Container(color: Colors.red),
      builder: (context, child) {
        return Transform.rotate(
          alignment: Alignment.center,
          angle: controller.value,
          child: Transform.scale(
            scale: 2.0 + 0.3 * sin(controller.value).abs(),
            child: Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        );
      },
    );
  }
}
