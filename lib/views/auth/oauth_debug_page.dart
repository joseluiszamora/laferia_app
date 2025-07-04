import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laferia/core/services/auth_service.dart';

class OAuthDebugPage extends StatefulWidget {
  const OAuthDebugPage({super.key});

  @override
  State<OAuthDebugPage> createState() => _OAuthDebugPageState();
}

class _OAuthDebugPageState extends State<OAuthDebugPage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _diagnosisResult;
  Map<String, dynamic>? _debugInfo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runDiagnosis();
  }

  Future<void> _runDiagnosis() async {
    setState(() => _isLoading = true);

    try {
      final diagnosis = await _authService.diagnoseOAuthIssues();
      final debugInfo = _authService.getDebugInfo();

      setState(() {
        _diagnosisResult = diagnosis;
        _debugInfo = debugInfo;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en diagnosis: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis OAuth'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _runDiagnosis, icon: const Icon(Icons.refresh)),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusCard(),
                    const SizedBox(height: 16),
                    _buildDebugInfoCard(),
                    const SizedBox(height: 16),
                    _buildDiagnosisCard(),
                    const SizedBox(height: 16),
                    _buildRecommendationsCard(),
                    const SizedBox(height: 16),
                    _buildActionsCard(),
                  ],
                ),
              ),
    );
  }

  Widget _buildStatusCard() {
    final isAuthenticated = _debugInfo?['is_authenticated'] ?? false;
    final isConfigured = _diagnosisResult?['supabase_configured'] ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStatusRow('Autenticado', isAuthenticated),
            _buildStatusRow('Supabase Configurado', isConfigured),
            _buildStatusRow(
              'Usuario Google',
              _debugInfo?['is_google_user'] ?? false,
            ),
            _buildStatusRow(
              'Email Confirmado',
              _debugInfo?['email_confirmed'] ?? false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            color: status ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildDebugInfoCard() {
    if (_debugInfo == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Información de Debug',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _copyToClipboard(_debugInfo.toString()),
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._debugInfo!.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '${entry.key}: ${entry.value?.toString() ?? 'null'}',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard() {
    if (_diagnosisResult == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultado de Diagnosis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Estado Auth: ${_diagnosisResult!['auth_state']}'),
            Text('Configurado: ${_diagnosisResult!['supabase_configured']}'),
            if (_diagnosisResult!['error'] != null)
              Text(
                'Error: ${_diagnosisResult!['error']}',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    final recommendations = _diagnosisResult?['recommendations'] as List? ?? [];
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recomendaciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.arrow_right,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(rec.toString())),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones de Prueba',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testGoogleSignIn,
                icon: const Icon(Icons.login),
                label: const Text('Probar Google Sign In'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testGoogleSignInAlternative,
                icon: const Icon(Icons.alt_route),
                label: const Text('Probar Método Alternativo'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openConfigGuide,
                icon: const Icon(Icons.help),
                label: const Text('Ver Guía de Configuración'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Información copiada al portapapeles')),
    );
  }

  Future<void> _testGoogleSignIn() async {
    try {
      final success = await _authService.signInWithGoogle();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Login exitoso' : 'Login cancelado'),
          backgroundColor: success ? Colors.green : Colors.orange,
        ),
      );
      if (success) _runDiagnosis();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testGoogleSignInAlternative() async {
    try {
      final success = await _authService.signInWithGoogleCustomRedirect();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Login alternativo exitoso' : 'Login cancelado',
          ),
          backgroundColor: success ? Colors.green : Colors.orange,
        ),
      );
      if (success) _runDiagnosis();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error alternativo: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openConfigGuide() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Guía de Configuración OAuth'),
            content: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Para configurar Google OAuth:'),
                  SizedBox(height: 8),
                  Text('1. Ve a Google Cloud Console'),
                  Text('2. Crea un proyecto OAuth 2.0'),
                  Text('3. Configura las URLs de redirección'),
                  Text('4. Copia Client ID y Client Secret'),
                  Text('5. Configura en Supabase Dashboard'),
                  SizedBox(height: 12),
                  Text(
                    'Ver CONFIGURACION_GOOGLE_OAUTH.md para detalles completos.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
    );
  }
}
