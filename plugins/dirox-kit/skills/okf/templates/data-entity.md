---
type: Data Entity
title: <entity or table, for example orders>
description: <one sentence, what one record represents>
owner: <person accountable>
status: stable
resource: <optional URI of the table, for example postgres://app/public/orders>
tags: []
---
# <Entity>

<!-- Saved in okf/data/. Describes stored data; the behaviour that changes it belongs in openspec/specs/. -->

# Schema
| Field | Type | Meaning | Notes |
|---|---|---|---|
| id | uuid | | primary key |

## Relations
Links to other `/data/` entities and how they relate.

## Lifecycle
Who creates, updates and deletes records, and how long they are kept. Mark personal data.
