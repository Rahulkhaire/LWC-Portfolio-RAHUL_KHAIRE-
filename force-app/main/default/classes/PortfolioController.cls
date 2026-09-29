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
            'experience' => getExperience(), 'certifications' => getCertifications(),
            'education' => getEducation(), 'achievements' => getAchievements()
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getProjects() {
        List<Map<String, Object>> projects = new List<Map<String, Object>>{
            proj('p1', 'Smart Medical Inventory & Transfer System', 'Salesforce Solution · Nath Agency', '🏥',
                'A Salesforce-based medical inventory and surgical instrument distribution solution for managing inventory, orders, shipments and operational workflows.',
                'The solution brings inventory, order and shipment workflows together, with integrations for payments, maps, identity verification and customer notifications.',
                'Coordinate medical inventory, orders and shipments while keeping operational workflows visible.',
                'Use Salesforce records and automation as the operational hub, with API integrations supporting payment, location, identity and messaging needs.',
                'Project focus: inventory tracking, order and shipment management, integrations and automated alerts. The exact individual work split is not published.',
                new List<String>{'User','Experience Cloud / LWC','Apex / Salesforce','Custom Objects','Integration Layer','Razorpay','Google Maps','IDFY','WhatsApp Cloud API'},
                'Coordinating inventory, orders and shipments alongside multiple external services.',
                'Centralized medical inventory and transfer workflows with integrated notifications and service connections.',
                new List<String>{'Salesforce','Apex','LWC','Flows','REST APIs','Razorpay','Google Maps','IDFY','WhatsApp Cloud API','Platform Events'},
                new List<String>{'Medicine Inventory','Order Management','Shipment Management','Inventory Tracking','API Integrations','WhatsApp Notifications','Payment Integration','Location / Maps Integration','Automated Alerts'}),
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
            proj('p3', 'WhatsApp Customer Support Integration', 'Integration', '💬',
                'Integrated Salesforce with WhatsApp Cloud API to enable real-time customer engagement, automated case creation, and conversation management.',
                'Developed Apex REST callouts, asynchronous processing and custom LWCs for seamless communication between customers and support teams.',
                'Connect customer WhatsApp conversations with Salesforce support and case workflows.',
                'Use API communication and Salesforce automation to support customer messaging and case creation.',
                'Project focus: WhatsApp Cloud API integration, Apex callouts, asynchronous processing and support workflows.',
                new List<String>{'Customer','WhatsApp Cloud API','Apex REST Callouts','Salesforce CRM','Cases','LWC'},
                'Handling customer conversation events and coordinating API responses with Salesforce processing.',
                'A CRM-connected messaging workflow for support conversations and case creation.',
                new List<String>{'Salesforce','Apex REST API','LWC','Queueable Apex','Scheduled Apex','WhatsApp Cloud API'},
                new List<String>{'Customer Communication','WhatsApp Integration','CRM Automation','Case / Support Workflow','API Communication','Asynchronous Processing'}),
            proj('p4', 'Automated Exploratory Data Analysis Platform', 'Python · Data Analysis', '📊',
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
            proj('p5', 'Dynamic AutoML Platform', 'Python · Machine Learning', '🧠',
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
            proj('p6', 'Movie Recommendation System', 'Python · Machine Learning', '🎬',
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
        return projects;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getSkills() {
        return new List<Map<String, Object>>{
            cat('Salesforce Development', '⚡', 'Build platform features and business automation with Salesforce-native tools.', new List<String>{'Apex','Triggers','Apex Classes','Test Classes','SOQL','SOSL','Lightning Web Components','Visualforce','Flows','Approval Processes','Security','Data Modeling'}),
            cat('Salesforce Platform', '☁️', 'Salesforce clouds, extensions and AI capabilities for CRM workflows.', new List<String>{'Sales Cloud','Service Cloud','Experience Cloud','Education Cloud','HEDA','OmniStudio','Agentforce','Prompt Builder'}),
            cat('Integration', '🔗', 'API and event-based connections between Salesforce and external services.', new List<String>{'REST API','Postman','WhatsApp Cloud API','Razorpay','Google Maps API','IDFY','Platform Events','Email Integrations'}),
            cat('Programming', '💻', 'Languages used across Salesforce development and data applications.', new List<String>{'Java','JavaScript','Python','SQL'}),
            cat('AI / Data', '🧠', 'AI, machine-learning and data-analysis concepts included in the portfolio.', new List<String>{'Machine Learning','Generative AI','Agentforce','Explainable AI','CNN','RNN','LSTM','GAN','AutoML','Data Analysis'}),
            cat('Cloud / Tools', '🧰', 'Development environments, cloud platforms and application frameworks.', new List<String>{'GitHub','VS Code','Google Cloud','AWS','OCI','Streamlit','Flask'})
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
        // Credential dates and verification URLs remain blank until supplied.
        List<Map<String, Object>> out = new List<Map<String, Object>>();
        for (List<String> c : new List<List<String>>{
            new List<String>{'Salesforce AI Associate','Salesforce'},
            new List<String>{'Oracle Cloud Infrastructure 2024 Certified AI Foundations Associate','Oracle'},
            new List<String>{'GitHub Foundation Certification','GitHub'},
            new List<String>{'Career Essentials in GitHub Professional Certificate','GitHub'},
            new List<String>{'Google Play Store Listing Certificate','Google'},
            new List<String>{'Google Study Jam','Google'},
            new List<String>{'GET AI Study Jam','GET'} }) {
            out.add(new Map<String, Object>{'id'=>c[0],'name'=>c[0],'issuer'=>c[1],'date'=>'','url'=>''});
        }
        return out;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getEducation() {
        return new List<Map<String, Object>>{
            new Map<String, Object>{'id'=>'d1','school'=>'Maharashtra Institute of Technology','degree'=>'B.Tech — Artificial Intelligence & Data Science','period'=>'2022 – 2026','score'=>'CGPA: 7.10'}
        };
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAchievements() {
        return new Map<String, Object>{
            'badges'=>210,'superbadges'=>6,'points'=>101500,'trails'=>18,
            'ranks'=>new List<String>{'Agentblazer Innovator','Prompt Builder Templates Superbadge Unit','Agentforce for Service Superbadge Unit','Apex Callouts Superbadge','Super Quest: Apex Callouts'}
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
