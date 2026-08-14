@IsTest
private class SecurityAlertTriggerTest {

    @IsTest
    static void testCriticalSeverity() {

        Security_Alert__c alert = new Security_Alert__c(
            Threat_Type__c = 'DDoS',
            Source_IP__c = '192.168.1.40',
            Risk_Score__c = 90,
            Description__c = 'Critical test',
            Status__c = 'New'
        );

        Test.startTest();

        insert alert;

        Test.stopTest();

        Security_Alert__c savedAlert = [
            SELECT Id, Risk_Score__c, Severity__c
            FROM Security_Alert__c
            WHERE Id = :alert.Id
        ];

        System.assertEquals(
            90,
            savedAlert.Risk_Score__c
        );

        System.assertEquals(
            'CRITICAL',
            savedAlert.Severity__c
        );
    }
}