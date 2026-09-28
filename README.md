# Rahul Khaire – Salesforce LWC Portfolio
Deploy: `sf project deploy start -d force-app` then `sf org assign permset -n Portfolio_Access` for authenticated users.
Open: App Builder → new App Page → drag "Rahul Khaire Portfolio" → activate (or add to an Experience Cloud page).

### Contact form access

The contact form uses user-mode Apex DML. In an authenticated App Builder preview, assign the `Portfolio_Access` permission set to the previewing user. For a public Experience Cloud page, the unauthenticated guest user does not inherit that assignment: open the site's Guest User Profile and grant Apex class access to `PortfolioController`, create access to `Portfolio Contact`, and edit access to its `Name__c`, `Email__c`, `Phone__c`, `Subject__c`, `Message__c`, `Status__c`, and `Created_Date__c` fields. Keep record sharing restrictive; grant only the minimum access needed to submit the form.

Deploy source changes with `sf project deploy start -d force-app` (a `sf project deploy validate` only checks changes and does not publish them).

Add real certification dates/URLs, project GitHub/demo links in `PortfolioController.cls`.
