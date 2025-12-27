import 'package:flutter/material.dart';
import 'package:kiosk_qms/models/service.dart';
import 'package:kiosk_qms/pages/service_form.dart';

class BlockGridPage extends StatefulWidget {
  final Service service;

  const BlockGridPage({super.key, required this.service});

  @override
  State<BlockGridPage> createState() => _BlockGridPageState();
}

class _BlockGridPageState extends State<BlockGridPage> {
  String _language = 'ENG';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 20,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFC107)),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 22,
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ),
        actions: [
          // ================= TOP BAR =================
          // CENTERED LOGO + TITLE
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 760) {
                  return Image(
                    image: AssetImage('assets/images/tra_logo.jpg'),
                    height: 58,
                    width: 58,
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage('assets/images/tra_logo.jpg'),
                        height: 58,
                        width: 58,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'SELF SERVICE KIOSK',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // LANGUAGE SELECTOR
          Padding(padding: const EdgeInsets.all(8.0), child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(value: 'ENG', child: Text('ENG')),
                  DropdownMenuItem(value: 'SWA', child: Text('SWA')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _language = value);
                  }
                },
              ),
            ),
          ),),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              widget.service.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              _language == 'ENG'
                  ? 'Please choose a service block'
                  : 'Tafadhali chagua kituo cha huduma',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 32),

            // ================= BLOCK GRID =================
            Expanded(
              child: Builder(
                builder: (context) {
                  final filteredBlocks = widget.service.blocks
                      .where((block) => block.name != '-')
                      .toList();
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 280,
                          mainAxisSpacing: 32,
                          crossAxisSpacing: 32,
                          childAspectRatio: 1,
                        ),
                    itemCount: filteredBlocks.length,
                    itemBuilder: (context, index) {
                      final block = filteredBlocks[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceFormPage(
                                service: widget.service,
                                block: block,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFFFE082)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // BLOCK ICON
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4D6),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFFFFE082),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    block.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF92400E),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // BLOCK NAME
                              Text(
                                block.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // ================= FOOTER =================
            Container(
              height: 56,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Text(
                _language == 'ENG'
                    ? 'Touch a block to continue'
                    : 'Gusa kituo kuendelea',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
