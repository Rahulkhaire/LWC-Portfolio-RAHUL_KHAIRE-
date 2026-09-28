@IsTest
private class PortfolioController_Test {
    @TestSetup static void setupUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(Alias = 'porttest', Email = 'portfolio.test@example.com', EmailEncodingKey = 'UTF-8',
            LastName = 'Portfolio Test', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'portfolio.test.' + DateTime.now().getTime() + '@example.com');
        insert u;
        PermissionSet access = [SELECT Id FROM PermissionSet WHERE Name = 'Portfolio_Access' LIMIT 1];
        insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = access.Id);
    }

    private static User portfolioUser() {
        return [SELECT Id FROM User WHERE Alias = 'porttest' LIMIT 1];
    }

    @IsTest static void contentGetters() {
        Map<String, Object> d = PortfolioController.getPortfolioData();
        System.assertEquals(6, d.size());
        System.assertEquals(3, PortfolioController.getProjects().size());
        System.assertEquals(6, PortfolioController.getCertifications().size());
        System.assertEquals(2, PortfolioController.getExperience().size());
        System.assertEquals(3, PortfolioController.getEducation().size());
        System.assertEquals(6, PortfolioController.getSkills().size());
        System.assertEquals(210, PortfolioController.getAchievements().get('badges'));
    }
    @IsTest static void submitValid() {
        System.runAs(portfolioUser()) {
            PortfolioController.submitContact(' Test ', ' a@b.com ', ' 123 ', ' Hi ', ' Hello ');
        }
        List<Portfolio_Contact__c> r = [SELECT Name__c, Email__c, Phone__c, Subject__c, Message__c, Status__c, Created_Date__c FROM Portfolio_Contact__c];
        System.assertEquals(1, r.size());
        System.assertEquals('Test', r[0].Name__c);
        System.assertEquals('a@b.com', r[0].Email__c);
        System.assertEquals('123', r[0].Phone__c);
        System.assertEquals('Hi', r[0].Subject__c);
        System.assertEquals('Hello', r[0].Message__c);
        System.assertEquals('New', r[0].Status__c);
        System.assertNotEquals(null, r[0].Created_Date__c);
    }
    @IsTest static void submitInvalid() {
        try {
            System.runAs(portfolioUser()) {
                PortfolioController.submitContact('', 'bad', null, '', '');
            }
            System.assert(false, 'Expected exception');
        } catch (AuraHandledException e) {
            System.assertEquals(0, [SELECT COUNT() FROM Portfolio_Contact__c]);
        }
    }
    @IsTest static void submitRejectsOverlongEmail() {
        String email = 'a'.leftPad(70, 'a') + '@example.com';
        try {
            System.runAs(portfolioUser()) {
                PortfolioController.submitContact('Test', email, null, 'Hi', 'Hello');
            }
            System.assert(false, 'Expected exception for an email longer than the field limit');
        } catch (AuraHandledException e) {
            System.assertEquals(0, [SELECT COUNT() FROM Portfolio_Contact__c]);
        }
    }
}
