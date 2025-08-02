import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:flutter/material.dart';

class MaterialListView extends StatelessWidget {
  final List<MaterialEntity> materials;
  const MaterialListView({
    super.key,
    required this.materials,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.4, // Adjust as needed
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: materials.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: context.width * 0.05),
        itemBuilder: (context, index) {
          final material = materials[index];
          return Container(
            width: context.width * 0.4,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(
                    material.fileUrl ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: context.height * 0.2,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(context.width * 0.02),
                  child: Text(
                    material.title,
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: context.width * 0.02),
                  child: Text(
                    material.description ?? '',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(context.width * 0.02),
                  child: MaterialButton(
                    onPressed: () {
                      // TODO: navigate to book details screen
                    },
                    color: AppTheme.secondaryColor,
                    child: Text('Lire plus',
                        style: AppTheme.lightTheme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}