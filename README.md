<div align="center">
  <a href="https://www.znuny.org">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://www.znuny.com/assets/znuny-logo.svg">
      <img alt="Znuny" src="https://www.znuny.com/assets/znuny-logo-black.svg" width="300">
    </picture>
  </a>

  ![Build status](https://badge.proxy.znuny.com/ITSMCore/rel-6_5)
</div>

ITSM Core
=========

**Feature List**

This package provides the ITSM Core functionality for Znuny. It is the base layer for the ITSM stack and is required by ITSM Change Management, ITSM Configuration Management and other ITSM packages.

- **Services**: ITSM service management – view, zoom and print services; link services to tickets and other objects
- **SLAs**: Service level agreement (SLA) management – view, zoom and print SLAs; link SLAs to services and tickets
- **CIP Allocation**: Admin interface to allocate configuration item permissions (Admin → ITSM CIP Allocate)
- **Link Object**: LinkObject support for services (e.g. link services to tickets, changes, config items)
- **Framework**: Core ITSM requirments for all other ITSM Add-ons


Install ITSMCore after the [General Catalog](https://download.znuny.org/releases/itsm/latest/) Add-on.

Then use the new package repository: `Znuny::ITSM` to install all other modules as needed ITSM Change Management, ITSM Configuration Management, ITSM Incident Problem Management and ITSM Service Level Management.
You can install all packages with the [ITSM](https://download.znuny.org/releases/itsm/latest/) bundle.

**Prerequisites**

- Znuny 6.5
- GeneralCatalog 6.5.1

**Installation**

Install via Admin interface → Package Manager. The package is part of the Znuny ITSM stack and can be installed from the Znuny repository or from a built .opm file.

**Configuration**

Configuration is available in the System Configuration under ITSMCore and related namespaces (e.g. ticket–service mapping). Use Admin → ITSM CIP Allocate for configuration item permission allocation. Relevant actions for ACLs include `AgentITSMService*`, `AgentITSMSLA*` and `AdminITSMCIPAllocate`.

**Download**

Source code is available in the [ITSMCore repository](https://download.znuny.org/releases/itsm/latest/). For packaged releases, use the Znuny package repository or build from source.

**Commercial Support**

For this extension and for Znuny in general visit [www.znuny.com](https://www.znuny.com). Looking forward to hear from you!

Enjoy!

Your Znuny Team!

[www.znuny.com](https://www.znuny.com)
