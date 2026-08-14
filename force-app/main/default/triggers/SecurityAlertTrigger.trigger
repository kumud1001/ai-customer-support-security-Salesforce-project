trigger SecurityAlertTrigger on Security_Alert__c (
    before insert,
    before update
) {

    for (Security_Alert__c alert : Trigger.new) {

        if (alert.Risk_Score__c == null) {
            continue;
        }

        if (alert.Risk_Score__c <= 24) {
            alert.Severity__c = 'LOW';

        } else if (alert.Risk_Score__c <= 49) {
            alert.Severity__c = 'MEDIUM';

        } else if (alert.Risk_Score__c <= 74) {
            alert.Severity__c = 'HIGH';

        } else {
            alert.Severity__c = 'CRITICAL';
        }
    }
}