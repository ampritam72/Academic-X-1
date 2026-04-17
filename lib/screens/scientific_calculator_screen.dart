import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';
import '../config/theme.dart';

/// Offline scientific calculator using `math_expressions` (open-source, local eval).
class ScientificCalculatorScreen extends StatefulWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  State<ScientificCalculatorScreen> createState() =>
      _ScientificCalculatorScreenState();
}

class _ScientificCalculatorScreenState extends State<ScientificCalculatorScreen> {
  String _expr = '';
  String _result = '0';

  void _append(String s) {
    setState(() => _expr += s);
  }

  void _clear() {
    setState(() {
      _expr = '';
      _result = '0';
    });
  }

  void _backspace() {
    if (_expr.isEmpty) return;
    setState(() => _expr = _expr.substring(0, _expr.length - 1));
  }

  void _evaluate() {
    if (_expr.trim().isEmpty) return;
    try {
      var normalized = _expr
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', 'pi')
          .replaceAll('√', 'sqrt');
      // Implicit multiply: number followed by '('
      final buf = StringBuffer();
      for (var i = 0; i < normalized.length; i++) {
        final c = normalized[i];
        buf.write(c);
        if (i < normalized.length - 1) {
          final next = normalized[i + 1];
          if (RegExp(r'[0-9.)]').hasMatch(c) && next == '(') {
            buf.write('*');
          }
        }
      }
      normalized = buf.toString();

      final p = Parser();
      final exp = p.parse(normalized);
      final cm = ContextModel();
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));
      final v = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        if (v.isNaN || v.isInfinite) {
          _result = 'Error';
        } else {
          _result = _formatNum(v);
        }
      });
    } catch (_) {
      setState(() => _result = 'Error');
    }
  }

  String _formatNum(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
                      ),
                      child: Icon(Icons.arrow_back_rounded,
                          color: isDark ? AppColors.darkText : AppColors.lightText, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Scientific Calculator',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isDark
                            ? Colors.white.withAlpha(13)
                            : Colors.black.withAlpha(8),
                        border: Border.all(
                          color: AppColors.brandGreen.withAlpha(60),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Text(
                              _expr.isEmpty ? '0' : _expr,
                              style: GoogleFonts.robotoMono(
                                fontSize: 18,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _result,
                            style: GoogleFonts.robotoMono(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: _buildKeypad(isDark)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(bool isDark) {
    final rows = <List<dynamic>>[
      ['sin(', 'cos(', 'tan(', 'log('],
      ['ln(', 'sqrt(', '^', '('],
      [')', 'π', 'e', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', 'C', '⌫'],
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _key('=', isDark, accent: true, onTap: _evaluate),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...rows.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: row.map<Widget>((cell) {
                if (cell is String) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _key(cell, isDark, onTap: () {
                        if (cell == 'C') {
                          _clear();
                        } else if (cell == '⌫') {
                          _backspace();
                        } else if (cell == '×') {
                          _append('*');
                        } else if (cell == '÷') {
                          _append('/');
                        } else if (cell == 'π') {
                          _append('pi');
                        } else if (cell == '^') {
                          _append('^');
                        } else {
                          _append(cell);
                        }
                      }),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _key(String label, bool isDark,
      {bool accent = false, required VoidCallback onTap}) {
    return Material(
      color: accent
          ? AppColors.brandGreen.withAlpha(220)
          : (isDark ? AppColors.darkCard : AppColors.lightCard),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: label.length > 2 ? 12 : 16,
              fontWeight: FontWeight.w600,
              color: accent ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText),
            ),
          ),
        ),
      ),
    );
  }
}
