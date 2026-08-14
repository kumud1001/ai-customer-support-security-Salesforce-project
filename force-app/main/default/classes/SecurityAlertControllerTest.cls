@IsTest
private class SecurityAlertControllerTest {

    @IsTest
    static void testGetSecurityAlerts() {

        Security_Alert__c alert = new Security_Alert__c(
            Threat_Type__c = 'Brute Force',
            Source_IP__c = '192.168.1.10',
            Risk_Score__c = 85,
            Description__c = 'Test security alert',
            Status__c = 'New'
        );

        insert alert;

        Test.startTest();

        List<Security_Alert__c> results =
            SecurityAlertController.getSecurityAlerts();

        Test.stopTest();

        System.assert(
            results.size() > 0,
            'Security alert should be returned'
        );
    }


    @IsTest
    static void testCreateSecurityAlert() {

        Test.startTest();

        Security_Alert__c alert =
            SecurityAlertController.createSecurityAlert(
                'Brute Force',
                'LOW',
                '192.168.1.20',
                85,
                'Multiple failed login attempts',
                'Block source IP and enable MFA'
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            alert.Id
        );

        System.assertEquals(
            'CRITICAL',
            alert.Severity__c
        );

        System.assertEquals(
            'New',
            alert.Status__c
        );
    }


    @IsTest
    static void testUpdateAlertStatus() {

        Security_Alert__c alert = new Security_Alert__c(
            Threat_Type__c = 'Port Scan',
            Source_IP__c = '192.168.1.30',
            Risk_Score__c = 70,
            Description__c = 'Port scanning detected',
            Status__c = 'New'
        );

        insert alert;

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