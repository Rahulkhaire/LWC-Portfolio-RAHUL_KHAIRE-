public without sharing class PortfolioContactEmailHandler {
    private static final String NOTIFICATION_EMAIL = 'rahul.khaire@mit.asia';

    public static void sendNewContactNotification(List<Portfolio_Contact__c> contacts) {
        if (contacts == null || contacts.isEmpty()) return;

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{NOTIFICATION_EMAIL});
        List<OrgWideEmailAddress> senderAddresses = [
            SELECT Id FROM OrgWideEmailAddress WHERE Address = :NOTIFICATION_EMAIL LIMIT 1
        ];
        if (!senderAddresses.isEmpty()) {
            email.setOrgWideEmailAddressId(senderAddresses[0].Id);
        }
        email.setSubject(contacts.size() == 1
            ? 'New portfolio contact submission'
            : 'New portfolio contact submissions (' + contacts.size() + ')');
        email.setPlainTextBody(buildEmailBody(contacts));

        try {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage>{email}, false);
            for (Messaging.SendEmailResult result : results) {
                if (!result.isSuccess()) {
                    for (Messaging.SendEmailError sendError : result.getErrors()) {
                        System.debug(LoggingLevel.ERROR, 'Portfolio notification email failed: ' + sendError.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            // Keep a contact submission successful even if outbound email is unavailable.
            System.debug(LoggingLevel.ERROR, 'Portfolio notification email failed: ' + e.getMessage());
        }
    }

    @TestVisible
    private static String buildEmailBody(List<Portfolio_Contact__c> contacts) {
        List<String> lines = new List<String>{'New message submitted through the portfolio contact form.'};
        for (Portfolio_Contact__c contact : contacts) {
            lines.add('');
            lines.add('----------------------------------------');
            lines.add('Record ID: ' + displayValue(contact.Id));
            lines.add('Name: ' + displayValue(contact.Name__c));
            lines.add('Email: ' + displayValue(contact.Email__c));
            lines.add('Phone: ' + displayValue(contact.Phone__c));
            lines.add('Subject: ' + displayValue(contact.Subject__c));
            lines.add('Message:');
            lines.add(displayValue(contact.Message__c));
            lines.add('Status: ' + displayValue(contact.Status__c));
            lines.add('Submitted: ' + (contact.Created_Date__c == null ? 'Not available' : contact.Created_Date__c.format()));
        }
        return String.join(lines, '\n');
    }

    private static String displayValue(String value) {
        return String.isBlank(value) ? 'Not provided' : value;
    }
}
