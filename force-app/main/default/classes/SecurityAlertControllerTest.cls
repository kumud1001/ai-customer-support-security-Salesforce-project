@IsTest
private class SecurityAlertControllerTest {

    @TestSetup
    static void setupData() {
        Security_Alert__c alert = new Security_Alert__c(
            Threat_Type__c = 'AI_ANOMALY',
            Severity__c = 'HIGH',
            Source_IP__c = '192.168.1.100',
            Risk_Score__c = 85,
            Description__c = 'Suspicious activity detected',
            Status__c = 'New',
            Detected_At__c = System.now(),
            AI_Recommendation__c = 'Investigate the source IP'
        );

        insert alert;
    }

    @IsTest
    static void testGetSecurityAlerts() {

        Test.startTest();

        List<Security_Alert__c> alerts =
            SecurityAlertController.getSecurityAlerts();

        Test.stopTest();

        System.assertEquals(1, alerts.size());
        System.assertEquals('HIGH', alerts[0].Severity__c);
        System.assertEquals('AI_ANOMALY', alerts[0].Threat_Type__c);
    }

    @IsTest
    static void testCreateSecurityAlert() {

        Test.startTest();

        Security_Alert__c alert =
            SecurityAlertController.createSecurityAlert(
                'PORT_SCAN',
                'CRITICAL',
                '10.10.10.5',
                95,
                'Multiple ports scanned',
                'Block the source IP'
            );

        Test.stopTest();

        System.assertNotEquals(null, alert.Id);
        System.assertEquals('PORT_SCAN', alert.Threat_Type__c);
        System.assertEquals('CRITICAL', alert.Severity__c);
        System.assertEquals('New', alert.Status__c);
    }

    @IsTest
    static void testUpdateAlertStatus() {

        Security_Alert__c alert = [
            SELECT Id, Status__c
            FROM Security_Alert__c
            LIMIT 1
        ];

        Test.startTest();

        Security_Alert__c updatedAlert =
            SecurityAlertController.updateAlertStatus(
                alert.Id,
                'Investigating'
            );

        Test.stopTest();

        System.assertEquals(
            'Investigating',
            updatedAlert.Status__c
        );
    }
}