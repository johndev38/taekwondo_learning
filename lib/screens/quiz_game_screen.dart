import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'home_screen.dart';

class QuizGameScreen extends StatefulWidget {
  final String belt;
  final List<String> fileNames;

  const QuizGameScreen(
      {super.key, required this.belt, required this.fileNames});

  @override
  QuizGameScreenState createState() => QuizGameScreenState();
}

class QuizGameScreenState extends State<QuizGameScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isGameOver = false;

  // État de réponse pour la question courante
  bool _answered = false;
  bool _lastWasCorrect = false;
  String? _singleTapped; // option touchée (mode simple)
  final Set<String> _selectedOptions = {}; // options cochées (mode multiple)
  List<String> _shuffledOptions = [];

  static const Color _navy = Color(0xFF0A1628);
  static const Color _correct = Color(0xFF2E7D32);
  static const Color _wrong = Color(0xFFCC1122);

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  // ─────────────────────────────────────────────
  //  CHARGEMENT
  // ─────────────────────────────────────────────

  Future<void> loadQuestions() async {
    List<dynamic> combined = [];
    for (final fileName in widget.fileNames) {
      final raw = await rootBundle.loadString('assets/$fileName');
      final data = json.decode(raw) as Map<String, dynamic>;
      data.forEach((_, v) { combined.addAll(v as List<dynamic>); });
    }
    final Map<int, dynamic> unique = {};
    for (final q in combined) { unique[q['id'] as int] = q; }
    final list = unique.values.toList()..shuffle();

    setState(() {
      questions = list.take(10).toList();
      _shuffleOptions();
    });
  }

  void _shuffleOptions() {
    if (questions.isEmpty) return;
    _shuffledOptions =
        List<String>.from(questions[currentQuestionIndex]['options'])..shuffle();
  }

  // ─────────────────────────────────────────────
  //  LOGIQUE DE RÉPONSE
  // ─────────────────────────────────────────────

  bool get _isModuleB => widget.fileNames
      .any((n) => n.startsWith('questions_module_b_'));

  bool get _isMultipleChoice =>
      _isModuleB ||
      (questions.isNotEmpty &&
          questions[currentQuestionIndex]['correctAnswer'] is List &&
          (questions[currentQuestionIndex]['correctAnswer'] as List).length > 1);

  List<String> get _correctAnswers {
    final ca = questions[currentQuestionIndex]['correctAnswer'];
    if (ca is List) return List<String>.from(ca);
    return [ca.toString()];
  }

  void _onSingleTap(String option) {
    if (_answered) return;
    final correct = _correctAnswers.contains(option);
    setState(() {
      _answered = true;
      _singleTapped = option;
      _lastWasCorrect = correct;
      if (correct) score++;
    });
  }

  void _onValidateMultiple() {
    if (_answered || _selectedOptions.isEmpty) return;
    final correct = _selectedOptions.length == _correctAnswers.length &&
        _selectedOptions.containsAll(_correctAnswers);
    setState(() {
      _answered = true;
      _lastWasCorrect = correct;
      if (correct) score++;
    });
  }

  void _next() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _answered = false;
        _singleTapped = null;
        _selectedOptions.clear();
        _shuffleOptions();
      });
    } else {
      setState(() {
        isGameOver = true;
      });
    }
  }

  // ─────────────────────────────────────────────
  //  COULEUR D'UNE OPTION
  // ─────────────────────────────────────────────

  Color _optionColor(String option) {
    if (!_answered) return Colors.white;
    final isCorrect = _correctAnswers.contains(option);
    final isSelected = _isMultipleChoice
        ? _selectedOptions.contains(option)
        : option == _singleTapped;
    if (isCorrect) return _correct.withOpacity(0.12);
    if (isSelected && !isCorrect) return _wrong.withOpacity(0.1);
    return Colors.white;
  }

  Color _optionBorderColor(String option) {
    if (!_answered) return Colors.grey.shade200;
    final isCorrect = _correctAnswers.contains(option);
    final isSelected = _isMultipleChoice
        ? _selectedOptions.contains(option)
        : option == _singleTapped;
    if (isCorrect) return _correct;
    if (isSelected && !isCorrect) return _wrong;
    return Colors.grey.shade200;
  }

  IconData? _optionTrailingIcon(String option) {
    if (!_answered) return null;
    if (_correctAnswers.contains(option)) return Icons.check_circle_rounded;
    if (_isMultipleChoice
        ? _selectedOptions.contains(option)
        : option == _singleTapped) return Icons.cancel_rounded;
    return null;
  }

  Color _optionIconColor(String option) {
    if (_correctAnswers.contains(option)) return _correct;
    return _wrong;
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (isGameOver) return _buildResultScreen(context);
    if (questions.isEmpty) return _buildLoading();
    return _buildQuizScreen(context);
  }

  // ── Chargement ──
  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  // ── Écran quiz ──
  Widget _buildQuizScreen(BuildContext context) {
    final q = questions[currentQuestionIndex];
    final total = questions.length;
    final progress = (currentQuestionIndex + 1) / total;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar custom ──
            Container(
              color: _navy,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white70, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${currentQuestionIndex + 1}/$total',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Score : $score',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            backgroundColor: Colors.white12,
                            color: const Color(0xFFCC1122),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Question ──
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: _navy,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _navy.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isMultipleChoice)
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCC1122).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'PLUSIEURS RÉPONSES POSSIBLES',
                                style: TextStyle(
                                  color: Color(0xFFCC1122),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          if (q['image'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(q['image'] as String),
                              ),
                            ),
                          Text(
                            q['question'] as String,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Options ──
                    ..._shuffledOptions.map((option) =>
                        _isMultipleChoice
                            ? _buildCheckOption(option)
                            : _buildSingleOption(option)),

                    const SizedBox(height: 12),

                    // ── Feedback inline ──
                    if (_answered) _buildFeedback(),

                    const SizedBox(height: 12),

                    // ── Bouton Valider (multiple) ──
                    if (_isMultipleChoice && !_answered)
                      _buildValidateButton(),

                    // ── Bouton Suivant ──
                    if (_answered) _buildNextButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleOption(String option) {
    final trailingIcon = _optionTrailingIcon(option);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        elevation: _answered ? 0 : 2,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: _answered ? null : () => _onSingleTap(option),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            decoration: BoxDecoration(
              color: _optionColor(option),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _optionBorderColor(option),
                width: _answered && _correctAnswers.contains(option) ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _answered && _correctAnswers.contains(option)
                          ? _correct
                          : _answered && option == _singleTapped
                              ? _wrong
                              : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                if (trailingIcon != null)
                  Icon(trailingIcon,
                      color: _optionIconColor(option), size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckOption(String option) {
    final isChecked = _selectedOptions.contains(option);
    final trailingIcon = _optionTrailingIcon(option);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        elevation: _answered ? 0 : 2,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: _answered
              ? null
              : () => setState(() {
                    if (isChecked) {
                      _selectedOptions.remove(option);
                    } else {
                      _selectedOptions.add(option);
                    }
                  }),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: _answered
                  ? _optionColor(option)
                  : isChecked
                      ? const Color(0xFF1565C0).withOpacity(0.08)
                      : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _answered
                    ? _optionBorderColor(option)
                    : isChecked
                        ? const Color(0xFF1565C0)
                        : Colors.grey.shade200,
                width: isChecked || _answered ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Checkbox custom
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _answered
                        ? (_correctAnswers.contains(option)
                            ? _correct
                            : isChecked
                                ? _wrong
                                : Colors.grey.shade300)
                        : isChecked
                            ? const Color(0xFF1565C0)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _answered
                          ? Colors.transparent
                          : isChecked
                              ? const Color(0xFF1565C0)
                              : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isChecked || (_answered && _correctAnswers.contains(option))
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _answered && _correctAnswers.contains(option)
                          ? _correct
                          : _answered && isChecked && !_correctAnswers.contains(option)
                              ? _wrong
                              : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                if (trailingIcon != null)
                  Icon(trailingIcon,
                      color: _optionIconColor(option), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: _lastWasCorrect
            ? _correct.withOpacity(0.1)
            : _wrong.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _lastWasCorrect ? _correct : _wrong,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _lastWasCorrect
                ? Icons.check_circle_rounded
                : Icons.info_rounded,
            color: _lastWasCorrect ? _correct : _wrong,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _lastWasCorrect ? 'Bonne réponse !' : 'Mauvaise réponse',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: _lastWasCorrect ? _correct : _wrong,
                  ),
                ),
                if (!_lastWasCorrect) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Réponse(s) correcte(s) : ${_correctAnswers.join(' · ')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: _wrong.withOpacity(0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _selectedOptions.isEmpty ? null : _onValidateMultiple,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1565C0),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              'Valider${_selectedOptions.isNotEmpty ? ' (${_selectedOptions.length} sélectionné${_selectedOptions.length > 1 ? 's' : ''})' : ''}',
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLast = currentQuestionIndex == questions.length - 1;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _next,
        style: ElevatedButton.styleFrom(
          backgroundColor: _navy,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLast ? 'Voir les résultats' : 'Question suivante',
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Icon(
              isLast ? Icons.bar_chart_rounded : Icons.arrow_forward_rounded,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  ÉCRAN RÉSULTATS
  // ─────────────────────────────────────────────

  Widget _buildResultScreen(BuildContext context) {
    final percent = score / questions.length;
    final medal = percent >= 0.8
        ? (icon: Icons.emoji_events_rounded, color: const Color(0xFFFFD700), label: 'Excellent !')
        : percent >= 0.6
            ? (icon: Icons.workspace_premium_rounded, color: const Color(0xFFB0BEC5), label: 'Bien !')
            : (icon: Icons.replay_rounded, color: const Color(0xFFCC1122), label: 'À retravailler');

    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Médaille
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: medal.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: medal.color.withOpacity(0.6), width: 3),
                ),
                child: Icon(medal.icon, size: 48, color: medal.color),
              ),
              const SizedBox(height: 20),
              Text(
                medal.label,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: medal.color,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.belt,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 32),

              // Score cercle
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      medal.color.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                  border: Border.all(
                      color: medal.color.withOpacity(0.4), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: medal.color,
                      ),
                    ),
                    Text(
                      '/ ${questions.length}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Barre de score
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 10,
                  backgroundColor: Colors.white12,
                  color: medal.color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(percent * 100).round()} % de réussite',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 40),

              // Boutons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HomeScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC1122),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Retour à l'accueil",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentQuestionIndex = 0;
                      score = 0;
                      isGameOver = false;
                      _answered = false;
                      _singleTapped = null;
                      _selectedOptions.clear();
                      loadQuestions();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Recommencer',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
