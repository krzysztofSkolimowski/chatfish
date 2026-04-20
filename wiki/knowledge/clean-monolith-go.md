---
title: Clean Monolith in Go — Microservices vs Modular Monolith
type: knowledge
source: https://threedots.tech/post/microservices-or-monolith-its-detail/
created: 19-04-2026
related: []
---

# Clean Monolith in Go — Microservices vs Modular Monolith

## Summary

Article by Robert Laszczak arguing that whether an application is a microservice or monolith is an implementation detail, when designed with Clean Architecture. Demonstrates a Go shop example where domain and application layers are identical in both architectures — only interfaces/infrastructure differ.

## Key Points

1. Clean Architecture separates code into Domain, Application, Interfaces, and Infrastructure layers — outer layers cannot be known by inner layers
2. Monolith vs microservice is just an implementation detail: only interfaces/infrastructure layers differ; domain and application are identical
3. Start as a Clean Monolith and migrate to microservices later with minimal rework — defer the architectural decision
4. Synchronous cross-module calls use intraprocess function calls in monolith; HTTP/REST in microservices
5. Asynchronous cross-module communication uses Go channels in monolith; RabbitMQ/AMQP in microservices
6. Module boundaries (Bounded Contexts) must be enforced by tooling in CI to prevent violations
7. Duplication of data types between bounded contexts is acceptable — cost of avoiding duplication grows with scale

## Relevance to Chatfish

Chatfish is a Go backend planned with api, upload, store, and scoring services. This article directly informs the decision to start as a Clean Monolith with proper module boundaries, making future extraction to microservices straightforward.

## Open Questions

- Should Chatfish enforce bounded context boundaries with a linting tool in CI from the start?
- At what scale or trigger should Chatfish consider extracting services to separate microservices?

## Related

(none)

