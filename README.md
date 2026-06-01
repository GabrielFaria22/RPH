# Roleplay Hub Backend

Roleplay Hub is a Rails API for creating, organizing, and managing character sheets for roleplaying and collaborative storytelling. The backend provides the data model, authentication, file attachment handling, search/filtering, API documentation, and test coverage needed to support a more rich frontend experience.

This repository contains only the backend service. The frontend lives in a separate project, the RPH_frontend.

## Overview of my project

This application is designed for users who want to keep an organized roleplaying material in one place, meaning the characters they create as well as the universe they belong to, the world and place they live in or where the story is set, their relationships, their families, including their family tree, the faction they belong to. It supports private records, public discovery, ownership checks, image attachments, and API endpoints that can be consumed by a dedicated frontend client.

The current focus is character and worldbuilding organization. Planned work includes storytelling tools, event-based timelines, larger updates to the current application flow, and ongoing fixes as the project evolves.

## Main Features

- JWT-based authentication for signup, login, and logout
- User-owned resources: universes, worlds, characters, locations, families, factions, and family trees
- Public/private visibility rules for shareable worldbuilding content
- Character relationships, family relationships, and faction relationships
- Image attachments through Active Storage
- Search, filtering, and sorting through Ransack
- JSON serialization through Blueprinter (for easily readable resources with multiple relations, like characters)
- API documentation through Swagger/OpenAPI
- Background job infrastructure with Sidekiq and Redis
- Automated request, model, blueprint, and integration tests with RSpec (Still not using Test Driven Development or context based tests, but soon)
- Docker-based local development environment

## Technology Stack

### Backend

- Ruby 3.2.2
- Ruby on Rails 7.1
- PostgreSQL
- Puma local server
- Active Record
- Active Storage
- Rails API-style controllers

### Authentication and Authorization

- Devise
- Devise JWT
- Ownership-based access control in API scopes
- Admin-aware access paths for privileged users (there is one admin, me. but since its for only testing, its publicly created in the seeds so anyone can see the password. when in production this will obviously change)

### API and Serialization

- RESTful JSON API under `/api/v1`
- Blueprinter for response serialization
- Oj for JSON performance
- Rack CORS for frontend integration
- Ransack for search, filtering, and sorting

### Background Jobs and Infrastructure

- Sidekiq
- Redis
- Docker
- Docker Compose

### Testing and Documentation

- RSpec
- rspec-rails
- Factory Bot
- Faker
- Rswag
- Swagger UI / OpenAPI documentation

These are widely used tools in Rails and backend development. The project intentionally uses practical, widely used and relevant technologies: API design, PostgreSQL data modeling, JWT authentication, background jobs, Dockerized development, automated tests, and OpenAPI documentation.

## API Areas

The API currently includes endpoints for:

- Authentication
- People
- Universes
- Worlds
- Characters
- Locations
- Families
- Factions
- Family trees
- Character relations
- Family relations
- Faction relations

Swagger documentation is available in development at:

```text
http://localhost:3001/api-docs
```

The generated OpenAPI file is located at:

```text
swagger/v1/openapi.yaml
```

## Running the Project

Start the backend services with Docker Compose:

```bash
docker compose up
```

The Rails API runs on:

```text
http://localhost:3001
```

PostgreSQL and Redis are started automatically by Docker Compose.

## Running Tests

Run the full test suite:

```bash
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec
```

Regenerate Swagger/OpenAPI documentation:

```bash
docker compose run --rm -e RAILS_ENV=test web bundle exec rails rswag:specs:swaggerize
```

The test suite covers models, request behavior, serializers/blueprints, attachment handling, authentication flows, and API documentation examples.

## Development Notes (IMPORTANT)

This backend is intended to be used together with the `RPH_frontend` project. The frontend consumes the API and is responsible for the user interface, while this service owns the database, business rules, authentication, serialization, background processing, and API documentation.

Future development plans include:

- Storytelling and campaign organization features
- Event-based timelines for characters, worlds, and narrative arcs
- Improvements to the current character sheet and worldbuilding workflows
- Larger API and data model updates as the product direction matures
- Bug fixes, refactors, and performance improvements when necessary

## Project Status

RPH is under active development. The backend already provides a solid foundation for roleplaying and worldbuilding data, with room for larger storytelling features and frontend-driven workflow improvements.
