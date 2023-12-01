import 'package:fhir/r4.dart';
import 'package:shelf/shelf.dart';

import '../../../../watch_fhir.dart';

Future<Response> postTask(Task task, List<String> path) async {
  if (task.status == FhirCode('on-hold')) {
    final int? outputIndex = task.output?.indexWhere((element) =>
        element.type.coding
            ?.indexWhere((e) => e.code.toString() == '90897-0') !=
        -1);
    if (outputIndex != null && outputIndex != -1) {
      final int? valueInteger = task.output![outputIndex].valueInteger?.value;
      if (valueInteger != null && valueInteger == 100) {
        return scoreTask(task, path);
      } else {
        return printResponseFirst(
            'Task ${task.fhirId} is on hold and $valueInteger% complete.');
      }
    } else {
      return printResponseFirst(
          'Task ${task.fhirId} does not list Percent of task completed.');
    }
  } else if (task.status == FhirCode('completed')) {
    return printResponseFirst('Task ${task.fhirId} is complete.');
  } else {
    return Response.ok('');

    /// Normally we would probably call
    /// return taskCommunication(task, path);
  }
}
