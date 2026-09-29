# Rahul Khaire – Salesforce LWC Portfolio
Deploy: `sf project deploy start -d force-app` then `sf org assign permset -n Portfolio_Access` for authenticated users.
Open: App Builder → new App Page → drag "Rahul Khaire Portfolio" → activate (or add to an Experience Cloud page).

### Contact form access

The contact form uses user-mode Apex DML. In an authenticated App Builder preview, assign the `Portfolio_Access` permission set to the previewing user. For a public Experience Cloud page, the unauthenticated guest user does not inherit that assignment: open the site's Guest User Profile and grant Apex class access to `PortfolioController`, object Create access to `Portfolio Contact`, and field Edit access for `Name__c`, `Email__c`, `Phone__c`, `Subject__c`, `Message__c`, `Status__c`, and `Created_Date__c`. Salesforce requires object Read alongside Create and field Read alongside Edit; keep organization-wide defaults private and do not add guest sharing rules that expose submitted records. Grant only the minimum access needed to submit the form.

Deploy source changes with `sf project deploy start -d force-app` (a `sf project deploy validate` only checks changes and does not publish them).

Every inserted portfolio contact now triggers one plain-text notification email to `rahul.khaire@mit.asia`, including all submitted fields. In Setup → Organization-Wide Addresses, add and verify `rahul.khaire@mit.asia`; the handler will use it as the sender when configured. Also ensure Setup → Deliverability → Access to Send Email is set to **All Email**. The trigger sends one consolidated email for bulk inserts and does not roll back saved contacts if mail delivery is unavailable.

Project-specific GitHub/demo links are intentionally blank until real URLs are available. Certificate records and verified source-file metadata are maintained in `certificateGallery.js`.

### Certificate gallery assets

- Source images live in `force-app/main/default/Certifications/`; the gallery renders the original image files from the deployable `PortfolioCertificates` ZIP static resource.
- The gallery's centralized certificate records are in `force-app/main/default/lwc/certificateGallery/certificateGallery.js`. The visible total is derived from the records in that array; categories and filters are generated from the same data.
- When adding/removing a certificate, update its metadata record and regenerate `force-app/main/default/staticresources/PortfolioCertificates.resource` with the source images. Salesforce static resources cannot enumerate files from a source folder at runtime, so the array is the catalog and its length is the live displayed count.
- The source folder currently contains two Oracle AI Foundations scans with conflicting printed dates. The gallery includes one higher-resolution original and omits the date rather than choosing between them.
- The gallery categorizes only areas represented by files: Salesforce, Cloud, AI / Data, and Development. Original images are loaded with browser lazy loading; selecting a card opens a keyboard-accessible zoomable preview and an original-image link.

### Experience Cloud production configuration

- In Experience Builder, configure the Home page SEO title as **Rahul Khaire | Salesforce Developer** and the meta description as **Rahul Khaire — Salesforce Developer specializing in Apex, Lightning Web Components, SOQL, integrations, automation, OmniStudio, Agentforce and Salesforce CRM solutions.** LWC runs inside Salesforce's page shell and cannot set the document's SEO metadata itself.
- Publish the Experience Cloud site after deployment; deploying source does not publish site changes.
- The resume PDF is a public static resource. Do not place confidential or private content in it.
- The contact form includes client-side validation, server-side validation and a honeypot field. A honeypot is basic spam friction, not rate limiting or CAPTCHA; configure Salesforce-supported CAPTCHA or another abuse control if public traffic warrants it.
- Project-specific GitHub, demo and case-study links are intentionally blank until verified URLs are provided. Add actual URLs in `PortfolioController.cls`; do not substitute profile URLs.
- Certificate dates and verification links are included only when readable in the source image; ambiguous dates and unavailable links are omitted. Confirm the portfolio's static Trailhead figures against the current profile before representing them to recruiters.

### Deployment and smoke tests

Deploy the `force-app` source to the target org, assign `Portfolio_Access` to authenticated preview users when needed, and publish the Experience Cloud site. Run the `PortfolioController_Test` and `PortfolioContactEmailHandler_Test` Apex tests in the target org. For a public contact form, configure the guest profile's Apex class and create/field permissions as described above; do not configure record sharing that exposes contact submissions. Verify static-resource access, email deliverability, the live resume download/view actions, and mobile navigation after publishing.
