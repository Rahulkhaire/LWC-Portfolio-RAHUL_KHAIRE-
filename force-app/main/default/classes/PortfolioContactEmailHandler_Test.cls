@IsTest
private class PortfolioContactEmailHandler_Test {
    @IsTest static void sendsOneEmailContainingAllBulkContactDetails() {
        List<Portfolio_Contact__c> contacts = new List<Portfolio_Contact__c>{
            new Portfolio_Contact__c(Name__c = 'Taylor One', Email__c = 'taylor@example.com', Phone__c = '555-0101',
                Subject__c = 'Project question', Message__c = 'Please share more details.', Status__c = 'New', Created_Date__c = System.now()),
            new Portfolio_Contact__c(Name__c = 'Jordan Two', Email__c = 'jordan@example.com', Phone__c = '555-0102',
                Subject__c = 'Work inquiry', Message__c = 'I would like to discuss an opportunity.', Status__c = 'New', Created_Date__c = System.now())
        };

        Test.startTest();
        Integer emailInvocationsBefore = Limits.getEmailInvocations();
        insert contacts;
        System.assertEquals(emailInvocationsBefore + 1, Limits.getEmailInvocations(),
            'The bulk insert should send one consolidated email.');
        Test.stopTest();

        String body = PortfolioContactEmailHandler.buildEmailBody(contacts);
        System.assert(body.contains('Taylor One'));
        System.assert(body.contains('taylor@example.com'));
        System.assert(body.contains('555-0101'));
        System.assert(body.contains('Project question'));
        System.assert(body.contains('Please share more details.'));
        System.assert(body.contains('Jordan Two'));
        System.assert(body.contains('jordan@example.com'));
        System.assert(body.contains('Work inquiry'));
        System.assert(body.contains('I would like to discuss an opportunity.'));
    }
}
