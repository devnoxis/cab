# Research: AI Workflow Automation — Tracker → Claude Code → GitHub

**Ticket:** TES-17
**Date:** 2026-03-18

---

## Problem Understanding

The goal is to find and document 4 concrete examples of end-to-end AI-driven development automation pipelines that follow this flow:

```
Issue Tracker (Linear / Jira / GitHub Issues)
        ↓
   Claude Code (AI agent that reads, plans, and implements)
        ↓
  GitHub (branch, commit, pull request, status sync)
```

This pattern enables autonomous or semi-autonomous software development: a developer (or automated process) creates a ticket, and an AI agent picks it up, writes the code, and opens a PR — with minimal or no human intervention in between.

---

## Relevant Context and Background

### Why this pattern is emerging

- Claude Code (Anthropic's CLI coding agent) supports SDK-level invocation, GitHub Actions integration, and MCP (Model Context Protocol) servers — making it composable in larger pipelines.
- Issue trackers like Linear and Jira offer webhooks and APIs that can trigger automation on state changes (e.g., "assigned to agent", "labeled ready").
- GitHub's CLI (`gh`), API, and Actions ecosystem provide the downstream integration layer for branch/PR management.
- The combination allows an "agentic loop": ticket → implementation → validation → PR → review → close.

### Key enabling technologies

| Technology | Role |
|---|---|
| Claude Code CLI / SDK | AI agent for code generation and editing |
| MCP (Model Context Protocol) | Standardized tool protocol for Claude to interact with external systems |
| Linear / Jira / GitHub Issues API | Issue intake and status update |
| GitHub CLI (`gh`) / PyGithub | Branch creation, PR opening |
| GitHub Actions | Orchestration, CI/CD, agent triggers |
| Webhooks | Event-driven triggers from issue tracker → agent |

---

## 4 Examples

### Example 1: Cyrus — Linear/GitHub Issues → Claude Code → GitHub PRs

**Source:** [github.com/ceedaragents/cyrus](https://github.com/ceedaragents/cyrus)

**How it works:**
1. **Trigger:** Cyrus monitors Linear or GitHub Issues for tickets assigned to its agent account.
2. **Claude Code invocation:** For each issue, Cyrus creates an isolated Git worktree and launches a Claude Code session inside it. Parallel issues are handled in parallel worktrees.
3. **GitHub output:** After Claude completes, Cyrus uses the GitHub CLI to open a pull request. Progress updates (including approval requests) are streamed back into Linear/GitHub in real time with rich UI elements.

**Key traits:**
- Self-hosted or cloud-hosted via app.atcyrus.com
- Supports Linear MCP natively
- Users supply their own Anthropic API keys
- Persistence via `tmux`, `pm2`, or `systemd`

---

### Example 2: Linear + Claude Code + GitHub Starter (`claude-linear-gh-starter`)

**Source:** [github.com/ronanathebanana/claude-linear-gh-starter](https://github.com/ronanathebanana/claude-linear-gh-starter)

**How it works:**
1. **Trigger:** Developer tells Claude Code conversationally: "Let's work on DEV-123." Claude fetches the Linear issue via Linear MCP (OAuth-based, no API key setup needed).
2. **Claude Code invocation:** Claude reads the issue, creates a task analysis document, posts it back to Linear, then begins implementation — developer-in-the-loop but Claude-orchestrated.
3. **GitHub output:** Claude creates a properly named branch (`feature/DEV-123-add-user-authentication`), commits with enforced message format, and pushes. GitHub Actions workflows sync status back to Linear as the branch progresses (push → "In Progress", merge → "Code Review", deploy → "Done").

**Key traits:**
- MCP-only mode (no API keys required for Linear)
- Git hooks enforce commit message conventions (issue ID required)
- Setup wizard validates environment and runs 7+ pre-flight checks
- `.linear-workflow.json` configures branch strategy and status mappings

---

### Example 3: Jira → Claude Agent (via aider) → GitHub PR — deepsense.ai

**Source:** [deepsense.ai/blog/from-jira-to-pr-claude-powered-ai-agents-that-code-test-and-review-for-you/](https://deepsense.ai/blog/from-jira-to-pr-claude-powered-ai-agents-that-code-test-and-review-for-you/)

**How it works:**
1. **Trigger:** A Jira ticket is created and assigned to the AI agent. A Jira webhook fires to a FastAPI backend hosted on Google Cloud Run.
2. **Claude Code invocation:** The agent uses the **aider** framework (an AI pair-programmer) with Claude 3.7 Sonnet / Claude 4.0. Claude inspects the repo structure, creates an implementation plan, then implements changes. After each step, it runs linters and tests — self-correcting in a loop until all checks pass.
3. **GitHub output:** Once validation passes, PyGithub pushes a branch and opens a PR. The PR title and description derive from the Jira ticket. The agent monitors the PR for reviewer comments and autonomously applies suggestions.

**Key traits:**
- Fully automated with no human intervention during implementation
- Self-correcting validation loop (lint + test → fix → retest)
- FastAPI backend on Google Cloud Run handles webhook events
- Also supports GitLab via python-gitlab

---

### Example 4: Port.io — Jira → Enriched GitHub Issue → Claude/Copilot Agent → PR

**Source:** [docs.port.io/guides/all/automatically-resolve-tickets-with-coding-agents/](https://docs.port.io/guides/all/automatically-resolve-tickets-with-coding-agents/)

**How it works:**
1. **Trigger:** A Jira issue transitions to "In Progress" with a `copilot` label. Port's workflow engine activates.
2. **Context enrichment:** Port AI enriches the ticket with software catalog data (related services, deployments, vulnerabilities, ownership) using MCP queries. This enriched context becomes a GitHub Issue labeled `auto_assign`.
3. **Claude/Copilot invocation:** The `auto_assign` label on the GitHub Issue triggers a GitHub Actions workflow that assigns the issue to a coding agent (GitHub Copilot or Claude).
4. **GitHub output:** The agent opens a PR. When the PR title contains the Jira key, Port maps it back to the original issue and comments the PR link on the Jira ticket — full bidirectional traceability.

**Key traits:**
- Tracker → GitHub Issue → Agent (two-hop architecture)
- Context enrichment step differentiates this from simpler pipelines
- Bidirectional sync: Jira ↔ GitHub ↔ Port software catalog
- Claude can be substituted as the AI agent in the GitHub Actions step

---

## Technical Considerations

### Common architectural patterns

All four examples share this structure:

```
1. TRIGGER     — Webhook or poll detects ticket state change
2. CONTEXT     — Agent reads issue description (+ optional enrichment)
3. IMPLEMENT   — Claude/AI edits code in an isolated branch/worktree
4. VALIDATE    — Tests and linters run; self-correction loop if needed
5. PR          — Branch pushed, pull request opened with issue context
6. SYNC        — Original tracker updated (status, PR link, comment)
```

### Key differentiators across examples

| Dimension | Cyrus | claude-linear-gh-starter | deepsense.ai | Port.io |
|---|---|---|---|---|
| Tracker | Linear / GitHub Issues | Linear | Jira | Jira |
| Trigger | Automatic (assigned to agent) | Manual (developer prompt) | Webhook → FastAPI | Jira status change → Port |
| Claude invocation | Claude Code CLI session | Claude Code conversational | aider + Claude API | GitHub Copilot / Claude via Actions |
| Hosting | Self-hosted / cloud SaaS | Local developer machine | Google Cloud Run | Port cloud platform |
| Parallelism | Yes (per-issue worktrees) | No | No | No |
| Self-correction | Depends on Claude Code | Depends on Claude Code | Yes (explicit lint+test loop) | Depends on agent |

### Integration complexity

- **Low complexity:** `claude-linear-gh-starter` — MCP OAuth setup + slash commands, developer stays in the loop.
- **Medium complexity:** Cyrus — npm install + GitHub CLI + Anthropic API key, then fully automated.
- **High complexity:** deepsense.ai approach — requires a backend server (FastAPI on Cloud Run), Jira webhooks, aider integration.
- **Platform complexity:** Port.io — requires Port platform account, blueprint configuration, multiple webhook chains.

---

## Potential Approaches for This Project

Given the codebase is a simple Rack microservice with no database, the most applicable patterns are:

1. **Cyrus / GSD-style automation:** Use the GSD skill set already available in this Claude Code environment. Linear tickets (like this one, TES-17) can be picked up via `/linear` or `/linear-process` skills, which implement the Tracker → Claude Code → GitHub PR pipeline directly.

2. **Claude Code + Linear MCP:** Configure a Linear MCP server in `~/.claude/settings.json` so Claude Code can natively read and update Linear tickets without external infrastructure.

3. **GitHub Actions + Claude Code Action:** Use `anthropics/claude-code-action` in a GitHub Actions workflow. A workflow triggered by issue labeling could invoke Claude Code to implement the solution and open a PR automatically.

4. **Webhook-driven agent:** Build a lightweight server (similar to the deepsense.ai approach) that listens for Linear/Jira webhooks and invokes Claude Code SDK programmatically for each incoming ticket.

---

## Open Questions

1. **Which issue tracker is the primary target?** Linear (as used in TES-17) or Jira or GitHub Issues?
2. **What is the desired autonomy level?** Fully automated (no human in the loop until PR review) or developer-assisted (human triggers Claude, Claude orchestrates)?
3. **Is there an existing CI/CD pipeline** that the GitHub PR step should integrate with (e.g., auto-run tests on PR, auto-merge on approval)?
4. **What is the hosting model?** Local developer machines, a shared cloud server, or a SaaS tool like Cyrus?
5. **Should status sync be bidirectional?** (i.e., should GitHub PR state update the Linear ticket status automatically?)
6. **Are there security/compliance constraints** on passing code and ticket content to Anthropic's API?

---

## References

- [Cyrus agent (ceedaragents/cyrus)](https://github.com/ceedaragents/cyrus)
- [claude-linear-gh-starter (ronanathebanana)](https://github.com/ronanathebanana/claude-linear-gh-starter)
- [From Jira to PR — deepsense.ai](https://deepsense.ai/blog/from-jira-to-pr-claude-powered-ai-agents-that-code-test-and-review-for-you/)
- [Port.io: Automatically resolve tickets with coding agents](https://docs.port.io/guides/all/automatically-resolve-tickets-with-coding-agents/)
- [anthropics/claude-code-action (GitHub Actions)](https://github.com/anthropics/claude-code-action)
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)
