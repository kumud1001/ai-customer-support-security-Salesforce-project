public with sharing class SecurityAlertController {

    @AuraEnabled
    public static Id createSecurityAlert(
        String threatType,
        String severity,
        String sourceIp,
        Decimal riskScore,
        String description,
        String recommendation
    ) {
        Security_Alert__c alert = new Security_Alert__c();

        alert.Threat_Type__c = threatType;
        alert.Severity__c = severity;
        alert.Source_IP__c = sourceIp;
        alert.Risk_Score__c = riskScore;
        alert.Description__c = description;
        alert.AI_Recommendation__c = recommendation;

        alert.Status__c = 'New';
        alert.Detected_At__c = System.now();

        insert alert;

        return alert.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<Security_Alert__c> getSecurityAlerts() {

        return [
            SELECT Id,
                   Name,
                   Threat_Type__c,
                   Severity__c,
                   Source_IP__c,
                   Risk_Score__c,
                   Description__c,
                   Status__c,
                   Detected_At__c,
                   AI_Recommendation__c
            FROM Security_Alert__c
            ORDER BY Detected_At__c DESC
            LIMIT 100
        ];
    }

    @AuraEnabled
    public static Security_Alert__c updateAlertStatus(
        Id alertId,
        String newStatus
    ) {

        Security_Alert__c alert = [
            SELECT Id, Status__c
            FROM Security_Alert__c
            WHERE Id = :alertId
            LIMIT 1
        ];

        alert.Status__c = newStatus;

        update alert;

        return alert;
    }
}