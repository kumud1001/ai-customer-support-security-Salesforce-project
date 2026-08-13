# AI Security Operations Dashboard

## Overview

The **AI Security Operations Dashboard** is a Salesforce-based cybersecurity application designed to monitor, manage, and track security alerts in a centralized dashboard.

The project uses **Salesforce Lightning Web Components (LWC), Apex, and custom Salesforce objects** to provide security teams with an easy-to-use interface for viewing and creating cybersecurity alerts.

The dashboard displays important security information such as:

* Threat Type
* Severity
* Risk Score
* Source IP
* Alert Status
* Detection Time

## Key Features

### Security Alert Dashboard

Provides a centralized view of security alerts with:

* Total alert count
* Critical alert count
* High-risk alert count
* Security alert table
* Refresh functionality

### Security Alert Creation

Users can create security alerts by entering:

* Threat Type
* Severity
* Source IP
* Risk Score
* Description
* AI Recommendation

### Alert Management

Security alerts are stored as Salesforce records and can be retrieved and updated using Apex.

The system automatically records:

* Alert status
* Detection timestamp

### Dynamic Dashboard

The Lightning Web Component automatically refreshes the alert table after a new security alert is created.

## Technology Stack

| Technology                | Purpose                    |
| ------------------------- | -------------------------- |
| Salesforce                | Cloud platform             |
| Lightning Web Components  | User interface             |
| Apex                      | Backend logic              |
| Salesforce Custom Objects | Security alert storage     |
| SOQL                      | Data retrieval             |
| Salesforce CLI            | Development and deployment |
| Git & GitHub              | Version control            |

## Architecture

```text
User
  |
  v
Lightning Web Component
  |
  | Create / Retrieve Alert
  v
Apex Controller
  |
  v
Security_Alert__c
  |
  v
Salesforce Database
```

## Main Components

### Lightning Web Component

`securityDashboard`

The LWC provides the cybersecurity dashboard interface.

It handles:

* Displaying security alerts
* Creating new alerts
* Calculating alert statistics
* Refreshing dashboard data
* Handling user input

### Apex Controller

`SecurityAlertController`

The Apex controller provides backend functionality for:

* Creating security alerts
* Retrieving security alerts
* Updating alert status

Main methods:

```text
createSecurityAlert()
getSecurityAlerts()
updateAlertStatus()
```

## Security Alert Data

The application currently uses fields such as:

```text
Threat_Type__c
Severity__c
Source_IP__c
Risk_Score__c
Description__c
AI_Recommendation__c
Status__c
Detected_At__c
```

## Dashboard Metrics

The dashboard calculates:

### Total Alerts

The total number of security alerts stored in Salesforce.

### Critical Alerts

The number of alerts where severity is:

```text
CRITICAL
```

### High-Risk Alerts

The number of alerts with:

```text
HIGH
CRITICAL
```

## Example Security Alert

```text
Threat Type: SQL Injection
Severity: CRITICAL
Risk Score: 92
Source IP: 10.10.10.5
Status: New
```

## Project Structure

```text
AI-Security-Operations-Dashboard/
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           │   ├── SecurityAlertController.cls
│           │   └── SecurityAlertController.cls-meta.xml
│           │
│           └── lwc/
│               └── securityDashboard/
│                   ├── securityDashboard.html
│                   ├── securityDashboard.js
│                   ├── securityDashboard.css
│                   └── securityDashboard.js-meta.xml
│
├── sfdx-project.json
└── README.md
```

## Setup

### Prerequisites

You need:

* Salesforce Developer Org
* Salesforce CLI
* Visual Studio Code
* Salesforce Extension Pack
* Git

### Clone the Repository

```bash
git clone <your-github-repository-url>
cd AI-Security-Operations-Dashboard
```

### Authenticate Salesforce

```bash
sf org login web
```

### Deploy the Apex Controller

```bash
sf project deploy start --source-dir force-app/main/default/classes/SecurityAlertController.cls
```

### Deploy the Lightning Web Component

```bash
sf project deploy start --source-dir force-app/main/default/lwc/securityDashboard
```

## Using the Dashboard

1. Open Salesforce.
2. Navigate to the Lightning App Builder.
3. Add the `securityDashboard` Lightning Web Component to your Lightning page.
4. Save and activate the page.
5. Open the dashboard.
6. Create a security alert.
7. Enter the threat information.
8. Click **Create Security Alert**.
9. The alert is stored in Salesforce.
10. The dashboard refreshes and displays the new alert.

## Future Enhancements

The project can be extended with:

* AI-based threat classification
* Automated risk-score calculation
* IP reputation checking
* CVE integration
* Automated alert prioritization
* Email notifications
* Alert status workflow
* Security analytics and charts
* Integration with external SIEM systems
* Automated incident response
* Role-based security access
* AI-generated security recommendations

## Learning Objectives

This project demonstrates practical experience with:

* Salesforce development
* Apex programming
* Lightning Web Components
* SOQL
* Salesforce custom objects
* REST/API-oriented backend concepts
* Event-driven UI updates
* Cybersecurity alert management
* Git and GitHub
* Salesforce CLI deployment

## Author

**Kumud Singh**

Cybersecurity / Software Engineering Project

## License

This project is intended for educational and portfolio purposes.
