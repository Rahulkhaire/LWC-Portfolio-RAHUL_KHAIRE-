/**
 * Backend for the Rahul Khaire portfolio LWC.
 * Content getters are cacheable; contact submission is the only DML path.
 */
public with sharing class PortfolioController {

    public class PortfolioException extends Exception {}

    // ---------- Read APIs ----------
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getPortfolioData() {
        return new Map<String, Object>{
            'projects' => getProjects(), 'skills' => getSkills(),
            'experience' => getExperience(),
            'education' => getEducation(), 'achievements' => getAchievements()
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getProjects() {
        List<Map<String, Object>> projects = new List<Map<String, Object>>{
            proj('p1', 'Smart Medical Inventory & Transfer System', 'Salesforce Solution · Nath Agency', '🏥',
                'Salesforce solution for medical inventory, orders, shipments and surgical instrument distribution.',
                'Uses Salesforce records and automation with payment, mapping, identity and messaging integrations.',
                'Coordinate medical inventory, orders and shipments while keeping operational workflows visible.',
                'Use Salesforce records and automation as the operational hub, with API integrations supporting payment, location, identity and messaging needs.',
                'Individual contribution details were not provided; documented scope includes inventory, orders, shipments, integrations and automated alerts.',
                new List<String>{'Experience Cloud / LWC','Apex / Salesforce','Custom Objects & Automation','Integration Layer','External APIs: Razorpay, Google Maps, IDFY, WhatsApp Cloud API'},
                'Coordinating inventory, orders and shipments alongside multiple external services.',
                'Centralized medical inventory and transfer workflows with integrated notifications and service connections.',
                new List<String>{'Salesforce','Apex','LWC','Flows','REST APIs','Razorpay','Google Maps','IDFY','WhatsApp Cloud API','Platform Events'},
                new List<String>{'Medicine Inventory','Orders & Shipments','Inventory Tracking','API Integrations','Automated Alerts'}),
            proj('p2', 'Sales Pipeline & Lead Management System', 'Sales Cloud', '📈',
                'Scalable lead-to-opportunity lifecycle solution with automated lead assignment, opportunity tracking, approval workflows and sales forecasting.',
                'Leveraged Apex, LWC and Salesforce automation tools to streamline sales operations and improve conversion tracking.',
                'Keep lead assignment, opportunity progress and approval steps coordinated through the sales lifecycle.',
                'Use Sales Cloud records, automation and reporting to support a lead-to-opportunity process.',
                'Project focus: lead and opportunity lifecycle, automated assignment, approvals and forecasting.',
                new List<String>{'Sales Cloud','Apex','LWC','Flow Builder','Approval Processes','Reports & Dashboards'},
                'Keeping pipeline handoffs and approval processes consistent.',
                'A structured sales workflow with pipeline visibility and forecasting.',
                new List<String>{'Sales Cloud','Apex','LWC','Flow','Approval Processes','Reports & Dashboards'},
                new List<String>{'Lead Management','Opportunity Tracking','Automated Assignment','Approval Workflow','Sales Forecasting','Conversion Tracking'}),
            proj('p3', 'Salesforce + WhatsApp Cloud API Customer Support', 'Salesforce Integration', '💬',
                'Customer-support integration connecting Salesforce CRM and WhatsApp Cloud API for messaging and case workflows.',
                'Connects CRM support processes with WhatsApp API communication and asynchronous Salesforce processing.',
                'Connect customer WhatsApp conversations with Salesforce support and case workflows.',
                'Use API communication and Salesforce automation to support customer messaging and case creation.',
                'Documented project scope includes WhatsApp API communication, Apex callouts, asynchronous processing and support workflows.',
                new List<String>{'Salesforce CRM','Apex','REST API','WhatsApp Cloud API','Customer'},
                'Handling customer conversation events and coordinating API responses with Salesforce processing.',
                'A CRM-connected messaging workflow for support conversations and case creation.',
                new List<String>{'Salesforce','Apex REST API','LWC','Queueable Apex','Scheduled Apex','WhatsApp Cloud API'},
                new List<String>{'Customer Messaging','WhatsApp Integration','Case Workflow','Apex REST / Async Processing'}),
            proj('p4', 'Salesforce Career Application System', 'Salesforce Application', '📄',
                'Guided Salesforce career-application experience for applicant details and resume submissions.',
                'Uses a two-step LWC interface with Apex, validation, file upload, progress feedback and resume handling.',
                'Provide applicants a clear, guided flow for submitting career application details and a resume.',
                'Use a two-step LWC form with validation and progress feedback, with Apex-backed processing and Salesforce file handling.',
                'Project scope: reusable application UI, input validation, progress state, feedback notifications and resume handling.',
                new List<String>{'Applicant','LWC Two-step UI','Apex','Validation','File Upload','Resume Handling'},
                'Keeping a multi-step application understandable while validating inputs and handling uploaded resume files.',
                'A guided Salesforce application flow with visible progress and submission feedback.',
                new List<String>{'Salesforce','LWC','Apex','File Upload','Validation','Toast Notifications'},
                new List<String>{'Two-step Form','Progress Indicator','Validation','File Upload & Resume Handling','Toast Notifications'}),
            proj('p5', 'Automated Exploratory Data Analysis Platform', 'Python · Data Analysis', '📊',
                'A Streamlit platform for exploring datasets and presenting data analysis and visualizations.',
                'The user-provided project summary describes an automated exploratory data analysis workflow built with Python, Pandas and Streamlit.',
                'Make dataset exploration and initial analysis accessible through a focused interface.',
                'Use Python and Pandas for analysis and Streamlit for the interactive application and visualizations.',
                'Project focus: exploratory analysis and data visualization; implementation details beyond the supplied summary are not published.',
                new List<String>{'Upload Dataset','Python','Pandas','Analysis','Visualization'},
                'Making a reusable exploration flow for different datasets.',
                'A browser-based workflow for data exploration and visualization.',
                new List<String>{'Python','Pandas','Streamlit','Data Analysis','Visualization'},
                new List<String>{'Dataset Exploration','Data Analysis','Visualizations','Streamlit Interface'}),
            proj('p6', 'Dynamic AutoML Platform', 'Python · Machine Learning', '🧠',
                'A Python-based AutoML platform using Flask, H2O.ai and PyCaret.',
                'The user-provided project summary describes a dynamic machine-learning workflow using Flask with H2O.ai and PyCaret.',
                'Provide an application workflow for experimenting with automated machine-learning tools.',
                'Use Flask as the web application layer with H2O.ai and PyCaret in the machine-learning workflow.',
                'Project focus: AutoML experimentation; specific models, datasets and measured outcomes are not published.',
                new List<String>{'User','Flask Application','H2O.ai','PyCaret','Model Results'},
                'Selecting and comparing model workflows without publishing unsupported performance claims.',
                'A web application demonstrating an AutoML workflow.',
                new List<String>{'Python','Flask','H2O.ai','PyCaret','Machine Learning'},
                new List<String>{'AutoML Workflow','Machine Learning','Flask Application'}),
            proj('p7', 'Movie Recommendation System', 'Python · Machine Learning', '🎬',
                'A Streamlit movie recommendation application using machine learning.',
                'The user-provided project summary identifies Python, Streamlit and machine learning as the project technologies.',
                'Help users explore movie recommendations through a simple application interface.',
                'Use Python and machine-learning logic in a Streamlit application.',
                'Project focus: movie recommendations; dataset, recommendation algorithm and evaluation results are not published.',
                new List<String>{'User','Streamlit Application','Recommendation Logic','Movie Results'},
                'The recommendation method and evaluation details are not published.',
                'A lightweight interface for exploring movie recommendations.',
                new List<String>{'Python','Streamlit','Machine Learning'},
                new List<String>{'Movie Recommendations','Machine Learning','Streamlit Interface'})
        };
        projects[0].put('organization', 'Nath Agency');
        projects[0].put('location', 'Chhatrapati Sambhajinagar');
        for (Integer index = 0; index < projects.size(); index++) {
            String projectCategory = new Set<Integer>{0, 2, 3}.contains(index)
                ? 'featured-salesforce'
                : (index == 1 ? 'additional-salesforce' : 'secondary');
            projects[index].put('category', projectCategory);
        }
        return projects;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getSkills() {
        return new List<Map<String, Object>>{
            cat('Salesforce Development', '⚡', 'Build platform features and business automation with Salesforce-native tools.', new List<String>{'Apex','Triggers','Apex Classes','Test Classes','SOQL','SOSL','Lightning Web Components','Visualforce','Flows','Approval Processes','Security','Data Modeling'}),
            cat('Salesforce Platform', '☁️', 'Salesforce clouds, extensions and AI capabilities for CRM workflows.', new List<String>{'Sales Cloud','Service Cloud','Experience Cloud','Education Cloud','HEDA','OmniStudio','Agentforce','Prompt Builder'}),
            cat('Integration', '🔗', 'API and event-based connections between Salesforce and external services.', new List<String>{'REST API','Postman','WhatsApp Cloud API','Razorpay','Google Maps API','IDFY','Platform Events','Email Integrations'}),
            cat('Programming', '💻', 'Supporting languages used across applications and data projects.', new List<String>{'Java','Python','JavaScript','SQL'}),
            cat('AI / Data', '🧠', 'AI, machine-learning and data-analysis concepts supporting the Salesforce profile.', new List<String>{'Machine Learning','Generative AI','Explainable AI','CNN','RNN','LSTM','GAN','AutoML','Data Analysis'}),
            cat('Cloud / Tools', '🧰', 'Cloud platforms and development tools used alongside Salesforce.', new List<String>{'AWS','Google Cloud','Oracle Cloud','GitHub','VS Code','Postman','Streamlit','Flask','H2O.ai','PyCaret'})
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getExperience() {
        return new List<Map<String, Object>>{
            new Map<String, Object>{'id'=>'e1','role'=>'Salesforce Developer Intern','company'=>'Pinnacle Technologies','period'=>'Jan 2025 – Apr 2026'},
            new Map<String, Object>{'id'=>'e2','role'=>'Salesforce Intern','company'=>'Cendance Systems Inc.','period'=>'Feb 2025 – May 2025'}
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getEducation() {
        return new List<Map<String, Object>>{
            new Map<String, Object>{'id'=>'d1','school'=>'Maharashtra Institute of Technology — Aurangabad','degree'=>'B.Tech — Artificial Intelligence & Data Science','period'=>'2022 – 2026','score'=>'CGPA: 7.10'},
            new Map<String, Object>{'id'=>'d2','school'=>'Shiveswar Vidyalaya — Aurangabad','degree'=>'Higher Secondary Certificate (HSC)','period'=>'2021 – 2022','score'=>'Percentage: 86.40%'},
            new Map<String, Object>{'id'=>'d3','school'=>'Nageswar Vidyalaya — Aurangabad','degree'=>'Secondary School Certificate (SSC)','period'=>'2019 – 2020','score'=>'Percentage: 89.20%'}
        };
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAchievements() {
        return new Map<String, Object>{
            'badges'=>210,'superbadges'=>6,'points'=>101500,'trails'=>18,
            'journey'=>new List<Map<String, String>>{
                new Map<String, String>{'name'=>'Agentblazer Innovator','type'=>'Trailblazer rank'},
                new Map<String, String>{'name'=>'Prompt Builder Templates Superbadge Unit','type'=>'Superbadge unit'},
                new Map<String, String>{'name'=>'Agentforce for Service Superbadge Unit','type'=>'Superbadge unit'},
                new Map<String, String>{'name'=>'Apex Callouts Superbadge','type'=>'Superbadge'},
                new Map<String, String>{'name'=>'Super Quest: Apex Callouts','type'=>'Super Quest'}
            }
        };
    }

    // ---------- Write API ----------
    @AuraEnabled
    public static void submitContact(String name, String email, String phone, String subject, String message, String website) {
        // Honeypot field: silently accept bot submissions without storing or emailing them.
        if (String.isNotBlank(website)) return;
        if (String.isBlank(name) || name.trim().length() > 120 ||
            String.isBlank(subject) || subject.trim().length() > 150 ||
            String.isBlank(message) || message.trim().length() > 5000 ||
            (String.isNotBlank(phone) && phone.trim().length() > 30) ||
            !isValidEmail(email) || email.trim().length() > 80) {
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
            Schema.sObjectType.Portfolio_Contact__c.fields.Subject__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Message__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Status__c.isCreateable() &&
            Schema.sObjectType.Portfolio_Contact__c.fields.Created_Date__c.isCreateable();
    }

    private static Boolean isValidEmail(String e) {
        return String.isNotBlank(e) && Pattern.matches('^[A-Za-z0-9._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,}$', e.trim());
    }
    private static Map<String, Object> proj(String id, String title, String type, String icon,
        String projectSummary, String detail, String problem, String solution, String contribution,
        List<String> architecture, String challenge, String outcome, List<String> tech, List<String> feats) {
        return new Map<String, Object>{'id'=>id,'title'=>title,'type'=>type,'icon'=>icon,
            'description'=>projectSummary,'details'=>detail,'problem'=>problem,'solution'=>solution,
            'contribution'=>contribution,'architecture'=>architecture,'challenge'=>challenge,'outcome'=>outcome,
            'technologies'=>tech,'features'=>feats,'githubUrl'=>'','demoUrl'=>'','caseStudyUrl'=>'',
            'organization'=>'','location'=>''};
    }
    private static Map<String, Object> cat(String name, String icon, String description, List<String> items) {
        return new Map<String, Object>{'category'=>name,'icon'=>icon,'description'=>description,'items'=>items};
    }
}
