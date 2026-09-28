/**
 * Backend for the Rahul Khaire portfolio LWC.
 * Content getters are cacheable; contact submission is the only DML path.
 */
public with sharing class PortfolioController {

    public class PortfolioException extends Exception {}

    private static final String GITHUB = 'https://github.com/Rahulkhaire';

    // ---------- Read APIs ----------
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getPortfolioData() {
        return new Map<String, Object>{
            'projects' => getProjects(), 'skills' => getSkills(),
            'experience' => getExperience(), 'certifications' => getCertifications(),
            'education' => getEducation(), 'achievements' => getAchievements()
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getProjects() {
        return new List<Map<String, Object>>{
            proj('p1', 'Customer Support & Case Management System', 'Service Cloud', '🎧',
                'Designed and developed an automated customer support platform featuring intelligent case routing, SLA monitoring, escalation workflows, and performance dashboards.',
                'Implemented Apex triggers, Record-Triggered Flows, and custom LWCs to optimize case resolution and enhance agent productivity.',
                new List<String>{'Salesforce Service Cloud','Apex','LWC','Flow','Reports & Dashboards'},
                new List<String>{'Intelligent Case Routing','SLA Monitoring','Escalation','Automation','Dashboard','LWC','Apex'}),
            proj('p2', 'Sales Pipeline & Lead Management System', 'Sales Cloud', '📈',
                'Scalable lead-to-opportunity lifecycle solution with automated lead assignment, opportunity tracking, approval workflows and sales forecasting.',
                'Leveraged Apex, LWC and Salesforce automation tools to streamline sales operations and improve conversion tracking.',
                new List<String>{'Sales Cloud','Apex','LWC','Flow','Approval Processes','Reports & Dashboards'},
                new List<String>{'Lead Management','Opportunity Tracking','Automated Assignment','Approval Workflow','Sales Forecasting','Conversion Tracking'}),
            proj('p3', 'WhatsApp Customer Support Integration', 'Integration', '💬',
                'Integrated Salesforce with WhatsApp Cloud API to enable real-time customer engagement, automated case creation, and conversation management.',
                'Developed Apex REST callouts, asynchronous processing and custom LWCs for seamless communication between customers and support teams.',
                new List<String>{'Salesforce','Apex REST API','LWC','Queueable Apex','Scheduled Apex','WhatsApp Cloud API'},
                new List<String>{'Real-time Messaging','Automatic Case Creation','Customer Conversations','Apex REST Callouts','Async Processing'})
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getSkills() {
        return new List<Map<String, Object>>{
            cat('Salesforce Development', '⚡', new List<String>{'Apex','Triggers','LWC','SOQL','SOSL','Flow Builder','Batch Apex','Queueable Apex','Scheduled Apex','Validation Rules','Approval Processes'}),
            cat('Administration', '🛡️', new List<String>{'User Management','Profiles','Roles','Permission Sets','Security & Sharing','Reports','Dashboards','Data Modeling'}),
            cat('Integration & AI', '🤖', new List<String>{'REST API','Named Credentials','Agentforce','Salesforce AI','Business Process Automation','Data Loader','Workbench'}),
            cat('Tools & DevOps', '🧰', new List<String>{'VS Code','Git','GitHub','Copado','Jenkins','Change Sets','Postman'}),
            cat('Programming', '💻', new List<String>{'Apex','Java','Python','JavaScript','HTML','CSS'}),
            cat('Clouds', '☁️', new List<String>{'Sales Cloud','Service Cloud','Experience Cloud'})
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getExperience() {
        return new List<Map<String, Object>>{
            new Map<String, Object>{'id'=>'e1','role'=>'Salesforce AI Intern','company'=>'Pinnacle Technology','period'=>'Jan 2026 – May 2026',
                'points'=>new List<String>{'Built Salesforce AI and automation solutions using Agentforce AI agents','Developed AI agents to automate workflows and improve process efficiency','Supported requirement analysis, testing and deployment','Worked with Salesforce Admin tools, Apex and LWC'}},
            new Map<String, Object>{'id'=>'e2','role'=>'Salesforce Intern','company'=>'Cendance Systems Inc.','period'=>'Feb 2025 – Jun 2025',
                'points'=>new List<String>{'Supported Salesforce CRM implementation and optimization','Assisted in requirement analysis, automation and workflow improvements','Collaborated with cross-functional teams in a virtual environment'}}
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getCertifications() {
        // Dates and credential URLs are intentionally blank until real values are added.
        List<Map<String, Object>> out = new List<Map<String, Object>>();
        for (List<String> c : new List<List<String>>{
            new List<String>{'Salesforce AI Associate Certification','Salesforce'},
            new List<String>{'Copado AI Certification','Copado'},
            new List<String>{'Copado Robotic Testing Certification','Copado'},
            new List<String>{'GitHub Foundation Certification','GitHub'},
            new List<String>{'Oracle Cloud AI Foundations','Oracle'},
            new List<String>{'Postman API Student Expert','Postman'}}) {
            out.add(new Map<String, Object>{'id'=>c[0],'name'=>c[0],'issuer'=>c[1],'date'=>'','url'=>''});
        }
        return out;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getEducation() {
        return new List<Map<String, Object>>{
            new Map<String, Object>{'id'=>'d1','school'=>'Maharashtra Institute of Technology, Aurangabad','degree'=>'B.Tech – Artificial Intelligence and Data Science','period'=>'2022 – 2026','score'=>'CGPA: 7.10'},
            new Map<String, Object>{'id'=>'d2','school'=>'Shiveswar Vidyalay, Aurangabad','degree'=>'HSC','period'=>'2021 – 2022','score'=>'86.40%'},
            new Map<String, Object>{'id'=>'d3','school'=>'Nageswar Vidhyalay, Aurangabad','degree'=>'SSC','period'=>'2019 – 2020','score'=>'89.20%'}
        };
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAchievements() {
        return new Map<String, Object>{
            'badges'=>210,'superbadges'=>6,'points'=>101500,'trails'=>18,
            'ranks'=>new List<String>{'Agentblazer Innovator 2025','Agentblazer Champion 2026','Postman API Student Expert'}
        };
    }

    // ---------- Write API ----------
    @AuraEnabled
    public static void submitContact(String name, String email, String phone, String subject, String message) {
        if (String.isBlank(name) || String.isBlank(subject) || String.isBlank(message) || !isValidEmail(email) || email.trim().length() > 80) {
            throw new AuraHandledException('Please enter a valid email and complete the required contact fields.');
        }
        if (!canCreateContact()) {
            throw new AuraHandledException(Label.Portfolio_Contact_Access_Error);
        }
        try {
            Portfolio_Contact__c rec = new Portfolio_Contact__c(
                Name__c = name.trim().left(120), Email__c = email.trim(),
                Phone__c = phone?.trim().left(30), Subject__c = subject.trim().left(150),
                Message__c = message.trim().left(5000), Status__c = 'New', Created_Date__c = System.now());
            SObjectAccessDecision d = Security.stripInaccessible(AccessType.CREATABLE, new List<Portfolio_Contact__c>{rec});
            Set<String> removedFields = d.getRemovedFields().get('Portfolio_Contact__c');
            if (removedFields != null && (removedFields.contains('Name__c') || removedFields.contains('Email__c') ||
                removedFields.contains('Subject__c') || removedFields.contains('Message__c'))) {
                throw new AuraHandledException(Label.Portfolio_Contact_Access_Error);
            }
            insert as user d.getRecords();
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'submitContact failed: ' + e.getMessage());
            throw new AuraHandledException(Label.Portfolio_Contact_Error);
        }
    }

    // ---------- Helpers ----------
    private static Boolean canCreateContact() {
        return Schema.sObjectType.Portfolio_Contact__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Name__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Email__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Phone__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Subject__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Message__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Status__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Created_Date__c.isCreateable();
    }

    private static Boolean isValidEmail(String e) {
        return String.isNotBlank(e) && Pattern.matches('^[A-Za-z0-9._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,}$', e.trim());
    }
    private static Map<String, Object> proj(String id, String title, String type, String icon, String projectSummary, String detail, List<String> tech, List<String> feats) {
        return new Map<String, Object>{'id'=>id,'title'=>title,'type'=>type,'icon'=>icon,'description'=>projectSummary,'details'=>detail,
            'technologies'=>tech,'features'=>feats,'githubUrl'=>GITHUB,'demoUrl'=>''};
    }
    private static Map<String, Object> cat(String name, String icon, List<String> items) {
        return new Map<String, Object>{'category'=>name,'icon'=>icon,'items'=>items};
    }
}
