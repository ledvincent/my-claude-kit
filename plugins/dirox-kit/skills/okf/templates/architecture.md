---
type: Architecture
title: Architecture overview
description: <one sentence, what the system is made of and how it runs>
owner: <architect>
status: draft
tags: []
---
# Architecture overview

<!-- One page: what a new developer (or Claude) needs before touching the code. Saved as
     okf/architecture/overview.md. Behaviour belongs in openspec/specs/, not here. Once the
     module table passes about 15 rows, give each module its own okf/architecture/modules/<name>.md. -->

## Overview
Two or three sentences: what the system does and for whom.

## Modules
| Module | Folder | Does |
|---|---|---|
| | `src/…` | one line |

## Data flow
How a typical request or job moves through the modules.

## External services
Databases, queues, third-party APIs. Each one with more to say gets a file in `/integrations/`.

## Deployment
Environments, how a release goes out, where it runs. Step-by-step procedures go in `/runbooks/`.

## Decisions
Links to the `/decisions/` files that shaped this architecture.
