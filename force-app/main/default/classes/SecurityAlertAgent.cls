public with sharing class SecurityAlertAgent {

    public class TriageResult {
        @AuraEnabled public String priority;
        @AuraEnabled public String classification;
        @AuraEnabled public String recommendation;
        @AuraEnabled public String nextAction;
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

        // Agent decision logic
        if (alert.Risk_Score__c >= 80) {

            result.priority = 'CRITICAL';
            result.classification = 'High Risk Threat';

            result.recommendation =
                'Immediately investigate the source IP and review related security events.';

            result.nextAction =
                'Escalate to security analyst';

        } else if (alert.Risk_Score__c >= 60) {

            result.priority = 'HIGH';
            result.classification = 'Suspicious Activity';

            result.recommendation =
                'Investigate the alert and check for repeated activity from the source IP.';

            result.nextAction =
                'Start investigation';

        } else if (alert.Risk_Score__c >= 30) {

            result.priority = 'MEDIUM';
            result.classification = 'Potential Threat';

            result.recommendation =
                'Monitor the source and review additional security events.';

            result.nextAction =
                'Monitor alert';

        } else {

            result.priority = 'LOW';
            result.classification = 'Low Risk Activity';

            result.recommendation =
                'Continue monitoring. No immediate response required.';

            result.nextAction =
                'Continue monitoring';
        }

        return result;
    }
}