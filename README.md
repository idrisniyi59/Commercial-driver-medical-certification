# Commercial Driver Medical Certification

A blockchain-based transportation compliance platform for tracking CDL medical exam schedules, certification renewals, and driver health clearances.

## Overview

This smart contract system provides a comprehensive solution for managing commercial driver medical certifications in compliance with Federal Motor Carrier Safety Administration (FMCSA) regulations. The platform enables transportation companies, medical examiners, and drivers to maintain transparent, immutable records of medical certifications, exam schedules, and health clearances required for commercial driver's license (CDL) operations.

The system ensures that commercial drivers maintain valid medical certifications, tracks certification expiration dates, manages examiner credentials, and provides complete audit trails for regulatory compliance and safety enforcement.

## Key Features

### Medical Exam Management
- Schedule and track medical examinations
- Examiner credential verification
- Physical examination result documentation
- Medical condition tracking
- Vision and hearing test results

### Certification Tracking
- Certificate issuance and storage
- Expiration date monitoring
- Automatic renewal reminders
- Certificate status management
- Variance and waiver tracking

### Driver Health Records
- Secure health information storage
- Medical history tracking
- Medication documentation
- Restriction management
- Fitness determination records

### Examiner Management
- Medical examiner registry
- Credential verification
- National Registry status tracking
- Examination history
- Quality assurance monitoring

### Compliance Monitoring
- FMCSA regulation adherence
- Certification renewal tracking
- Driver qualification file management
- Audit trail maintenance
- Regulatory reporting

## System Components

### Core Functionality
1. **Driver Registration**: Onboard commercial drivers with CDL information
2. **Examiner Registry**: Maintain certified medical examiner credentials and National Registry status
3. **Exam Scheduling**: Manage medical examination appointments and reminders
4. **Certification Management**: Issue, track, and renew medical certificates
5. **Health Records**: Secure documentation of exam results and medical conditions
6. **Compliance Monitoring**: Track certification status and regulatory requirements

### Data Structures
- Driver profiles with CDL information
- Medical examiner credentials and registry status
- Examination records and results
- Certification documents with expiration tracking
- Health clearance status and restrictions
- Audit logs for all transactions

## Use Cases

### Transportation Companies
- Monitor driver medical certification status across fleet
- Receive alerts for expiring certifications
- Maintain driver qualification files (DQF)
- Ensure compliance before trip assignments
- Generate regulatory reports

### Medical Examiners
- Document examination findings
- Issue medical certificates
- Track examination history
- Maintain National Registry compliance
- Update examiner credentials

### Commercial Drivers
- View certification status and expiration dates
- Schedule medical examinations
- Access examination history
- Receive renewal reminders
- Maintain medical documentation

### Regulatory Authorities
- Verify examiner credentials
- Audit certification records
- Monitor compliance rates
- Track medical variances and waivers
- Enforce safety standards

## Smart Contract: medical-certification-coordinator

### Features
- Register drivers and medical examiners
- Schedule medical examinations
- Document exam results and health conditions
- Issue and track certifications
- Monitor expiration and trigger renewals
- Verify examiner credentials against National Registry
- Maintain compliance records and audit trails
- Manage medical variances and restrictions

## Technical Architecture

### Blockchain Benefits
- **Immutability**: Certification records cannot be altered or falsified
- **Transparency**: All stakeholders have access to relevant information
- **Automation**: Smart contracts trigger renewal reminders and status updates
- **Security**: Encrypted health data with access controls
- **Auditability**: Complete transaction history for compliance verification

### Access Control
- Driver self-service functions
- Examiner-only medical documentation
- Company fleet monitoring capabilities
- Admin functions for system management
- Read-only access for regulatory audit

## Getting Started

```bash
git clone <repository-url>
cd Commercial-driver-medical-certification
npm install
clarinet check
clarinet test
```

## Security

- HIPAA-compliant data handling
- Examiner credential verification
- Driver authentication
- Immutable certification records
- Access control enforcement

## Compliance

- FMCSA Part 391 regulations
- National Registry of Certified Medical Examiners
- DOT medical certification requirements
- State CDL regulations
- Data privacy requirements

## License

MIT License
