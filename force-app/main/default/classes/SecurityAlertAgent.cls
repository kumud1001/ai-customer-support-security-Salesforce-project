
public with sharing class SecurityAlertAgent {

    public class TriageResult {
        @AuraEnabled public String priority;
        @AuraEnabled public String classification;
        @AuraEnabled public String recommendation;
        @AuraEnabled public String nextAction;
        @AuraEnabled public String updatedStatus;
        @AuraEnabled public Boolean taskCreated;
        @AuraEnabled public String taskMessage;
    }

    @AuraEnabled
    public static TriageResult triageAlert(Id alertId) {

        Security_Alert__c alert = [
            SELECT Id,
                   Name,
                   Threat_Type__c,
                   Severity__c,
                   Source_IP__c,
                   Risk_Score__c,
                   Description__c,
                   Status__c,
                   AI_Recommendation__c
            FROM Security_Alert__c
            WHERE Id = :alertId
            LIMIT 1
        ];

        TriageResult result = new TriageResult();
        result.taskCreated = false;
        result.taskMessage = 'No task required.';

        // =========================================
        // AI DECISION ENGINE
        // =========================================

        if (alert.Risk_Score__c >= 80) {

            result.priority = 'CRITICAL';
            result.classification = 'High Risk Threat';
            result.recommendation =
                'Immediately investigate the source IP and review related security events.';
            result.nextAction =
                'Escalate to security analyst';
            result.updatedStatus = 'Investigating';

        } else if (alert.Risk_Score__c >= 60) {

            result.priority = 'HIGH';
            result.classification = 'Suspicious Activity';
            result.recommendation =
                'Investigate the alert and check for repeated activity from the source IP.';
            result.nextAction =
                'Start investigation';
            result.updatedStatus = 'Investigating';

        } else if (alert.Risk_Score__c >= 30) {

            result.priority = 'MEDIUM';
            result.classification = 'Potential Threat';
            result.recommendation =
                'Monitor the source and review additional security events.';
            result.nextAction =
                'Monitor alert';
            result.updatedStatus = 'New';

        } else {

            result.priority = 'LOW';
            result.classification = 'Low Risk Activity';
            result.recommendation =
                'Continue monitoring. No immediate response required.';
            result.nextAction =
                'Continue monitoring';
            result.updatedStatus = 'New';
        }

        // =========================================
        // UPDATE SECURITY ALERT
        // =========================================

        alert.Status__c = result.updatedStatus;
        alert.AI_Recommendation__c = result.recommendation;

        update alert;

        // =========================================
        // AUTONOMOUS TASK CREATION
        // =========================================

        if (result.priority == 'CRITICAL' ||
            result.priority == 'HIGH') {

            Task investigationTask = new Task();

            investigationTask.Subject =
                'AI Security Investigation - ' + alert.Name;

            investigationTask.Description =
                'AI Agent Security Analysis\n\n' +
                'Alert: ' + alert.Name + '\n' +
                'Priority: ' + result.priority + '\n' +
                'Classification: ' + result.classification + '\n' +
                'Threat Type: ' + alert.Threat_Type__c + '\n' +
                'Source IP: ' + alert.Source_IP__c + '\n' +
                'Risk Score: ' + String.valueOf(alert.Risk_Score__c) + '\n\n' +
                'Recommendation:\n' +
                result.recommendation + '\n\n' +
                'Next Action:\n' +
                result.nextAction;

            investigationTask.Status = 'Not Started';
            investigationTask.Priority =
                result.priority == 'CRITICAL' ? 'High' : 'Normal';

            insert investigationTask;

            result.taskCreated = true;
            result.taskMessage =
                'Investigation Task created successfully.';
        }

        return result;
    }
}
