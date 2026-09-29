trigger PortfolioContactTrigger on Portfolio_Contact__c (after insert) {
    PortfolioContactEmailHandler.sendNewContactNotification(Trigger.new);
}
