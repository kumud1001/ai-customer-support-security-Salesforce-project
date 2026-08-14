public with sharing class SecurityAlertController {

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
public static Security_Alert__c createSecurityAlert(
    String incidentName,
    String threatType,
    String severity,
    String sourceIp,
    Decimal riskScore,
    String attackType,
    String description,
    String recommendation
) {
    if (riskScore == null || riskScore < 0 || riskScore > 100) {
        throw new AuraHandledException(
            'Risk Score must be between 0 and 100.'
        );
    }

    Security_Alert__c alert = new Security_Alert__c();

    // Save incident name
    alert.Name = incidentName;

    // Security information
    alert.Threat_Type__c = threatType;
    alert.Source_IP__c = sourceIp;
    alert.Risk_Score__c = riskScore;

    // Automatically determine severity
    if (riskScore <= 30) {
        alert.Severity__c = 'LOW';
    } else if (riskScore <= 60) {
        alert.Severity__c = 'MEDIUM';
    } else if (riskScore <= 80) {
        alert.Severity__c = 'HIGH';
    } else {
        alert.Severity__c = 'CRITICAL';
    }

    alert.Status__c = 'New';
    alert.Description__c = description;
    alert.AI_Recommendation__c = recommendation;
    alert.Detected_At__c = System.now();

    // IMPORTANT:
    // Only add this if Attack_Type__c exists on your object.
    alert.Attack_Type__c = attackType;

    insert alert;

    return alert;
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