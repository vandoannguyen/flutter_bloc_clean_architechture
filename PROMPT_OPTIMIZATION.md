# 🎯 Prompt Optimization – Feature Development & Cost Savings

This document provides **sample prompts** and **communication guidelines** for working with AI (Cursor/Copilot) effectively: aligned with project standards, fewer back-and-forth rounds, and lower token usage.

---

## 📌 Cost-Saving Principles

| Do | Avoid |
|----|--------|
| Use `@DEVELOPMENT_RULES.md` or `@REQUIREMENTS.md` when referring to process | Pasting full doc content into chat |
| Use `@file_path` or `@folder` when context is needed | Pasting long code snippets into chat |
| One request = one clear scope (1 feature, 1 screen, 1 fix) | Combining multiple features/screens in one prompt |
| Specify feature name (e.g. `product`, `order`) and layer | Vague descriptions like "add a feature" |
| Send only relevant files/snippets | Sending the whole project or long file lists |

---

## 🚀 Sample Prompts by Scenario

### 1. Create a new feature (full Clean Architecture)

**Use when:** Adding a brand-new feature (entity → repository → use case → data → presentation).

```
Create new feature: [feature_name] (e.g. product, order, notification).

- Follow @DEVELOPMENT_RULES.md and @REQUIREMENTS.md.
- Structure: domain (entities, repository interface, use cases) → data (models, datasources, repository impl) → presentation (bloc, pages, widgets).
- API/endpoints (if any): [short list or "same as auth feature"].
- UI: [short description or "list + detail"].

Only create code and index exports; no long explanations.
```

**Concrete example:**

```
Create feature "product": list products, view detail. API GET /products and GET /products/:id. Follow @DEVELOPMENT_RULES.md and @REQUIREMENTS.md. Use base_bloc_module for presentation. Only create code, no explanation.
```

---

### 2. Add screen / flow to an existing feature

**Use when:** Feature already exists; only add a screen or flow (e.g. create order screen, filter screen).

```
In feature [feature_name], add [screen/flow description].

- Reference @DEVELOPMENT_RULES.md (presentation section).
- Use base bloc/cubit from base_bloc_module.
- Route: [route name if applicable].

Only create/update necessary files; do not refactor the whole feature.
```

---

### 3. Fix bug / wrong behavior

**Use when:** Specific bug or incorrect behavior.

```
[Description of bug or wrong behavior]. File/area: @path/to/file or feature [name].

- Keep Clean Architecture and @REQUIREMENTS.md.
- Only fix the cause of the issue; do not change unrelated structure.
```

---

### 4. Refactor / rename / move

**Use when:** Renaming classes/files, splitting files, moving code to the correct layer.

```
Refactor: [short description, e.g. rename UserRepositoryImpl to AuthRepositoryImpl and update all references].

- Keep @REQUIREMENTS.md (dependency rules, feature structure).
- List changed files and updated imports/DI.
```

---

### 5. Review / check compliance

**Use when:** You want the AI to check if a feature or file complies with standards.

```
Review feature [feature_name] (or file @path) against @REQUIREMENTS.md and @DEVELOPMENT_RULES.md.

- Checklist: folder structure, dependency rules (domain does not import data/presentation), Result/Failure, naming, index exports.
- Only list violations and short fix suggestions.
```

---

## 📎 Quick References in Cursor

When chatting, @ these files as needed:

- `@DEVELOPMENT_RULES.md` – feature creation process, code examples per layer
- `@REQUIREMENTS.md` – mandatory rules (structure, dependencies, naming)
- `@CLEAN_ARCHITECTURE_LAYERS.md` – explanation of each layer
- `@FORM_VALIDATION_GUIDE.md` – when working on forms/validation
- `@base_bloc_module/README.md` – when using base cubit/bloc
- `@lib/features/[feature_name]` – when working inside a specific feature

---

## ✅ Checklist Before Sending a Prompt

- [ ] Feature name / file / scope is clear
- [ ] Correct doc @’d (DEVELOPMENT_RULES / REQUIREMENTS) if about process or standards
- [ ] One prompt = one type of work (create feature / fix bug / refactor / review)
- [ ] No long code paste when @file can be used instead

---

## 🔧 Cursor Rules (Always Apply)

In `.cursor/rules/` there is **flutter-clean-arch-prompt.mdc** so the AI will:

- Read DEVELOPMENT_RULES.md and REQUIREMENTS.md when creating features or changing structure
- Prefer @ references instead of asking you to paste docs
- Reply concisely and only create/change necessary code

You can simply say: *"Follow DEVELOPMENT_RULES"* or *"Comply with REQUIREMENTS"*.

---

*Last updated: 2025 – Flutter BLoC Clean Architecture project*
